//
//  MessageCentreViewController.m
//  Charge
//
//  Created by olive on 16/8/31.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "MessageCentreViewController.h"
#import "SystemNoticeViewController.h"
#import "MyTrendViewController.h"
#import "XFunction.h"
#import "NavView.h"
#import "Masonry.h"
#import "CityModel.h"
#import "WMNetWork.h"
#import "MJExtension.h"
#import "UserGuideViewController.h"

@interface MessageCentreViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *arrayTitle;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NavView *navView;
@property (nonatomic, strong) NSMutableDictionary *dict;

@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSMutableArray *indexArray;

@property (nonatomic, strong) NSMutableArray *rulesArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *dictory;


@end

@implementation MessageCentreViewController


-(NSMutableDictionary *)dictory
{
    if (_dictory == nil) {
        _dictory = [NSMutableDictionary dictionary];
    }
    return _dictory;
}


-(NSMutableArray *)rulesArray
{
    if (_rulesArray == nil) {
        _rulesArray = [NSMutableArray array];
    }
    return _rulesArray;
}

-(NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }

    return _dataArray;
}


-(NSMutableDictionary *)dict
{
    if (_dict == nil) {
        _dict = [NSMutableDictionary dictionary];
    }
    return _dict;
}

-(NSArray *)array
{
    if (_array == nil) {
        _array = [NSArray array];
    }
    return _array;
}

-(NSMutableArray *)indexArray
{
    if (_indexArray == nil) {
        _indexArray = [NSMutableArray array];
    }
    return _indexArray;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatUI];
    arrayTitle = @[@"我的动态",@"系统通知",@"用户指南",@"联系客服"];

    
}

#pragma mark -action


-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)creatUI
{
    //创建nav
    self.navView = [[NavView alloc] initWithFrame:CGRectZero title:@"消息中心"];
    __weak  MessageCentreViewController *weakSelf = self;
    self.navView.backBlock = ^(){
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    };
    [self.view addSubview:self.navView];
    
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(64);
        
    }];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, XYScreenWidth, XYScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
}


#pragma mark - UITableView代理方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
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
    if (indexPath.section == 0 && indexPath.row == 0) {
        //我的动态
        MyTrendViewController *myTrendVC = [[MyTrendViewController alloc] init];
        [self.navigationController pushViewController:myTrendVC animated:YES];
        
    }else if (indexPath.section == 0 && indexPath.row == 1)
    {
       //系统通知
        SystemNoticeViewController *systemVC = [[SystemNoticeViewController alloc] init];
        [self.navigationController pushViewController:systemVC animated:YES];
    }
    if (indexPath.row == 2) {
        //用户指南   webView界面
        UserGuideViewController *userVC = [[UserGuideViewController alloc] init];
        [self.navigationController pushViewController:userVC animated:YES];
        
    }else if (indexPath.row == 3)
    {
        //联系客服
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
    static NSString *cellIdetifier = @"myCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdetifier];
    }
    cell.textLabel.text = arrayTitle[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = TableViewCellFont;
    
    return cell;
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
