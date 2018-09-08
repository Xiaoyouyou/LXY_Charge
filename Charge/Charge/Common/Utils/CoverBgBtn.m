//
//  CoverBgBtn.m
//  Charge
//
//  Created by olive on 16/6/24.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "CoverBgBtn.h"

@implementation CoverBgBtn

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        [self addTarget:self action:@selector(tapClick) forControlEvents:UIControlEventTouchUpInside];
        self.adjustsImageWhenHighlighted = NO;
        self.alpha = 0;
    }
    return self;
}

-(void)tapClick
{
    self.BgBtnActionBlcok();
}

@end
