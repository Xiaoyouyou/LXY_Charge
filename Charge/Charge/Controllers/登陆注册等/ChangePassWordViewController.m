//
//  ChangePassWordViewController.m
//  Charge
//
//  Created by olive on 16/7/11.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "ChangePassWordViewController.h"
#import "XFunction.h"
#import "RegisterRightView.h"
#import "ChangePassWord1ViewController.h"
#import "Masonry.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "WMNetWork.h"
#import "API.h"

@interface ChangePassWordViewController ()<UITextFieldDelegate>
{
    UITextField *phoneNum;
    UIButton *nextBtn;
    UITextField *yanZhengMa;
    RegisterRightView *rightView;
}
@end

@implementation ChangePassWordViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"重置密码";
    UIImage *image = [UIImage imageNamed:@"back"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.view.backgroundColor = RGBA(235, 236, 237, 1);
    [self creatUI];
    
}

#pragma mark - Action

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)creatUI
{
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 45)];
    view1.backgroundColor = [UIColor whiteColor];
    
    phoneNum = [[UITextField alloc] initWithFrame:CGRectMake(15, StatusBarH + 60, XYScreenWidth-30, 45)];
    phoneNum.placeholder = @"请输入绑定手机号";
    phoneNum.leftView = view1;
    phoneNum.leftViewMode = UITextFieldViewModeAlways;
    phoneNum.keyboardType = UIKeyboardTypeNumberPad;
    phoneNum.delegate = self;
    phoneNum.tag = ChangePassWordVCTag3;
    phoneNum.textColor = [UIColor blackColor];
    phoneNum.font = [UIFont systemFontOfSize:13];
    phoneNum.backgroundColor = [UIColor whiteColor];
//    phoneNum.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneNum.layer.cornerRadius = 6;
    phoneNum.clipsToBounds = YES;
    [self.view addSubview:phoneNum];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];
    view2.backgroundColor = [UIColor whiteColor];
    
    rightView = [[RegisterRightView alloc] initWithFrame:CGRectMake(XYScreenWidth-30, 45, 70, 45)];
    
    __weak ChangePassWordViewController *weakSelf = self;
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
    yanZhengMa.tag = ChangePassWordVCTag4;
    yanZhengMa.leftView = view2;
    yanZhengMa.leftViewMode = UITextFieldViewModeAlways;
    yanZhengMa.font = [UIFont systemFontOfSize:13];
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
        make.height.mas_equalTo(45);
    }];
    
    nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectZero;
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    nextBtn.layer.cornerRadius = 6;
    nextBtn.layer.masksToBounds = YES;
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"greenBg"] forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(yanZhengMa.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.size.mas_equalTo(45);
    }];
}

-(void)nextBtn
{
    if (phoneNum.text.length == 0) {
        [MBProgressHUD show:@"请输入手机号" icon:nil view:self.view];
        return;
    }
    if (yanZhengMa.text.length == 0) {
        [MBProgressHUD show:@"请输入验证码" icon:nil view:self.view];
        return;
    }
    
    NSMutableDictionary *paramers = [NSMutableDictionary dictionary];
    paramers[@"mobile"] = phoneNum.text;
    paramers[@"code"] = yanZhengMa.text;
//    MYLog(@"phoneNum= %@",phoneNum.text);
//    MYLog(@"yanZhengMa = %@",yanZhengMa.text);
    //校验验证码
    [WMNetWork post:JiaoYanCodes parameters:paramers success:^(id responseObj) {
        
        [MBProgressHUD showMessage:@""];
        MYLog(@"responseObj = %@",responseObj);
        if ([responseObj[@"status"] intValue] == 0) {
            
            [MBProgressHUD hideHUD];
            
            ChangePassWord1ViewController *changeVC = [[ChangePassWord1ViewController alloc] init];
            changeVC.phone = phoneNum.text;
            changeVC.code = yanZhengMa.text;
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

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- textField 代理

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == ChangePassWordVCTag3) {
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
            [[NSNotificationCenter defaultCenter] postNotificationName:ChangePassWordNoti object:nil];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:ChangePassWordNotis object:nil];
        }
    }
    
    if (textField.tag == ChangePassWordVCTag4) {
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [yanZhengMa resignFirstResponder];
    return YES;
}


@end
