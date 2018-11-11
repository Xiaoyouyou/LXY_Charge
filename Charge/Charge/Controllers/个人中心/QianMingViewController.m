//
//  QianMingViewController.m
//  Charge
//
//  Created by olive on 16/6/14.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "QianMingViewController.h"
#import "MyTextView.h"
#import "XFunction.h"
#import "API.h"
#import "WMNetWork.h"
#import "Masonry.h"
#import "Config.h"
#import "NavView.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"

@interface QianMingViewController ()<UITextViewDelegate, UITextFieldDelegate>
{
    UILabel *desLab;
    MyTextView *qianMingTextView;
}
@end

@implementation QianMingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBA(231, 232, 234, 1);
    
    self.navigationController.navigationBarHidden = YES;
    
    //初始化自定义nav
    NavView *nav = [[NavView alloc] initWithFrame:CGRectZero title:@"我的签名" rightTitle:@"保存"];
    [nav setRightBtnMasonry];
    nav.backBlock = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    nav.rightBlock = ^{
        [self save];//保存签名
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

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)save
{
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    parms[@"userId"] = [Config getOwnID];//用户ID
    parms[@"infoVal"] = qianMingTextView.text;//要修改的参数值
    parms[@"field"] = @"SIGN";
    [MBProgressHUD showMessage:@""];
    [WMNetWork post:UpdateBase parameters:parms success:^(id responseObj) {
        MYLog(@"responseObj = %@",responseObj);
        [MBProgressHUD hideHUD];
        if ([responseObj[@"status"] intValue] == 0) {
            self.QianMingBlock(responseObj[@"result"][@"sign"]);
            [MBProgressHUD show:@"修改成功" icon:nil view:self.view];
            //退出键盘
            [qianMingTextView resignFirstResponder];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        if ([responseObj[@"status"] intValue] == -1) {
            [MBProgressHUD show:responseObj[@"message"] icon:nil view:self.view];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
        [MBProgressHUD hideHUD];
        [MBProgressHUD show:@"网络连接超时,保存失败" icon:nil view:self.view];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)creatUI
{
    qianMingTextView = [[MyTextView alloc] initWithFrame:CGRectMake(0, StatusBarH + 44, XYScreenWidth, XYScreenHeight-420-64) placeholder:nil];
    qianMingTextView.delegate = self;
//  qianMingTextView.placeholder.text = @"请输入您的个性签名";
    qianMingTextView.font = [UIFont systemFontOfSize:13];
    qianMingTextView.text = _qianMing;
    [self.view addSubview:qianMingTextView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (qianMingTextView.text.length == 0) {
        qianMingTextView.placeholder.text = @"请输入您的个性签名";
    }else{
        qianMingTextView.placeholder.text = @"";
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"textView.text.length = %lu",(unsigned long)textView.text.length);
    if ([text isEqualToString:@""] && range.length > 0) {
        //删除字符肯定是安全的
        return YES;
    }
    else {
        if (textView.text.length - range.length + textView.text.length > 60) {
            return NO;
        }
        else {
            return YES;
        }
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [qianMingTextView resignFirstResponder];
}

@end
