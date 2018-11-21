//
//  ChargeingsViewController.m
//  Charge
//
//  Created by olive on 16/8/22.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
//#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
//#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入搜索功能头文件
#import "ChargeingsViewController.h"
#import "ChangePayViewController.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "Masonry.h"
#import "API.h"
#import "Config.h"
#import "heartView.h"
#import "XStringUtil.h"
#import "XFunction.h"
#import "Singleton.h"
#import "WMNetWork.h"
#import "PersonMessage.h"

#define OUTP_TIME 45

@interface ChargeingsViewController ()
{
    heartView *heart;
    int mySeconds;
    int time;//计时
    NSTimer *timer;//超时时间
//    
//    //上传桩的地址的参数
//    NSString *address;//街道名称
//    NSString *district;//区县
//    NSString *city;//城市
//    NSString *province;//省份
//    NSString *pingJieAddress;//拼接地址
    
}

/***--------luoxiaoyou------------****/
@property (strong, nonatomic) IBOutlet UILabel *voltage;

@property (strong, nonatomic) IBOutlet UILabel *current;
@property (strong, nonatomic) IBOutlet UILabel *remainingTime;
@property (strong, nonatomic) IBOutlet UIProgressView *socProgress;
@property (strong, nonatomic) IBOutlet UILabel *socJIndu;

////地图相关
//@property (strong,nonatomic) BMKLocationService *locService;
//@property (nonatomic, strong) BMKGeoCodeSearch *searcher;//初始化检索对象

@property (weak, nonatomic)   IBOutlet UIImageView *bgImageView;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UIButton *endChrgeingBtn;
@property (nonatomic, retain)  NSTimer *Timer; // 充电时间定时器
@property (nonatomic, retain)  NSTimer *chargeTimer; // 获取电量定时器

@property (strong, nonatomic) IBOutlet UILabel *costMoney;//消费金额
@property (strong, nonatomic) IBOutlet UILabel *chargedAmount;//已充电量
@property (strong, nonatomic) ChangePayViewController  *ChangePay;

@property (strong, nonatomic) NSString *tempChargeTime;//临时传值时间
@property (nonatomic, copy) NSString *MoneyNoEnoughTipStr;//余额不足的提示
@property (nonatomic, strong) NSString *chargeingNum;//充电桩桩号

@property (nonatomic, copy) NSString  *latitude;//纬度
@property (nonatomic, copy) NSString  *longitude;//经度
@property (nonatomic, assign) BOOL isUpdateLocation;//是否更新地理位置

- (IBAction)endChargeBtnClick:(id)sender;

@end

@implementation ChargeingsViewController

