//
//  KeFuViewController.m
//  Charge
//
//  Created by olive on 16/6/6.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "KeFuViewController.h"
#import "KeFuHeaderView.h"
#import "UserGuideViewController.h"
#import "XFunction.h"
#import "Masonry.h"
#import "NavView.h"

@interface KeFuViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *arrayTitle;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation KeFuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // Do any additional setup after loading the view from its nib.
   // self.navigationController.navigationBarHidden = NO;
   //  self.title = @"客服";
   //  UIImage *image = [UIImage imageNamed:@"back"];
   // image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
   // self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    //初始化nav
    NavView *nav = [[NavView alloc] initWithFrame:CGRectZero title:@"客服"];
    nav.backBlock = ^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    };
    
    [self.view addSubview:nav];
    
    CGFloat statusH = [UIApplication sharedApplication].statusBarFrame.size.height + 44;
    [nav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(statusH);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, statusH, XYScreenWidth, XYScreenHeight-64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
  //  KeFuHeaderView *kefuView = [KeFuHeaderView creatKeFuHeaderView];
    //self.tableView.tableHeaderView = kefuView;
    
    arrayTitle = @[@"用户指南",@"联系客服"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView代理方法

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0.01;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

//设置每个区有多少行共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayTitle.count;
}


//响应点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        //加载html界面
        
        UserGuideViewController *userVC = [[UserGuideViewController alloc] init];
        [self.navigationController pushViewController:userVC animated:YES];
        
    }else if (indexPath.row == 1)
    {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"联系客服" message:@"4001688050" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4001688050"]];
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
    
    static NSString *cellIdetifier = @"newCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdetifier];
    }
    
    NSString *content = arrayTitle[indexPath.row];
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%@",content]];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.10;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15.0;
}

@end
