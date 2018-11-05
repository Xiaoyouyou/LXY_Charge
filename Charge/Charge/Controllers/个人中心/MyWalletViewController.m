//
//  MyWalletViewController.m
//  Charge
//
//  Created by olive on 16/6/7.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "MyWalletViewController.h"
#import "ChuZhiViewController.h"
#import "RechargeDetailsViewController.h"
#import "XFunction.h"
#import "WMNetWork.h"
#import "Masonry.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "ChuZiViewController.h"
#import "Config.h"
#import "NavView.h"
#import "API.h"

@interface MyWalletViewController ()
@property (strong, nonatomic) IBOutlet UILabel *balance;//余额

@property (strong, nonatomic) IBOutlet UIButton *tiKuan;
@property (strong, nonatomic) IBOutlet UIButton *chuZhi;

- (IBAction)chuZhiAction:(id)sender;
- (IBAction)tiKuanAction:(id)sender;

@end

@implementation MyWalletViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSMutableDictionary *paramers = [NSMutableDictionary dictionary];
    paramers[@"userId"] = [Config getOwnID];
    NSLog(@"getOwnID = %@",[Config getOwnID]);
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    [WMNetWork post:GetBalance parameters:paramers success:^(id responseObj) {
        
      //  MYLog(@"responseObj = %@",responseObj);
    self.balance.text = responseObj[@"balance"];
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    } failure:^(NSError *error) {
        MYLog(@"%@",error);
        if (error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD show:@"网络连接超时" icon:nil view:self.view];
        }
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.title = @"我的钱包";
//    UIImage *image = [UIImage imageNamed:@"back"];
//    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(back)];
//    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 0, 35, 30);
//    [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
//    [btn setTitle:@"明细" forState:UIControlStateNormal];
//    [btn setTitleColor:RGBA(122, 122, 122, 1) forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(mingXi) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
//
    
    //初始化自定义nav
    NavView *nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) title:@"我的钱包" rightTitle:@"明细"];
    nav.backBlock = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    nav.rightBlock = ^{
        [self mingXi];
    };
    
    [self.view addSubview:nav];
    
    [nav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(StatusBarH + 44);
    }];

    //初始化圆角
    self.chuZhi.layer.cornerRadius = 5;
    self.chuZhi.clipsToBounds = YES;
    self.tiKuan.layer.cornerRadius = 5;
    self.tiKuan.clipsToBounds = YES;
}

#pragma mark - action
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)mingXi
{
    RechargeDetailsViewController *RechargeDetailsVC = [[RechargeDetailsViewController alloc] init];
    [self.navigationController pushViewController:RechargeDetailsVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)chuZhiAction:(id)sender {
    
//    ChuZhiViewController *chuzhiVC = [[ChuZhiViewController alloc] init];
//    [self.navigationController pushViewController:chuzhiVC animated:YES];
      ChuZiViewController *chuziVC = [[ChuZiViewController alloc] init];
      [self.navigationController pushViewController:chuziVC animated:YES];
//    StoreValueViewController *storeValueVC = [[StoreValueViewController alloc] initWithNibName:@"StoreValueViewController" bundle:nil];
//    [self.navigationController pushViewController:storeValueVC animated:YES];
}

- (IBAction)tiKuanAction:(id)sender {
}
@end
