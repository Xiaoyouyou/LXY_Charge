//
//  ChargeingViewController.m
//  Charge
//
//  Created by olive on 16/6/24.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "ChargeingViewController.h"
#import "CATCurveProgressView.h"
#import "Masonry.h"
#import "XFunction.h"

@interface ChargeingViewController ()
{
    UILabel *ZhuangWeiNumLab;//桩位号
    UILabel *price;//每度价格
    UIView *bgView1;//背景1
    UIView *bgView2;//背景2
    UIView *bgView3;//背景3
    UIImageView *chongDianShiChangImageView;//充电时长图片
    UIImageView *costIconImageView;//消费金额图片
    UIImageView *stopChargeImageView;//停止充电图片
    UILabel *chargeLab;//充电时长
    UILabel *costLab;//消费金额
    UILabel *stopLab;//停止充电
    UIImageView *jianTouImageView;//箭头
}

@property (nonatomic, strong) UILabel *chargeTime;
@property (nonatomic, strong) UILabel *cost;
@property (strong, nonatomic) IBOutlet CATCurveProgressView *progressView;

@end

@implementation ChargeingViewController


#pragma mark - 生命周期


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBA(254, 255, 255, 1);
    [self creatUI];
    [self constraint];
    
    [self performSelector:@selector(changeProgress) withObject:nil afterDelay:0.3];
}

-(void)changeProgress{
    _progressView.progress = 0.88f;
}

-(void)creatUI
{
    _progressView = [[CATCurveProgressView alloc]initWithFrame:CGRectMake(XYScreenWidth/2 - 78, 44, 156, 156)];
    _progressView.startAngle = -90;
    _progressView.endAngle = 270;
    _progressView.progressColor = RGBA(28, 166, 145, 1);
    _progressView.curveBgColor = RGBA(34, 47, 54, 1);
    _progressView.progress = 0.01;
    _progressView.progressLineWidth = 15;
    
    [self.view addSubview:_progressView];
    
    ZhuangWeiNumLab = [[UILabel alloc] init];
    ZhuangWeiNumLab.text = @"1号桩";
    ZhuangWeiNumLab.font = [UIFont systemFontOfSize:17];
    ZhuangWeiNumLab.textColor = RGBA(29, 167, 146, 1);
    [ZhuangWeiNumLab sizeToFit];
    [self.view addSubview:ZhuangWeiNumLab];
    
    price = [[UILabel alloc] init];
    price.text = @"0.5元/度";
    price.font = [UIFont systemFontOfSize:16];
    price.textColor = RGBA(162, 161, 163, 1);
    [price sizeToFit];
    [self.view addSubview:price];
    
    bgView1 = [[UIView alloc] init];
    bgView1.backgroundColor = RGBA(247, 249, 250, 1);
    bgView1.layer.cornerRadius = 3;
    bgView1.layer.masksToBounds = YES;
    [self.view addSubview:bgView1];
    
    bgView2 = [[UIView alloc] init];
    bgView2.backgroundColor = RGBA(247, 249, 250, 1);
    bgView2.layer.cornerRadius = 3;
    bgView2.layer.masksToBounds = YES;
    [self.view addSubview:bgView2];
    
    bgView3 = [[UIView alloc] init];
    bgView3.backgroundColor = RGBA(247, 249, 250, 1);
    bgView3.layer.cornerRadius = 5;
    bgView3.layer.masksToBounds = YES;
    [self.view addSubview:bgView3];
    
    chongDianShiChangImageView = [[UIImageView alloc]init];
    chongDianShiChangImageView.image = [UIImage imageNamed:@"chargeTime"];
    [bgView1 addSubview:chongDianShiChangImageView];
    
    costIconImageView = [[UIImageView alloc]init];
    costIconImageView.image = [UIImage imageNamed:@"costIcon"];
    [bgView2 addSubview:costIconImageView];
    
    stopChargeImageView = [[UIImageView alloc]init];
    stopChargeImageView.image = [UIImage imageNamed:@"stopCharge"];
    [bgView3 addSubview:stopChargeImageView];
    
    chargeLab = [[UILabel alloc] init];
    chargeLab.text = @"充电时长";
    chargeLab.textAlignment = NSTextAlignmentCenter;
    chargeLab.font = [UIFont systemFontOfSize:15];
    chargeLab.textColor = RGBA(250, 166, 8, 1);
    [chargeLab sizeToFit];
    [self.view addSubview:chargeLab];
    
    costLab = [[UILabel alloc] init];
    costLab.text = @"消费金额";
    costLab.textAlignment = NSTextAlignmentCenter;
    costLab.font = [UIFont systemFontOfSize:15];
    costLab.textColor = RGBA(250, 166, 8, 1);
    [costLab sizeToFit];
    [self.view addSubview:costLab];
    
    stopLab = [[UILabel alloc] init];
    stopLab.text = @"停止充电";
    stopLab.textAlignment = NSTextAlignmentCenter;
    stopLab.font = [UIFont systemFontOfSize:15];
    stopLab.textColor = RGBA(27, 216, 156, 1);
    [stopLab sizeToFit];
    [self.view addSubview:stopLab];
    
    _chargeTime = [[UILabel alloc] init];
    _chargeTime.text = @"3:18";
    _chargeTime.textAlignment = NSTextAlignmentCenter;
    _chargeTime.font = [UIFont systemFontOfSize:14];
    _chargeTime.textColor = RGBA(149, 149, 150, 1);
    [_chargeTime sizeToFit];
    [self.view addSubview:_chargeTime];
    
    _cost = [[UILabel alloc] init];
    _cost.text = @"32元";
    _cost.textAlignment = NSTextAlignmentCenter;
    _cost.font = [UIFont systemFontOfSize:14];
    _cost.textColor = RGBA(149, 149, 150, 1);
    [_cost sizeToFit];
    [self.view addSubview:_cost];
    
    jianTouImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    [self.view addSubview:jianTouImageView];
    
}

