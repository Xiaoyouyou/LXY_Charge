//
//  ChuZiViewController.m
//  Charge
//
//  Created by olive on 17/3/6.
//  Copyright © 2017年 com.XinGuoXin.cn. All rights reserved.
//

#import "ChuZiViewController.h"
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
#import "YZWebViewController.h"



typedef enum{
    
    weChat = 0,//微信支付
    aliplay,//支付宝支付
    
}payType;

typedef enum{
    
    ErShi = 0,//20元
    SanShi,//30元
    WuShi,//50元
    YiBai,//100元
    ErBai,//200元
    SanBai,//300元
}payMoney;





@interface ChuZiViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *navView;//自定义导航栏
@property (strong, nonatomic) IBOutlet UIView *weChatPayView;//微信支付view

@property (strong, nonatomic) IBOutlet UIView *alipayView;//支付宝支付view

@property (strong, nonatomic) IBOutlet UIView *moneyView1;//金额view1
@property (strong, nonatomic) IBOutlet UIView *moneyView2;//金额view2
@property (strong, nonatomic) IBOutlet UIView *ErShiview;//50元
@property (strong, nonatomic) IBOutlet UIView *SanShiView;//100元
@property (strong, nonatomic) IBOutlet UIView *WuShiView;//200元
@property (strong, nonatomic) IBOutlet UIView *YiBaiView;//500元
@property (strong, nonatomic) IBOutlet UIView *ErBaiView;//1000元
@property (strong, nonatomic) IBOutlet UIView *SanBaiView;//其他


//---------------------------------
@property (weak, nonatomic) IBOutlet UITextField *moneyFild;

@property (weak, nonatomic) IBOutlet UILabel *youhiMoneyText;
@property (nonatomic ,strong)NSString *textFildStr;


//---------------------------------

@property (strong, nonatomic) IBOutlet UIView *moneyView;//金额view


@property (strong, nonatomic) IBOutlet UILabel *ErShiLab;//20元lab
@property (strong, nonatomic) IBOutlet UILabel *SanShiLab;//30元lab
@property (strong, nonatomic) IBOutlet UILabel *WuShiLab;//50元lab
@property (strong, nonatomic) IBOutlet UILabel *YiBaiLab;//100元lab
@property (strong, nonatomic) IBOutlet UILabel *ErBaiLab;//200元lab
@property (strong, nonatomic) IBOutlet UILabel *SanBaiLab;//其他金额


@property (strong, nonatomic) IBOutlet UIImageView *gouImageView;//打钩
@property (strong, nonatomic) IBOutlet UIImageView *gouImageView1;//打钩

//定义枚举属性
@property (nonatomic,assign) int InActionType; //操作类型
@property (nonatomic,assign) int ChooseMonetyType; //选择金额


@property (strong, nonatomic) IBOutlet UIButton *sureBtn;

- (IBAction)SureBtnAction:(id)sender;

@end

@implementation ChuZiViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)viewWillAppear:(BOOL)animated{
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    int money = self.moneyFild.text.intValue;
    if(money < 50){
//        [MBProgressHUD showSuccess:@"输入金额不能小于50元"];
         self.youhiMoneyText.attributedText = [self straaaaaaa:@"0"];
        self.sureBtn.enabled = NO;
    }else if(![self isPureInt:self.moneyFild.text]){
        [MBProgressHUD showSuccess:@"输入金额必须为整数"];
         self.youhiMoneyText.attributedText = [self straaaaaaa:@"0"];
        self.sureBtn.enabled = NO;
    }else{
        [self getChargeMoney:self.moneyFild.text];
        self.sureBtn.enabled = YES;
    }
    [self.moneyFild resignFirstResponder];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //初始化自定义nav
    NavView *nav = [[NavView alloc] initWithFrame:CGRectZero title:@"余额储值" rightTitle:@"退款"];
    nav.backBlock = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    nav.rightBlock = ^{
        YZWebViewController *web = [[YZWebViewController alloc] init];
        [self.navigationController pushViewController:web animated:YES];
    };
    self.navView = nav;
    
    [self.view addSubview:nav];
    
    [nav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(StatusBarH + 44);
    }];
    
    self.view.backgroundColor = RGBA(235, 236, 237, 1);
    
    [self someThingSetting];
    //初始支付设置：默认微信支付，20元
    self.InActionType = 0;
    self.ChooseMonetyType = 0;
    [self ErShiAction];
    
    //增加支付宝充值完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zhiFubaoAction) name:@"resultStatusSuccess" object:nil];
    
    
    self.moneyFild.delegate = self;
    self.moneyFild.layer.borderWidth = 1.0f;
    self.moneyFild.layer.borderColor = RGBA(29, 167, 146, 1).CGColor;
    //影藏输入金额
    self.moneyFild.hidden = YES;
    
}

