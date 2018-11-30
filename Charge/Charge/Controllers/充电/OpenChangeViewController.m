//
//  OpenChangeViewController.m
//  Charge
//
//  Created by olive on 16/8/19.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "OpenChangeViewController.h"
#import "ChargeingsViewController.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入搜索功能头文件
#import "XFunction.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "Singleton.h"
#import "XStringUtil.h"
#import "ChuZhiViewController.h"
#import "MyReservationViewController.h"
#import "ChuZiViewController.h"
#import "WMNetWork.h"
#import "Config.h"
#import "API.h"

#define OUTP_TIME 70
#define Check_OUTP_TIME 10

@interface OpenChangeViewController ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    int time;//计时
    int checkTime;//检测超时
    int mySeconds;//检测预约超时
//  NSTimer *timer;//等待时间
    
    
    //上传桩的地址的参数
    NSString *address;//街道名称
    NSString *district;//区县
    NSString *city;//城市
    NSString *province;//省份
    NSString *pingJieAddress;//拼接地址
}

//地图相关
@property (strong,nonatomic) BMKLocationService *locService;
@property (nonatomic, strong) BMKGeoCodeSearch *searcher;//初始化检索对象

@property (strong, nonatomic) IBOutlet UIView *containView;
@property (strong, nonatomic) IBOutlet UIButton *startChangeBtn;
@property (strong, nonatomic) IBOutlet UIView *backView;//返回back
@property (strong, nonatomic) IBOutlet UILabel *ChargePoints;
@property (strong, nonatomic) IBOutlet UILabel *chargeNum;
@property (strong, nonatomic) NSString *tempChargePoints;//临时存充电点地址
@property (strong, nonatomic) NSString *tempchargeNum;//临时存电桩号
@property (copy, nonatomic)   NSString *chargeStatus;//充电桩状态
@property (strong, nonatomic) ChargeingsViewController  *chargeVC;//正在充电控制器

@property (strong, nonatomic) NSString *chargeingNum;//充电桩桩号
@property (strong, nonatomic) NSTimer *timer;//等待时间
@property (strong, nonatomic) NSTimer *checkTimer;//检测充电桩状态超时定时器
@property (nonatomic, copy) NSString *balance;//余额

@property (nonatomic, copy) NSString  *latitude;//纬度
@property (nonatomic, copy) NSString  *longitude;//经度
@property (nonatomic, assign) BOOL isUpdateLocation;//是否更新地理位置

- (IBAction)startChageClick:(id)sender;

@end

@implementation OpenChangeViewController

