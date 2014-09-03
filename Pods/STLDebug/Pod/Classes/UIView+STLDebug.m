// UIView+STLDebug.m
//
// Copyright (c) 2014 Simon Li
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

#import "UIView+STLDebug.h"

#define DEBUG_BORDER_WIDTH_DEFAULT 1.0

@implementation UIView (STLDebug)

- (void)stl_setDebugBorderLine
{
#ifdef DEBUG
    self.layer.borderColor = [self _randomColor].CGColor;
    self.layer.borderWidth = DEBUG_BORDER_WIDTH_DEFAULT;
#endif
}

- (void)stl_setDebugBorderLineWithColor:(UIColor*)color
{
#ifdef DEBUG
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = DEBUG_BORDER_WIDTH_DEFAULT;
#endif
}

+ (void)stl_resetUserDefaults
{
#ifdef DEBUG
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
#endif
}

- (UIColor *)_randomColor
{
    CGFloat red = arc4random_uniform(255) / 255.0;
    CGFloat green = arc4random_uniform(255) / 255.0;
    CGFloat blue = arc4random_uniform(255) / 255.0;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    return color;
}

@end