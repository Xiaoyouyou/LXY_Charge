//
//  ChangePayViewController.m
//  Charge
//
//  Created by olive on 16/8/19.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "ChangePayViewController.h"
#import "Config.h"
#import "XFunction.h"

@interface ChangePayViewController ()
{
    NSString *tempChargeTime;//临时赋值数据
    NSString *tempChargePower;
    NSString *tempPayMoney;
}

@property (strong, nonatomic) IBOutlet UILabel *chargeTime;//充电时长
@property (strong, nonatomic) IBOutlet UILabel *chargePower;//电量
@property (strong, nonatomic) IBOutlet UILabel *payMoney;//消费金额
@property (strong, nonatomic) IBOutlet UIButton *sureBtn ;
@property (strong, nonatomic) IBOutlet UIView *back;
@property (strong, nonatomic) IBOutlet UILabel *tipTitle;//余额不足提示信息

- (IBAction)sureBtnClick:(id)sender;

@end

@implementation ChangePayViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];

    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    MYLog(@"进入了充电状态viewAppear");
    
    [Config removeChargePay];//移除电费
    [Config removeChargeNum];//移除充电桩号
    [Config removeCurrentPower];//移除当前电量
    //存正常结束充电标志位为1
    [Config saveNormalEndChargingFlag:@"1"];//思路：开始充电的时候正常结束充电位置为为0.正常结束的时候为1
    //移除充电状态
    [Config removeUseCharge];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //置位所有充电操作
    if ([self.alertTitle isEqualToString:@""]) {
        self.tipTitle.alpha = 0;
    }else if ([self.alertTitle isEqualToString:@"提示：余额不足，自动停止充电并结算!"])
    {
        self.tipTitle.alpha = 1;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)initUI
{
    self.chargeTime.text = tempChargeTime;
    self.chargePower.text = tempChargePower;
    
    if (self.payMoney.text == NULL) {
      self.payMoney.text = @"0.00";
    }else
    {
      self.payMoney.text = tempPayMoney;
    }
//    self.payMoney.text = tempPayMoney;
    
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 8;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backView)];
    [self.back addGestureRecognizer:tap];
}

-(void)backView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sureBtnClick:(id)sender {
    
  [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark - SET方法
-(void)setChargeTimeStr:(NSString *)chargeTimeStr
{
    _chargeTimeStr = chargeTimeStr;
    tempChargeTime = chargeTimeStr;
}

-(void)setPowersStr:(NSString *)powersStr
{
    _powersStr = powersStr;
    tempChargePower = powersStr;
}

-(void)setPayMoneyStr:(NSString *)payMoneyStr
{
    _payMoneyStr = payMoneyStr;
    tempPayMoney= payMoneyStr;
}

@end