-(void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
    
    [self.checkTimer invalidate];
    self.checkTimer = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self.timer invalidate];
    self.timer = nil;
    
    [self.checkTimer invalidate];
    self.checkTimer = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //初始化检测充电桩状态计时器
    //设置超时时间
    checkTime = Check_OUTP_TIME;
    //初始化超时时间
    self.checkTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(CheckoutTimeAction) userInfo:nil repeats:YES];

    [[Singleton sharedInstance] socketConnectHost];//连接socket
    [MBProgressHUD showMessage:@"正在检测充电桩状态" toView:self.view];
    //延时2秒
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //如果连接成功才发送检测充电桩状态
        if ([Singleton sharedInstance].isLink == 0) {
            //socket连接失败，请重试，返回上一级界面
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"服务器连接失败" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
            
            [alertVc addAction:sureAction];
            [self presentViewController:alertVc animated:YES completion:nil];
    
        }else
        {
            //发送检测状状态的指令
            [[Singleton sharedInstance] checkChargeStatusWithChargeNum:self.chargeingNum];
            //发送检测充电桩、
         
        }
    });
    
    //检查充电桩状态
    [Singleton sharedInstance].ChargeStatusMesBlock = ^(NSString *chargeStr){
            [MBProgressHUD hideHUDForView:self.view];
        
        //检查到充电桩状态清零计时器
        [self.checkTimer invalidate];
        self.checkTimer = nil;
            
    if ([chargeStr isEqualToString:@"10"] || [chargeStr isEqualToString:@"04"] || [chargeStr isEqualToString:@"05"] || [chargeStr isEqualToString:@"06"]) {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"此充电桩有故障，目前不可用" preferredStyle:UIAlertControllerStyleAlert];
            
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [[Singleton sharedInstance] cutOffSocket];//发现掉线切断socket
            [self.navigationController popToRootViewControllerAnimated:YES];
    
        }];
            
        [alertVc addAction:sureAction];
        [self presentViewController:alertVc animated:YES completion:nil];
        }
            
        if ([chargeStr isEqualToString:@"01"] || [chargeStr isEqualToString:@"02"] || [chargeStr isEqualToString:@"03"]) {
            self.chargeStatus = chargeStr;
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"充电桩被占用" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
            
            [alertVc addAction:sureAction];
            [self presentViewController:alertVc animated:YES completion:nil];
        }else if ([chargeStr isEqualToString:@"00"])
        {
            self.chargeStatus = chargeStr;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[Singleton sharedInstance] socketConnectHost];//连接socket
            });
            [MBProgressHUD showSuccess:@"和后台连接成功"];
        }
     };
    
    //检测电桩超时失败回调
    [Singleton sharedInstance].connectFailBlcok = ^(NSString *str){
    MYLog(@"%@",str);
    [MBProgressHUD hideHUDForView:self.view];
        
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"socket连接失败,是否重新连接" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[Singleton sharedInstance] socketConnectHost];//连接socket
//        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    
    [alertVc addAction:sureAction];
    [self presentViewController:alertVc animated:YES completion:nil];
    
    };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
    //查询用户余额
   // [self checkMoney];
    //初始化状态
    self.isUpdateLocation = 1;//加载1次位置更新的置位
    //初始化百度地图定位
    _locService = [[BMKLocationService alloc] init];
    _locService.delegate = self;
    //启动locationService
    [_locService startUserLocationService];
    //初始化检索对象
    _searcher = [[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    

}

-(void)checkMoney
{
    NSMutableDictionary *paramers = [NSMutableDictionary dictionary];
    paramers[@"userId"] = [Config getOwnID];
    
    [WMNetWork post:GetBalance parameters:paramers success:^(id responseObj) {
        
        MYLog(@"responseObj = %@",responseObj);
        self.balance = responseObj[@"balance"];
        
    } failure:^(NSError *error) {
        MYLog(@"%@",error);
        if (error) {
  
        }
    }];
}


-(void)initUI
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [self.backView addGestureRecognizer:tap];
    
    self.containView.layer.masksToBounds = YES;
    self.containView.layer.cornerRadius = 8;
    
    self.startChangeBtn.layer.masksToBounds = YES;
    self.startChangeBtn.layer.cornerRadius = 8;
    
  //self.ChargePoints.text =_tempChargePoints;
  //NSString *tempStr = [_tempchargeNum substringFromIndex:5];
  //NSString *str = [tempStr substringToIndex:10];//充电桩桩号
    
    self.chargeNum.text = _tempchargeNum;
    self.chargeingNum = _tempchargeNum;
    
    if (self.chargingAddress == NULL) {
        return;
    }else
    {
       self.ChargePoints.text = self.chargingAddress;
    }

}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    [[Singleton sharedInstance] cutOffSocket];//主动断开socket
}

