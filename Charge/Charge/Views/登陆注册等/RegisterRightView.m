//
//  RegisterRightView.m
//  Charge
//
//  Created by olive on 16/6/14.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "RegisterRightView.h"
#import "XStringUtil.h"
#import "XFunction.h"
#import "Masonry.h"
#import "MBProgressHUD+MJ.h"
#import "WMNetWork.h"
#import "API.h"

#define TimeCount 60

@interface RegisterRightView ()
{
    NSTimer *_timer;
    BOOL _isTime;
    int timecount;
}
@property (nonatomic, strong) UIButton *rightBtn;
@end

@implementation RegisterRightView

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self creatUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(YanZhenMaCanClick) name:PersonMesNoti object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(YanZhenMaCanClicks) name:PersonMesNotis object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(YanZhenMaCanClick) name:ChangePassWordNoti object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(YanZhenMaCanClicks) name:ChangePassWordNotis object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(YanZhenMaCanClick) name:ReplacePhoneNumNoti object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(YanZhenMaCanClicks) name:ReplacePhoneNumNotis object:nil];
    }
    return self;
}

#pragma mark - action

-(void)YanZhenMaCanClick
{
    _rightBtn.backgroundColor = RGBA(29, 167, 146, 1);
    _rightBtn.userInteractionEnabled = YES;
}

-(void)YanZhenMaCanClicks
{
    _rightBtn.backgroundColor = [UIColor grayColor];
     _rightBtn.userInteractionEnabled = NO;
}

- (void)creatUI
{
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.backgroundColor = [UIColor grayColor];
    _rightBtn.userInteractionEnabled = NO;
    _rightBtn.layer.cornerRadius = 4;
    _rightBtn.clipsToBounds = YES;
    [_rightBtn addTarget:self action:@selector(huoQuYanZhengMa) forControlEvents:UIControlEventTouchUpInside];
    [_rightBtn setTitle:@"点击获取" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_rightBtn];
    
    [self setConstrain];
}

- (void)setConstrain
{
    
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self);
    }];
}

-(void)huoQuYanZhengMa
{
    MYLog(@"phoneNum= %@",self.phoneNum);
    //判断手机号
    if ([XStringUtil isMobileNumber:self.phoneNum]) {
        timecount = TimeCount;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
        [_rightBtn setTitle:[NSString stringWithFormat:@"%ds重新获取",timecount] forState:UIControlStateNormal];
        _rightBtn.backgroundColor = [UIColor grayColor];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        
#warning 发送验证码请求处理
        
       NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
       parmas[@"mobile"] = self.phoneNum;
    
        [WMNetWork post:GetYanZhengMa parameters:parmas success:^(id responseObj) {
            MYLog(@"responseObj = %@",responseObj);
            
            if ([responseObj[@"status"] intValue] == 0) {
             //短信发送成功
                if (self.ShowSuessMess) {
                    self.ShowSuessMess();
                }
            }
            
            if ([responseObj[@"status"] intValue] == -1) {
             //短信发送失败
                if (self.ShowFailMess) {
                    self.ShowFailMess();
                }
            }
            
        } failure:^(NSError *error) {
           MYLog(@"error = %@",error);
             //网络连接超时
            if (self.ShowNetWorkFailMess) {
                self.ShowNetWorkFailMess();
            }
        }];
    }
}

#pragma mark -- 获取验证码处理方法

- (void)timerFired
{
    timecount--;
    if (timecount<= 0) {
        [_timer invalidate];
        [_rightBtn setTitle:@"点击获取" forState:UIControlStateNormal];
        _rightBtn.backgroundColor = RGBA(29, 167, 146, 1);
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        _rightBtn.userInteractionEnabled = YES;
        
    }else{
         [_rightBtn setTitle:[NSString stringWithFormat:@"%ds重新获取",timecount] forState:UIControlStateNormal];
         _rightBtn.backgroundColor = [UIColor grayColor];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        _rightBtn.userInteractionEnabled = NO;
    }
}
@end
