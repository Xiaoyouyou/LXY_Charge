//
//  LoginViewController.m
//  Charge
//
//  Created by olive on 16/6/12.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

// 引入JPush功能所需头文件
#import "JPUSHService.h"
#import "LoginViewController.h"
#import "adminLeftView.h"
#import "MJExtension.h"
#import "Masonry.h"
#import "XFunction.h"
#import "XStringUtil.h"
#import "WMNetWork.h"
#import "AppDelegate.h"
#import "RegisterViewController.h"
#import "ChangePassWordViewController.h"
#import "BindingPhoneViewController.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "MBProgressHUD+MJ.h"
#import "PersonMesCaches.h"
#import "WXApiObject.h"
#import "loginModel.h"
#import "PersonMessage.h"
#import "API.h"
#import "Config.h"
#import "WXApi.h"


NSString *const AccessToken = @"accessToken";//QQ登陆token

NSString *const OpenId = @"openId";// QQ登陆openId

NSString *const ExpirationDate = @"expirationDate";//QQ登陆expirationDate

@interface LoginViewController ()<UITextFieldDelegate,WXApiDelegate,TencentSessionDelegate>
{
    UITextField *account;
    UITextField *mima;
    adminLeftView *leftView;
    UIButton *registerBtn;
    UIButton *ForgetMiMaBtn;
    UIButton *loginBtn;
    UIView *lineViews;
    UIView *lineView1;
    
    //第三方登陆
    UILabel *desLab;//描述lab
    UIButton *weChatBtn;//微信登陆按钮
    UIButton *QqLoginBtn;//qq登陆按钮
    UILabel *weChatLoginLab;//微信lab
    UILabel *QqLoginLab;//qqlab
    
    AppDelegate *appdelegate;
    
    int mySeconds;//充电总秒数
}

@property (nonatomic, strong) NSString *TempRegistrationID;
@property (nonatomic, strong) TencentOAuth *tencentOAuth;//qq实例

@end

@implementation LoginViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    UIImage *image = [UIImage imageNamed:@"back"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.view.backgroundColor = RGBA(231, 231, 231, 1);
    [self creatUI];
    
    //获取登陆账号
    NSString *accountAndPassword = [Config getOwnAccount];
    account.text = accountAndPassword;
    
    //获取JPush RegistrationID
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        
        MYLog(@"resCode : %d,registrationID: %@",resCode,registrationID);
        _TempRegistrationID = registrationID;
    }];
    
     _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQappid andDelegate:self];
    
    //通知事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tuiChuVC:) name:ThirdLoginPush object:nil];
}

#pragma mark - action

-(void)tuiChuVC:(NSNotification *)noti
{
    //如果是微信登陆，调用微信用户信息查询
    if ([noti.userInfo[@"login_platform"] intValue] == 1) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSMutableDictionary *paramers = [NSMutableDictionary dictionary];
        paramers[@"loginId"] = noti.userInfo[@"login_id"];
        
        NSString *token = noti.userInfo[@"user_token"];
        NSString *loginType = noti.userInfo[@"login_platform"];
        
        //保存token
        [Config saveToken:token];
        //保存第三方登陆状态
        [Config saveThirdLoginType:loginType];
        NSLog(@"loginType = %@",loginType);
        
        [WMNetWork post:GetWeChatMessage parameters:paramers success:^(id responseObj) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
          
            NSLog(@"微信登陆信息responseObj = %@",responseObj);
            if ([responseObj[@"status"] intValue] == 0) {
                //保存第三方登陆信息
                [self saveThirdMesWithNick:responseObj[@"result"][@"nickname"] andAvatar:responseObj[@"result"][@"headimgurl"]];
                //保存登陆必要信息
                [Config saveOwnID:responseObj[@"result"][@"user_id"]];
                [Config saveMobile:responseObj[@"result"][@"mobile"]];
                [MBProgressHUD showSuccess:@"登录成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
                
            }else{
                
                [MBProgressHUD showError:@"登陆失败,请重试！"];
            }
        } failure:^(NSError *error) {
            NSLog(@"error = %@",error);
            [MBProgressHUD showError:@"网络连接超时"];
        }];
    }else if ([noti.userInfo[@"login_platform"] intValue] == 2)//qq登陆
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSLog(@"qq登陆");
        NSString *token = noti.userInfo[@"user_token"];
        NSString *loginType = noti.userInfo[@"login_platform"];
        //保存token
        [Config saveToken:token];
        //保存第三方登陆状态
        [Config saveThirdLoginType:loginType];
        
        //保存第三方登陆信息
        [self saveThirdMesWithNick:noti.userInfo[@"nickName"] andAvatar:noti.userInfo[@"headerImage"]];
            //保存登陆必要信息
        [Config saveOwnID:noti.userInfo[@"user_id"]];
        [Config saveMobile:noti.userInfo[@"user_mobile"]];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showSuccess:@"登录成功"];
            [self dismissViewControllerAnimated:YES completion:nil];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                
