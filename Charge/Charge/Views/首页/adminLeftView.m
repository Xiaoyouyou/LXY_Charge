//
//  adminLeftView.m
//  Charge
//
//  Created by olive on 16/6/13.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "adminLeftView.h"
#import "Masonry.h"

@interface adminLeftView ()
@property (strong ,nonatomic) UIImageView *imageViews;
@end

@implementation adminLeftView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI
{
    _imageViews = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self addSubview:_imageViews];
    [self setConstrain];
}

- (void)setConstrain
{
    [_imageViews mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).offset(15);
        make.bottom.equalTo(self).offset(-15);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);;
        
    }];
}

- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    _imageViews.image = [UIImage imageNamed:imageName];
}

@end