//#pragma mark - 百度地图位置更新代理方法
//
//-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
//    if (error == BMK_SEARCH_NO_ERROR) {
//        
//        MYLog(@"result = %@",result.addressDetail.city);
//        NSLog(@"resultsdfafd = %@",result.addressDetail);
//        
//        NSLog(@"街道号码 = %@",result.addressDetail.streetNumber);//无
//        NSLog(@"街道名称 = %@",result.addressDetail.streetName);//新泰街
//        NSLog(@"区县 =%@",result.addressDetail.district);//天河区
//        NSLog(@"城市 = %@",result.addressDetail.city);//广州
//        NSLog(@"省份 = %@",result.addressDetail.province);//广东省
//        
//        NSString *newStr = [NSString stringWithFormat:@"%@ %@ %@ %@",result.addressDetail.province,result.addressDetail.city,result.addressDetail.district,result.addressDetail.streetName];
//        NSLog(@"拼接的地址是 = %@",newStr);
//        address = result.addressDetail.streetName;//街道名称
//        district = result.addressDetail.district;//区县
//        city = result.addressDetail.city;//城市
//        province = result.addressDetail.province;//省份
//        pingJieAddress = newStr;//拼接地址
//    }
//    else {
//        MYLog(@"抱歉，未找到结果");
//    }
//}
//
////处理位置坐标更新
//- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
//{
//    MYLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
//
//    self.latitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
//    self.longitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
//
//    //发起反向地理编码检索
//    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){[self.latitude doubleValue], [self.longitude doubleValue]};
//    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
//                                                            BMKReverseGeoCodeOption alloc]init];
//    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
//    BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
//    if(flag)
//    {
//        MYLog(@"反geo检索发送成功");
//    }
//    else
//    {
//        MYLog(@"反geo检索发送失败");
//    }
//    
//    //延时2秒，再上传经纬度
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        if (address == NULL || district == NULL || city == NULL || province == NULL) {
//            NSLog(@"上传的地址某个为空，不上传地址");
//        }else
//        {
//        
//        if (self.isUpdateLocation == 1) {
//            //调用上传经纬度位置接口
//            [self UploadDeviceLocations];
//            self.isUpdateLocation =0;
//        }
//        }
//    });
//    
//    [_locService stopUserLocationService];
//}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    //进入前台通知事件
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:app];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.socProgress.layer.masksToBounds = YES;
    self.socProgress.layer.cornerRadius = 3;
    self.socProgress.layer.borderWidth = 2.0;
    self.socProgress.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.isUpdateLocation =1;//置位还原
    //反注册通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
    
    if ([Config getChargeNum]) {
      self.chargeingNum = [Config getChargeNum];
      //判断sock是否连接
    if ([Singleton sharedInstance].isLink) {
            MYLog(@"socket连接正常");
            //发送继续充电指令
            [[Singleton sharedInstance] continueCharging];//继续充电
        }else{
            //连接socket
            [[Singleton sharedInstance] socketConnectHost];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([Singleton sharedInstance].isLink) {
                    //发送继续充电指令
                    [[Singleton sharedInstance] continueCharging];//继续充电
                 }
            });
        }
    }
    
    //充电结束Blcok
    [self abnormalStopCharge];
    
    //判断是否有存当前时间
    if ([Config getCurrentDate]) {
        MYLog(@"获取到当前时间");
        NSDate *newCurrentDate = [NSDate date];
        NSString *value = [XStringUtil dateTimeDifferenceWithStartTimes:[Config getCurrentDate] endTime:newCurrentDate];
        //赋值计时器初始值
        mySeconds = [value intValue];
        NSString *tmphh = [NSString stringWithFormat:@"%d",mySeconds/3600];
        if ([tmphh length] == 1)
        {
            tmphh = [NSString stringWithFormat:@"0%@",tmphh];
        }
        NSString *tmpmm = [NSString stringWithFormat:@"%d",(mySeconds/60)%60];
        if ([tmpmm length] == 1)
        {
            tmpmm = [NSString stringWithFormat:@"0%@",tmpmm];
        }
        NSString *tmpss = [NSString stringWithFormat:@"%d",mySeconds%60];
        if ([tmpss length] == 1)
        {
            tmpss = [NSString stringWithFormat:@"0%@",tmpss];
        }
        
        self.tempChargeTime =[NSString stringWithFormat:@"%@%@%@",tmphh,tmpmm,tmpss];//保存传值充电拼接时间
        self.chargeTime.text = [NSString stringWithFormat:@"%@:%@:%@",tmphh,tmpmm,tmpss];

    }else
    {
        MYLog(@"没有当前时间");
    }
    
    //金额不足充电结束block
    [Singleton sharedInstance].MoneyNoEnoughMesBlock = ^(NSString *chargeStr){
        MYLog(@"接收到的异常充电是text =%@",chargeStr);
        self.MoneyNoEnoughTipStr = chargeStr;
        
        //存充电状态:0.代表结束充电
        [Config saveUseCharge:@"0"];
        
        //充电计时器销毁
        [self.Timer invalidate];//时间停止
        self.Timer = nil;
        mySeconds = 0;
        
        //移除当前时间
        [Config removeCurrentDate];
   
        //超时定时器销毁
        [timer invalidate];
        timer = nil;
        
        //断开socket
        [[Singleton sharedInstance] cutOffSocket];
        
        //结束充电通知
        [[NSNotificationCenter defaultCenter] postNotificationName:EndChargeingMessage object:nil];
        
        [Config removeUseCharge];
        
        if (self.ChangePay == nil) {
            
            self.ChangePay = [[ChangePayViewController alloc] init];
   
            MYLog(@"getChargePaygetChargePay%@",[Config getChargePay]);
            MYLog(@"getCurrentPowergetCurrentPower%@",[Config getCurrentPower]);
            
            self.ChangePay.payMoneyStr = [Config getCurrentPower];
         
            self.ChangePay.powersStr =  [Config getChargePay];
    
            self.ChangePay.chargeTimeStr = self.chargeTime.text;
            
            if (self.MoneyNoEnoughTipStr == nil) {
                self.ChangePay.alertTitle = @"";
            }else
            {
                self.ChangePay.alertTitle = @"提示：余额不足，自动停止充电并结算!";
            }
            
            
            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:self.ChangePay.chargeTimeStr,@"time",self.MoneyNoEnoughTipStr,@"unenoughMoney", nil];
            
            //如果self.navigationController为null 通知首页推出结算界面 否则在当前页面推出结算界面
            if (self.navigationController == NULL) {
                //通知首页推出结算界面
                [[NSNotificationCenter defaultCenter] postNotificationName:UNenoughChargeNot object:nil userInfo:dict];
            }else
            {
                [self.navigationController pushViewController:self.ChangePay animated:YES];
            }
            //移除当前时间
            [Config removeCurrentDate];
            //移除电量和电费
            [Config removeChargePay];
            [Config removeCurrentPower];
            //移除充电桩号
            [Config removeChargeNum];
            //移除用户充电状态
            [Config removeUseCharge];
            //移除充电状态
            [Config removeUseCharge];
            //存正常结束充电标志位为1
            [Config saveNormalEndChargingFlag:@"1"];//思路：开始充电的时候正常结束充电位置为为0.正常结束的时候为1
        }
    };
    
    
    if ([Config getCurrentPower]) {

        MYLog(@"getChargePay  = %@",[Config getChargePay]);
        MYLog(@"getCurrentPower = %@",[Config getCurrentPower]);
        
        self.chargedAmount.text = [Config getCurrentPower];
        self.costMoney.text = [Config getChargePay];
        
    }else
    {
        
    }
      [Singleton sharedInstance].StartReceiveMesBlock = ^(NSString *text){
      MYLog(@"接收到的充电信息是text =%@",text);
      
      //消费 金额
      NSString *payMoney = [text substringWithRange:NSMakeRange(31, 6)];
      MYLog(@"payMoney = %@",payMoney);
      //已充电量
      NSString *power = [text substringWithRange:NSMakeRange(37, 6)];
      MYLog(@"power = %@",power);
          
      NSString *temp = nil;
      for(int i =0; i < [power length]; i++)
          {
              temp = [power substringWithRange:NSMakeRange(i, 1)];
              if ([temp isEqualToString:@"0"]) {
                  
              }else
              {
                  NSString *powerNum = [power substringWithRange:NSMakeRange(i, [power length] - i)];
                  MYLog(@"powerNum = %@",powerNum);
                  NSString *charging = [NSString stringWithFormat:@"%.2f",[powerNum floatValue]/100];
                  MYLog(@"powerNum除于100 = %@",charging);
                  self.chargedAmount.text = [NSString stringWithFormat:@"%@kwh",charging];
                  //保存电量
                  [Config saveCurrentPower:[NSString stringWithFormat:@"%@kwh",charging]];
               
                   break;
              }
          }
          
      NSString *temps = nil;
      for(int i =0; i < [payMoney length]; i++)
          {
              temps = [payMoney substringWithRange:NSMakeRange(i, 1)];
              if ([temps isEqualToString:@"0"]) {
                  
              }else
              {
                  NSString *pays = [payMoney substringWithRange:NSMakeRange(i, [payMoney length] - i)];
                  MYLog(@"payMoney = %@",pays);
                  NSString *pay = [NSString stringWithFormat:@"%.2f",[pays floatValue]/100];
                  MYLog(@"payMoney除于100 = %@",pay);
                  self.costMoney.text = [NSString stringWithFormat:@"%@￥",pay];
                  //保存电费
                  [Config saveChargePay:[NSString stringWithFormat:@"%@￥",pay]];
                  break;
              }
        }
    };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //初始化状态
