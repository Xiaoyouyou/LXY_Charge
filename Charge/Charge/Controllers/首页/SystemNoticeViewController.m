//
//  SystemNoticeViewController.m
//  Charge
//
//  Created by olive on 16/8/31.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "SystemNoticeViewController.h"
#import "SystemTableViewCell.h"
#import "XFunction.h"
#import "Masonry.h"
#import "NavView.h"

@interface SystemNoticeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation SystemNoticeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"系统通知";
//    UIImage *image = [UIImage imageNamed:@"back"];
//    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    //初始化自定义nav
    NavView *nav = [[NavView alloc] initWithFrame:CGRectZero title:@"系统通知"];
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
    
    [self creatUI];
}


#pragma Mark- action
-(void)creatUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, XYScreenWidth, XYScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];

}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView代理方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//设置每个区有多少行共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//响应点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYLog(@"点击了系统更新");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdetifier = @"systemCell";
    SystemTableViewCell * SystemTableCell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier];
    if (SystemTableCell == nil) {
        SystemTableCell = [[[NSBundle mainBundle]loadNibNamed:@"SystemTableViewCell" owner:nil options:nil]lastObject];
    }
    [SystemTableCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return SystemTableCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15.0;
}


@end
