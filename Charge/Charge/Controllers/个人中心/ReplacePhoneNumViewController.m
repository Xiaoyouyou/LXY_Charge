//
//  ReplacePhoneNumViewController.m
//  Charge
//
//  Created by olive on 16/6/27.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "ReplacePhoneNumViewController.h"
#import "RegisterRightView.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "Masonry.h"
#import "XFunction.h"
#import "WMNetWork.h"
#import "Config.h"
#import "API.h"
#import "NavView.h"

@interface ReplacePhoneNumViewController ()<UITextFieldDelegate>
{
    UILabel *titleLab;
    UITextField *phoneNum;
    RegisterRightView *rightView;
    UITextField *yanZhengMa;
    UITextField *dengLuMiMa;
    UIButton *nextBtn;
}

@end

@implementation ReplacePhoneNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //   self.title = @"更换手机号";
    // self.view.backgroundColor = [UIColor whiteColor];
    //UIImage *image = [UIImage imageNamed:@"back"];
    //image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.view.backgroundColor = RGBA(230, 231, 234, 1);
    
    //初始化自定义nav
    NavView *nav = [[NavView alloc] initWithFrame:CGRectZero title:@"更换手机号"];
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
    
    [self creatUI];
}

#pragma mark - action
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)creatUI
{
    titleLab = [[UILabel alloc] init];
    titleLab.text = @"更改后个人信息不变，下次使用新手机号登陆";
    titleLab.numberOfLines = 0;
    [titleLab sizeToFit];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:12];
    titleLab.textColor = RGBA(131, 132, 133, 1);
    [self.view addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(80);
        make.size.mas_equalTo(CGSizeMake(180, 35));
    }];
    
    UIView *kongGeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];
    kongGeView.backgroundColor = [UIColor clearColor];
    
    UIView *kongGeView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];
    kongGeView1.backgroundColor = [UIColor clearColor];
    
    UIView *kongGeView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];
    kongGeView2.backgroundColor = [UIColor clearColor];
    
    phoneNum = [[UITextField alloc] initWithFrame:CGRectZero];
    phoneNum.placeholder = @"请输入手机号码";
    phoneNum.delegate = self;
    phoneNum.font = [UIFont systemFontOfSize:14];
    phoneNum.backgroundColor = [UIColor whiteColor];
    phoneNum.returnKeyType = UIReturnKeyDone;
    phoneNum.layer.cornerRadius = 6;
    phoneNum.tag = ReplacePhoneNumVCTag5;
    phoneNum.clipsToBounds = YES;
    phoneNum.keyboardType = UIKeyboardTypeNumberPad;
    phoneNum.leftView = kongGeView;
    phoneNum.leftViewMode = UITextFieldViewModeAlways;
    phoneNum.clearsOnBeginEditing = YES;
    phoneNum.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:phoneNum];
    
    [phoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(5);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(44);
    }];
    
    rightView = [[RegisterRightView alloc] initWithFrame:CGRectMake(XYScreenWidth-30, 45, 70, 45)];
    __weak ReplacePhoneNumViewController *weakSelf = self;
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
    yanZhengMa.tag = ReplacePhoneNumVCTag6;
    yanZhengMa.leftView = kongGeView1;
    yanZhengMa.leftViewMode = UITextFieldViewModeAlways;
    yanZhengMa.font = [UIFont systemFontOfSize:14];
    yanZhengMa.backgroundColor = [UIColor whiteColor];
    yanZhengMa.layer.cornerRadius = 6;
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
    dengLuMiMa.placeholder = @"请输入登陆密码";
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
    
    nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitle:@"确认更换" forState:UIControlStateNormal];
    nextBtn.layer.cornerRadius = 6;
    nextBtn.clipsToBounds = YES;
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"greenBg"] forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:nextBtn];
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dengLuMiMa.mas_bottom).offset(50);
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
}

-(void)nextBtnAction
{
    if (phoneNum.text.length == 0) {
        [MBProgressHUD show:@"请输入手机号" icon:nil view:self.view];
        return;
    }
    if (yanZhengMa.text.length == 0) {
        [MBProgressHUD show:@"请输入验证码" icon:nil view:self.view];
        return;
    }
    
    if (dengLuMiMa.text.length == 0) {
        [MBProgressHUD show:@"请输入密码" icon:nil view:self.view];
        return;
    }
    
    NSMutableDictionary *paramers = [NSMutableDictionary dictionary];
    paramers[@"newMobile"] = phoneNum.text;
    paramers[@"userId"] = [Config getOwnID];
    paramers[@"code"] = yanZhengMa.text;
    paramers[@"password"] = dengLuMiMa.text;
    
    MYLog(@"phoneNum.text = %@,ID = %@,CODE = %@",phoneNum.text,[Config getOwnID],yanZhengMa.text);
    
    [WMNetWork post:UpdateMobile parameters:paramers success:^(id responseObj) {
        
        MYLog(@"responseObj = %@",responseObj);
        if ([responseObj[@"status"] intValue] == 0) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showSuccess:@"修改手机号成功！"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
//                [self.navigationController popToRootViewControllerAnimated:YES];
            });
            
        }else if([responseObj[@"status"] intValue] == -1)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [MBProgressHUD showError:responseObj[@"message"]];
        }
        
    } failure:^(NSError *error) {
        MYLog(@"%@",error);
        if (error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD show:@"网络连接超时" icon:nil view:self.view];
        }
    }];
}

#pragma mark -- textField 代理

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == ReplacePhoneNumVCTag5) {
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
            [[NSNotificationCenter defaultCenter] postNotificationName:ReplacePhoneNumNoti object:nil];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:ReplacePhoneNumNotis object:nil];
        }
    }
    
    if (textField.tag == ReplacePhoneNumVCTag6) {
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

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [yanZhengMa resignFirstResponder];
    [dengLuMiMa resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
