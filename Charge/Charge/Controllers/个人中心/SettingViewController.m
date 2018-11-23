//
//  SettingViewController.m
//  Charge
//
//  Created by olive on 16/6/7.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingFooterView.h"
#import "AccountSafeViewController.h"
#import "YinXiaoTableViewCell.h"
#import "AppAgreementViewController.h"
#import "FeedBackViewController.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "XFunction.h"
#import "Masonry.h"
#import "SDWebImageCompat.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "Config.h"
#import "WMNetWork.h"
#import "NavView.h"
#import "API.h"


@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *arrayTitle;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //  self.navigationController.navigationBarHidden = NO;
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //初始化自定义nav
    NavView *nav = [[NavView alloc] initWithFrame:CGRectZero title:@"设置"];
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
    
    //初始化
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, XYScreenWidth, XYScreenHeight-64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
 //   self.title = @"设置";
 //   UIImage *image = [UIImage imageNamed:@"back"];
 //   image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
 //   self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    SettingFooterView *settingFootView = [SettingFooterView creatSettingFooterView];
    
    self.tableView.tableFooterView = settingFootView;
    settingFootView.tuiChuDengLuBlock = ^{
        //判断是不是正在充电
        if ([[Config getNormalEndChargingFlag] isEqualToString:@"0"]) {
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"请先结束充电，再退出登录！" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            [alertVc addAction:cancelAction];
            //    调用self的方法展现控制器
            [self presentViewController:alertVc animated:YES completion:nil];
        }else{
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"确定要退出吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            UIAlertAction *sureAction= [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                
                  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                NSMutableDictionary *parmaes = [NSMutableDictionary dictionary];
//
                [Config getOwnID];
//                parmaes[@"userId"] = [Config getOwnID];
                NSDictionary *parmaes = @{
                                        @"userId" : [Config getOwnID]
                                        };
                [WMNetWork post:OutOfLogin parameters:parmaes success:^(id responseObj) {
                    MYLog(@"responseObj = %@",responseObj);
                    if ([responseObj[@"status"] intValue] == 0) {
                        
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
   
                        [MBProgressHUD show:responseObj[@"message"] icon:nil view:self.view];
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [Config removeOwnID];//移除ID
                            [Config removeUseName];//移除用户名字
                            [Config removetoken]; //移除token
                            [Config removeThirdLoginType];//移除第三方登陆状态
                            //退出登陆时通知主控制器收起左滑界面
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:LeaveOutNoti object:nil];
                            [self.navigationController popViewControllerAnimated:YES];
                            
                        });
                    }
                    if ([responseObj[@"status"] intValue] == -1) {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [MBProgressHUD show:responseObj[@"message"] icon:nil view:self.view];
                    }
                    
                } failure:^(NSError *error) {
                    MYLog(@"%@",error);
                    if (error) {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [MBProgressHUD show:@"网络连接超时" icon:nil view:self.view];
                    }

                }];
            }];
            
            [alertVc addAction:cancelAction];
            [alertVc addAction:sureAction];
            //    调用self的方法展现控制器
            [self presentViewController:alertVc animated:YES completion:nil];
        }
        
    };
    self.arrayTitle = @[@[@"账号与安全"],@[@"意见反馈",@"软件许可及服务协议",@"清除缓存"]];
}


#pragma mark - action
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView代理方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.arrayTitle.count;
}

//设置每个区有多少行共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayTitle[section] count];
}

//响应点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (indexPath.section == 0 && indexPath.row == 0) {
      AccountSafeViewController *accountSafeVC = [[AccountSafeViewController alloc]init];
       [self.navigationController pushViewController:accountSafeVC animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 1)
    {
        AppAgreementViewController *appAgreeMentVC = [[AppAgreementViewController alloc] init];
        [self.navigationController pushViewController:appAgreeMentVC animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 0)
    {
        FeedBackViewController *FeedBackVC = [[FeedBackViewController alloc] init];
        [self.navigationController pushViewController:FeedBackVC animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 2)
    {
 
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定清除缓存" preferredStyle:UIAlertControllerStyleAlert];
 
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
                //清除异常
                [Config saveNormalEndChargingFlag:@"1"];//思路：开始充电的时候正常结束充电位置为为0.正常结束的时候为1
                //移除充电状态
                [Config removeUseCharge];
            
                [Config removeChargePay];//移除电费
                [Config removeChargeNum];//移除充电桩号
                [Config removeCurrentPower];//移除当前电量
            
                //结束充电通知
                [[NSNotificationCenter defaultCenter] postNotificationName:EndChargeingMessage object:nil];
                //提示文字
                [MBProgressHUD show:@"清除缓存成功" icon:nil view:self.view];
            
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        [alertVc addAction:cancelAction];
        [alertVc addAction:sureAction];
  
        [self presentViewController:alertVc animated:YES completion:nil];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
        static NSString *cellIdetifier = @"YinXiaoCell";
        YinXiaoTableViewCell *yinXiaoCell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier];
        if (yinXiaoCell == nil) {
            UINib *nib = [UINib nibWithNibName:@"YinXiaoTableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:cellIdetifier];
            yinXiaoCell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier];
            [yinXiaoCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
        return yinXiaoCell;
        
    }else
    {
    static NSString *cellIdetifier = @"SttingCell";
    UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier];
    if (Cell == nil) {
        Cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdetifier];
    }
    NSString *content = self.arrayTitle[indexPath.section][indexPath.row];
    Cell.textLabel.text = [NSString stringWithFormat:@"%@",content];
    Cell.textLabel.font = TableViewCellFont;
    Cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [Cell setSelectionStyle:UITableViewCellSelectionStyleNone];
   
        return Cell;
        
    }
}

//tableView间距处理代理方法

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 16;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 16)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view;
}

@end
