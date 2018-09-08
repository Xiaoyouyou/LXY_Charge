//
//  ChuZhiViewController.m
//  Charge
//
//  Created by olive on 16/7/8.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "ChuZhiViewController.h"
#import "XFunction.h"
#import "Masonry.h"
#import "WMNetWork.h"
#import "WXApi.h"
#import "MBProgressHUD+MJ.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Config.h"
#import "API.h"
#import "NavView.h"

typedef enum{
    
   weChat = 0,//微信支付
   aliplay,//支付宝支付

}payType;


@interface ChuZhiViewController ()<UITextFieldDelegate>
{
    UITextField *moneyTextField;//输入金额
    UILabel *leftLab;//左边lab
    
    UIView *weChatView;//微信view
    UIImageView *weChatImageView;//微信图片
    UILabel *weChatLab;//微信lab
    UIImageView *gouImageView;//打钩图片
    
    UIView *aliplayView;//支付宝view
    UIImageView *aliplayImageView;//支付宝图片
    UILabel *aliplayLab;//支付宝lab
    UIImageView *gouImageView1;//打钩图片
    
    UIButton *weChatPay;//微信支付
    UIButton *alipayPay;//支付宝支付
    
    UIButton *chuZhiBtn;//充值按钮
    UILabel *desLab;//描述lab
}

//定义枚举属性
@property (nonatomic,assign) int InActionType; //操作类型

@end

@implementation ChuZhiViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //添加文本框通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeValue:) name:UITextFieldTextDidChangeNotification object:nil];
    [moneyTextField becomeFirstResponder];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.title = @"余额储值";
//    UIImage *image = [UIImage imageNamed:@"back"];
//    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    //初始化自定义nav
    NavView *nav = [[NavView alloc] initWithFrame:CGRectZero title:@"余额储值"];
    nav.backBlock = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:nav];
    
    [nav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
    
    self.view.backgroundColor = RGBA(235, 236, 237, 1);
    [self creatUI];
    
    //增加支付宝充值完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zhiFubaoAction) name:@"resultStatusSuccess" object:nil];
    
}


-(void)zhiFubaoAction
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

