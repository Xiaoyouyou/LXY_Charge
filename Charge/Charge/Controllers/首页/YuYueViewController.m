//
//  YuYueViewController.m
//  Charge
//
//  Created by olive on 16/11/16.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "YuYueViewController.h"
#import "StartSearchViewController.h"
#import "MyReservationViewController.h"
#import "MyYuYueViewController.h"
#import "XFunction.h"
#import "UIView+Extension.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "MJExtension.h"
#import "TipView.h"
#import "Masonry.h"
#import "Singleton.h"
#import "Config.h"
#import "API.h"
#import "WMNetWork.h"


//预约成功标志位为：0
//定义枚举类型
typedef enum {
    jiaoLiu=0,//交流桩
    zhiLiu,//直流桩
} chargeType;


#define Check_OUTP_TIME 10
@interface YuYueViewController ()
{
     UIView *bgView;
     int checkTime;//检测超时
}

@property (strong, nonatomic) IBOutlet UIView *jiaoLiuTapView;
@property (strong, nonatomic) IBOutlet UIView *zhiLiuTapView;
@property (strong, nonatomic) IBOutlet UILabel *jiaoLiuLab;
@property (strong, nonatomic) IBOutlet UIImageView *jiaoLiuImageView;
@property (strong, nonatomic) IBOutlet UIImageView *zhiLiuImageView;
@property (strong, nonatomic) IBOutlet UILabel *jiaoLiuFree;
@property (strong, nonatomic) IBOutlet UILabel *zhiLiuFree;
@property (strong, nonatomic) IBOutlet UILabel *zhiLiuLab;

@property (nonatomic,assign) int InActionType; //操作类型

@property (strong, nonatomic) IBOutlet UIButton *sureBtn;
@property (strong, nonatomic) IBOutlet UIView *backView;//返回view
@property (nonatomic, strong) NSTimer *timer;//转菊花超时定时器

- (IBAction)sureBtnAction:(id)sender;

@end

@implementation YuYueViewController

-(void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = RGBA(235,236,237, 1);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jiaoLiuTap)];
    self.jiaoLiuTapView.userInteractionEnabled = YES;
    [self.jiaoLiuTapView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zhiLiuTap)];
    self.zhiLiuTapView.userInteractionEnabled = YES;
    [self.zhiLiuTapView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backclick)];
    [self.backView addGestureRecognizer:tap2];
    
    //初始化圆角
    self.sureBtn.layer.cornerRadius = 5;
    self.sureBtn.clipsToBounds = YES;
    
    self.jiaoLiuFree.text = [NSString stringWithFormat:@"空闲:%@",_freeCharge];
    self.zhiLiuFree.text = [NSString stringWithFormat:@"空闲:0"];
    self.zhiLiuFree.textColor = RGBA(181, 181, 183, 1);
    self.zhiLiuLab.textColor = RGBA(160, 162, 162, 1);
    
}

#pragma mark - action

-(void)creatTipViewWithChargingNum:(NSString *)chargingNum showMessage:(NSString *)showMes;
{
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:whiteView];
    
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    bgView = [[UIView alloc] init];
    bgView.layer.cornerRadius = 12;
    bgView.clipsToBounds = YES;
    bgView.backgroundColor = [UIColor whiteColor];
    [whiteView addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(128);
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.textColor = [UIColor blackColor];
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.text = showMes;
    [titleLab sizeToFit];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.top.equalTo(bgView).offset(20);
    }];
    
    UILabel *FutitleLab = [[UILabel alloc] init];
    FutitleLab.textColor = [UIColor blackColor];
    FutitleLab.font = [UIFont systemFontOfSize:13];
    FutitleLab.textColor = RGBA(137, 138, 139, 1);
    FutitleLab.text = chargingNum;
    [FutitleLab sizeToFit];
    FutitleLab.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:FutitleLab];
    
    [FutitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.top.equalTo(titleLab.mas_bottom).offset(15);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGBA(129, 196, 182, 1);
    [bgView addSubview:lineView];

    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.left.equalTo(bgView).offset(20);
        make.right.equalTo(bgView).offset(-20);
        make.top.equalTo(FutitleLab.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
    }];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:RGBA(27, 173, 149, 1) forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(YuYuesureBtn) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:sureBtn];
    
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.left.equalTo(bgView);
        make.right.equalTo(bgView);
        make.top.equalTo(lineView.mas_bottom);
        make.bottom.equalTo(bgView);
    }];
}

