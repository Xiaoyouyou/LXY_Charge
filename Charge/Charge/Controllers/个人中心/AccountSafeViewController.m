//
//  AccountSafeViewController.m
//  Charge
//
//  Created by olive on 16/6/8.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "AccountSafeViewController.h"
#import "PhoneNumViewController.h"
#import "AccountSafeHeaderView.h"
#import "ChangeKeyViewController.h"
#import "Masonry.h"
#import "XFunction.h"
#import "NavView.h"

@interface AccountSafeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
   
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *arrayTitle;

@end

@implementation AccountSafeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
  //  self.navigationController.navigationBarHidden = NO;
    
 //   self.title = @"账号与安全";
  //  UIImage *image = [UIImage imageNamed:@"back"];
  //  image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
  //  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    //初始化自定义nav
    NavView *nav = [[NavView alloc] initWithFrame:CGRectZero title:@"账号与安全"];
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
    
    self.arrayTitle = @[@"手机号",@"修改密码"];
    //初始化
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, XYScreenWidth, XYScreenHeight-64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    //注释：第三方账号登陆界面
    //AccountSafeHeaderView *accountFootView = [AccountSafeHeaderView creatAccoundSafeFootView];
    //self.tableView.tableFooterView = accountFootView;
    
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self creatUI];
    
}

-(void)creatUI
{
   

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 48;
    
}

//设置每个区有多少行共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayTitle.count;
}

//响应点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        PhoneNumViewController *phoneNumVC = [[PhoneNumViewController alloc] init];
        [self.navigationController pushViewController:phoneNumVC animated:YES];
    }else if (indexPath.section == 0 && indexPath.row == 1)
    {
        ChangeKeyViewController *changeVC = [[ChangeKeyViewController alloc] init];
        [self.navigationController pushViewController:changeVC animated:YES];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdetifier = @"SafeCell";
    UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier];
    if (Cell == nil) {
        Cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdetifier];
    }
    NSString *content = self.arrayTitle[indexPath.row];
    Cell.textLabel.text = [NSString stringWithFormat:@"%@",content];
    Cell.textLabel.font = [UIFont systemFontOfSize:15];
    Cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [Cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return Cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 16;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0 || section == 1) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    return nil;
    
}
@end