-(void)constraint
{
   [jianTouImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    
  [ZhuangWeiNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.view).offset(15);
      make.top.equalTo(self.view).offset(9);
  }];
    
  [price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.view).offset(9);
  }];
    
    
    [bgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.bottom.equalTo(self.view).offset(-15);
        make.size.mas_equalTo(CGSizeMake((XYScreenWidth - 20 - 12)/3, 114));
    }];
    
    [bgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-15);
        make.size.mas_equalTo(CGSizeMake((XYScreenWidth - 20 - 12)/3, 114));
    }];
    
    [bgView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.view).offset(-15);
        make.size.mas_equalTo(CGSizeMake((XYScreenWidth - 20 - 12)/3, 114));
    }];
    
    [chongDianShiChangImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView1);
        make.top.equalTo(bgView1).offset(15);
        make.size.mas_equalTo(CGSizeMake(35, 35));
        
    }];
    
    [costIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView2);
        make.top.equalTo(bgView2).offset(15);
        make.size.mas_equalTo(CGSizeMake(35, 35));
        
    }];
    
    [stopChargeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView3);
        make.top.equalTo(bgView3).offset(15);
        make.size.mas_equalTo(CGSizeMake(35, 35));
        
    }];
    
    [chargeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView1);
        make.top.equalTo(chongDianShiChangImageView.mas_bottom).offset(15);
        
    }];
    
    [costLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView2);
        make.top.equalTo(costIconImageView.mas_bottom).offset(15);
        
    }];
    
    [stopLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView3);
        make.top.equalTo(stopChargeImageView.mas_bottom).offset(15);
        
    }];
    
    [_chargeTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView1);
        make.top.equalTo(chargeLab.mas_bottom).offset(5);
        
    }];
    
    [_cost mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView2);
        make.top.equalTo(costLab.mas_bottom).offset(5);
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
