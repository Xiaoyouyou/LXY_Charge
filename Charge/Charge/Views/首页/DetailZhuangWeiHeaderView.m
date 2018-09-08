//
//  DetailZhuangWeiHeaderView.m
//  Charge
//
//  Created by olive on 16/6/8.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "DetailZhuangWeiHeaderView.h"
#import "Masonry.h"
#import "XFunction.h"

@interface DetailZhuangWeiHeaderView ()

@end

@implementation DetailZhuangWeiHeaderView


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
 
     self.backgroundColor = [UIColor whiteColor];
    [self creatUI];
    
    }
    return self;
}

-(void)creatUI
{
    _pictImageView = [[UIImageView alloc] init];
    _pictImageView.image = [UIImage imageNamed:@"logos@2x.png"];
    _pictImageView.layer.cornerRadius = 3;
    _pictImageView.clipsToBounds = YES;
    [self addSubview:_pictImageView];
    
    _titleLab = [[UILabel alloc] init];
    _titleLab.font = [UIFont systemFontOfSize:15];
    _titleLab.text = @"太古汇充电1区";
    [_titleLab sizeToFit];
    _titleLab.textColor = [UIColor blackColor];
    [self addSubview:_titleLab];
    
    _FutitleLab = [[UILabel alloc] init];
    _FutitleLab.font = [UIFont systemFontOfSize:12];
    _FutitleLab.text = @"天河路383号1区";
    _FutitleLab.numberOfLines = 0;
    _FutitleLab.textColor = RGBA(132, 133, 134, 1);
    [self addSubview:_FutitleLab];
    
    _diastaceLab = [[UILabel alloc] init];
    _diastaceLab.font = [UIFont systemFontOfSize:13];
    _diastaceLab.text = @"600m";
    [_diastaceLab sizeToFit];
    _diastaceLab.textColor = RGBA(132, 133, 134, 1);
    [self addSubview:_diastaceLab];
    
    
    _fastImageView = [[UIImageView alloc] init];
    _fastImageView.image = [UIImage imageNamed:@"kuais"];
    [self addSubview:_fastImageView];
    

    _slowImageView = [[UIImageView alloc] init];
    _slowImageView.image = [UIImage imageNamed:@"mans"];
    [self addSubview:_slowImageView];
    
    _fastLab = [[UILabel alloc] init];
    _fastLab.font = [UIFont systemFontOfSize:13];
    _fastLab.text = @"快(2)";
    [_fastLab sizeToFit];
    _fastLab.textColor = RGBA(132, 133, 134, 1);
    [self addSubview:_fastLab];
    
    _slowLab = [[UILabel alloc] init];
    _slowLab.font = [UIFont systemFontOfSize:13];
    _slowLab.text = @"慢(2)";
    [_slowLab sizeToFit];
    _slowLab.textColor = RGBA(132, 133, 134, 1);
    [self addSubview:_slowLab];
    
    [self setConstrain];
}


-(void)setConstrain
{
    [_pictImageView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.size.mas_equalTo(CGSizeMake(64, 64));
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
        
    }];
 
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_pictImageView.mas_right).offset(15);
        make.top.equalTo(self).offset(10);
        
    }];
    
    [_FutitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_pictImageView.mas_right).offset(15);
        make.top.equalTo(_titleLab.mas_bottom).offset(5);
        make.width.mas_equalTo(220);
        
    }];

    [_diastaceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(_titleLab);
        
    }];

    [_fastImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
       make.left.equalTo(_pictImageView.mas_right).offset(15);
       make.top.equalTo(_FutitleLab.mas_bottom).offset(10);
       make.size.mas_equalTo(CGSizeMake(11, 11));
        
    }];
    
    [_fastLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_fastImageView.mas_right).offset(5);
        make.top.equalTo(_FutitleLab.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(55,11));
    
    }];
    
    [_slowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_fastLab.mas_right);
        make.top.equalTo(_FutitleLab.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(11, 11));
        
    }];
    
    [_slowLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_slowImageView.mas_right).offset(5);
        make.top.equalTo(_FutitleLab.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(55,11));
        
    }];

}
@end