-(void)someThingSetting
{
    _weChatPayView.layer.cornerRadius = 6;
    _weChatPayView.layer.masksToBounds = YES;
    _weChatPayView.userInteractionEnabled = YES;
    
    _alipayView.layer.cornerRadius = 6;
    _alipayView.layer.masksToBounds = YES;
    _alipayView.userInteractionEnabled = YES;
    
    
    //设置金额view的约束
    CGFloat payViewWidth = (XYScreenWidth - 12*4)/3;
    CGFloat payVieHeight = (_moneyView.frame.size.height - 12*3)/2;
    
    [_ErShiview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_moneyView1).offset(12);
        make.top.equalTo(_moneyView1).offset(12);
        make.width.mas_equalTo(payViewWidth);
        make.height.mas_equalTo(payVieHeight);
    }];
    
    _ErShiview.layer.cornerRadius = 6;
    _ErShiview.layer.masksToBounds = YES;
    _ErShiview.userInteractionEnabled = YES;
    _ErShiview.layer.borderWidth = 1;
    _ErShiview.layer.borderColor = RGBA(29, 167, 146, 1).CGColor;
    
    [_SanShiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_moneyView1);
        make.top.equalTo(_moneyView1).offset(12);
        make.width.mas_equalTo(payViewWidth);
        make.height.mas_equalTo(payVieHeight);
    }];
    
    _SanShiView.layer.cornerRadius = 6;
    _SanShiView.layer.masksToBounds = YES;
    _SanShiView.userInteractionEnabled = YES;
    _SanShiView.layer.borderWidth = 1;
    _SanShiView.layer.borderColor = RGBA(29, 167, 146, 1).CGColor;
    
    [_WuShiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_moneyView1).offset(-12);
        make.top.equalTo(_moneyView1).offset(12);
        make.width.mas_equalTo(payViewWidth);
        make.height.mas_equalTo(payVieHeight);
    }];
    
    _WuShiView.layer.cornerRadius = 6;
    _WuShiView.layer.masksToBounds = YES;
    _WuShiView.userInteractionEnabled = YES;
    _WuShiView.layer.borderWidth = 1;
    _WuShiView.layer.borderColor = RGBA(29, 167, 146, 1).CGColor;
    
    
    [_YiBaiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_moneyView2).offset(12);
        make.bottom.equalTo(_moneyView2).offset(-12);
        make.width.mas_equalTo(payViewWidth);
        make.height.mas_equalTo(payVieHeight);
    }];
    
    _YiBaiView.layer.cornerRadius = 6;
    _YiBaiView.layer.masksToBounds = YES;
    _YiBaiView.userInteractionEnabled = YES;
    _YiBaiView.layer.borderWidth = 1;
    _YiBaiView.layer.borderColor = RGBA(29, 167, 146, 1).CGColor;
    
    
    [_ErBaiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_moneyView2);
        make.bottom.equalTo(_moneyView2).offset(-12);
        make.width.mas_equalTo(payViewWidth);
        make.height.mas_equalTo(payVieHeight);
    }];
    
    _ErBaiView.layer.cornerRadius = 6;
    _ErBaiView.layer.masksToBounds = YES;
    _ErBaiView.userInteractionEnabled = YES;
    _ErBaiView.layer.borderWidth = 1;
    _ErBaiView.layer.borderColor = RGBA(29, 167, 146, 1).CGColor;
    
    
    [_SanBaiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_moneyView2).offset(-12);
        make.bottom.equalTo(_moneyView2).offset(-12);
        make.width.mas_equalTo(payViewWidth);
        make.height.mas_equalTo(payVieHeight);
    }];
    
    _SanBaiView.layer.cornerRadius = 6;
    _SanBaiView.layer.masksToBounds = YES;
    _SanBaiView.userInteractionEnabled = YES;
    _SanBaiView.layer.borderWidth = 1;
    _SanBaiView.layer.borderColor = RGBA(29, 167, 146, 1).CGColor;

    //金额lab设置
    [_ErShiLab sizeToFit];
    _ErShiLab.textColor = RGBA(29, 167, 146, 1);

    
    [_SanShiLab sizeToFit];
    _SanShiLab.textColor = RGBA(29, 167, 146, 1);
    
    [_WuShiLab sizeToFit];
    _WuShiLab.textColor = RGBA(29, 167, 146, 1);
    
    [_YiBaiLab sizeToFit];
    _YiBaiLab.textColor = RGBA(29, 167, 146, 1);
    
    [_ErBaiLab sizeToFit];
      _ErBaiLab.textColor = RGBA(29, 167, 146, 1);
    
    [_SanBaiLab sizeToFit];
    _SanBaiLab.textColor = RGBA(29, 167, 146, 1);
    
    [_ErShiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_ErShiview);
        make.centerY.equalTo(_ErShiview);
    }];
    
    [_SanShiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_SanShiView);
        make.centerY.equalTo(_SanShiView);
    }];
    
    [_WuShiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_WuShiView);
        make.centerY.equalTo(_WuShiView);
    }];
    
    [_YiBaiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_YiBaiView);
        make.centerY.equalTo(_YiBaiView);
    }];
    
    [_ErBaiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_ErBaiView);
        make.centerY.equalTo(_ErBaiView);
    }];
    
    
    [_SanBaiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_SanBaiView);
        make.centerY.equalTo(_SanBaiView);
    }];
    
    //金额选择手势
    //金额50
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ErShiAction)];
    [_ErShiview addGestureRecognizer:tap];
    
    //金额100
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SanShiAction)];
    [_SanShiView addGestureRecognizer:tap1];
    
    //金额200
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(WuShiAction)];
    [_WuShiView addGestureRecognizer:tap2];
    
    //金额500
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(YiBaiAction)];
    [_YiBaiView addGestureRecognizer:tap3];
    
    //金额1000
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ErBaiAction)];
    [_ErBaiView addGestureRecognizer:tap4];
    
    //其他金额
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SanBaiAction)];
    [_SanBaiView addGestureRecognizer:tap5];
    
    //微信
    UITapGestureRecognizer *tap6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weChatAction)];
    [_weChatPayView addGestureRecognizer:tap6];
    
    //支付宝
    UITapGestureRecognizer *tap7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aliplayAction)];
    [_alipayView addGestureRecognizer:tap7];
    
    
    //按钮设置
    _sureBtn.layer.cornerRadius = 6;
    _sureBtn.layer.masksToBounds = YES;
    _sureBtn.userInteractionEnabled = YES;

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - action