-(void)creatUI
{
    leftLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 86, 49)];
    leftLab.text = @"金额(元)";
    leftLab.font = [UIFont systemFontOfSize:14];
    leftLab.textColor = [UIColor blackColor];
    leftLab.textAlignment = NSTextAlignmentCenter;
    
    moneyTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 80, XYScreenWidth, 49)];
    moneyTextField.leftView = leftLab;
    moneyTextField.placeholder = @"请输入金额(上限9999元)";
    moneyTextField.delegate = self;
    moneyTextField.keyboardType = UIKeyboardTypeNumberPad;
    moneyTextField.font = [UIFont systemFontOfSize:14];
    moneyTextField.backgroundColor = [UIColor whiteColor];

    moneyTextField.leftViewMode = UITextFieldViewModeAlways;
    moneyTextField.clearsOnBeginEditing = YES;
    moneyTextField.borderStyle = UITextBorderStyleNone;
    moneyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:moneyTextField];
    
    //微信支付
    weChatView = [[UIView alloc] init];
    weChatView.backgroundColor = [UIColor whiteColor];
    weChatView.layer.cornerRadius = 3;
    weChatView.layer.masksToBounds = YES;
    weChatView.userInteractionEnabled = YES;
    [self.view addSubview:weChatView];
    
    UITapGestureRecognizer *weChatTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weChatAction)];
    [weChatView addGestureRecognizer:weChatTap];
    

    [weChatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyTextField.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(43);
    }];
    
    weChatImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    weChatImageView.image = [UIImage imageNamed:@"weChat@2x.png"];
    [weChatView addSubview:weChatImageView];
    
   [weChatImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weChatView);
        make.left.equalTo(weChatView).offset(15);
        make.size.mas_equalTo(CGSizeMake(26, 26));
   }];
    
    weChatLab = [[UILabel alloc] init];
    weChatLab.text = @"微信";
    weChatLab.font = [UIFont systemFontOfSize:16];
    weChatLab.textColor = [UIColor blackColor];
    weChatLab.textAlignment = NSTextAlignmentCenter;
    [weChatView addSubview:weChatLab];
    
    [weChatLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weChatView);
        make.left.equalTo(weChatImageView.mas_right).offset(15);
    }];
    
    gouImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    gouImageView.image = [UIImage imageNamed:@"chongZhi@2x.png"];
    [weChatView addSubview:gouImageView];
    
    [gouImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weChatView);
        make.right.equalTo(weChatView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];
    
    
    //支付宝支付
    aliplayView = [[UIView alloc] init];
    aliplayView.backgroundColor = [UIColor whiteColor];
    aliplayView.layer.cornerRadius = 3;
    aliplayView.layer.masksToBounds = YES;
    aliplayView.userInteractionEnabled = YES;
    [self.view addSubview:aliplayView];
    
    [aliplayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weChatView.mas_bottom).offset(8);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(43);
    }];
    
    UITapGestureRecognizer *aliplayTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aliplayAction)];
    [aliplayView addGestureRecognizer:aliplayTap];
    
    
    aliplayImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    aliplayImageView.image = [UIImage imageNamed:@"alplay@2x.png"];
    [aliplayView addSubview:aliplayImageView];
    
    [aliplayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(aliplayView);
        make.left.equalTo(aliplayView).offset(15);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
    
    aliplayLab = [[UILabel alloc] init];
    aliplayLab.text = @"支付宝";
    aliplayLab.font = [UIFont systemFontOfSize:16];
    aliplayLab.textColor = [UIColor blackColor];
    aliplayLab.textAlignment = NSTextAlignmentCenter;
    [aliplayView addSubview:aliplayLab];
    
    [aliplayLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(aliplayView);
        make.left.equalTo(aliplayImageView.mas_right).offset(15);
    }];
    
    gouImageView1 = [[UIImageView alloc] initWithFrame:CGRectZero];
    gouImageView1.image = [UIImage imageNamed:@""];
    [aliplayView addSubview:gouImageView1];
    
    [gouImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(aliplayView);
        make.right.equalTo(aliplayView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];

  //  weChatPay = [UIButton buttonWithType:UIButtonTypeCustom];
   // weChatPay.frame = CGRectZero;
  //  weChatPay.layer.cornerRadius = 5;
  //  weChatPay.layer.masksToBounds = YES;
  //  weChatPay.backgroundColor = [UIColor whiteColor];
 //   weChatPay.userInteractionEnabled = NO;
 //   [weChatPay setTitle:@"微信支付" forState:UIControlStateNormal];
 //   [weChatPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
 //   [weChatPay addTarget:self action:@selector(weChatPayAction) forControlEvents:UIControlEventTouchUpInside];
 //   weChatPay.titleLabel.font = [UIFont systemFontOfSize:16];
 //   [self.view addSubview:weChatPay];
    
 //   [weChatPay mas_makeConstraints:^(MASConstraintMaker *make) {
 //       make.top.equalTo(moneyTextField.mas_bottom).offset(26);
 //       make.left.equalTo(self.view).offset(15);
 //       make.right.equalTo(self.view).offset(-15);
 //       make.height.mas_equalTo(43);
 //   }];
    
    
 //   alipayPay = [UIButton buttonWithType:UIButtonTypeCustom];
  //  alipayPay.frame = CGRectZero;
  //  alipayPay.layer.cornerRadius = 5;
 //   alipayPay.layer.masksToBounds = YES;
 //   alipayPay.backgroundColor = [UIColor whiteColor];
  //  alipayPay.userInteractionEnabled = NO;
  //  [alipayPay setTitle:@"支付宝支付" forState:UIControlStateNormal];
  //  [alipayPay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[alipayPay addTarget:self action:@selector(aliPayAction) forControlEvents:UIControlEventTouchUpInside];
  //  alipayPay.titleLabel.font = [UIFont systemFontOfSize:16];
  //  [self.view addSubview:alipayPay];
    
 //   [alipayPay mas_makeConstraints:^(MASConstraintMaker *make) {
 //       make.top.equalTo(weChatPay.mas_bottom).offset(10);
  //      make.left.equalTo(self.view).offset(15);
  //      make.right.equalTo(self.view).offset(-15);
 //       make.height.mas_equalTo(43);
 //   }];
    
    chuZhiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chuZhiBtn.frame = CGRectZero;
    chuZhiBtn.layer.cornerRadius = 5;
    chuZhiBtn.layer.masksToBounds = YES;
    [chuZhiBtn setTitle:@"充值" forState:UIControlStateNormal];
    [chuZhiBtn setBackgroundImage:[UIImage imageNamed:@"greenBg"] forState:UIControlStateNormal];
    [chuZhiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [chuZhiBtn addTarget:self action:@selector(chuZhiAction) forControlEvents:UIControlEventTouchUpInside];
    chuZhiBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:chuZhiBtn];
    
    [chuZhiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(aliplayView.mas_bottom).offset(35);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(43);
    }];

}

#pragma mark - 手势方法

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [moneyTextField resignFirstResponder];
}

-(void)weChatAction
{
   //选择微信
    gouImageView1.image = [UIImage imageNamed:@""];
    gouImageView.image = [UIImage imageNamed:@"chongZhi@2x.png"];
    self.InActionType = weChat;
}

-(void)aliplayAction
{
  //选择支付宝
    gouImageView.image = [UIImage imageNamed:@""];
    gouImageView1.image = [UIImage imageNamed:@"chongZhi@2x.png"];
    self.InActionType = aliplay;
}

