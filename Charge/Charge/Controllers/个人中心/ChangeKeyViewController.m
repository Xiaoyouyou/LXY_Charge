//
//  ChangeKeyViewController.m
//  Charge
//
//  Created by olive on 16/8/19.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "ChangeKeyViewController.h"
#import "ChangeKey2ViewController.h"
#import "XFunction.h"
#import "MBProgressHUD+MJ.h"
#import "MBProgressHUD.h"
#import "Masonry.h"
#import "API.h"
#import "Config.h"
#import "NavView.h"
#import "WMNetWork.h"

@interface ChangeKeyViewController ()<UITextFieldDelegate>
{
    UITextField *phoneNum; //手机号
    UITextField *dengLuMiMa;//当前密码
    UIButton *nextBtn;//下一步
}

@end

@implementation ChangeKeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // self.title = @"修改密码";
   // UIImage *image = [UIImage imageNamed:@"back"];
   // image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
   // self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //初始化自定义nav
    NavView *nav = [[NavView alloc] initWithFrame:CGRectZero title:@"修改密码"];
    nav.backBlock = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:nav];
    
    [nav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(44+StatusBarH);
    }];
    
    [self creatUI];
}

-(void)creatUI
{
    UIView *kongGeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];
    kongGeView.backgroundColor = [UIColor clearColor];
    
    UIView *kongGeView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];
    kongGeView2.backgroundColor = [UIColor clearColor];
    
    phoneNum = [[UITextField alloc] initWithFrame:CGRectZero];
    phoneNum.placeholder = @"请输入手机号码";
    phoneNum.delegate = self;
    phoneNum.font = [UIFont systemFontOfSize:16];
    phoneNum.backgroundColor = [UIColor whiteColor];
    phoneNum.returnKeyType = UIReturnKeyDone;
    phoneNum.layer.cornerRadius = 6;
    phoneNum.text = [Config getMobile];
//    phoneNum.tag = ReplacePhoneNumVCTag5;
    phoneNum.clipsToBounds = YES;
    phoneNum.keyboardType = UIKeyboardTypeNumberPad;
    phoneNum.leftView = kongGeView;
    phoneNum.leftViewMode = UITextFieldViewModeAlways;
    phoneNum.clearsOnBeginEditing = YES;
    phoneNum.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:phoneNum];
    
    [phoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(44+StatusBarH + 10);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(44);
    }];
    
    dengLuMiMa = [[UITextField alloc] initWithFrame:CGRectZero];
    dengLuMiMa.placeholder = @"请输入登陆密码";
    dengLuMiMa.leftView = kongGeView2;
    dengLuMiMa.delegate = self;
    dengLuMiMa.returnKeyType = UIReturnKeyDone;
    dengLuMiMa.secureTextEntry = YES;
    dengLuMiMa.leftViewMode = UITextFieldViewModeAlways;
    dengLuMiMa.font = [UIFont systemFontOfSize:16];
    dengLuMiMa.backgroundColor = [UIColor whiteColor];
    dengLuMiMa.layer.cornerRadius = 6;
    dengLuMiMa.clipsToBounds = YES;
    dengLuMiMa.rightViewMode = UITextFieldViewModeAlways;
    dengLuMiMa.clearsOnBeginEditing = YES;
    dengLuMiMa.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.view addSubview:dengLuMiMa];
    
    [dengLuMiMa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneNum.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(44);
    }];
    
    nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.layer.cornerRadius = 6;
    nextBtn.clipsToBounds = YES;
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"greenBg"] forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:nextBtn];
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dengLuMiMa.mas_bottom).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.left.equalTo(self.view).offset(15);
        make.height.mas_equalTo(38);
    }];
}

#pragma mark - action
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)nextBtnAction
{
    if (phoneNum.text.length == 0) {
        [MBProgressHUD show:@"请输入手机号" icon:nil view:self.view];
        return;
    }
    
    if (dengLuMiMa.text.length == 0) {
        [MBProgressHUD show:@"请输入密码" icon:nil view:self.view];
        return;
    }
    
    NSMutableDictionary *paramers = [NSMutableDictionary dictionary];
    paramers[@"password"] = dengLuMiMa.text;
    paramers[@"mobile"] = phoneNum.text;
    MYLog(@"password = %@",dengLuMiMa.text);
    MYLog(@"mobile = %@",phoneNum.text);
    
    //更改密码校验验证码
    [WMNetWork post:CheckPassWord parameters:paramers success:^(id responseObj) {
        
        [MBProgressHUD showMessage:@""];
        if ([responseObj[@"status"] intValue] == 0) {
            
            [MBProgressHUD hideHUD];
            [MBProgressHUD show:responseObj[@"message"] icon:nil view:self.view];
            ChangeKey2ViewController *changeVC = [[ChangeKey2ViewController alloc] init];
            changeVC.phoneNum = phoneNum.text;
            changeVC.oldPaw = dengLuMiMa.text;
            [self.navigationController pushViewController:changeVC animated:YES];
            
        }else if([responseObj[@"status"] intValue] == -1)
        {
            [MBProgressHUD hideHUD];
            
            [MBProgressHUD show:responseObj[@"message"] icon:nil view:self.view];
        }
        
    } failure:^(NSError *error) {
        if (error) {
            [MBProgressHUD show:@"网络连接超时" icon:nil view:self.view];
        }
    }];
    
}

#pragma mark - TextField 代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [phoneNum resignFirstResponder];
    [dengLuMiMa resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [phoneNum resignFirstResponder];
    [dengLuMiMa resignFirstResponder];
}


@end
