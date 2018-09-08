//
//  UIImageView+Ext.m
//  OpenDoor
//
//  Created by M&M on 15/6/5.
//  Copyright (c) 2015年 CNMOBI. All rights reserved.
//

#import "UIView+Ext.h"

@implementation UIView(UIView_Ext)

//重写系统的方法时使用
//- (instancetype)init {
//    if (self = [super init]) {
//        
//    }
//    return self;
//}

//orgin
- (void)setOrigin:(CGPoint)orgin
{
    self.frame = CGRectMake(orgin.x, orgin.y, self.frame.size.width, self.frame.size.height);
}
- (CGPoint)origin
{
    return self.frame.origin;
}


- (void)setOriginX:(CGFloat)originX
{
    self.frame = CGRectMake(originX, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}
- (CGFloat)originX
{
    return self.frame.origin.x;
}

- (void)setOriginY:(CGFloat)originY
{
    self.frame = CGRectMake(self.frame.origin.x, originY, self.frame.size.width, self.frame.size.height);
}
- (CGFloat)originY
{
    return self.frame.origin.y;
}

//size
- (void)setSizeHeight:(CGFloat)sizeHeight
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, sizeHeight);
}
- (CGFloat)sizeHeight
{
    return self.frame.size.height;
}

- (void)setSizeWidth:(CGFloat)sizeWidth
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, sizeWidth, self.frame.size.height);
}
- (CGFloat)sizeWidth
{
    return self.frame.size.width;
}


//center
- (void)setFloatx:(CGFloat)floatx
{
    self.center = CGPointMake(floatx, self.center.y);
}
- (CGFloat)floatx
{
    return self.center.x;
}

- (void)setFloaty:(CGFloat)floaty
{
    self.center = CGPointMake(self.center.x, floaty);
}
- (CGFloat)floaty
{
    return self.center.y;
}


//

- (void)setBottom:(CGFloat)bottom
{
    self.originY = bottom - self.sizeHeight;
}
- (CGFloat)bottom
{
    return self.originY+self.sizeHeight;
}

- (void)setRight:(CGFloat)right
{
    self.originX = right - self.sizeWidth;
}
- (CGFloat)right
{
    return self.originX+self.sizeWidth;
}

@end
