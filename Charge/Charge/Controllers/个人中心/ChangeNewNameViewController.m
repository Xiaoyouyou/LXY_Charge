//
//  ChangeNewNameViewController.m
//  Charge
//
//  Created by olive on 16/6/15.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "ChangeNewNameViewController.h"
#import "API.h"
#import "WMNetWork.h"
#import "Config.h"
#import "XFunction.h"
#import "MBProgressHUD.h"
#import "Masonry.h"
#import "NavView.h"
#import "MBProgressHUD+MJ.h"

@interface ChangeNewNameViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) UITextField *changeName;

@end

@implementation ChangeNewNameViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.changeName.text = self.name;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //初始化自定义nav
    NavView *nav = [[NavView alloc] initWithFrame:CGRectZero title:@"昵称"];
    [nav setRightBtnMasonry];
    nav.backBlock = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    nav.rightBlock = ^{
        [self save];//保存
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

-(void)creatUI
{
    self.changeName = [[UITextField alloc] initWithFrame:CGRectMake(0, 80, XYScreenWidth, 44)];
    self.changeName.placeholder = @"您的新昵称";
    self.changeName.font = [UIFont systemFontOfSize:16];
    self.changeName.backgroundColor = [UIColor whiteColor];
    self.changeName.returnKeyType = UIReturnKeyDone;
    self.changeName.delegate = self;
    [self.changeName becomeFirstResponder];
    [self.view addSubview:self.changeName];
    
    [self.changeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(80);
        make.height.mas_equalTo(44);
    }];
    
    UIView *leftView = [[UIView alloc] init];
    leftView.frame = CGRectMake(0, 0, 10, self.changeName.frame.size.height);
    self.changeName.leftView = leftView;
    self.changeName.leftViewMode =  UITextFieldViewModeAlways;
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)save
{
    //限制名字长度为8位
    if (self.changeName.text.length >8) {
        [MBProgressHUD show:@"昵称输入太长" icon:nil view:self.view];
        return;
    }
    
    [self.changeName resignFirstResponder];
    
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    parms[@"userId"] = [Config getOwnID];//用户ID
    parms[@"infoVal"] = self.changeName.text;//要修改的参数值
    parms[@"field"] = @"NICK";
    [MBProgressHUD showMessage:@""];
    [WMNetWork post:UpdateBase parameters:parms success:^(id responseObj) {
       MYLog(@"responseObj = %@",responseObj);
        [MBProgressHUD hideHUD];
       if ([responseObj[@"status"] intValue] == 0) {
           self.ReturnTextBlock(responseObj[@"result"][@"nick"]);
           //更新缓存用户名
           [Config saveUseName:responseObj[@"result"][@"nick"]];
           NSString *tempNick = responseObj[@"result"][@"nick"];
           //通知个人中心页面跟新名字信息
           [[NSNotificationCenter defaultCenter]postNotificationName:ChangeNewName object:nil userInfo:@{@"text":tempNick}];
           [MBProgressHUD show:@"修改成功" icon:nil view:self.view];
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
       [MBProgressHUD show:@"网络连接超时" icon:nil view:self.view];
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           [self.navigationController popViewControllerAnimated:YES];
       });
   }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.changeName resignFirstResponder];
    return YES;
}
@end