//            
//            });
            
        });

    }
}

-(void)back
{
    [account resignFirstResponder];
    [mima resignFirstResponder];
    //延时
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     
    [self dismissViewControllerAnimated:YES completion:nil];
        
    });
}

#pragma mark - 初始化

-(void)creatUI
{
    leftView = [[adminLeftView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    leftView.imageName = @"admin";
    NSLog(@"%f",StatusBarH);
    account = [[UITextField alloc] initWithFrame:CGRectMake(15, StatusBarH + 60, XYScreenWidth-30, 44)];
    account.leftView = leftView;
    account.placeholder = @"请输入手机号码";
    account.delegate = self;
    account.keyboardType = UIKeyboardTypeNumberPad;
    account.tag = LogingVCTextfielTag2;
    account.font = [UIFont systemFontOfSize:14];
    account.backgroundColor = [UIColor whiteColor];
    account.layer.cornerRadius = 6;
    account.clipsToBounds = YES;
    account.leftViewMode = UITextFieldViewModeAlways;
    account.returnKeyType = UIReturnKeyDone;
    account.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.view addSubview:account];
    
    leftView = [[adminLeftView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    leftView.imageName = @"mima";
    
    mima = [[UITextField alloc] initWithFrame:CGRectMake(15, StatusBarH + 60 + 15 + 44, XYScreenWidth-30, 44)];
    mima.leftView = leftView;
    mima.delegate = self;
    mima.placeholder = @"请输入登录密码";
    mima.font = [UIFont systemFontOfSize:14];
    mima.backgroundColor = [UIColor whiteColor];
    mima.layer.cornerRadius = 6;
    mima.clipsToBounds = YES;
    mima.leftViewMode = UITextFieldViewModeAlways;
    mima.secureTextEntry = YES;
//  mima.clearsOnBeginEditing = YES;
    mima.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.view addSubview:mima];
    
    registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectZero;
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:registerBtn];
    
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mima.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset(15);
        make.size.mas_equalTo(CGSizeMake(38, 20));
    }];
    
    lineViews = [[UIView alloc] init];
    lineViews.backgroundColor = [UIColor blackColor];
    lineViews.alpha = 0.1;
    [self.view addSubview:lineViews];
    
    [lineViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(registerBtn.mas_bottom);
        make.left.equalTo(self.view).offset(15);
        make.size.mas_equalTo(CGSizeMake(38, 1));
    }];
    
    ForgetMiMaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ForgetMiMaBtn.frame = CGRectZero;
    [ForgetMiMaBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [ForgetMiMaBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [ForgetMiMaBtn addTarget:self action:@selector(ForgetMiMaAction) forControlEvents:UIControlEventTouchUpInside];
    ForgetMiMaBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:ForgetMiMaBtn];
    
    [ForgetMiMaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mima.mas_bottom).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.size.mas_equalTo(CGSizeMake(65, 20));
    }];
    
    lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = [UIColor blackColor];
    lineView1.alpha = 0.1;
    [self.view addSubview:lineView1];
    
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ForgetMiMaBtn.mas_bottom);
        make.right.equalTo(self.view).offset(-15);
        make.size.mas_equalTo(CGSizeMake(65, 1));
    }];
    
    loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius = 6;
    loginBtn.clipsToBounds = YES;
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"greenBg"] forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:loginBtn];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mima.mas_bottom).offset(50);
        make.right.equalTo(self.view).offset(-15);
        make.left.equalTo(self.view).offset(15);
        make.height.mas_equalTo(38);
    }];
    