//     self.isUpdateLocation = 1;//加载1次位置更新的置位
//    //初始化百度地图定位
//    _locService = [[BMKLocationService alloc] init];
//    _locService.delegate = self;
//    //启动locationService
//    [_locService startUserLocationService];
//    //初始化检索对象
//    _searcher = [[BMKGeoCodeSearch alloc]init];
//    _searcher.delegate = self;
    
    self.MoneyNoEnoughTipStr = nil;
    
    heart = [[heartView alloc]initWithFrame:CGRectZero];
    heart.backgroundColor = [UIColor clearColor];
    [self.view addSubview:heart];
    
    [heart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.bgImageView addSubview:heart];
    [self.view bringSubviewToFront:heart];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [self.backView addGestureRecognizer:tap];
    
    //倒圆角
    self.endChrgeingBtn.layer.masksToBounds = YES;
    self.endChrgeingBtn.layer.cornerRadius = 8;
    
    //存充电状态:1.代表正在充电
    [Config saveUseCharge:@"1"];
    
    //开始计时充电
    self.Timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAdd) userInfo:nil repeats:YES];
    [self.Timer fire];
    
    self.chargeTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(checkUpChargeMessage) userInfo:nil repeats:YES];
    [self.chargeTimer fire];
    
    //增加异常登录通知
  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yiChangLogin) name:YiChangLogin object:nil];
}


