//
//  MainNavView.m
//  Charge
//
//  Created by olive on 17/4/7.
//  Copyright © 2017年 com.XinGuoXin.cn. All rights reserved.
//

#import "MainNavView.h"
#import "Masonry.h"
#import "XFunction.h"

@interface MainNavView ()
{
    UILabel *showLab;
    UIView *lineView;
    UIImageView *leftImageView;
    
    UIView *leftTapView;
    
    UIImageView *rightImageView;
    UIView *rightTapView;
}

@end

@implementation MainNavView

- (id)initWithFrame:(CGRect)frame title:(NSString *)title leftImgae:(NSString *)leftImage rightImage:(NSString *)rightImage
{
    if (self = [super initWithFrame:frame]) {
        //标题
        self.backgroundColor = [UIColor whiteColor];
        showLab = [[UILabel alloc] init];
        showLab.text = title;
        //        showLab.font = [UIFont fontWithName:@"Helvetica Bold" size:15];
        showLab.font = [UIFont systemFontOfSize:18];
        showLab.textColor = RGBA(51, 51, 51, 1);
        showLab.textAlignment = NSTextAlignmentCenter;
        [showLab sizeToFit];
        [self addSubview:showLab];
        
        //线
        lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor blackColor];
        lineView.alpha = 0.3;
        [self addSubview:lineView];
        
        //左边的图片
        leftImageView = [[UIImageView alloc] init];
        leftImageView.image = [UIImage imageNamed:leftImage];
        
        [self addSubview:leftImageView];
        
        //tapView
        leftTapView = [[UIView alloc] init];
        [self addSubview:leftTapView];
        
        //左边图片手势
        UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] init]initWithTarget:self action:@selector(leftAction)];
        [leftTapView addGestureRecognizer:tap];
        
        //右边的图片
        rightImageView = [[UIImageView alloc] init];
        rightImageView.image = [UIImage imageNamed:rightImage];
        
        [self addSubview:rightImageView];
        
        //rightTapView
        rightTapView = [[UIView alloc] init];
        [self addSubview:rightTapView];
        
        //右边按钮手势
        UITapGestureRecognizer *RightTap = [[[UITapGestureRecognizer alloc] init]initWithTarget:self action:@selector(rightAction)];
        [rightTapView addGestureRecognizer:RightTap];
        
        [self MakeMasonry];
        
    }
    return self;
}

-(void)MakeMasonry
{
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-11);
        make.left.equalTo(self).offset(15);
        make.size.mas_equalTo(CGSizeMake(22,15));
    }];
    
    [leftTapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(44);
    }];
    
    [showLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.centerX.equalTo(self);
        make.centerY.equalTo(leftImageView);
    }];
    
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-11);
        make.right.equalTo(self).offset(-15);
    }];
    
    [rightTapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(44);
    }];
}

#pragma mark -action

-(void)rightAction
{
    if (self.rightBlock) {
        self.rightBlock();
    }
}

-(void)leftAction
{
    if (self.leftBlock) {
        self.leftBlock();
    }
}

@end
