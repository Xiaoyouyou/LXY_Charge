//
//  ZhuangWeiHeaderView.m
//  Charge
//
//  Created by olive on 16/6/8.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "ZhuangWeiHeaderView.h"
#import "Masonry.h"
#import "XFunction.h"

@interface ZhuangWeiHeaderView ()
{
    UIImageView *logoImageView;
    UILabel *totalLab;//总数
    UILabel *freeLab;//空闲
    UILabel *zhiLiuLab;//直流
    UILabel *jiaoLiuLab;//交流
}

@end

@implementation ZhuangWeiHeaderView


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)creatUI
{
    logoImageView = [[UIImageView alloc ]init];
    logoImageView.image = [UIImage imageNamed:@"logos"];
    [self addSubview:logoImageView];
    
    totalLab = [[UILabel alloc] init];
    totalLab.text = @"总数: 4";
    totalLab.font = [UIFont systemFontOfSize:14];
    totalLab.textColor = [UIColor blackColor];
    [totalLab sizeToFit];
    [self addSubview:totalLab];
    
    freeLab = [[UILabel alloc] init];
    freeLab.text = @"空闲: 3";
    freeLab.font = [UIFont systemFontOfSize:14];
    freeLab.textColor = [UIColor blackColor];
    [freeLab sizeToFit];
    [self addSubview:freeLab];
    
    zhiLiuLab = [[UILabel alloc] init];
    zhiLiuLab.text = @"直流: 2";
    zhiLiuLab.font = [UIFont systemFontOfSize:14];
    zhiLiuLab.textColor = RGBA(143, 144, 145, 1);
    [zhiLiuLab sizeToFit];
    [self addSubview:zhiLiuLab];
    
    jiaoLiuLab = [[UILabel alloc] init];
    jiaoLiuLab.text = @"交流: 4";
    jiaoLiuLab.font = [UIFont systemFontOfSize:14];
    jiaoLiuLab.textColor = RGBA(143, 144, 145, 1);
    [jiaoLiuLab sizeToFit];
    [self addSubview:jiaoLiuLab];
    
    [self setConstrain];
}

- (void)setConstrain
{
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.top.equalTo(self).offset(6);
        make.bottom.equalTo(self).offset(-6);
        make.left.equalTo(self).offset(43);
    }];
    
    [totalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(logoImageView.mas_right).offset(20);
        make.top.equalTo(self).offset(6);
        make.height.mas_equalTo(25);
    }];
    
    [freeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(totalLab.mas_right).offset(20);
        make.top.equalTo(self).offset(6);
        make.height.mas_equalTo(25);
    }];
    
    [zhiLiuLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(logoImageView.mas_right).offset(20);
        make.top.equalTo(totalLab.mas_bottom);
        make.height.mas_equalTo(25);
    }];
    
    [jiaoLiuLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(zhiLiuLab.mas_right).offset(20);
        make.top.equalTo(freeLab.mas_bottom);
        make.height.mas_equalTo(25);
    }];

}


#pragma mark - set方法

-(void)setTotal:(NSString *)total
{
    _total = total;
    totalLab.text = total;
}

-(void)setFree:(NSString *)free
{
    _free = free;
    freeLab.text = free;
}

-(void)setZhiliu:(NSString *)zhiliu
{
    _zhiliu = zhiliu;
    zhiLiuLab.text = zhiliu;

}

-(void)setJiaoliu:(NSString *)jiaoliu
{
    _jiaoliu = jiaoliu;
    jiaoLiuLab.text = jiaoliu;
}
@end
