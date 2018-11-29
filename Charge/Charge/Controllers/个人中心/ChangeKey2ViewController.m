//
//  ChangeKey2ViewController.m
//  Charge
//
//  Created by olive on 16/8/22.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "ChangeKey2ViewController.h"
#import "XFunction.h"
#import "MBProgressHUD+MJ.h"
#import "MBProgressHUD.h"
#import "XStringUtil.h"
#import "Masonry.h"
#import "Config.h"
#import "WMNetWork.h"
#import "API.h"
#import "NavView.h"
#import "Masonry.h"

@interface ChangeKey2ViewController ()<UITextFieldDelegate>
{
    UITextField *phoneNums; //手机号
    UITextField *dengLuMiMa;//当前密码
    UIButton *nextBtn;//下一步
}

@end

@implementation ChangeKey2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  //  self.title = @"修改密码";
  //  UIImage *image = [UIImage imageNamed:@"back"];
  //  image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
  //  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
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
        make.height.mas_equalTo(StatusBarH + 44);
    }];
    
    [self creatUI];
}

-(void)creatUI
{
    UIView *kongGeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];
    kongGeView.backgroundColor = [UIColor clearColor];
    
    UIView *kongGeView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];
    kongGeView2.backgroundColor = [UIColor clearColor];
    
    phoneNums = [[UITextField alloc] initWithFrame:CGRectZero];
    phoneNums.placeholder = @"请输入新密码";
    phoneNums.delegate = self;
    phoneNums.font = [UIFont systemFontOfSize:16];
    phoneNums.backgroundColor = [UIColor whiteColor];
    phoneNums.returnKeyType = UIReturnKeyDone;
    phoneNums.layer.cornerRadius = 6;
    //    phoneNum.tag = ReplacePhoneNumVCTag5;
    phoneNums.clipsToBounds = YES;
    phoneNums.secureTextEntry = YES;
    phoneNums.leftView = kongGeView;
    phoneNums.leftViewMode = UITextFieldViewModeAlways;
    phoneNums.clearsOnBeginEditing = YES;
    phoneNums.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:phoneNums];
    
    [phoneNums mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(StatusBarH + 44 + 10);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(44);
    }];
    
    dengLuMiMa = [[UITextField alloc] initWithFrame:CGRectZero];
    dengLuMiMa.placeholder = @"请再次输入";
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
        make.top.equalTo(phoneNums.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(44);
    }];
    
    nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitle:@"确定" forState:UIControlStateNormal];
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
    if (phoneNums.text.length == 0) {
        [MBProgressHUD show:@"请输入新密码" icon:nil view:self.view];
        return;
    }
    if (dengLuMiMa.text.length == 0) {
        [MBProgressHUD show:@"请再次输入密码" icon:nil view:self.view];
        return;
    }
    
    [phoneNums resignFirstResponder];
    [dengLuMiMa resignFirstResponder];
    
    if ([phoneNums.text isEqualToString:dengLuMiMa.text]) {
        
        NSMutableDictionary *paramers = [NSMutableDictionary dictionary];
        paramers[@"password"] = dengLuMiMa.text; //[XStringUtil stringToMD5:dengLuMiMa.text];
        paramers[@"mobile"] = self.phoneNum;
        paramers[@"oldpwd"] = self.oldPaw;
        //更改密码校验验证码
        [WMNetWork post:ChangePassWord parameters:paramers success:^(id responseObj) {
            
            [MBProgressHUD showMessage:@""];
            if ([responseObj[@"status"] intValue] == 0) {
                
                [MBProgressHUD hideHUD];
                [MBProgressHUD show:responseObj[@"message"] icon:nil view:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    LoginViewController *loginVC = [[LoginViewController alloc] init];
                    UINavigationController *nav = [[UINavigationController alloc] init];
                    [nav addChildViewController:loginVC];
                    [self presentViewController:nav animated:YES completion:nil];
                });
                
            }else if([responseObj[@"status"] intValue] == -1)
            {
                [MBProgressHUD hideHUD];
                [MBProgressHUD show:responseObj[@"message"] icon:nil view:self.view];
            }
            
        } failure:^(NSError *error) {
            if (error) {
                NSLog(@"网络连接超时");
                [MBProgressHUD show:@"网络连接超时" icon:nil view:self.view];
            }
        }];
 
    }else
    {
       [MBProgressHUD show:@"两次输入的密码不一致" icon:nil view:self.view];
    }
}

#pragma mark - TextField 代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [phoneNums resignFirstResponder];
    [dengLuMiMa resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [phoneNums resignFirstResponder];
    [dengLuMiMa resignFirstResponder];
}


@end
