//
//  RegisterViewController.m
//  Charge
//
//  Created by olive on 16/6/12.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "RegisterViewController.h"
#import "XFunction.h"
#import "RegisterRightView.h"
#import "MBProgressHUD+MJ.h"
#import "XStringUtil.h"
#import "Masonry.h"
#import "API.h"
#import "WMNetWork.h"

@interface RegisterViewController ()<UITextFieldDelegate>
{
    UITextField *phoneNum;
    RegisterRightView *rightView;
    UITextField *yanZhengMa;
    UITextField *dengLuMiMa;
    UITextField *invitCode;
    UIButton *nextBtn;
}

@property (strong, nonatomic) IBOutlet UILabel *titleLab;

- (IBAction)backActionClick:(id)sender;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = RGBA(236, 236, 236, 1);
    self.title = @"(1/2)创建个人资料";
    UIImage *image = [UIImage imageNamed:@"back"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    [self creatUI];
}

#pragma mark - Action

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)creatUI
{
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, StatusBarH + 60 , XYScreenWidth-15, 30)];
    self.titleLab.text = @"设置手机号以保障您的账号安全";
    self.titleLab.font = [UIFont systemFontOfSize:13];
    self.titleLab.textColor = RGBA(164, 164, 164, 1);
    [self.view addSubview:self.titleLab];
    
    UIView *kongGeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];
    kongGeView.backgroundColor = [UIColor clearColor];
    
    UIView *kongGeView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];
    kongGeView1.backgroundColor = [UIColor clearColor];
    
    UIView *kongGeView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];
    kongGeView2.backgroundColor = [UIColor clearColor];
    
    UIView *kongGeView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];
    kongGeView2.backgroundColor = [UIColor clearColor];
    
    phoneNum = [[UITextField alloc] initWithFrame:CGRectZero];
    phoneNum.placeholder = @"请输入手机号码";
    phoneNum.delegate = self;
    phoneNum.font = [UIFont systemFontOfSize:14];
    phoneNum.backgroundColor = [UIColor whiteColor];
    phoneNum.returnKeyType = UIReturnKeyDone;
    phoneNum.layer.cornerRadius = 6;
    phoneNum.clipsToBounds = YES;
    phoneNum.tag = RegisterVcTextfielTag;
    phoneNum.keyboardType = UIKeyboardTypeNumberPad;
    phoneNum.leftView = kongGeView;
    phoneNum.leftViewMode = UITextFieldViewModeAlways;
//  phoneNum.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:phoneNum];
    
    [phoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(0);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(44);
    }];
    
    rightView = [[RegisterRightView alloc] initWithFrame:CGRectMake(XYScreenWidth-30, 45, 70, 45)];
    
    __weak RegisterViewController *weakSelf = self;
    rightView.ShowSuessMess = ^{
        [MBProgressHUD show:@"短信发送成功" icon:nil view:weakSelf.view];
    };
    rightView.ShowFailMess = ^{
        [MBProgressHUD show:@"短信发送失败" icon:nil view:weakSelf.view];
    };
    rightView.ShowNetWorkFailMess = ^{
        [MBProgressHUD show:@"网络连接超时" icon:nil view:weakSelf.view];
    };

    yanZhengMa = [[UITextField alloc] initWithFrame:CGRectZero];
    yanZhengMa.rightView = rightView;
    yanZhengMa.delegate = self;
    yanZhengMa.placeholder = @"请输入验证码";
    yanZhengMa.leftView = kongGeView1;
    yanZhengMa.leftViewMode = UITextFieldViewModeAlways;
    yanZhengMa.font = [UIFont systemFontOfSize:14];
    yanZhengMa.backgroundColor = [UIColor whiteColor];
    yanZhengMa.layer.cornerRadius = 6;
    yanZhengMa.tag = RegisterVcTextfielTag1;
    yanZhengMa.clipsToBounds = YES;
    yanZhengMa.returnKeyType = UIReturnKeyDone;
    yanZhengMa.rightViewMode = UITextFieldViewModeAlways;
    
    [self.view addSubview:yanZhengMa];
    
    [yanZhengMa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneNum.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(44);
    }];
    
    dengLuMiMa = [[UITextField alloc] initWithFrame:CGRectZero];
    dengLuMiMa.placeholder = @"请输入登陆密码(长度6~16位)";
    dengLuMiMa.leftView = kongGeView2;
    dengLuMiMa.delegate = self;
    dengLuMiMa.returnKeyType = UIReturnKeyDone;
    dengLuMiMa.secureTextEntry = YES;
    dengLuMiMa.leftViewMode = UITextFieldViewModeAlways;
    dengLuMiMa.font = [UIFont systemFontOfSize:14];
    dengLuMiMa.backgroundColor = [UIColor whiteColor];
    dengLuMiMa.layer.cornerRadius = 6;
    dengLuMiMa.clipsToBounds = YES;
    dengLuMiMa.rightViewMode = UITextFieldViewModeAlways;
    dengLuMiMa.clearsOnBeginEditing = YES;
    dengLuMiMa.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.view addSubview:dengLuMiMa];
    
    [dengLuMiMa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(yanZhengMa.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(44);
    }];
    
    
    
    invitCode = [[UITextField alloc] initWithFrame:CGRectZero];
    invitCode.placeholder = @"请输入邀请码(非必填)";
    invitCode.delegate = self;
    invitCode.font = [UIFont systemFontOfSize:14];
    invitCode.backgroundColor = [UIColor whiteColor];
    invitCode.returnKeyType = UIReturnKeyDone;
    invitCode.layer.cornerRadius = 6;
    invitCode.clipsToBounds = YES;
    invitCode.tag = RegisterVcTextfielTag;
    invitCode.keyboardType = UIKeyboardTypeNumberPad;
    invitCode.leftView = kongGeView3;
    invitCode.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:invitCode];
    [invitCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dengLuMiMa.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(44);
    }];
