//
//  AppDelegate.m
//  Charge
//
//  Created by olive on 16/6/3.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import "AppDelegate.h"
#import "MainViewController.h"
#import "ChargeingViewController.h"
#import "YBMonitorNetWorkState.h"
#import <AVFoundation/AVFoundation.h>
#import "XFunction.h"
#import "Reachability.h"
#import "LoginViewController.h"
#import "ChargingMessageModel.h"
#import "YuYueViewController.h"
#import "WMNetWork.h"
#import "MJExtension.h"
#import <AlipaySDK/AlipaySDK.h>
#import "MBProgressHUD.h"
#import "Singleton.h"
#import "Config.h"
//#import <RichAPM/RichAPM.h>
#import "MBProgressHUD+MJ.h"
#import "QRCodeReader.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "API.h"


static BOOL isProduction = FALSE;
static NSString *channel = @"Publish channel";


@interface AppDelegate ()<WXApiDelegate,YBMonitorNetWorkStateDelegate,JPUSHRegisterDelegate,TencentSessionDelegate>
{
  UIBackgroundTaskIdentifier bgTask;
    
}

@property (nonatomic, strong) NSString *tempRegistrationID;
@property (nonatomic, strong) TencentOAuth *tencentOAuth;//qq实例


@end

@implementation AppDelegate

-(void)initWeChat
{
    //向微信注册
    [WXApi registerApp:WeChat_appkey];
   
}

-(void)initBaiDu
{
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:BaiDuMap_appkey generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

#pragma mark 网络监听的代理方法，当网络状态发生改变的时候触发
- (void)netWorkStateChanged{
    if ([[YBMonitorNetWorkState shareMonitorNetWorkState] getNetWorkState]) {
        NSLog(@"有网络");
    }else
    {
        NSLog(@"没有网");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"未连接网络，请检查，WiFi或数据是否开启！" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击了确认按钮");
        }];
        [alert addAction:sure];
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
    }
}

-(void)checkNetWork
{
    [YBMonitorNetWorkState shareMonitorNetWorkState].delegate = self;
    // 添加网络监听
    [[YBMonitorNetWorkState shareMonitorNetWorkState] addMonitorNetWorkState];
    [self netWorkStateChanged];
}

- (void)initialization
{
    [self checkNetWork];//检测网络
    [self initBaiDu];//初始化百度
    [self initWeChat];//初始化微信
    [self init3DTouch];//初始化3Dtouch
    //[self initTencent];//初始化qq
    
  //  [self initAVAudio];//初始化后台运行
     [self initSaveLog];//初始化保存log日志文件
  // [RichAPM startWithAppID:Rich_APM_appkey];//初始化richAPM

    if (self.window == nil) {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds] ];
        [self.window makeKeyAndVisible];
    }
    //初始化控制器
    MainViewController *mainVC = [[MainViewController alloc] init];
    
    UINavigationController *Nav = [[UINavigationController alloc] init];
    [Nav addChildViewController:mainVC];

    self.window.rootViewController = Nav;
    
}

//-(void)initTencent
//{
 //  _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQappid andDelegate:self];
//}


-(void)init3DTouch
{
    //创建系统风格的icon
    UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeCloud];
    
    //创建快捷选项
    UIApplicationShortcutItem * item = [[UIApplicationShortcutItem alloc]initWithType:@"com.mycompany.myapp.saoma" localizedTitle:@"扫码开始充电" localizedSubtitle:nil icon:icon userInfo:nil];
    
    //添加到快捷选项数组
    [UIApplication sharedApplication].shortcutItems = @[item];

}