//开启电桩按钮
- (IBAction)startChageClick:(id)sender {
    MYLog(@"点击了开始充电");
    //如果在预约别的桩，要先取消预约，才能充电。
    MYLog(@"[Config getYuYueFlag] = %@",[Config getYuYueFlag]);
    if ([[Config getYuYueFlag] isEqualToString:@"0"]) {
        
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"先取消预约,才能充电。" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            //跳转取消预约界面
            MyReservationViewController *myReservationVC = [[MyReservationViewController alloc] init];
            [self.navigationController pushViewController:myReservationVC animated:YES];
        }];
        
        [alertVc addAction:sureAction];
        //调用self的方法展现控制器
        [self presentViewController:alertVc animated:YES completion:nil];
        return;
        
       }
    
    NSMutableDictionary *paramers = [NSMutableDictionary dictionary];
    paramers[@"userId"] = [Config getOwnID];
    [MBProgressHUD showMessage:@"" toView:self.view];
    
    [WMNetWork post:GetBalance parameters:paramers success:^(id responseObj) {
        
        MYLog(@"responseObj = %@",responseObj);
        self.balance = responseObj[@"balance"];
        MYLog(@"balance = %@",self.balance);
        MYLog(@"balanceintValue = %f",[self.balance floatValue]);
        
        [MBProgressHUD hideHUDForView:self.view];
        if ([self.balance floatValue]<=0.01) {
            
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"余额不足，请充值！" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                //跳转到充值界面
                ChuZiViewController *chuziVC = [[ChuZiViewController alloc] init];
//              ChuZhiViewController *chuzhiVC = [[ChuZhiViewController alloc] init];
                [self.navigationController pushViewController:chuziVC animated:YES];
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                //退出
                [self.navigationController popToRootViewControllerAnimated:YES];
                
                [[Singleton sharedInstance] cutOffSocket];//主动断开socket
            }];
            
            [alertVc addAction:sureAction];
            [alertVc addAction:cancelAction];
            //    调用self的方法展现控制器
            [self presentViewController:alertVc animated:YES completion:nil];
        }else
        {
            if ([Singleton sharedInstance].isLink) {
                
                //设置超时时间
                time = OUTP_TIME;
                //初始化超时时间
                self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(outTimeAction) userInfo:nil repeats:YES];
//--------开始充电------------------------------------------------//
                //进入充电步揍
                [[Singleton sharedInstance] startChargingWithChargeNum:self.chargeingNum];//开始充电
                
                //超时计时器开启
                [self.timer fire];
                
                [MBProgressHUD showMessage:@"请插充电枪到电动车" toView:self.view];
                
                [Singleton sharedInstance].StartChargeBlock = ^(NSString *text)
                {
                NSString *status = [text substringWithRange:NSMakeRange(4, 4)];
                if ([status isEqualToString:@"0101"]) {
                        [MBProgressHUD showMessage:@"正在初始化充电桩，请您耐心等待" toView:self.view];
                }else if ([status isEqualToString:@"0100"]){
                    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"开启充电失败" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }];
                    
                    [alertVc addAction:sureAction];
                    [self presentViewController:alertVc animated:YES completion:nil];
                }
      
                MYLog(@"返回的充电确认充电指令text = %@",text);
                if ([status isEqualToString:@"0601"]) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
//                        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"开启充电成功" preferredStyle:UIAlertControllerStyleAlert];
//                        
//                        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//                            [self.navigationController popToRootViewControllerAnimated:YES];
//                        }];
//                        
//                        [alertVc addAction:sureAction];
//                        [self presentViewController:alertVc animated:YES completion:nil];
                    
                    if (self.chargeVC == nil) {
     //-----------------------------------------------------------------//
                        self.chargeVC = [[ChargeingsViewController alloc] init];
                        //                        self.chargeVC.chargeingNum = self.chargeingNum;//赋值充电桩桩号
                        [MBProgressHUD hideHUDForView:self.view];
                        //获取本地时间，并保存开始充电时间
                        NSDate *currentDate = [NSDate date];
                        [Config saveCurrentDate:currentDate];
                        //赋值置位正常结束充电标志位
                        [Config saveNormalEndChargingFlag:@"0"];
                        //保存当前充电桩桩号
                        [Config saveChargeNum:self.chargeingNum];
                        
                        [self.navigationController pushViewController: self.chargeVC animated:YES];
                        
                        //收到开始充电确认指令上传经纬度
                        //上传经纬度
                        if (self.latitude == NULL || self.longitude == NULL || address == NULL || district == NULL || city == NULL || province == NULL ) {
                            NSLog(@"上传的地址或者经纬度某个为空，不上传地址");
                        }else
                        {
                            if (self.isUpdateLocation == 1) {
                                //调用上传经纬度位置接口
                                [self UploadDeviceLocations];
                                self.isUpdateLocation =0;
                            }
                        }
                        [self.timer invalidate];
                        self.timer = nil;
                        //断开连接
                        [[Singleton sharedInstance] cutOffSocket];
                    }else if ([status isEqualToString:@"0600"]){
                        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"初始化充电桩失败,请再试一遍" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        }];
                        
                        [alertVc addAction:sureAction];
                        [self presentViewController:alertVc animated:YES completion:nil];
                        [[Singleton sharedInstance] cutOffSocket];
                     }
                    
                   }
               
            };
                
            }else
            {
                [[Singleton sharedInstance] socketConnectHost];//连接socket
                [MBProgressHUD show:@"正在连接服务器，请稍后" icon:nil view:self.view];
            }
        }
        
    } failure:^(NSError *error) {
        MYLog(@"%@",error);
           [MBProgressHUD hideHUDForView:self.view];
        if (error) {
           
        }
    }];
    
}