-(void)weChatAction
{
    //选择微信
    _gouImageView1.image = [UIImage imageNamed:@""];
    _gouImageView.image = [UIImage imageNamed:@"chongZhi@2x.png"];
    self.InActionType = weChat;
}

-(void)aliplayAction
{
    //选择支付宝
    _gouImageView.image = [UIImage imageNamed:@""];
    _gouImageView1.image = [UIImage imageNamed:@"chongZhi@2x.png"];
    self.InActionType = aliplay;
}

-(void)ErShiAction
{
    
    self.ChooseMonetyType = ErShi;
    
    _ErShiview.backgroundColor = RGBA(29, 167, 146, 1);
    _ErShiLab.textColor = [UIColor whiteColor];
    
    _SanShiView.backgroundColor = [UIColor whiteColor];
    _SanShiLab.textColor =RGBA(29, 167, 146, 1);
    
    _WuShiView.backgroundColor = [UIColor whiteColor];
    _WuShiLab.textColor =RGBA(29, 167, 146, 1);
    
    _YiBaiView.backgroundColor = [UIColor whiteColor];
    _YiBaiLab.textColor =RGBA(29, 167, 146, 1);
    
    
    _ErBaiView.backgroundColor = [UIColor whiteColor];
    _ErBaiLab.textColor =RGBA(29, 167, 146, 1);
    
    _SanBaiView.backgroundColor = [UIColor whiteColor];
    _SanBaiLab.textColor =RGBA(29, 167, 146, 1);
     [self showOrHiddenMoneyFiled:0];
    self.sureBtn.enabled = YES;
    [self.moneyFild resignFirstResponder];
    [self getChargeMoney:@"50"];
}