#pragma mark - action

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

//储值点击事件
-(void)chuZhiAction
{
    //判断选择是支付宝还是微信支付
    if (self.InActionType == 0) {
        [self weChatPayAction];
    }else if(self.InActionType == 1)
    {
      //  [MBProgressHUD showError:@"支付宝支付暂未开通"];
        //支付宝支付
        [self openAliplayAction];
    }
}

//支付宝支付事件
-(void)openAliplayAction
{
     if ([self validateNumber:moneyTextField.text]) {
    
    NSLog(@"Config getOwnID = %@",[Config getOwnID]);
    NSMutableDictionary *paramers = [NSMutableDictionary dictionary];
    paramers[@"userId"] = [Config getOwnID];
//    paramers[@"totalAmount"] = moneyTextField.text;
    paramers[@"totalAmount"] = @"0.01";
    
    [WMNetWork post:Alipays parameters:paramers success:^(id responseObj) {
        NSLog(@"responseObj = %@",responseObj);
        if ([responseObj[@"status"] isEqualToString:@"0"]) {
         //  NOTE: 调用支付结果开始支付
         NSString *appScheme = @"alisdkapp";
         [[AlipaySDK defaultService] payOrder:responseObj[@"result"] fromScheme:appScheme callback:^(NSDictionary *resultDic) {
         
         }];
        }
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
    }];
         
     }else
     {
         UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"请输入正确金额！" message:nil preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
         [alertVc addAction:sureAction];
         [self presentViewController:alertVc animated:YES completion:nil];
     }
}

//微信支付事件
-(void)weChatPayAction
{
    if ([self validateNumber:moneyTextField.text]) {
        [moneyTextField resignFirstResponder];
        
        //判断是否安装微信
        if ([WXApi isWXAppInstalled]) {
            NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
            parmas[@"userId"] = [Config getOwnID];
            parmas[@"totalFee"] = moneyTextField.text;
           // parmas[@"totalFee"] = @"0.01";
            [WMNetWork post:WeChatPayHost parameters:parmas success:^(id responseObj) {
                MYLog(@"%@",responseObj);
                
                if ([responseObj[@"status"] intValue] == 0) {
                    
                    AppDelegate *appDels = [UIApplication sharedApplication].delegate;
                    appDels.wxPayResultBlock = ^(int errCode){
                        MYLog(@"errCode = %d",errCode);
                        if (errCode == 0) {
                            [MBProgressHUD showSuccess:@"支付成功"];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self.navigationController popViewControllerAnimated:YES];
                            });
                            
                        }
                        else
                        {
                           [MBProgressHUD showError:@"支付失败"];
                        }
                    };
                    NSDictionary *dict = responseObj[@"result"];
                     //调起微信支付
                    PayReq* req = [[PayReq alloc] init];
                    req.partnerId = [dict objectForKey:@"partnerid"];
                    req.prepayId = [dict objectForKey:@"prepayid"];
                    req.nonceStr = [dict objectForKey:@"noncestr"];
                    req.timeStamp = [dict[@"timestamp"] intValue];
                    req.package = [dict objectForKey:@"package"];
                    req.sign = [dict objectForKey:@"sign"];
                    [WXApi sendReq:req];
                    
                }
            } failure:^(NSError *error) {
                
                if (error) {
                    MYLog(@"error = %@",error);
                    [MBProgressHUD show:@"网络连接超时" icon:nil view:self.view];
                }
            }];
            
        } else
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
    
    }else
    {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"请输入正确金额！" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
        [alertVc addAction:sureAction];
        [self presentViewController:alertVc animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeValue:(NSNotification *) Notification{
    UITextField * moneyTextFields = Notification.object;
    if (moneyTextFields.text.length > 0 ) {
        
    if ([self validateNumber:moneyTextField.text]) {
            weChatPay.selected = YES;
            weChatPay.userInteractionEnabled = YES;
            weChatPay.backgroundColor = RGBA(29, 167, 146, 1);
        }else
        {
            weChatPay.selected = NO;
            weChatPay.userInteractionEnabled = NO;
            weChatPay.backgroundColor = [UIColor whiteColor];
        }
        
    }else{
        weChatPay.selected = NO;
        weChatPay.userInteractionEnabled = NO;
        weChatPay.backgroundColor = [UIColor whiteColor];
    }
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if ([textField.text isEqualToString:@""] && toBeString.length > 0) {
        //删除字符肯定是安全的
            return YES;
    }
    else {
    if (toBeString.length>4) {
            return NO;
        }
        else {
            return YES;
        }
    }
}

- (BOOL)validateNumber:(NSString *) textString
{
    NSString* number=@"^[1-9][0-9]*$";//第一位非0得正整数
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:textString];
}

@end