//上线需要注释
#pragma mark - 保存打印日志文件
-(void)initSaveLog
{
//    NSLog(@"跳到了输出logo方法");
    //如果已经连接Xcode调试则不输出到文件
    if(isatty(STDOUT_FILENO)) {
        return;
    }
    
    UIDevice *device = [UIDevice currentDevice];
    if([[device model] hasSuffix:@"Simulator"]){ //在模拟器不保存到文件中
        return;
    }
    
    //获取Document目录下的Log文件夹，若没有则新建
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *logDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Log"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:logDirectory];
    if (!fileExists) {
        [fileManager createDirectoryAtPath:logDirectory  withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //每次启动后都保存一个新的日志文件中
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    NSString *logFilePath = [logDirectory stringByAppendingFormat:@"/%@.txt",dateStr];
    
    // freopen 重定向输入输出流，将log输入到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
  
}

#pragma mark - action

//-(void)initYouMeng
//{
//    //打开调试日志
//    [[UMSocialManager defaultManager] openLog:YES];
//    
//    //设置友盟appkey
//    [[UMSocialManager defaultManager] setUmSocialAppkey:YouMeng_appkey];
//    
//    // 获取友盟social版本号
//    //NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
//    
//    //设置微信的appKey和appSecret
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WeChat_appkey appSecret:WeChat_appSecret redirectURL:@"http://www.baidu.com"];
//}

- (void)initAVAudio
{
    NSError *setCategoryErr = nil;
    NSError *activationErr = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &setCategoryErr];
    
    [[AVAudioSession sharedInstance] setActive: YES error: &activationErr];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [NSThread sleepForTimeInterval:0.5];
    [self initialization];


    //初始化JPUSH
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:JPUSH_appkey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    NSLog(@"launchOptions = %@",launchOptions);
    NSDictionary * remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
     NSLog(@"推送消息sdfsdf==== %@",remoteNotification);
    if (launchOptions) {
        NSDictionary * remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        //这个判断是在程序没有运行的情况下收到通知，点击通知跳转页面
        if (remoteNotification) {
            NSLog(@"推送消息==== %@",remoteNotification);
            [self goToMssageViewControllerWith:remoteNotification];
        }
    }
    //获取RegistrationID
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        NSLog(@"resCode : %d,registrationID: %@",resCode,registrationID);
        _tempRegistrationID = registrationID;
        NSLog(@"_tempRegistrationID = %@",_tempRegistrationID);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //设置别名
        [JPUSHService setAlias:_tempRegistrationID callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    });

    //版本更新
    [self VersionUpDate];
    
    //初始化JPUSH
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
//    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
//    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        // 可以添加自定义categories
//        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
//        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
//    }
//    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
//
//    // Required
//    // init Push
//    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
//    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
//    [JPUSHService setupWithOption:launchOptions appKey:JPUSH_appkey
//                          channel:channel
//                 apsForProduction:isProduction
//            advertisingIdentifier:nil];
//    NSLog(@"launchOptions = %@",launchOptions);
//    NSDictionary * remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//     NSLog(@"推送消息sdfsdf==== %@",remoteNotification);
//    if (launchOptions) {
//        NSDictionary * remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//        //这个判断是在程序没有运行的情况下收到通知，点击通知跳转页面
//        if (remoteNotification) {
//            NSLog(@"推送消息==== %@",remoteNotification);
//            [self goToMssageViewControllerWith:remoteNotification];
//        }
//    }
//    //获取RegistrationID
//    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
//        NSLog(@"resCode : %d,registrationID: %@",resCode,registrationID);
//        _tempRegistrationID = registrationID;
//        NSLog(@"_tempRegistrationID = %@",_tempRegistrationID);
//    }];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        //设置别名
//        [JPUSHService setAlias:_tempRegistrationID callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
//    });


    return YES;
}


-(void)VersionUpDate{
    
     NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://47.107.14.253/ios/version.json"]];
    NSData *res = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *JsonObject=[NSJSONSerialization JSONObjectWithData:res options:NSJSONReadingAllowFragments error:nil];
    NSLog (@"%@",JsonObject);
    NSString* newVersion = [JsonObject objectForKey:@"version"];
    if ([newVersion isEqualToString:@""]) return;
    //本地的版本号
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *myVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    
    //当前版本号小于服务上的版本号 需要下载
    if (myVersion.floatValue < newVersion.floatValue) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[JsonObject objectForKey:@"versionDesc"] message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *comfirmAction = [UIAlertAction actionWithTitle:@"去更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[JsonObject objectForKey:@"downloadUrl"]] options:@{} completionHandler:^(BOOL success) {
                }];
                
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:comfirmAction];
            [alertController addAction:cancelAction];
            [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
        });
    }
//    {
//        apkName = cdz;
//        downloadUrl = "http://sys2.xgnet.com.cn/apk/cdz.apk";
//        version = "1.4";
//        versionDesc = "\U53cb\U6869\U65b0\U7248\U672c\U53d1\U5e03\Uff0c\U5feb\U5145\U5145\U7535\U6869\U66f4\U8282\U7701\U4f60\U7684\U7b49\U5f85\U65f6\U95f4\Uff01";
//    }
}
    
