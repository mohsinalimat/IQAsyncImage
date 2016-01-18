//
//  UIImage+IQTextPlaceholder.m
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

#import "UIImage+IQTextPlaceholder.h"

@implementation UIImage (IQTextPlaceholder)

+(UIImage*)placeholderImageWithText:(NSString*)text
                               size:(CGSize)size
                    backgroundColor:(UIColor*)color
{
    NSMutableString *displayString = [NSMutableString stringWithString:@""];
    
    NSMutableArray *words = [[text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] mutableCopy];
    
    if ([words count])
    {
        NSString *firstWord = [words firstObject];
        if ([firstWord length]) {
            // Get character range to handle emoji (emojis consist of 2 characters in sequence)
            NSRange firstLetterRange = [firstWord rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 1)];
            [displayString appendString:[firstWord substringWithRange:firstLetterRange]];
        }
        
        if ([words count] >= 2) {
            NSString *lastWord = [words lastObject];
            
            while ([lastWord length] == 0 && [words count] >= 2) {
                [words removeLastObject];
                lastWord = [words lastObject];
            }
            
            if ([words count] > 1) {
                // Get character range to handle emoji (emojis consist of 2 characters in sequence)
                NSRange lastLetterRange = [lastWord rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 1)];
                [displayString appendString:[lastWord substringWithRange:lastLetterRange]];
            }
        }
    }

    
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    //  Background Color;
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    //  Text Attributes
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:size.width * 0.5],
                                     NSForegroundColorAttributeName: [UIColor whiteColor]
                                     };
    
    //  Text Size
    CGSize textSize = [displayString sizeWithAttributes:textAttributes];

    //  Text
    [displayString drawInRect:CGRectMake((size.width - textSize.width)/2,
                                (size.height - textSize.height)/2,
                                textSize.width,
                                textSize.height)
      withAttributes:textAttributes];
    
    //  Image
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    return snapshot;
}

@end
