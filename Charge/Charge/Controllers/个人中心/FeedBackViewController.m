//
//  FeedBackViewController.m
//  Charge
//
//  Created by olive on 16/9/1.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "FeedBackViewController.h"
#import "MyTextView.h"
#import "MBProgressHUD+MJ.h"
#import "MBProgressHUD.h"
#import "XFunction.h"
#import "WMNetWork.h"
#import "Masonry.h"
#import "Config.h"
#import "API.h"
#import "NavView.h"


@interface FeedBackViewController ()<UITextViewDelegate, UITextFieldDelegate>
{
    MyTextView *myTextView;
    UIButton *sureBtn;
}

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
  //  self.title = @"意见反馈";
  //  UIImage *image = [UIImage imageNamed:@"back"];
  //  image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
  //  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    //初始化自定义nav
    NavView *nav = [[NavView alloc] initWithFrame:CGRectZero title:@"意见反馈"];
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
    
    [self creatUI];//创建UI
}

#pragma mark - ACTION

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)creatUI
{
    myTextView = [[MyTextView alloc] initWithFrame:CGRectMake(0, 64, XYScreenWidth, 180-64) placeholder:nil];
    myTextView.delegate = self;
    myTextView.backgroundColor = [UIColor whiteColor];
    myTextView.placeholder.text = @"请输入您的反馈意见(300字以内)";
    myTextView.font = [UIFont systemFontOfSize:12];
    myTextView.bounces = NO;
    [self.view addSubview:myTextView];
    
    
    sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectZero;
    [sureBtn setTitle:@"确 定" forState:UIControlStateNormal];
    sureBtn.layer.cornerRadius = 6;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"greenBg"] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnAction) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:sureBtn];
    
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(myTextView.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(44);
    }];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (myTextView.text.length == 0) {
        myTextView.placeholder.text = @"请输入您的反馈意见(300字以内)";
    }else{
        myTextView.placeholder.text = @"";
    }
    if (textView.text.length <= 500) {
        
//        MYLog(@"小于500");
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@""] && range.length > 0) {
        //删除字符肯定是安全的
        return YES;
    }
    else {
        if (textView.text.length - range.length + text.length > 500) {
            
            return NO;
        }
        else {
//        MYLog(@"大于500");
            return YES;
        }
    }
}

#pragma mark - action
-(void)sureBtnAction
{
    if (myTextView.text.length <=0) {
        [MBProgressHUD showError:@"反馈内容不能为空"];
        return;
    }
    
    [myTextView resignFirstResponder];
    NSMutableDictionary *paramers = [NSMutableDictionary dictionary];
    paramers[@"userId"] = [Config getOwnID];
    paramers[@"content"] = myTextView.text;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WMNetWork post:FeedBack parameters:paramers success:^(id responseObj) {
        
        MYLog(@"responseObj = %@",responseObj);
        if ([responseObj[@"status"] intValue] == 0) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showSuccess:@"反馈成功"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
      [myTextView resignFirstResponder];
}
@end