>>>>>>> develope
- (void)tagsAliasCallback:(int)iResCode tags:(NSString *)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
    switch (iResCode) {
        case 0:
            MYLog(@"alias设置成功");
            break;
            
        case 1005:
            MYLog(@"APPkey不存在");
            break;
        case 1008:
            MYLog(@"APPkey非法");
            break;
        case 1009:
            MYLog(@"当前appkey无对应应用");
            break;
        case 6002:
            MYLog(@"设置超时");
             [JPUSHService setAlias:_tempRegistrationID callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
            break;
        case 6003:
            MYLog(@"alias 字符串不合法");
        case 6011:
            MYLog(@"短时间内操作过于频繁");
            break;
        
        default:
            break;
    }
}

//程序暂行
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

//程序进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"进入后台");
    //清零消息提示
    [application setApplicationIconBadgeNumber:0];

        bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        
        // 10分钟后执行这里，应该进行一些清理工作，如断开和服务器的连接等
        [application endBackgroundTask:bgTask];
         bgTask = UIBackgroundTaskInvalid;
        }];
    
       if (bgTask == UIBackgroundTaskInvalid) {
       NSLog(@"failed to start background task!");
       }
    
       // Start the long-running task and return immediately.
       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       // Do the work associated with the task, preferably in chunks.
      __block NSTimeInterval timeRemain = 0;
         do{
        [NSThread sleepForTimeInterval:5];
         if (bgTask!= UIBackgroundTaskInvalid) {
             // 如果没到10分钟，也可以主动关闭后台任务，但这需要在主线程中执行，否则会出错
             dispatch_async(dispatch_get_main_queue(), ^{
                timeRemain = [application backgroundTimeRemaining];
              //  NSLog(@"Time remaining: %f",timeRemain);
             });
            }
        }while(bgTask!= UIBackgroundTaskInvalid && timeRemain > 0);
        // 如果改为timeRemain > 5*60,表示后台运行5分钟
        // 如果没到10分钟，也可以主动关闭后台任务，但这需要在主线程中执行，否则会出错
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
                {
        // 和上面10分钟后执行的代码一样
        // if you don't call endBackgroundTask, the OS will exit your app.
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
           }
        });
    });
}
//程序进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"进入前台");
    //清零消息提示
    [application setApplicationIconBadgeNumber:0];
    //清除所有通知
    [application cancelAllLocalNotifications];
    
    // 如果没到10分钟又打开了app,结束后台任务
     if (bgTask!=UIBackgroundTaskInvalid) {
     [application endBackgroundTask:bgTask];
     bgTask = UIBackgroundTaskInvalid;
      }
    
}
//程序重新激活
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
//程序意外暂行
- (void)applicationWillTerminate:(UIApplication *)application {
     // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

     //移除充电状态
     //[Config removeUseCharge];

     //移除电量和电费
     [Config removeChargePay];
     [Config removeCurrentPower];
     //移除充电桩桩号
     [Config removeChargeNum];
    
    NSLog(@"移除充电主状态,通知后台主动断开socket了，充电自动扣费");
    //断开socket
     [[Singleton sharedInstance] cutOffSocket];

}

#pragma mark - WXAPiDelegate

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}


-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"url = %@",url.host);
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSLog(@"resultStatus = %@",[resultDic objectForKey:@"resultStatus"]);
            if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
                 [MBProgressHUD showSuccess:@"订单支付成功"];
                //通知支付宝充值完成
                [[NSNotificationCenter defaultCenter] postNotificationName:@"resultStatusSuccess" object:nil];
            }else if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"4000"])
            {
                 [MBProgressHUD showSuccess:@"订单支付失败"];
            }else if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"6001"])
            {
                 [MBProgressHUD showSuccess:@"用户中途取消"];
            }
        }];
        return YES;
    }else if ([url.host isEqualToString:@"pay"])
    {
       return [WXApi handleOpenURL:url delegate:self];
   }else if ([url.host isEqualToString:@"oauth"])
   {
      return [WXApi handleOpenURL:url delegate:self];
   }else if ([url.host isEqualToString:@"qq"])
   {
       NSLog(@"qq");
       return YES;
   }else if ([url.host isEqualToString:@"platformId=wechat"])
   {
        return [WXApi handleOpenURL:url delegate:self];
   }
       return YES;
}