-(void)checkUpChargeMessage{
    NSDictionary *paramer = @{
                              @"userId":[Config getOwnID]
                              };
    [WMNetWork get:ChargeMessge parameters:paramer success:^(id responseObj) {
        NSString *str1 = responseObj[@"chargInfo"][@"spendMoney"];
        NSString *str2 = responseObj[@"chargInfo"][@"electric"];//电量
        NSString *volStr = responseObj[@"chargInfo"][@"vol"];//电压
        NSString *lefttimeStr = responseObj[@"chargInfo"][@"lefttime"];//剩余时间
        NSString *eleStr = responseObj[@"chargInfo"][@"ele"];//电流
        NSString *socStr = responseObj[@"chargInfo"][@"soc"];//SOC
        self.voltage.text = [NSString stringWithFormat:@"%.2fV",volStr.floatValue];//电压
        self.current.text = [NSString stringWithFormat:@"%.2fA",eleStr.floatValue];//电流
        self.remainingTime.text = [self timeString:lefttimeStr];
        //[NSString stringWithFormat:@"%.2fs",lefttimeStr.floatValue];//剩余时间
        self.socJIndu.text = [NSString stringWithFormat:@"%.1f%%",socStr.floatValue];//进度
        self.socProgress.progress = socStr.floatValue / 100.00;
        
        
        self.remainingTime.text = [self timeString:lefttimeStr];
//        [NSString stringWithFormat:@"%.2fs",lefttimeStr.floatValue];//剩余时间

        
        self.costMoney.text = [NSString stringWithFormat:@"%.2f￥",str1.floatValue];//消费金额
        self.chargedAmount.text = [NSString stringWithFormat:@"%.2fkwh",str2.floatValue];//已充电量
        [Config saveCurrentPower:[NSString stringWithFormat:@"%.2fkwh",str2.floatValue]];
        //保存电量
        [Config saveChargePay: [NSString stringWithFormat:@"%.2f￥",str1.floatValue]];//保存电费
        
        if(![responseObj[@"chargInfo"][@"endTime"] isEqualToString:@""]){
            [MBProgressHUD showSuccess:@"充电已经结束"];
            //充电之后的结算
            self.costMoney.text = [NSString stringWithFormat:@"%.2f￥",str1.floatValue];//消费金额
            self.chargedAmount.text = [NSString stringWithFormat:@"%.2fkwh",str2.floatValue];//已充电量
            
            [Config saveCurrentPower:[NSString stringWithFormat:@"%.2fkwh",str2.floatValue]];
            //保存电量
            [Config saveChargePay: [NSString stringWithFormat:@"%.2f￥",str1.floatValue]];//保存电费
            //结束充电通知 修改首页扫码充电按钮文字
            [[NSNotificationCenter defaultCenter] postNotificationName:EndChargeingMessage object:nil];
            //跳转到结算界面
            //---------------------------------------------------------//
            if (self.ChangePay == nil) {
                self.ChangePay = [[ChangePayViewController alloc] init];
                
                if ([Config getChargePay] == NULL) {
                    self.ChangePay.payMoneyStr =@"0￥";
                }else
                {
                    self.ChangePay.payMoneyStr = [Config getChargePay];
                }
                
                if ([Config getCurrentPower] == NULL) {
                    self.ChangePay.powersStr =@"0kwh";
                }else
                {
                    self.ChangePay.powersStr = [Config getCurrentPower];
                }
                
                self.ChangePay.chargeTimeStr = self.chargeTime.text;
                
                
                if (self.MoneyNoEnoughTipStr == nil) {
                    self.ChangePay.alertTitle = @"";
                }else
                {
                    self.ChangePay.alertTitle = @"提示：余额不足，自动停止充电并结算!";
                }
                NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:self.ChangePay.chargeTimeStr,@"time",self.MoneyNoEnoughTipStr,@"unenoughMoney", nil];
                //如果self.navigationController为null 通知首页推出结算界面 否则在当前页面推出结算界面
                if (self.navigationController == NULL) {
                    //通知首页推出结算界面
                    [[NSNotificationCenter defaultCenter] postNotificationName:JiTingChargeNot object:nil userInfo:dict];
                }else
                {
                    [self.navigationController pushViewController:self.ChangePay animated:YES];
                }
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //充电计时器销毁
    [self.Timer invalidate];//时间停止
    self.Timer = nil;
    //超时定时器销毁
    [timer invalidate];
    timer = nil;
    
    
    [self.chargeTimer invalidate];//时间停止  超时定时器销毁
    self.chargeTimer = nil;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}


-(void)back
{
    //通知首页正在充电状态显示
    [[NSNotificationCenter defaultCenter] postNotificationName:ChargeingMessage object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//结束充电
- (IBAction)endChargeBtnClick:(id)sender {
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"确定要结束充电吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //设置超时时间
        time = OUTP_TIME;
        //初始化超时时间
         timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(outTimeAction) userInfo:nil repeats:YES];
        [timer fire];
        [MBProgressHUD showSuccess:@"正在结束充电"];
        [[Singleton sharedInstance] socketConnectHost];
//        [[Singleton sharedInstance] startReconectBlcok];
        [[Singleton sharedInstance] stopChargingWithChargeNum:self.chargeingNum];//停止充电
        
    }];
    
    [alertVc addAction:sureAction];
    [alertVc addAction:cancelAction];

    [self presentViewController:alertVc animated:YES completion:nil];
}

#pragma mark - ACTION

-(void)yiChangLogin
{
    NSLog(@"异常登录事件处理");
}

-(void)timeAdd
{
    mySeconds ++;
    NSString *tmphh = [NSString stringWithFormat:@"%d",mySeconds/3600];
    if ([tmphh length] == 1)
    {
        tmphh = [NSString stringWithFormat:@"0%@",tmphh];
    }
    NSString *tmpmm = [NSString stringWithFormat:@"%d",(mySeconds/60)%60];
    if ([tmpmm length] == 1)
    {
        tmpmm = [NSString stringWithFormat:@"0%@",tmpmm];
    }
    NSString *tmpss = [NSString stringWithFormat:@"%d",mySeconds%60];
    if ([tmpss length] == 1)
    {
        tmpss = [NSString stringWithFormat:@"0%@",tmpss];
    }
    
    self.chargeTime.text = [NSString stringWithFormat:@"%@:%@:%@",tmphh,tmpmm,tmpss];
}

#pragma  mark - action
-(void)outTimeAction
{
    time--;
    MYLog(@"time = %d",time);
    if (time == 0) {
        
        [timer invalidate];
        timer = nil;
        //清除菊花转
        [MBProgressHUD hideHUD];
        
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"服务器未响应，请再试" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        }];
        
        [alertVc addAction:sureAction];
        [self presentViewController:alertVc animated:YES completion:nil];
        
    }else if (time == 58)
    {
        //40s重发结束充电指令
        [[Singleton sharedInstance] stopChargingWithChargeNum:self.chargeingNum];//停止充电
        
    }else if (time == 55)
    {
        //30s重发结束充电指令
        [[Singleton sharedInstance] stopChargingWithChargeNum:self.chargeingNum];//停止充电
    }else if (time == 52)
    {
        //25s重发结束充电指令
        [[Singleton sharedInstance] stopChargingWithChargeNum:self.chargeingNum];//停止充电
      
    }else if (time == 49)
    {
        //20s重发结束充电指令
        [[Singleton sharedInstance] stopChargingWithChargeNum:self.chargeingNum];//停止充电
    }else if (time == 46)
    {
        //10s重发结束充电指令
        [[Singleton sharedInstance] stopChargingWithChargeNum:self.chargeingNum];//停止充电
    }else if (time == 40)
    {
        //10s重发结束充电指令
        [[Singleton sharedInstance] stopChargingWithChargeNum:self.chargeingNum];//停止充电
    }else if (time == 30)
    {
        //10s重发结束充电指令
        [[Singleton sharedInstance] stopChargingWithChargeNum:self.chargeingNum];//停止充电
    }else if (time == 20)
    {
        //10s重发结束充电指令
        [[Singleton sharedInstance] stopChargingWithChargeNum:self.chargeingNum];//停止充电
    }else if (time == 10)
    {
        //10s重发结束充电指令
        [[Singleton sharedInstance] stopChargingWithChargeNum:self.chargeingNum];//停止充电
    }
    
}