////    //描述lab
//    desLab = [[UILabel alloc] init];
//    desLab.text = @"使用第三方账号登陆";
//    [desLab sizeToFit];
//    desLab.textAlignment = NSTextAlignmentCenter;
//    desLab.textColor = [UIColor blackColor];
//    desLab.font = [UIFont systemFontOfSize:15];
//    [self.view addSubview:desLab];
//
//    [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(loginBtn.mas_bottom).offset(50);
//        make.centerX.equalTo(self.view);
//    }];
//
//
//    //微信登陆按钮
//    weChatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [weChatBtn setBackgroundImage:[UIImage imageNamed:@"sns_weixin_icon@2x"] forState:UIControlStateNormal];
//    [weChatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [weChatBtn addTarget:self action:@selector(weChatAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:weChatBtn];
//
//    [weChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(desLab.mas_bottom).offset(30);
//        make.centerX.equalTo(self.view).offset(-40);
//    }];
//
//    //微信lab
//    weChatLoginLab = [[UILabel alloc] init];
//    weChatLoginLab.text = @"微信登陆";
//    [weChatLoginLab sizeToFit];
//    weChatLoginLab.textAlignment = NSTextAlignmentCenter;
//    weChatLoginLab.textColor = [UIColor blackColor];
//    weChatLoginLab.font = [UIFont systemFontOfSize:12];
//    [self.view addSubview:weChatLoginLab];
//
//    [weChatLoginLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weChatBtn.mas_bottom).offset(10);
//        make.centerX.equalTo(weChatBtn);
//    }];
//
//
//    //qq登陆按钮
//    QqLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [QqLoginBtn setBackgroundImage:[UIImage imageNamed:@"sns_qqfriends_icon@2x"] forState:UIControlStateNormal];
//    [QqLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [QqLoginBtn addTarget:self action:@selector(QqLoginBtn) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:QqLoginBtn];
//
//    [QqLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(desLab.mas_bottom).offset(30);
//        make.centerX.equalTo(self.view).offset(40);
//    }];
//
//    //QQ lab
//    QqLoginLab = [[UILabel alloc] init];
//    QqLoginLab.text = @"QQ登陆";
//    [QqLoginLab sizeToFit];
//    QqLoginLab.textAlignment = NSTextAlignmentCenter;
//    QqLoginLab.textColor = [UIColor blackColor];
//    QqLoginLab.font = [UIFont systemFontOfSize:12];
//    [self.view addSubview:QqLoginLab];
//
//    [QqLoginLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(QqLoginBtn.mas_bottom).offset(10);
//        make.centerX.equalTo(QqLoginBtn);
//    }];
    
}

