//
//  AdvertisementView.m
//  Charge
//
//  Created by olive on 17/4/10.
//  Copyright © 2017年 com.XinGuoXin.cn. All rights reserved.
//

#import "AdvertisementView.h"
#import "Masonry.h"


@interface AdvertisementView()
{
    UIView *bgview1;//透明的view
    UIView *bgView;
    UIButton *dismissBtn;
    UIImageView *imageview;
}

@end

@implementation AdvertisementView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        bgview1 = [[UIView alloc] init];
        bgview1.backgroundColor = [UIColor clearColor];
        [self addSubview:bgview1];
        
        bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 16.0;
        [bgview1 addSubview:bgView];
        
        imageview= [[UIImageView alloc] init];
        imageview.image = [UIImage imageNamed:@"01.png"];
        [bgView addSubview:imageview];
        
        
        dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [dismissBtn setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        [dismissBtn addTarget:self action:@selector(dissmissView) forControlEvents:UIControlEventTouchUpInside];
        [bgview1 addSubview:dismissBtn];
        
        //设置约束
        [self setMasonry];
    }
    return self;
}

-(void)setMasonry
{
    [bgview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgview1);
        make.right.equalTo(bgview1);
        make.top.equalTo(bgview1);
        make.height.mas_equalTo(400);
    }];
    
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bgView);
    }];
    
    
    
    [dismissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_bottom).offset(44);
        make.centerX.equalTo(bgview1);
        make.size.mas_equalTo(CGSizeMake(39, 39));
    }];
}

#pragma mark - action
-(void)dissmissView
{
    if (self.DisMissViewBlock) {
        self.DisMissViewBlock();
    }
}

@end