-(void)jiaoLiuTap
{
    self.InActionType = jiaoLiu;
    
    self.jiaoLiuLab.textColor = RGBA(6, 168, 144, 1);
    self.jiaoLiuImageView.image = [UIImage imageNamed:@"choose@2x.png"];
    self.jiaoLiuFree.textColor = [UIColor blackColor];

    self.zhiLiuLab.textColor = RGBA(160, 162, 162, 1);
    self.zhiLiuImageView.image = [UIImage imageNamed:@""];
    self.zhiLiuFree.textColor = RGBA(181, 181, 183, 1);
}
-(void)zhiLiuTap
{
    self.InActionType = zhiLiu;
    
    self.zhiLiuLab.textColor = RGBA(6, 168, 144, 1);
    self.zhiLiuImageView.image = [UIImage imageNamed:@"choose@2x.png"];
    self.zhiLiuFree.textColor = [UIColor blackColor];
    
    self.jiaoLiuLab.textColor = RGBA(160, 162, 162, 1);
    self.jiaoLiuImageView.image = [UIImage imageNamed:@""];
    self.jiaoLiuFree.textColor = RGBA(181, 181, 183, 1);
}

-(void)backclick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)YuYuesureBtn
{
    [UIView animateWithDuration:0.3 animations:^{
        bgView.alpha = 0;
        [bgView removeFromSuperview];
    } completion:^(BOOL finished) {
        MyYuYueViewController *MyYuYueVC = [[MyYuYueViewController alloc] init];
        [self presentViewController:MyYuYueVC animated:YES completion:nil];
    }];
}