-(void)SanShiAction
{
     self.ChooseMonetyType = SanShi;
    _SanShiView.backgroundColor = RGBA(29, 167, 146, 1);
    _SanShiLab.textColor = [UIColor whiteColor];
    
    _ErShiview.backgroundColor = [UIColor whiteColor];
    _ErShiLab.textColor =RGBA(29, 167, 146, 1);
    
    _WuShiView.backgroundColor = [UIColor whiteColor];
    _WuShiLab.textColor =RGBA(29, 167, 146, 1);
    
    _YiBaiView.backgroundColor = [UIColor whiteColor];
    _YiBaiLab.textColor =RGBA(29, 167, 146, 1);
    
    
    _ErBaiView.backgroundColor = [UIColor whiteColor];
    _ErBaiLab.textColor =RGBA(29, 167, 146, 1);
    
    _SanBaiView.backgroundColor = [UIColor whiteColor];
    _SanBaiLab.textColor =RGBA(29, 167, 146, 1);
     [self showOrHiddenMoneyFiled:0];
    self.sureBtn.enabled = YES;
    [self.moneyFild resignFirstResponder];
    [self getChargeMoney:@"100"];
    
}
-(void)WuShiAction
{
    self.ChooseMonetyType = WuShi;
    _WuShiView.backgroundColor = RGBA(29, 167, 146, 1);
    _WuShiLab.textColor = [UIColor whiteColor];
    
    _ErShiview.backgroundColor = [UIColor whiteColor];
    _ErShiLab.textColor =RGBA(29, 167, 146, 1);
    
    _SanShiView.backgroundColor = [UIColor whiteColor];
    _SanShiLab.textColor =RGBA(29, 167, 146, 1);
    
    _YiBaiView.backgroundColor = [UIColor whiteColor];
    _YiBaiLab.textColor =RGBA(29, 167, 146, 1);
    
    
    _ErBaiView.backgroundColor = [UIColor whiteColor];
    _ErBaiLab.textColor =RGBA(29, 167, 146, 1);
    
    _SanBaiView.backgroundColor = [UIColor whiteColor];
    _SanBaiLab.textColor =RGBA(29, 167, 146, 1);
     [self showOrHiddenMoneyFiled:0];
    self.sureBtn.enabled = YES;
    [self.moneyFild resignFirstResponder];
    [self getChargeMoney:@"200"];
}
-(void)YiBaiAction
{
    self.ChooseMonetyType = YiBai;
    _YiBaiView.backgroundColor = RGBA(29, 167, 146, 1);
    _YiBaiLab.textColor = [UIColor whiteColor];
    
    _ErShiview.backgroundColor = [UIColor whiteColor];
    _ErShiLab.textColor =RGBA(29, 167, 146, 1);
    
    _SanShiView.backgroundColor = [UIColor whiteColor];
    _SanShiLab.textColor =RGBA(29, 167, 146, 1);
    
    _WuShiView.backgroundColor = [UIColor whiteColor];
    _WuShiLab.textColor =RGBA(29, 167, 146, 1);
    
    _ErBaiView.backgroundColor = [UIColor whiteColor];
    _ErBaiLab.textColor =RGBA(29, 167, 146, 1);
    
    _SanBaiView.backgroundColor = [UIColor whiteColor];
    _SanBaiLab.textColor =RGBA(29, 167, 146, 1);
    [self showOrHiddenMoneyFiled:0];
    self.sureBtn.enabled = YES;
    [self.moneyFild resignFirstResponder];
    [self getChargeMoney:@"500"];
}
-(void)ErBaiAction
{
    self.ChooseMonetyType = ErBai;
    _ErBaiView.backgroundColor = RGBA(29, 167, 146, 1);
    _ErBaiLab.textColor = [UIColor whiteColor];
    
    _ErShiview.backgroundColor = [UIColor whiteColor];
    _ErShiLab.textColor =RGBA(29, 167, 146, 1);
    
    _SanShiView.backgroundColor = [UIColor whiteColor];
    _SanShiLab.textColor =RGBA(29, 167, 146, 1);
    
    _WuShiView.backgroundColor = [UIColor whiteColor];
    _WuShiLab.textColor =RGBA(29, 167, 146, 1);
    
    _YiBaiView.backgroundColor = [UIColor whiteColor];
    _YiBaiLab.textColor =RGBA(29, 167, 146, 1);
    
    _SanBaiView.backgroundColor = [UIColor whiteColor];
    _SanBaiLab.textColor =RGBA(29, 167, 146, 1);
     [self showOrHiddenMoneyFiled:0];
    self.sureBtn.enabled = YES;
    [self.moneyFild resignFirstResponder];
    [self getChargeMoney:@"1000"];
}

-(void)SanBaiAction
{
    self.ChooseMonetyType = SanBai;
    _SanBaiView.backgroundColor = RGBA(29, 167, 146, 1);
    _SanBaiLab.textColor = [UIColor whiteColor];
    
    _ErShiview.backgroundColor = [UIColor whiteColor];
    _ErShiLab.textColor =RGBA(29, 167, 146, 1);
    
    _SanShiView.backgroundColor = [UIColor whiteColor];
    _SanShiLab.textColor =RGBA(29, 167, 146, 1);
    
    _WuShiView.backgroundColor = [UIColor whiteColor];
    _WuShiLab.textColor =RGBA(29, 167, 146, 1);
    
    _ErBaiView.backgroundColor = [UIColor whiteColor];
    _ErBaiLab.textColor =RGBA(29, 167, 146, 1);
    
    _YiBaiView.backgroundColor = [UIColor whiteColor];
    _YiBaiLab.textColor =RGBA(29, 167, 146, 1);
    [self showOrHiddenMoneyFiled:1];
}


