//
//  IQAsyncImageView.m
// https://github.com/hackiftekhar/IQAsyncImage
// Copyright (c) 2016 Iftekhar Qurashi.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "IQAsyncButton.h"
#import "IQcircularProgressView.h"
#import "IQImageDownloadManager.h"
#import "UIImage+IQTextPlaceholder.h"
#import "UIColor+IQRandomTextColor.h"

@interface IQAsyncButton ()

@property(nonatomic, strong) IQCircularProgressView *progressView;
@property(nonatomic, strong) void(^completionHandler)(UIImage *image);

@end

@implementation IQAsyncButton
{
    IQNetworkTask *downloadTask;
    UIImage *networkImage;
}

@dynamic tintColor;

-(void)initialize
{
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.layer.masksToBounds = YES;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self initialize];
}

-(void)setCircular:(BOOL)circular
{
    _circular = circular;
    [self setNeedsLayout];
}

-(void)setPlaceholderText:(NSString *)placeholderText
{
    if (_placeholderText != placeholderText)
    {
        _placeholderText = placeholderText;
        
        if (downloadTask == nil && networkImage == nil)
        {
            [self setImage:[self placeholderImage] forState:UIControlStateNormal];
            self.progressView.state = IQProgressViewStateNone;
        }
    }
}

-(void)setImageURL:(NSURL *)imageURL
{
    [self setImageURL:imageURL completionHandler:NULL];
}

-(void)setImageURL:(NSURL *)imageURL completionHandler:(void(^)(UIImage *image))completion
{
    _imageURL = imageURL;
    
    //Removing old callbacks
    [self removeCallbacks];
    
    if (_imageURL == nil || ![_imageURL isKindOfClass:[NSURL class]])
    {
        [self setImage:[self placeholderImage] forState:UIControlStateNormal];
        self.progressView.state = IQProgressViewStateNone;
        
        if (completion)
        {
            completion(nil);
        }
    }
    else
    {
        self.completionHandler = completion;
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:_imageURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60.0];
        
        NSData *cachedData = [[[NSURLCache sharedURLCache] cachedResponseForRequest:request] data];
        
        UIImage *_cachedImage = [[UIImage alloc] initWithData:cachedData];
        
        if(cachedData && !_cachedImage)
        {
            [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
        }
        
        if (_cachedImage)
        {
            [self setImage:_cachedImage forState:UIControlStateNormal];
            self.progressView.state = IQProgressViewStateNone;
            
            if (self.completionHandler)
            {
                self.completionHandler(_cachedImage);
            }
        }
        else
        {
            [self setImage:nil forState:UIControlStateNormal];
            
            downloadTask = [[IQImageDownloadManager sharedManager] taskForURL:_imageURL];
            _progress = downloadTask.downloadProgress;
            [self.progressView setProgress:downloadTask.downloadProgress animated:NO];
            
            switch (downloadTask.status)
            {
                case IQNetworkTaskStatusNotStarted:
                case IQNetworkTaskStatusPaused:
                case IQNetworkTaskStatusDownloaded:
                case IQNetworkTaskStatusFailed:
                {
                    self.progressView.state = IQProgressViewStateNone;
                }
                    break;
                case IQNetworkTaskStatusPreparing:
                case IQNetworkTaskStatusUploading:
                case IQNetworkTaskStatusWaiting:
                {
                    self.progressView.state = IQProgressViewStateSpinning;
                }
                    break;
                    
                case IQNetworkTaskStatusDownloading:
                {
                    self.progressView.state = IQProgressViewStateProgress;
                }
                    break;
            }
            
            [downloadTask addDownloadProgressTarget:self action:@selector(progress:)];
            [downloadTask addStatusUpdateTarget:self action:@selector(networkStatusUpdate:)];
            [downloadTask addCompletionTarget:self action:@selector(downloadingFinishWithData:error:)];
        }
    }
}

-(void)networkStatusUpdate:(IQNetworkTaskStatus)status
{
    switch (status)
    {
        case IQNetworkTaskStatusNotStarted:
        case IQNetworkTaskStatusPaused:
        case IQNetworkTaskStatusDownloaded:
        case IQNetworkTaskStatusFailed:
        {
            self.progressView.state = IQProgressViewStateNone;
        }
            break;
        case IQNetworkTaskStatusPreparing:
        case IQNetworkTaskStatusUploading:
        case IQNetworkTaskStatusWaiting:
        {
            self.progressView.state = IQProgressViewStateSpinning;
        }
            break;
            
        case IQNetworkTaskStatusDownloading:
        {
            self.progressView.state = IQProgressViewStateProgress;
        }
            break;
    }
}

-(void)progress:(CGFloat)progress
{
    _progress = progress;
    [self.progressView setProgress:progress animated:YES];
}

-(void)downloadingFinishWithData:(NSData*)result error:(NSError*)error
{
    UIImage *image = [[UIImage alloc] initWithData:result];
    
    if (image)
    {
        [self setImage:image forState:UIControlStateNormal];
    }
    else
    {
        [self setImage:[self placeholderImage] forState:UIControlStateNormal];
    }
    
    //Animation
    {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade;
        transition.removedOnCompletion = YES;
        
        [self.layer addAnimation:transition forKey:nil];
    }
    
    if (self.completionHandler)
    {
        self.completionHandler(image);
    }
}

-(void)tintColorDidChange
{
    [super tintColorDidChange];
    self.progressView.tintColor = self.tintColor;
}

-(IQCircularProgressView *)progressView
{
    if (_progressView == nil)
    {
        _progressView = [[IQCircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _progressView.tintColor = self.tintColor;
        _progressView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        [self addSubview:_progressView];
    }
    
    return _progressView;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _progressView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    if (self.isCircular)
    {
        self.layer.cornerRadius = MIN(self.frame.size.width, self.frame.size.height)/2;
    }
    else
    {
        self.layer.cornerRadius = 0;
    }
}

-(UIImage*)placeholderImage
{
    if ([self.placeholderText isKindOfClass:[NSString class]] && [self.placeholderText length])
    {
        UIColor *backgroundColor = [UIColor colorForText:self.placeholderText];
        return [UIImage placeholderImageWithText:self.placeholderText size:self.frame.size backgroundColor:backgroundColor];
    }
    else
    {
        return nil;
    }
}

-(void)cancel
{
    [self removeCallbacks];
}

-(void)removeCallbacks
{
    self.completionHandler = NULL;
    [downloadTask removeStatusUpdateTarget:self action:@selector(networkStatusUpdate:)];
    [downloadTask removeDownloadProgressTarget:self action:@selector(progress:)];
    [downloadTask removeCompletionTarget:self action:@selector(downloadingFinishWithData:error:)];
    self.progressView.state = IQProgressViewStateNone;
    downloadTask = nil;
}

-(void)dealloc
{
    [self removeCallbacks];
}

@end