#pragma mark - Action
-(void)weChatAction
{
    NSLog(@"微信登陆按钮点击了");
    if ([WXApi isWXAppInstalled]) {
        //构造SendAuthReq结构体
        SendAuthReq* req =[[SendAuthReq alloc ] init];
        req.scope = @"snsapi_userinfo";
        req.state =@"APP";
        
        [WXApi sendReq:req];
        
        //微信第三方登陆回调
        AppDelegate *appDels = [UIApplication sharedApplication].delegate;
        appDels.wxSendAuthRespResultBlock = ^(NSString* code,int errcode){
            MYLog(@"code = %@",code);
            MYLog(@"errcode = %d",errcode);
            if (errcode == 0) {
                NSMutableDictionary *paramers = [NSMutableDictionary dictionary];
                paramers[@"code"] = code;//获取的code参数
                [WMNetWork post:WeChatLogin parameters:paramers success:^(id responseObj) {
                    NSLog(@"responseObj = %@",responseObj);
                    if ([responseObj[@"status"] intValue] == 0) {
                            //0未绑定，1绑定
                        if ([responseObj[@"bind_phone"] intValue] == 0) {
                            //跳转绑定界面
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                BindingPhoneViewController *bindingVC = [[BindingPhoneViewController alloc] init];
                                bindingVC.loginID = responseObj[@"login_id"];
                                [self.navigationController pushViewController:bindingVC animated:YES];
                            });
                            
                        }else
                        {
                            //提示登陆成功，调用查询个人信息接口
                            //如果是微信登陆，调用微信用户信息查询
                            // 登录平台，0：账号密码登录，1：微信登录，2：qq登录
                            NSString *str = [NSString stringWithFormat:@"%d",[responseObj[@"login_platform"] intValue]];
                            //保存第三方登陆状态
                            [Config saveThirdLoginType:str];
                            NSString *token = responseObj[@"user_token"];
                            //保存user_token
                            [Config saveToken:token];
                            NSLog(@"str = %@",str);
                            
                            if ([responseObj[@"login_platform"] intValue] == 1) {
                                NSMutableDictionary *paramers = [NSMutableDictionary dictionary];
                                paramers[@"loginId"] = responseObj[@"login_id"];
                                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                
                                [WMNetWork post:GetWeChatMessage parameters:paramers success:^(id responseObj) {
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                     [MBProgressHUD showSuccess:@"登录成功"];
                                    NSLog(@"绑定成功 获取微信息 responseObj = %@",responseObj);
                                    //保存第三方登陆信息
                                    [self saveThirdMesWithNick:responseObj[@"result"][@"nickname"] andAvatar:responseObj[@"result"][@"headimgurl"]];
                                    //保存登陆必要信息
                                    [Config saveOwnID:responseObj[@"result"][@"user_id"]];
                                    [Config saveMobile:responseObj[@"result"][@"mobile"]];
                                    
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                        [self dismissViewControllerAnimated:YES completion:nil];
                                    });
                                    
                                } failure:^(NSError *error) {
                                    NSLog(@"error = %@",error);
                                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                    [MBProgressHUD showError:@"网络连接超时"];
                                }];
                            }else if ([responseObj[@"login_platform"] intValue] == 2)//qq登陆
                            {
                                
                                
                            }
                        }
                   
                    }else
                    {
                       NSLog(@"%@",responseObj[@"message"]);
                       [MBProgressHUD showError:@"授权失败请重试！"];
                    }
                    
                } failure:^(NSError *error) {
                    NSLog(@"error = %@",error);
                    [MBProgressHUD showError:@"网络连接超时"];
                }];
                
            }else
            {
                [MBProgressHUD showError:@"用户取消授权"];
            }
    };
        
    }else{
      //没有安装微信
      [self setupAlertController];
    }
}