#pragma mark - SET方法

-(void)setEquipmentNum:(NSString *)equipmentNum
{
    _equipmentNum = equipmentNum;
    self.tempchargeNum = equipmentNum;
}

//-(void)setChargingAddress:(NSString *)chargingAddress
//{
//    _chargingAddress = chargingAddress;
//    self.tempChargePoints = chargingAddress;
//}

#pragma  mark - action

-(void)outTimeAction
{
    time--;
    MYLog(@"time = %d",time);
//    if (time == 0) {
//    [self.timer invalidate];
//    self.timer = nil;
//        
////  清除菊花
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"服务器未响应，请再试" preferredStyle:UIAlertControllerStyleAlert];
//        
//    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        
//        }];
//        
//        [alertVc addAction:sureAction];
//        [self presentViewController:alertVc animated:YES completion:nil];
//     
//    }else if (time == 50)
//    {
//        //50秒没收到回复，重发开启充电指令
//        [[Singleton sharedInstance] startChargingWithChargeNum:self.chargeingNum];//开始充电
//        
//    }else if (time == 40)
//    {
//        //40秒没收到回复，重发开启充电指令
//        [[Singleton sharedInstance] startChargingWithChargeNum:self.chargeingNum];//开始充电
//    }else if (time == 30)
//    {
//        //30秒没收到回复，重发开启充电指令
//        [[Singleton sharedInstance] startChargingWithChargeNum:self.chargeingNum];//开始充电
//    }else if (time == 20)
//    {
//        //20秒没收到回复，重发开启充电指令
//        [[Singleton sharedInstance] startChargingWithChargeNum:self.chargeingNum];//开始充电
//    }else if (time == 10)
//    {
//        //10秒没收到回复，重发开启充电指令
//        [[Singleton sharedInstance] startChargingWithChargeNum:self.chargeingNum];//开始充电
//    }
    
        if (time == 0) {
        [self.timer invalidate];
        self.timer = nil;
    
    //  清除菊花
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"服务器未响应，请再试" preferredStyle:UIAlertControllerStyleAlert];
    
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
            }];
    
            [alertVc addAction:sureAction];
            [self presentViewController:alertVc animated:YES completion:nil];
    
        }else if (time == 57)
        {
            //50秒没收到回复，重发开启充电指令
            [[Singleton sharedInstance] startChargingWithChargeNum:self.chargeingNum];//开始充电
    
        }else if (time == 54)
        {
            //40秒没收到回复，重发开启充电指令
            [[Singleton sharedInstance] startChargingWithChargeNum:self.chargeingNum];//开始充电
        }else if (time == 51)
        {
            //30秒没收到回复，重发开启充电指令
            [[Singleton sharedInstance] startChargingWithChargeNum:self.chargeingNum];//开始充电
        }else if (time == 49)
        {
            //20秒没收到回复，重发开启充电指令
            [[Singleton sharedInstance] startChargingWithChargeNum:self.chargeingNum];//开始充电
        }else if (time == 45)
        {
            //10秒没收到回复，重发开启充电指令
            [[Singleton sharedInstance] startChargingWithChargeNum:self.chargeingNum];//开始充电
        }else if (time == 40)
        {
            //10秒没收到回复，重发开启充电指令
            [[Singleton sharedInstance] startChargingWithChargeNum:self.chargeingNum];//开始充电
        }else if (time == 30)
        {
            //10秒没收到回复，重发开启充电指令
            [[Singleton sharedInstance] startChargingWithChargeNum:self.chargeingNum];//开始充电
        }else if (time == 20)
        {
            //10秒没收到回复，重发开启充电指令
            [[Singleton sharedInstance] startChargingWithChargeNum:self.chargeingNum];//开始充电
        }else if (time == 10)
        {
            //10秒没收到回复，重发开启充电指令
            [[Singleton sharedInstance] startChargingWithChargeNum:self.chargeingNum];//开始充电
        }
}