//收到充电结束的回调Blcok
-(void)abnormalStopCharge
{
    [Singleton sharedInstance].StopChargingMesBlock = ^(NSString *text){
        
        //text:aabb05001 406001290 20181028-22-23-43 20181028-22-25-55
        NSString *status = [text substringWithRange:NSMakeRange(4, 4)];
        NSString *status2 = [text substringWithRange:NSMakeRange(4, 2)];
        if([status isEqualToString:@"0201"]){
            [MBProgressHUD showMessage:@"正在结束充电,请稍后" toView:self.view];
            [MBProgressHUD hideHUDForView:self.view];
        }else if([status isEqualToString:@"0200"]){
            [MBProgressHUD showSuccess:@"结束充电失败"];
            [[Singleton sharedInstance] startReconectBlcok];
        }
        if([status2 isEqualToString:@"05"]){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (self.ChangePay == nil) {
                
                //存充电状态:0.代表结束充电
                [Config saveUseCharge:@"0"];
                MYLog(@"getUseCharge = %@",[Config getUseCharge]);
                
                //充电计时器销毁
                [self.Timer invalidate];//时间停止
                self.Timer = nil;
                mySeconds = 0;
                
                //超时定时器销毁
                [timer invalidate];
                timer = nil;
                
                //结束充电通知
                [[NSNotificationCenter defaultCenter] postNotificationName:EndChargeingMessage object:nil];
                
                //跳转到结算界面
                
                
 //---------------------------------------------------------//
//                self.ChangePay = [[ChangePayViewController alloc] init];
//
//
//                if ([Config getChargePay] == NULL) {
//                    self.ChangePay.payMoneyStr =@"0￥";
//                }else
//                {
//                    self.ChangePay.payMoneyStr = [Config getChargePay];
//                }
//
//                if ([Config getCurrentPower] == NULL) {
//                    self.ChangePay.powersStr =@"0kwh";
//                }else
//                {
//                    self.ChangePay.powersStr = [Config getCurrentPower];
//                }
//
//                self.ChangePay.chargeTimeStr = self.chargeTime.text;
//
//
//                if (self.MoneyNoEnoughTipStr == nil) {
//                    self.ChangePay.alertTitle = @"";
//                }else
//                {
//                    self.ChangePay.alertTitle = @"提示：余额不足，自动停止充电并结算!";
//                }
//
//                NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:self.ChangePay.chargeTimeStr,@"time",self.MoneyNoEnoughTipStr,@"unenoughMoney", nil];
//
//                //如果self.navigationController为null 通知首页推出结算界面 否则在当前页面推出结算界面
//                if (self.navigationController == NULL) {
//                    //通知首页推出结算界面
//                    [[NSNotificationCenter defaultCenter] postNotificationName:JiTingChargeNot object:nil userInfo:dict];
//
//                }else
//                {
//                    [self.navigationController pushViewController:self.ChangePay animated:YES];
//                }
//
                [self checkUpChargeMessage];
                //移除当前时间
                [Config removeCurrentDate];
                //移除电量和电费
                [Config removeChargePay];
                [Config removeCurrentPower];
                //移除充电桩号
                [Config removeChargeNum];
                //移除用户充电状态
                [Config removeUseCharge];
                //移除充电状态
                [Config removeUseCharge];
                //存正常结束充电标志位为1
                [Config saveNormalEndChargingFlag:@"1"];//思路：开始充电的时候正常结束充电位置为为0.正常结束的时候为1
                
                
                //   [self.navigationController pushViewController:self.ChangePay animated:YES];
                NSLog(@"navigationController = %@",self.navigationController);
                //断开socket
                 [MBProgressHUD showSuccess:@"结束充电成功"];
                [[Singleton sharedInstance] cutOffSocket];
            }
        }
        //结束充电
        MYLog(@"接收到的结束充电指令text = %@",text);
        

        
       
    };
//}];
}

