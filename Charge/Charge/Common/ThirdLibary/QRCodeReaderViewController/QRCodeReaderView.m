/*
 * QRCodeReaderViewController
 *
 * Copyright 2014-present Yannick Loriot.
 * http://yannickloriot.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "QRCodeReaderView.h"
#import <QuartzCore/QuartzCore.h>

@interface QRCodeReaderView ()
{
    __weak id<QRCodeReaderViewDelegate> delegate;
    CGRect       innerViewRect;
}
@property (nonatomic, strong) CAShapeLayer *overlay;
@end

@implementation QRCodeReaderView
@synthesize innerViewRect,delegate;

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
//     [self addOverlay];
  }
  
  return self;
}

#pragma mark - Private Methods

//- (void)drawRect:(CGRect)rect
//{
//    CGRect innerRect = CGRectInset(rect, 50, 50);
//    
//    CGFloat minSize = MIN(innerRect.size.width, innerRect.size.height);
//    if (innerRect.size.width != minSize) {
//        innerRect.origin.x   += 50;
//        innerRect.size.width = minSize;
//    }
//    else if (innerRect.size.height != minSize) {
//        innerRect.origin.y   += (rect.size.height - minSize) / 2 - rect.size.height / 6;
//        innerRect.size.height = minSize;
//    }
//    CGRect offsetRect = CGRectOffset(innerRect, 0, 15);
//    
//    innerViewRect = offsetRect;
//    if(delegate)
//    {
//        [delegate loadView:innerViewRect];
//    }
//    _overlay.path = [UIBezierPath bezierPathWithRect:offsetRect].CGPath;
//    
////  [self addOtherLay:offsetRect];
//}


@end
