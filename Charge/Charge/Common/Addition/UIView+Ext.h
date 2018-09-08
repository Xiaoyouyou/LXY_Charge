//
//  UIImageView+Ext.h
//  OpenDoor
//
//  Created by M&M on 15/6/5.
//  Copyright (c) 2015年 CNMOBI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(UIView_Ext)

//orgin x/y
@property (assign, nonatomic) CGPoint origin;
@property (assign, nonatomic) CGFloat originX;
@property (assign, nonatomic) CGFloat originY;

@property (assign, nonatomic) CGFloat sizeHeight;
@property (assign, nonatomic) CGFloat sizeWidth;
//center x/y
@property (assign, nonatomic) CGFloat floatx;
@property (assign, nonatomic) CGFloat floaty;

@property (assign, nonatomic) CGFloat bottom;
@property (assign, nonatomic) CGFloat right;
@end