- (IBAction)sureBtnAction:(id)sender {
    
    //正在充电，不能预约
    if ([[Config getNormalEndChargingFlag] isEqualToString:@"0"]) {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"正在充电,请结束充电" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        [alertVc addAction:sureAction];
        [self presentViewController:alertVc animated:YES completion:nil];
        return;
    }
    
    if (self.InActionType == 0) {
        
        if ([self.jiaoLiuFreeCount isEqualToString:@"0"]) {
           [MBProgressHUD showError:@"暂无交流桩可预约"];
            return;
        }
    }
    
    if (self.InActionType == 1) {
        
        if ([self.zhiLiuFreeCount isEqualToString:@"0"]) {
            [MBProgressHUD showError:@"暂无直流桩可预约"];
             return;
        }
    }
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"确定预约吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        //设置预约socket超时定时器
        //设置超时时间
        checkTime = Check_OUTP_TIME;
        //初始化超时时间
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(CheckoutTimeAction) userInfo:nil repeats:YES];
        
        //确定预约动作
        NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
        parmas[@"stationId"] = self.chargeID;
        parmas[@"chargingType"] = [NSString stringWithFormat:@"%d",self.InActionType];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        MYLog(@"stationId = %@",self.chargeID);
        [WMNetWork post:ReservationCharge parameters:parmas success:^(id responseObj) {
           MYLog(@"yuyueresponseObj = %@",responseObj);
            if ([responseObj[@"status"] intValue] == 0) {
                //连接socket预约电桩
                [[Singleton sharedInstance] socketConnectHost];
                //延时0.5秒
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([Singleton sharedInstance].isLink) {
                        
                        NSMutableString *chargeCost = [[NSMutableString  alloc] initWithString:@"000000"];
                        int cost = [self.yuYueCost doubleValue] *100;
                
                        NSString *costStr = [NSString stringWithFormat:@"%d",cost];
                        //充电费每分钟费率
                        [chargeCost replaceCharactersInRange:NSMakeRange(chargeCost.length - costStr.length, costStr.length) withString:costStr];
                        
                        MYLog(@"充电费率是chargeCost = %@",chargeCost);
                        //发送预约电桩指令
                       // [[Singleton sharedInstance] yuYueChargeNum:@"004401001003000000" cost:chargeCost];
                          [[Singleton sharedInstance] yuYueChargeNum:responseObj[@"pileId"] cost:chargeCost];
                        //预约的充电桩号
                        NSString *strCharge = responseObj[@"pileId"];
                        
                        //预约消息回复
                        [Singleton  sharedInstance].YuYueChargeStatusMesBlock = ^(NSString *chargeStr){
                       
                            [self.timer invalidate];
                            self.timer = nil;
                            
                            if ([chargeStr isEqualToString:@"状态正常"]) {
//                              [self creatTipViewWithChargingNum:@"004401001003000000"];//创建提示view
                                //查询后台确定是否预约成功
                                //查看预约信息
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                 
                                NSMutableDictionary *paramers = [NSMutableDictionary dictionary];
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                paramers[@"mobile"] = [Config getMobile];
                                MYLog(@"getMobile = %@",[Config getMobile]);
                                
                                [MBProgressHUD showMessage:@"" toView:self.view];
                                [WMNetWork post:ReservationInfoCharge parameters:paramers success:^(id responseObj) {
                                    
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                    MYLog(@"chaxunyuyueresponseObj = %@",responseObj);
                                    
                                    if ([responseObj[@"status"] intValue] == 0) {
                                        //预约成功
                                        MYLog(@"预约Http检查：预约成功");
                                        [self creatTipViewWithChargingNum:strCharge showMessage:@"预约成功"];
                                        //预约成功存预约成功标志位
                                        [Config saveYuYueFlag:@"0"];
                                    }
                                    
                                    if ([responseObj[@"status"] intValue] == -1) {
                                         //预约失败
                                        MYLog(@"请到预约信息栏查看预约");
                                        [MBProgressHUD showError:@"请到预约信息栏查看预约"];
                                    }
                                } failure:^(NSError *error) {
                                    MYLog(@"%@",error);
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                    [MBProgressHUD showError:@"预约失败"];
                                }];

                            });
                            
                            }else if ([chargeStr isEqualToString:@"充电桩故障"])
                            {
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                [MBProgressHUD showError:@"预约失败,充电桩故障"];
                            }else if ([chargeStr isEqualToString:@"充电桩正在使用"])
                            {
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                [MBProgressHUD showError:@"预约失败,充电桩正在使用"];
                            }else if ([chargeStr isEqualToString:@"充电桩掉线"])
                            {
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                [MBProgressHUD showError:@"预约失败,充电桩掉线"];
                            
                            }else if ([chargeStr isEqualToString:@"充电桩被预约"])
                            {
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                [MBProgressHUD showError:@"预约失败,充电桩被预约"];
                            }else
                            {
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                [MBProgressHUD showError:@"预约失败44"];
                            }
                        };
                    }else
                    {
                       
                    }
                });
            }
        } failure:^(NSError *error) {
            MYLog(@"%@",error);
            
            [self.timer invalidate];
            self.timer = nil;

            if (error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD show:@"网络连接失败" icon:nil view:self.view];
            }
        }];
    }];
    
    [alertVc addAction:cancelAction];
    [alertVc addAction:sureAction];
    [self presentViewController:alertVc animated:YES completion:nil];
    
}

//检查超时时间动作
-(void)CheckoutTimeAction
{
    checkTime--;
    MYLog(@"checkTime = %d",checkTime);
    if (checkTime == 0) {
        [self.timer invalidate];
        self.timer = nil;
        //清除菊花
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"服务器连接超时" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        
        [alertVc addAction:sureAction];
        [self presentViewController:alertVc animated:YES completion:nil];
    }
}

@end
