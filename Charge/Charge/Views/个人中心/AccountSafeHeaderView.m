//
//  AccountSafeHeaderView.m
//  Charge
//
//  Created by olive on 16/6/8.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "AccountSafeHeaderView.h"
#import "XFunction.h"

@interface AccountSafeHeaderView ()

@property (strong, nonatomic) IBOutlet UIView *labBgView;
@property (strong, nonatomic) IBOutlet UIView *bgview1;
@property (strong, nonatomic) IBOutlet UIView *bgView2;
@property (strong, nonatomic) IBOutlet UIView *bgView3;

@property (assign, nonatomic) BOOL IsWeiXinBangDing;
@property (assign, nonatomic) BOOL IsQQBangDing;
@property (assign, nonatomic) BOOL IsWeiBoBangDing;

@property (strong, nonatomic) IBOutlet UILabel *weiXinLab;

@property (strong, nonatomic) IBOutlet UILabel *qqLab;

@property (strong, nonatomic) IBOutlet UILabel *weiBoLab;

@end

@implementation AccountSafeHeaderView

+(instancetype)creatAccoundSafeFootView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"AccountSafeHeaderView" owner:nil options:nil]lastObject];
    
}

-(void)awakeFromNib
{
    self.labBgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.bgview1.layer.cornerRadius = 3;
    self.bgview1.clipsToBounds = YES;
    
    self.bgView2.layer.cornerRadius = 3;
    self.bgView2.clipsToBounds = YES;
    
    self.bgView3.layer.cornerRadius = 3;
    self.bgView3.clipsToBounds = YES;
    
    
    UITapGestureRecognizer *weixintap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weiXinBangDing)];
    [self.bgview1 addGestureRecognizer:weixintap];
    
    UITapGestureRecognizer *qqtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(qqBangDing)];
    [self.bgView2 addGestureRecognizer:qqtap];
    
    UITapGestureRecognizer *weibotap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weiboBangDing)];
    [self.bgView3 addGestureRecognizer:weibotap];
    
    
}


#pragma mark -- Action

-(void)weiXinBangDing
{
    if (_IsWeiXinBangDing) {
       self.bgview1.backgroundColor = RGBA(29, 166, 145, 1);
        self.weiXinLab.text = @"绑定";
       self.IsWeiXinBangDing = 0;
    }else
    {
        self.bgview1.backgroundColor = RGBA(231, 232, 234, 1);
        self.weiXinLab.text = @"解绑";
        self.IsWeiXinBangDing = 1;
    }

}

-(void)qqBangDing
{
    if (_IsQQBangDing) {
        self.bgView2.backgroundColor = RGBA(29, 166, 145, 1);
        self.qqLab.text = @"绑定";
        self.IsQQBangDing = 0;
    }else
    {
        self.bgView2.backgroundColor = RGBA(231, 232, 234, 1);
        self.qqLab.text = @"解绑";
        self.IsQQBangDing = 1;
    }
    
}

-(void)weiboBangDing
{
    if (_IsWeiBoBangDing) {
        self.bgView3.backgroundColor = RGBA(29, 166, 145, 1);
        self.weiBoLab.text = @"绑定";
        self.IsWeiBoBangDing = 0;
    }else
    {
        self.bgView3.backgroundColor = RGBA(231, 232, 234, 1);
        self.weiBoLab.text = @"解绑";
        self.IsWeiBoBangDing = 1;
    }
    
}

@end
