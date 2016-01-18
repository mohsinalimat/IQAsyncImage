//
//  IQImageDownloadTask.m
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

#import "IQImageDownloadTask.h"
#import <UIKit/UIImage.h>
#import "IQURLConnection.h"

@interface IQImageDownloadTask ()

@end

@implementation IQImageDownloadTask

-(void)handleResponseData:(NSData * _Nullable * _Nullable)data error:(NSError * _Nullable * _Nullable)error
{
    NSError *networkError = *error;

    if (networkError == nil)
    {
        NSData *imageData = *data;
        
        if (imageData == nil)
        {
            *data = nil;
            *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:-101 userInfo:@{NSLocalizedDescriptionKey:@"Image Couldn't be downloaded from given URL"}];
            [[NSURLCache sharedURLCache] removeCachedResponseForRequest:_connection.originalRequest];
        }
        else
        {
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            
            if (image == nil)
            {
                *data = nil;
                *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:-101 userInfo:@{NSLocalizedDescriptionKey:@"Given URL is not an image source"}];
                [[NSURLCache sharedURLCache] removeCachedResponseForRequest:_connection.originalRequest];
            }
            else if (image)
            {
                NSCachedURLResponse *cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:_connection.response data:imageData userInfo:nil storagePolicy:NSURLCacheStorageAllowed];
                [[NSURLCache sharedURLCache] storeCachedResponse:cachedResponse forRequest:_connection.originalRequest];
            }
        }
    }
}

@end