-(void)QqLoginBtn
{
    NSLog(@"qq登陆了");
//    NSUserDefaults * token= [NSUserDefaults standardUserDefaults];
//    NSString *tokenStr = [token objectForKey:AccessToken];
//    
//    NSUserDefaults * openId= [NSUserDefaults standardUserDefaults];
//    NSString *openIdStr = [openId objectForKey:OpenId];
//    
//    NSUserDefaults * expirationDate= [NSUserDefaults standardUserDefaults];
//    NSDate *expirationDateStr = [expirationDate objectForKey:ExpirationDate];
//    
    //如果有保存的token等值就不用授权
//    if (tokenStr && openIdStr && expirationDateStr) {
//        //计算时间
//        NSDate *newCurrentDate = [NSDate date];
//        NSString *value = [XStringUtil dateTimeDifferenceWithStartTimes:expirationDateStr endTime:newCurrentDate];
//        //赋值计时器初始值
//        mySeconds = [value intValue];
//        NSLog(@"mySeconds = %d",mySeconds);
//        NSLog(@"openIdStr = %@",openIdStr);
//        NSLog(@"expirationDateStr = %@",expirationDateStr);
//        NSLog(@"tokenStr = %@",tokenStr);
//        
//        if (mySeconds<0) {
//            NSLog(@"授权未失效");
//            [_tencentOAuth setAccessToken:tokenStr] ;
//            [_tencentOAuth setOpenId:openIdStr] ;
//            [_tencentOAuth setExpirationDate:expirationDateStr];
//            // 获取用户信息
//            [_tencentOAuth getUserInfo];
//  
//        }else
//        {
//            NSLog(@"授权失效");
//            //发送qq授权
//            NSArray *permissions = [NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo",@"add_t",nil];
//            [_tencentOAuth setAuthShareType:AuthShareType_QQ];
//            [_tencentOAuth authorize:permissions inSafari:NO];
//        }
//
//    }else
//    {
//        NSLog(@"有为空的值");
        NSArray *permissions = [NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo",@"add_t",nil];
       // [_tencentOAuth authorize:permissions];
        [_tencentOAuth setAuthShareType:AuthShareType_QQ];
        [_tencentOAuth authorize:permissions inSafari:NO];
   

//    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [account resignFirstResponder];
    [mima resignFirstResponder];
}

//忘记密码
-(void)ForgetMiMaAction
{
    ChangePassWordViewController *changePassVC = [[ChangePassWordViewController alloc] init];
    [self.navigationController pushViewController:changePassVC animated:YES];
}

//登陆
-(void)loginBtnAction
{
    [mima resignFirstResponder];
    [account resignFirstResponder];
    
    if (account.text.length == 0) {
        [MBProgressHUD show:@"请输入手机号" icon:nil view:self.view];
        return;
    }
    if (mima.text.length == 0) {
        [MBProgressHUD show:@"请输入密码" icon:nil view:self.view];
        return;
    }
    
    if (![XStringUtil isPhoneNumber:account.text]) {
        [MBProgressHUD show:@"请输入正确的手机号" icon:nil view:self.view];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *paramers = [NSMutableDictionary dictionary];
    paramers[@"mobile"] = account.text;
    paramers[@"password"] = [XStringUtil stringToMD5:mima.text];//MD5加密密码
    paramers[@"deviceId"] = _TempRegistrationID;//设备id
    
    NSLog(@"MD5 = %@",[XStringUtil stringToMD5:mima.text]);
    
   [WMNetWork post:Login_Host parameters:paramers success:^(id responseObj) {
      
      MYLog(@"responseObj = %@",responseObj);
   if ([responseObj[@"status"] intValue] == 0) {
      
      [MBProgressHUD hideHUDForView:self.view animated:YES];
      [MBProgressHUD showSuccess:@"登录成功"];

      NSMutableDictionary *dict = responseObj[@"result"];
      MYLog(@"dict[id] = %@",dict[@"id"]);
      
       loginModel *userInfo = [loginModel objectWithKeyValues:responseObj[@"result"]];
       [Config saveOwnID:userInfo.id];//保存用户id
       [Config saveOwnAccount:account.text];
       [Config saveUseName:userInfo.nick];
       [Config saveMobile:userInfo.mobile];
       [Config savePortrait:userInfo.avatar];
       [Config saveToken:userInfo.token];
      
       //加载个人信息缓存模型
       PersonMessage  *per = [PersonMessage objectWithKeyValues:responseObj[@"result"]];
       //保存用户缓存信息
       [self saveDataWithSex:per.sex andAge:per.age andNick:per.nick andMobile:per.mobile andAvatar:per.avatar andSignature:per.signature];
      
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          if ([userInfo.checkCharging isEqualToString:@"1"]) {
              //通知首页加载继续充电
              [[NSNotificationCenter defaultCenter] postNotificationName:CheckChargingNotis object:nil];
          }
           [self dismissViewControllerAnimated:YES completion:nil];
      });
      
      }else if([responseObj[@"status"] intValue] == -1)
      {
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              [MBProgressHUD hideHUDForView:self.view animated:YES];
              [MBProgressHUD showError:responseObj[@"message"]];
          });
      }
      
  } failure:^(NSError *error) {
      
      MYLog(@"%@",error);
      if (error) {
      [MBProgressHUD hideHUDForView:self.view animated:YES];
      [MBProgressHUD show:@"网络连接超时" icon:nil view:self.view];
      }
      
  }];
}