-(void)CheckoutTimeAction
{
    checkTime--;
    MYLog(@"checkTime = %d",checkTime);
    if (checkTime == 0) {
        [self.checkTimer invalidate];
        self.checkTimer = nil;
        //清除菊花
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"服务器连接超时"];
    }
    
}


#pragma mark - 百度地图位置更新代理方法

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        
//      MYLog(@"result = %@",result.addressDetail.city);
//      NSLog(@"resultsdfafd = %@",result.addressDetail);
//      NSLog(@"街道号码 = %@",result.addressDetail.streetNumber);//无
//      NSLog(@"街道名称 = %@",result.addressDetail.streetName);//新泰街
//      NSLog(@"区县 =%@",result.addressDetail.district);//天河区
//      NSLog(@"城市 = %@",result.addressDetail.city);//广州
//      NSLog(@"省份 = %@",result.addressDetail.province);//广东省
        NSString *newStr = [NSString stringWithFormat:@"%@ %@ %@ %@",result.addressDetail.province,result.addressDetail.city,result.addressDetail.district,result.addressDetail.streetName];
//      NSLog(@"拼接的地址是 = %@",newStr);
        address = result.addressDetail.streetName;//街道名称
        district = result.addressDetail.district;//区县
        city = result.addressDetail.city;//城市
        province = result.addressDetail.province;//省份
        pingJieAddress = newStr;//拼接地址
    }
    else {
        MYLog(@"抱歉，未找到结果");
    }
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
 //   MYLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    self.latitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
    
    //发起反向地理编码检索
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){[self.latitude doubleValue], [self.longitude doubleValue]};
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
                                                            BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
        MYLog(@"反geo检索发送成功");
    }
    else
    {
        MYLog(@"反geo检索发送失败");
    }

    [_locService stopUserLocationService];
}

//上传经纬度方法
-(void)UploadDeviceLocations
{
    NSMutableDictionary *paramers = [NSMutableDictionary dictionary];
    paramers[@"latitude"] = self.latitude;
    // NSLog(@"jingdu = %@",self.latitude);
    paramers[@"longitude"] = self.longitude;
    //  NSLog(@"weidu = %@",self.longitude);
    paramers[@"equipmentId"] = [Config getChargeNum];
    //  NSLog(@"equipmentId = %@",[Config getChargeNum]);
    paramers[@"userId"] = [Config getOwnID];
    // NSLog(@"userID = %@",[Config getOwnID]);
    
    paramers[@"province"] = province;//省份
    //  NSLog(@"provincexxxx = %@",province);
    paramers[@"city"] = city;//城市
    //  NSLog(@"cityxxx = %@",city);
    paramers[@"address"] = pingJieAddress;//拼接的地址
    // NSLog(@"addressxxx = %@",pingJieAddress);
    paramers[@"area"] = district;//区
    //   NSLog(@"areaxxx = %@",district);
    //   MYLog(@"self.latitude = %@",self.latitude);
    //   MYLog(@"self.longitude = %@",self.longitude);
    // 调用接口上传当前经纬度信息
    [WMNetWork post:UploadDeviceLocation parameters:paramers success:^(id responseObj) {
       // NSLog(@"responseObj = %@",responseObj);
        if ([responseObj[@"status"] intValue] == 0) {
            MYLog(@"%@",responseObj);
            MYLog(@"上传地址成功 = %@",pingJieAddress);
        }
        if ([responseObj[@"status"] intValue] == -1) {
            MYLog(@"上传地址失败");
        }
    } failure:^(NSError *error) {
        MYLog(@"%@",error);
        if (error) {
        }
    }];
    
}


@end