-(void)onResp:(BaseResp*)resp{
    NSLog(@"微信支付回调接口调用了");
    if([resp isKindOfClass:[PayResp class]]){
        PayResp  *response=(PayResp*)resp;
        switch (response.errCode) {
                
        case WXSuccess:
                self.wxPayResultBlock(resp.errCode);
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
        default:
                self.wxPayResultBlock(resp.errCode);
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }else if ([resp isKindOfClass:[SendAuthResp class]])
    {
        NSLog(@"respsdfasdfsd =  %@",resp);
//      NSString *strMsg = [NSString stringWithFormat:@"code:%@,state:%@,errcode:%d", resp.code, resp.state, resp.errCode];
        SendAuthResp *authResp = (SendAuthResp *)resp;
        NSLog(@"code = %@",authResp.code);
        NSLog(@"state = %@",authResp.state);
        NSLog(@"lang = %@",authResp.lang);
        NSLog(@"country = %@",authResp.country);
        
        switch (authResp.errCode) {
            case WXSuccess:
                NSLog(@"授权成功 = %d", resp.errCode);
                self.wxSendAuthRespResultBlock(authResp.code,authResp.errCode);
                break;
            default:
                NSLog(@"授权失败 = %d", resp.errCode);
                [MBProgressHUD showError:@"用户取消授权"];
                self.wxSendAuthRespResultBlock(authResp.code,authResp.errCode);
                break;
        }
    }
}

- (void)goToMssageViewControllerWith:(NSDictionary*)msgDic{
//    //将字段存入本地，因为要在你要跳转的页面用它来判断,这里我只介绍跳转一个页面，
//    NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
//    [pushJudge setObject:@"push"forKey:@"push"];
//    [pushJudge synchronize];
//    NSString * targetStr = [msgDic objectForKey:@"target"];
//    if ([targetStr isEqualToString:@"notice"]) {
//       // 跳转控制器代码
       // MessageVC * VC = [[MessageVC alloc]init];
       // UINavigationController * Nav = [[UINavigationController alloc]initWithRootViewController:VC];//这里加导航栏是因为我跳转的页面带导航栏，如果跳转的页面不带导航，那这句话请省去。
       //[self.window.rootViewController presentViewController:Nav animated:YES completion:nil];
    NSString *alertStr = [[msgDic objectForKey:@"aps"] objectForKey:@"alert"];
    NSLog(@"alertStr = %@",alertStr);
    if ([alertStr isEqualToString:@"账号在另一台手机登录"]) {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"账号异常登录！" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [Config removeChargePay];//移除电费
            [Config removeChargeNum];//移除充电桩号
            [Config removeCurrentPower];//移除当前电量
            [Config saveNormalEndChargingFlag:@"1"];//思路：开始充电的时候正常结束充电位置为为0.正常结束的时候为1，        //存正常结束充电标志位为1
            
            [Config removeUseCharge];   //移除充电状态
            [Config removeOwnID];//移除ID
            [Config removeUseName];//移除用户名字
            [Config removetoken]; //移除token
        }];
        
        [alertVc addAction:sureAction];
        
        [self.window.rootViewController presentViewController:alertVc animated:YES completion:nil];
    }
//    }
}

#pragma mark - 极光推送

//注册APNs成功并上报DeviceToken
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

//实现注册APNs失败接口
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSLog(@"ios10推送接收到了");
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    NSLog(@"ios10 123userInfo = %@",userInfo);
    NSLog(@"aps.alert = %@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
    
    NSString *alertStr = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    if ([alertStr isEqualToString:@"账号在另一台手机登录"]) {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"账号在另一台手机登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [Config removeChargePay];//移除电费
            [Config removeChargeNum];//移除充电桩号
            [Config removeCurrentPower];//移除当前电量
            [Config saveNormalEndChargingFlag:@"1"];//思路：开始充电的时候正常结束充电位置为为0.正常结束的时候为1 //存正常结束充电标志位为1
            
            [Config removeUseCharge];//移除充电状态
            [Config removeOwnID];//移除ID
            [Config removeUseName];//移除用户名字
            [Config removetoken]; //移除token
        }];
        
        [alertVc addAction:sureAction];
        [self.window.rootViewController presentViewController:alertVc animated:YES completion:nil];
    }
    //发送异常登陆通知
    //[[NSNotificationCenter defaultCenter] postNotificationName:YiChangLogin object:nil];
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}


// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    NSLog(@"ios10456 userInfo = %@",userInfo);
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"ios7 尼玛的推送消息呢===%@",userInfo);
    // Required, iOS 7 Support
    NSString *alertStr = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    if ([alertStr isEqualToString:@"账号在另一台手机登录"]) {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"账号在另一台手机登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [Config removeChargePay];//移除电费
            [Config removeChargeNum];//移除充电桩号
            [Config removeCurrentPower];//移除当前电量
            [Config saveNormalEndChargingFlag:@"1"];//思路：开始充电的时候正常结束充电位置为为0.正常结束的时候为1，        //存正常结束充电标志位为1
            
            [Config removeUseCharge];//移除充电状态
            [Config removeOwnID];//移除ID
            [Config removeUseName];//移除用户名字
            [Config removetoken]; //移除token
        }];
        
        [alertVc addAction:sureAction];
        
        [self.window.rootViewController presentViewController:alertVc animated:YES completion:nil];
    }

    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"ios6 尼玛的推送消息呢===%@",userInfo);
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

#pragma mark - 支付宝代码
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    NSLog(@"url.host = %@",url.host);
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
                [MBProgressHUD showSuccess:@"支付成功"];
                //通知支付宝充值完成
                [[NSNotificationCenter defaultCenter] postNotificationName:@"resultStatusSuccess" object:nil];
            }else
            {
                [MBProgressHUD showSuccess:@"支付失败"];
            }
        }];
    }else if ([url.host isEqualToString:@"pay"])//微信支付
    {
      NSLog(@"微信 options = %@",options);
      return  [WXApi handleOpenURL:url delegate:self];
    }else if ([url.host isEqualToString:@"oauth"])
    {
         NSLog(@"微信登陆 options = %@",options);
//        LoginViewController *loginVC = [[LoginViewController alloc] init];
//        bool res = [WXApi handleOpenURL:url delegate:loginVC];
//        return res;
            return  [WXApi handleOpenURL:url delegate:self];
    }else if ([url.host isEqualToString:@"qzapp"])
    {
          return [TencentOAuth HandleOpenURL:url];
    }else if ([url.host isEqualToString:@"platformId=wechat"])
    {
          return  [WXApi handleOpenURL:url delegate:self];
    }
    
    return YES;
}

//如果app在后台，通过快捷选项标签进入app，则调用该方法，如果app不在后台已杀死，则处理通过快捷选项标签进入app的逻辑在- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions中
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    
    if (self.window == nil) {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds] ];
        [self.window makeKeyAndVisible];
    }
    
    //初始化控制器
    MainViewController *mainVC = [[MainViewController alloc] init];
    
    UINavigationController *Nav = [[UINavigationController alloc] init];
    [Nav addChildViewController:mainVC];
    
    self.window.rootViewController = Nav;
    
    //判断先前我们设置的快捷选项标签唯一标识，根据不同标识执行不同操作
    if([shortcutItem.type isEqualToString:@"com.mycompany.myapp.one"]){
        NSArray *arr = @[@"hello 3D Touch"];
        UIActivityViewController *vc = [[UIActivityViewController alloc]initWithActivityItems:arr applicationActivities:nil];
        [self.window.rootViewController presentViewController:vc animated:YES completion:^{
        }];
    } else if ([shortcutItem.type isEqualToString:@"com.mycompany.myapp.search"]) {//进入搜索界面
        NSLog(@"进入搜索界面");
//      SearchViewController *childVC = [storyboard instantiateViewControllerWithIdentifier:@"searchController"];
//      [mainNav pushViewController:childVC animated:NO];
    } else if ([shortcutItem.type isEqualToString:@"com.mycompany.myapp.saoma"]) {//进入分享界面
        NSLog(@"进入扫码界面");
//      SharedViewController *childVC = [storyboard instantiateViewControllerWithIdentifier:@"sharedController"];
//      [mainNav pushViewController:childVC animated:NO];
    }
    
    if (completionHandler) {
        completionHandler(YES);
    }
    
}

//- (void)tencentDidLogin
//{
  //  NSLog(@"登陆成功");
    //if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    //{
        // 记录登录用户的OpenID、Token以及过期时间
     //   NSLog(@"_tencentOAuth.accessToken = %@",_tencentOAuth.accessToken);
      //  NSLog(@"_tencentOAuth.openId = %@",_tencentOAuth.openId);
    //}
    //else
    //{
     //   NSLog(@"登陆不成功，没有token");
   // }
//}

//-(void)tencentDidNotLogin:(BOOL)cancelled
//{
  //  if (cancelled)
   // {
     //   NSLog(@"用户取消登录");
    //}else
    //{
      //  NSLog(@"登录失败");
    //}
//}
//-(void)tencentDidNotNetWork
//{
  //  NSLog(@"无网络连接，请设置网络");
//}

- (void)tencentDidLogin {
    
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    
}

- (void)tencentDidNotNetWork {
    
}

@end