//隐藏和显示输入框
-(void)showOrHiddenMoneyFiled:(int)type{
    if (type == 0) {
        self.moneyFild.hidden = YES;
    }else{
         self.moneyFild.hidden = NO;
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSInteger money = self.moneyFild.text.intValue;
    if(money < 50){
        [MBProgressHUD showSuccess:@"输入金额不能小于50元"];
        self.sureBtn.enabled = NO;
    }else if(![self isPureInt:self.moneyFild.text]){
        [MBProgressHUD showSuccess:@"输入金额必须为整数"];
        self.sureBtn.enabled = NO;
    }else{
        [self getChargeMoney:self.moneyFild.text];
        self.sureBtn.enabled = YES;
    }
    [self.moneyFild resignFirstResponder];
    return YES;
}

//判断一个字符串是否是一个正整数
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}


- (IBAction)SureBtnAction:(id)sender {
    
    
    
    
    
    
    NSString *tempStr = @"";
    if (self.ChooseMonetyType == 0) {
        tempStr = @"50";
    }else if (self.ChooseMonetyType == 1)
    {
        tempStr = @"100";
    }else if (self.ChooseMonetyType == 2)
    {
        tempStr = @"200";
    }else if (self.ChooseMonetyType == 3)
    {
        tempStr = @"500";
    }else if (self.ChooseMonetyType == 4)
    {
        tempStr = @"1000";
    }else if (self.ChooseMonetyType == 5)
    {
        tempStr = self.moneyFild.text; //输入的金额
    }
  //  NSLog(@"tempStr = %@",tempStr);
    if (self.InActionType == 0) {
        NSLog(@"微信支付");
        [self weChatPayAction:tempStr];
    }else if (self.InActionType == 1)
    {
        NSLog(@"支付宝支付");
        [self openAliplayAction:tempStr];
    }
}

-(void)zhiFubaoAction
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

//微信支付事件
-(void)weChatPayAction:(NSString *)payMoney
{
        //判断是否安装微信
    NSString *string = [WXApi getApiVersion];
    BOOL isapi =   [WXApi isWXAppSupportApi];
//    BOOL isInstall = [WXApi openWXApp];
        if ([WXApi isWXAppInstalled]) {
            NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
            parmas[@"userId"] = [Config getOwnID];
            parmas[@"totalFee"] = payMoney;
          //   parmas[@"totalFee"] = @"0.01";
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
                    [WXApi sendReq:req completion:^(BOOL success) {
                        
                    }];
                    
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
}

//支付宝支付事件
-(void)openAliplayAction:(NSString *)payMoney
{
        NSLog(@"Config getOwnID = %@",[Config getOwnID]);
        NSMutableDictionary *paramers = [NSMutableDictionary dictionary];
        paramers[@"userId"] = [Config getOwnID];
        //    paramers[@"totalAmount"] = moneyTextField.text;
          paramers[@"totalAmount"] = payMoney;
        //  paramers[@"totalAmount"] = @"0.01";
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
}




//请求赠送金额接口
-(void)getChargeMoney:(NSString *)payMoney
{
    NSLog(@"Config getOwnID = %@",[Config getOwnID]);
    NSDictionary *paramer = @{
                              @"money" : @(payMoney.intValue)
                              };
    [WMNetWork post:ChargeGETMoney parameters:paramer success:^(id responseObj) {
        NSLog(@"responseObj = %@",responseObj);
        NSString *retMoney = responseObj[@"retMoney"];
        NSString *status = responseObj[@"status"];
        if (status.intValue == 0) {
            self.youhiMoneyText.attributedText = [self straaaaaaa:retMoney];
        }else{
            self.youhiMoneyText.attributedText = [self straaaaaaa:@"0"];
        }
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
    }];
}



-(NSMutableAttributedString *)straaaaaaa:(NSString *)retMoney{
    NSString *str = [NSString stringWithFormat:@"赠送金额：%d元",retMoney.intValue];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 15],NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    
    [string addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:252/255.0 green:194/255.0 blue:112/255.0 alpha:1.0]} range:NSMakeRange(5, str.length - 5)];
    
    return string;
}

@end
