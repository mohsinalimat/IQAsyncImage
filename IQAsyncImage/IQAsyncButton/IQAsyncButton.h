//
//  IQAsyncImageView.h
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

#import <UIKit/UIKit.h>

@interface IQAsyncButton : UIButton

/**
 Set imageURL property to load image asynchronously
 **/
@property (nonatomic, strong) NSURL *imageURL;

/**
 User thi method to load image asynchronously and optionally can register for completionHandler
 **/
-(void)setImageURL:(NSURL *)imageURL completionHandler:(void(^)(UIImage *image))completionHandler;

/**
 When image is unable to download from the network then placeholderText initials is used to generate an arbitary image and use it to for showing on button
 **/
@property(nonatomic, strong) NSString* placeholderText;

/**
 tintColor is used for progress color
 **/
@property(nonatomic, strong) UIColor *tintColor;

/**
 Current progress of image loading
 **/
@property(nonatomic, readonly) CGFloat progress;

/**
 If circular property is YES then layer.cornerRadius property is used for making a perfect circular button
 **/
@property(nonatomic, assign, getter=isCircular) IBInspectable BOOL circular;

/**
 Calling removeCallback method will remove all progress and downloading callbacks. Mostly this method is used in tableViewCell where cell is being reused
 **/
-(void)removeCallbacks;

@end