//注册
-(void)registerBtnAction
{
    RegisterViewController *registerView = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerView animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextField 代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [mima resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == LogingVCTextfielTag2) {
        
        NSInteger strLength = textField.text.length - range.length + string.length;
        if (strLength > 11){
            return NO;
        }
        NSString *text = nil;
        //如果string为空，表示删除
        if (string.length > 0) {
            text = [NSString stringWithFormat:@"%@%@",textField.text,string];
        }else{
            text = [textField.text substringToIndex:range.location];
        }
    }
    return YES;
}

#pragma mark -- 保存个人信息缓存

- (void)saveDataWithSex:(NSString *)Sex andAge:(NSString *)Age andNick:(NSString *)Nick andMobile:(NSString *)Mobile andAvatar:(NSString *)Avatar andSignature:(NSString *)Signature
{
    PersonMesCaches *perCaches = [[PersonMesCaches alloc]init];
    perCaches.sex = Sex;
    perCaches.age = Age;
    perCaches.nick = Nick;
    perCaches.mobile = Mobile;
    perCaches.avatar = Avatar;
    perCaches.signature = Signature;
    
    //获取文件路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //文件类型可以随便取，不一定要正确的格式
    NSString *targetPath = [docPath stringByAppendingPathComponent:@"mes.plist"];
    
    //将自定义对象保存在指定路径下
    [NSKeyedArchiver archiveRootObject:perCaches toFile:targetPath];
    MYLog(@"文件已储存");
}

//第三方资料存储
-(void)saveThirdMesWithNick:(NSString *)Nick andAvatar:(NSString *)Avatar
{
    PersonMesCaches *perCaches = [[PersonMesCaches alloc]init];
    perCaches.nick = Nick;
    perCaches.avatar = Avatar;
    //获取文件路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //文件类型可以随便取，不一定要正确的格式
    NSString *targetPath = [docPath stringByAppendingPathComponent:@"ThirdMes.plist"];
    //将自定义对象保存在指定路径下
    [NSKeyedArchiver archiveRootObject:perCaches toFile:targetPath];
}

#pragma mark - 设置弹出微信是否安装提示语
-(void)setupAlertController
{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"该设备没安装微信，前往下载安装!" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WXApi getWXAppInstallUrl]]];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    
    [alertVc addAction:sureAction];
    [alertVc addAction:cancelAction];
    
    //    调用self的方法展现控制器
    [self presentViewController:alertVc animated:YES completion:nil];
}

#pragma mark - qq代理方法
- (void)tencentDidLogin
{
    NSLog(@"登陆成功");
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        //发送qq授权
        [_tencentOAuth setAccessToken:[_tencentOAuth accessToken]] ;
        [_tencentOAuth setOpenId:[_tencentOAuth openId]] ;
        [_tencentOAuth setExpirationDate:_tencentOAuth.expirationDate];
        // 获取用户信息
        [_tencentOAuth getUserInfo];
    }
    else
    {
        NSLog(@"登陆不成功，没有token");
        [MBProgressHUD showError:@"授权失败"];
    }
}