#pragma  mark - otherAction、
////上传经纬度方法
//-(void)UploadDeviceLocations
//{
//    NSMutableDictionary *paramers = [NSMutableDictionary dictionary];
//    paramers[@"latitude"] = self.latitude;
//    paramers[@"longitude"] = self.longitude;
//    paramers[@"equipmentId"] = [Config getChargeNum];
//    paramers[@"userId"] = [Config getOwnID];
//    
//    paramers[@"province"] = province;//省份
//    paramers[@"city"] = city;//城市
//    paramers[@"address"] = pingJieAddress;//拼接的地址
//    paramers[@"area"] = district;//区
//
//    
//    MYLog(@"self.latitude = %@",self.latitude);
//    MYLog(@"self.longitude = %@",self.longitude);
//    
//   // 调用接口上传当前经纬度信息
//   [WMNetWork post:UploadDeviceLocation parameters:paramers success:^(id responseObj) {
//  
//        if ([responseObj[@"status"] intValue] == 0) {
//            MYLog(@"%@",responseObj);
//            MYLog(@"上传成功地址成功 = %@",pingJieAddress);
//        }
//    } failure:^(NSError *error) {
//        MYLog(@"%@",error);
//        if (error) {
//        }
//    }];
//}

//定义进入前台时调用的函数
- (void)applicationWillEnterForeground:(NSNotification *)notification
{
    //进入前台时调用此函数
    
    //如果充电状态为正在充电
    if ([[Config getNormalEndChargingFlag] isEqualToString:@"0"]) {
        
        if ([Singleton sharedInstance].isLink) {
            MYLog(@"socket连接正常");
            //发送继续充电指令
            [[Singleton sharedInstance] continueCharging];//继续充电
        }else{
            //连接socket
            [[Singleton sharedInstance] socketConnectHost];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([Singleton sharedInstance].isLink) {
                    //发送继续充电指令
                    [[Singleton sharedInstance] continueCharging];//继续充电
                }
            });
        }
    }
    MYLog(@"进入前台，正在充电，充电界面时间更新");
    if ([Config getCurrentDate]) {
        MYLog(@"获取到当前时间");
        NSDate *newCurrentDate = [NSDate date];
        NSString *value = [XStringUtil dateTimeDifferenceWithStartTimes:[Config getCurrentDate] endTime:newCurrentDate];
        //赋值计时器初始值
        mySeconds = [value intValue];
        NSString *tmphh = [NSString stringWithFormat:@"%d",mySeconds/3600];
        if ([tmphh length] == 1)
        {
            tmphh = [NSString stringWithFormat:@"0%@",tmphh];
        }
        NSString *tmpmm = [NSString stringWithFormat:@"%d",(mySeconds/60)%60];
        if ([tmpmm length] == 1)
        {
            tmpmm = [NSString stringWithFormat:@"0%@",tmpmm];
        }
        NSString *tmpss = [NSString stringWithFormat:@"%d",mySeconds%60];
        if ([tmpss length] == 1)
        {
            tmpss = [NSString stringWithFormat:@"0%@",tmpss];
        }
        
        self.tempChargeTime =[NSString stringWithFormat:@"%@%@%@",tmphh,tmpmm,tmpss];//保存传值充电拼接时间
        self.chargeTime.text = [NSString stringWithFormat:@"%@:%@:%@",tmphh,tmpmm,tmpss];
    }
    
}


-(NSString *)timeString:(NSString *)timeStr{
    NSString *tmphh = [NSString stringWithFormat:@"%d",timeStr.intValue/3600];
    if ([tmphh length] == 1)
    {
        tmphh = [NSString stringWithFormat:@"0%@",tmphh];
    }
    NSString *tmpmm = [NSString stringWithFormat:@"%d",(timeStr.intValue/60)%60];
    if ([tmpmm length] == 1)
    {
        tmpmm = [NSString stringWithFormat:@"0%@",tmpmm];
    }
    NSString *tmpss = [NSString stringWithFormat:@"%d",timeStr.intValue%60];
    if ([tmpss length] == 1)
    {
        tmpss = [NSString stringWithFormat:@"0%@",tmpss];
    }
    
   NSString *str = [NSString stringWithFormat:@"%@:%@:%@",tmphh,tmpmm,tmpss];
    return str;
}

@end