//
    nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitle:@"注 册" forState:UIControlStateNormal];
    nextBtn.layer.cornerRadius = 6;
    nextBtn.clipsToBounds = YES;
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"greenBg"] forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:nextBtn];
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(invitCode.mas_bottom).offset(50);
        make.right.equalTo(self.view).offset(-15);
        make.left.equalTo(self.view).offset(15);
        make.height.mas_equalTo(38);
    }];
    
}

- (IBAction)backActionClick:(id)sender {
    
  [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [phoneNum resignFirstResponder];
    [yanZhengMa resignFirstResponder];
    [dengLuMiMa resignFirstResponder];
    [invitCode resignFirstResponder];
}

-(void)nextBtnAction
{
    [dengLuMiMa resignFirstResponder];
    
    if (phoneNum.text.length == 0) {
       [MBProgressHUD show:@"请输入手机号" icon:nil view:self.view];
        return;
    }
    if (yanZhengMa.text.length == 0) {
       [MBProgressHUD show:@"请输入验证码(长度6位)" icon:nil view:self.view];
        return;
    }
    
    if (dengLuMiMa.text.length == 0) {
        [MBProgressHUD show:@"请输入密码(长度6~16位)" icon:nil view:self.view];
        return;
    }
    
    if (dengLuMiMa.text.length <6) {
        [MBProgressHUD show:@"密码长度不够(长度6~16位)" icon:nil view:self.view];
         return;
    }
    
    if (dengLuMiMa.text.length < 6) {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"密码不能少于6位" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        }];
        [alertVc addAction:sureAction];
        [self presentViewController:alertVc animated:YES completion:nil];
    }
    
    if (dengLuMiMa.text.length > 16) {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"密码不能大于16位" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        }];
        [alertVc addAction:sureAction];
        [self presentViewController:alertVc animated:YES completion:nil];
    }
    

    [MBProgressHUD showMessage:@""];
    NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
    MYLog(@"phoneNum = %@",phoneNum.text);
    parmas[@"mobile"] = phoneNum.text;
    parmas[@"code"] = yanZhengMa.text;
    parmas[@"type"] = @"REG";
    
    [WMNetWork post:JiaoYanCodes parameters:parmas success:^(id responseObj) {
        MYLog(@"responseObj = %@",responseObj);

        if ([responseObj[@"status"] intValue] == 0) {
             [MBProgressHUD hideHUD];
           //调用注册接口
            
            NSMutableDictionary *paramers = [NSMutableDictionary dictionary];
            paramers[@"mobile"] = phoneNum.text;
            paramers[@"code"] = yanZhengMa.text;
            parmas[@"inviteCode"] = invitCode.text;
            paramers[@"password"] = [XStringUtil stringToMD5:dengLuMiMa.text];
            
            [MBProgressHUD showMessage:@""];

            [WMNetWork post:Reg_Host parameters:paramers success:^(id responseObj) {
                
                //手机号已注册
                if ([responseObj[@"status"] intValue] == 1) {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD show:responseObj[@"message"] icon:nil view:self.view];
                }
                
                //注册成功
                if ([responseObj[@"status"] intValue] == 0) {
                    MYLog(@"responseObj = %@",responseObj);
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD show:responseObj[@"message"] icon:nil view:self.view];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    });
                }
                
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD show:@"请求超时，稍后再试！" icon:nil view:self.view];
                MYLog(@"error = %@",error);
            }];
           // Resgister2ViewController *register2 = [[Resgister2ViewController alloc] init];
           // register2.phoneNum = phoneNum.text;
           // register2.yanZhengMa = yanZhengMa.text;
           // register2.mima = dengLuMiMa.text;
           /// [self.navigationController pushViewController:register2 animated:YES];
            
        }
        
        if ([responseObj[@"status"] intValue] == -1) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD show:responseObj[@"message"] icon:nil view:self.view];
        }
        
    } failure:^(NSError *error) {
        MYLog(@"error = %@",error);
          [MBProgressHUD hideHUD];
          [MBProgressHUD show:@"网络请求错误" icon:nil view:self.view];
    }];
}

#pragma mark -- textField 代理

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == RegisterVcTextfielTag) {
        NSInteger strLength = textField.text.length - range.length + string.length;
        if (strLength > 11){
            return NO;
        }
        NSString *text = nil;
        //如果string为空，表示删除
        if (string.length > 0) {
            text = [NSString stringWithFormat:@"%@%@",textField.text,string];
            rightView.phoneNum = text;
        }else{
            text = [textField.text substringToIndex:range.location];
        }
        if (strLength == 11) {
           [[NSNotificationCenter defaultCenter] postNotificationName:PersonMesNoti object:nil];
        }else{
           [[NSNotificationCenter defaultCenter] postNotificationName:PersonMesNotis object:nil];
        }
    }
    
    if (textField.tag == RegisterVcTextfielTag1) {
        NSInteger strLength = textField.text.length - range.length + string.length;
        if (strLength > 6){
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [yanZhengMa resignFirstResponder];
    [dengLuMiMa resignFirstResponder];
    return YES;
}

@end