-(void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled)
    {
        NSLog(@"用户取消登录");
        [MBProgressHUD showError:@"用户取消授权"];
        
    }else
    {
        NSLog(@"登录失败");
        [MBProgressHUD showError:@"授权失败"];
    }
}

-(void)tencentDidNotNetWork
{
    NSLog(@"无网络连接，请设置网络");
    [MBProgressHUD showError:@"无网络连接，请设置网络"];
}

// 获取用户信息
- (void)getUserInfoResponse:(APIResponse *)response {
    
    if (response && response.retCode == URLREQUEST_SUCCEED) {
        NSLog(@"response = %@",[response jsonResponse]);
        NSDictionary *userInfo = [response jsonResponse];
     //   NSString *nickName = userInfo[@"nickname"];
    //    NSString *headerImage = userInfo[@"figureurl_qq_2"];

        //上传第三方平台登陆信息
        //nadate转换为时间戳
        NSTimeInterval a=[_tencentOAuth.expirationDate timeIntervalSince1970]*1000; // *1000 是精确到毫秒，不乘就是精确到秒
        NSString *timeString = [NSString stringWithFormat:@"%.0f", a]; //转为字符型
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSMutableDictionary *paramers = [NSMutableDictionary dictionary];
        paramers[@"access_token"] = _tencentOAuth.accessToken;
        paramers[@"refresh_token"] = @"";
        paramers[@"open_id"] = _tencentOAuth.openId;
        paramers[@"expires_in"] = timeString;
        paramers[@"platform"] = @"2";
    
        [WMNetWork post:UPloadThirdMes parameters:paramers success:^(id responseObj) {
            NSLog(@"responseObj = %@",responseObj);
             [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([responseObj[@"status"] intValue] == 0) {
                //0未绑定，1绑定
                if ([responseObj[@"bind_phone"] intValue] == 0) {
                    //跳转绑定界面
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        BindingPhoneViewController *bindingVC = [[BindingPhoneViewController alloc] init];
                        bindingVC.loginID = responseObj[@"login_id"];
                        bindingVC.nickName =  userInfo[@"nickname"];
                        bindingVC.headerImage =  userInfo[@"figureurl_qq_2"];
                        [self.navigationController pushViewController:bindingVC animated:YES];
                    });
                    
                }else//已经绑定
                {
                    //提示登陆成功，调用查询个人信息接口
                    //如果是微信登陆，调用微信用户信息查询
                    // 登录平台，0：账号密码登录，1：微信登录，2：qq登录
                    NSString *str = [NSString stringWithFormat:@"%d",[responseObj[@"login_platform"] intValue]];
                    //保存第三方登陆状态
                    [Config saveThirdLoginType:str];
                    NSString *token = responseObj[@"user_token"];
                    NSLog(@"token dsfsdfsdff = %@",token);
                    //保存user_token
                    [Config saveToken:token];
                    NSLog(@"str = %@",str);
               
                    if ([responseObj[@"login_platform"] intValue] == 2) {
                        
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        //保存第三方登陆信息
                        [self saveThirdMesWithNick:userInfo[@"nickname"] andAvatar:userInfo[@"figureurl_qq_2"]];
                        //保存登陆必要信息
                        [Config saveOwnID:responseObj[@"user_id"]];
                        [Config saveMobile:responseObj[@"mobile"]];
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            [MBProgressHUD showSuccess:@"登录成功"];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                       
                                [self dismissViewControllerAnimated:YES completion:nil];
                            });

                        });
                        
                    }
                }
            }else
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSLog(@"%@",responseObj[@"message"]);
                [MBProgressHUD showError:@"授权失败请重试！"];
            }
            
        } failure:^(NSError *error) {
            NSLog(@"error = %@",error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:@"网络连接超时"];
        }];

    } else {
        NSLog(@"QQ auth fail ,getUserInfoResponse:%d", response.detailRetCode);
    }
}

@end
