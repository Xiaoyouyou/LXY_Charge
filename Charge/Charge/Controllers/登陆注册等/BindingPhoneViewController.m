//
//  BindingPhoneViewController.m
//  Charge
//
//  Created by olive on 17/3/29.
//  Copyright © 2017年 com.XinGuoXin.cn. All rights reserved.
//

#import "BindingPhoneViewController.h"
#import "XFunction.h"
#import "RegisterRightView.h"
#import "ChangePassWord1ViewController.h"
#import "Masonry.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "WMNetWork.h"
#import "API.h"

@interface BindingPhoneViewController ()<UITextFieldDelegate>
{
    UITextField *phoneNum;
    UIButton *nextBtn;
    UITextField *yanZhengMa;
    RegisterRightView *rightView;
}
@end

@implementation BindingPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"绑定手机号";
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
    
    phoneNum = [[UITextField alloc] initWithFrame:CGRectMake(15, 80, XYScreenWidth-30, 45)];
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
    
    __weak BindingPhoneViewController *weakSelf = self;
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
    [nextBtn setTitle:@"确定" forState:UIControlStateNormal];
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
    [yanZhengMa resignFirstResponder];
    
    if (phoneNum.text.length == 0) {
        [MBProgressHUD show:@"请输入手机号" icon:nil view:self.view];
        return;
    }
    if (yanZhengMa.text.length == 0) {
        [MBProgressHUD show:@"请输入验证码" icon:nil view:self.view];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *paramers = [NSMutableDictionary dictionary];
    paramers[@"mobile"] = phoneNum.text;
    paramers[@"vCode"] = yanZhengMa.text;
    paramers[@"loginId"] = self.loginID;
    NSLog(@"loginid = %@",self.loginID);
    //    MYLog(@"phoneNum= %@",phoneNum.text);
    //    MYLog(@"yanZhengMa = %@",yanZhengMa.text);
    //校验验证码
    
    [WMNetWork post:BindingPhone parameters:paramers success:^(id responseObj) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"responseObj 绑定手机号界面 = %@",responseObj);
        if ([responseObj[@"status"] intValue]== 0) {
            [MBProgressHUD showSuccess:@"绑定成功"];

             NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:responseObj[@"result"][@"login_platform"],@"login_platform",responseObj[@"result"][@"login_id"] ,@"login_id", responseObj[@"result"][@"user_token"],@"user_token",responseObj[@"result"][@"user_id"],@"user_id",self.nickName,@"nickName",self.headerImage,@"headerImage",responseObj[@"result"][@"user_mobile"],@"user_mobile",nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //通知登陆页面推出
                    [[NSNotificationCenter defaultCenter] postNotificationName:ThirdLoginPush object:nil userInfo:dict];
                });
                
            });
        }
        if ([responseObj[@"status"] intValue] == -1) {
            [MBProgressHUD showSuccess:@"绑定失败"];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
        [MBProgressHUD showSuccess:@"网络连接超时"];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
