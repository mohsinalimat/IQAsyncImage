//
//  IQFileDownloadManager.m
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

#import "IQImageDownloadManager.h"

@implementation IQImageDownloadManager

-(IQImageDownloadTask*)taskForURL:(NSURL*)url;
{
    IQImageDownloadTask *task = (IQImageDownloadTask*)[self existingTaskForURL:url];
    
    if (task == nil)
    {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60.0];
        
        task = [[[[self class] networkClass] alloc] initWithRequest:request];
        
        [self addTask:task];
    }
    
    return task;
}

-(void)cancelTaskForURL:(NSURL*)url
{
    IQNetworkTask *task = [self existingTaskForURL:url];
    [self removeTask:task];
}

-(IQNetworkTask*)existingTaskForURL:(NSURL*)url
{
    for (IQNetworkTask *task in [self tasks])
        if ([task.request.URL isEqual:url])
            return task;
    
    return nil;
}

+(Class)networkClass
{
    return [IQImageDownloadTask class];
}

@end
