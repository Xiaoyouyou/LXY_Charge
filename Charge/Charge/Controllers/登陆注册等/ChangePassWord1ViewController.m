//
//  ChangePassWord1ViewController.m
//  Charge
//
//  Created by olive on 16/7/11.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "ChangePassWord1ViewController.h"
#import "XFunction.h"
#import "adminLeftView.h"
#import "Masonry.h"
#import "XStringUtil.h"
#import "MBProgressHUD+MJ.h"
#import "WMNetWork.h"
#import "API.h"


@interface ChangePassWord1ViewController ()<UITextFieldDelegate>
{
    UITextField *mima;
    adminLeftView *leftView;
    UIButton *nextBtn;
}

@end

@implementation ChangePassWord1ViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [mima becomeFirstResponder];
    
    //添加文本框通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeValue:) name:UITextFieldTextDidChangeNotification object:nil];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)creatUI
{
    leftView = [[adminLeftView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    leftView.imageName = @"mima";
    
    mima = [[UITextField alloc] initWithFrame:CGRectMake(15, 80, XYScreenWidth-30, 45)];
    mima.leftView = leftView;
    mima.delegate = self;
    mima.placeholder = @"请输入新密码(长度6~16位)";
    mima.font = [UIFont systemFontOfSize:13];
    mima.backgroundColor = [UIColor whiteColor];
    mima.layer.cornerRadius = 6;
    mima.clipsToBounds = YES;
    mima.leftViewMode = UITextFieldViewModeAlways;
    mima.secureTextEntry = YES;
    mima.clearsOnBeginEditing = YES;
    mima.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.view addSubview:mima];

    nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectZero;
    [nextBtn setTitle:@"重置密码" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    nextBtn.layer.cornerRadius = 6;
    nextBtn.layer.masksToBounds = YES;
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"greenBg"] forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mima.mas_bottom).offset(15);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(45);
    }];
}

-(void)nextBtn
{
    if (mima.text.length == 0) {
        [MBProgressHUD show:@"请输入密码" icon:nil view:self.view];
        return;
    }
    
    if (mima.text.length < 6) {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"密码不能少于6位" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        }];
        [alertVc addAction:sureAction];
        [self presentViewController:alertVc animated:YES completion:nil];
    }
    
    if (mima.text.length > 16) {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"密码不能大于16位" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        }];
        [alertVc addAction:sureAction];
        [self presentViewController:alertVc animated:YES completion:nil];
    }
    
    [mima resignFirstResponder];
    
    NSMutableDictionary *paramers = [NSMutableDictionary dictionary];
    paramers[@"password"] = [XStringUtil stringToMD5:mima.text];//MD5加密
    paramers[@"mobile"] = self.phone;
    MYLog(@"phone = %@",self.phone);
    MYLog(@"mima = %@",mima);
    //更改密码
    [WMNetWork post:ChangePassWord parameters:paramers success:^(id responseObj) {
        
        
        if ([responseObj[@"status"] intValue] == 0) {
            
            [MBProgressHUD hideHUD];
            [MBProgressHUD show:responseObj[@"message"] icon:nil view:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
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
            [MBProgressHUD show:@"网络连接超时" icon:nil view:self.view];
        }
    }];
}


- (void)changeValue:(NSNotification *) Notification{
    
    UITextField * moneyTextFields = Notification.object;
    
    if (moneyTextFields.text.length > 0 ) {
        nextBtn.selected = YES;
        nextBtn.userInteractionEnabled = YES;
        nextBtn.backgroundColor = RGBA(29, 167, 146, 1);
    }else{
        nextBtn.selected = NO;
        nextBtn.userInteractionEnabled = NO;
        nextBtn.backgroundColor = RGBA(195, 196, 197, 1);
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
