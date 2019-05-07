//
//  MyTrendViewController.m
//  Charge
//
//  Created by olive on 16/8/31.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "MyTrendViewController.h"
#import "MyTrendTableViewCell.h"
#import "XFunction.h"
#import "NavView.h"
#import "Masonry.h"
#import "WMNetWork.h"
#import "MJExtension.h"
#import "Config.h"
#import "MJRefresh.h"
#import "MyTrendModel.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "API.h"

#import "MyNoticationModel.h"
#import "MyNoticationTableViewCell.h"
@interface MyTrendViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *MyTrendDataArray;//数据源

@end

@implementation MyTrendViewController


-(NSMutableArray *)MyTrendDataArray
{
    if (_MyTrendDataArray == nil) {
        _MyTrendDataArray = [NSMutableArray array];
    }
    return _MyTrendDataArray;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

//-(void)viewDidDisappear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"我的动态";
//    UIImage *image = [UIImage imageNamed:@"back"];
//    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    //初始化自定义nav
    NavView *nav = [[NavView alloc] initWithFrame:CGRectZero title:@"公告"];
    nav.backBlock = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:nav];
    
    [nav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(StatusBarH + 44);
    }];
    
    [self creatUI];
    
    //添加下拉刷新
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self loadDataSource];
//    }];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDataSource)];
    //进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}
//
//-(void)loadNewData
//{
//    //加载数据
//    NSMutableDictionary *paramers = [NSMutableDictionary dictionary];
//    paramers[@"mobile"] = [Config getMobile];
//    paramers[@"page"] = @"1";
//    paramers[@"pageSize"] = @"10";//数量
//
//    [WMNetWork post:ChargingLog parameters:paramers success:^(id responseObj) {
//
//        [self.tableView.mj_header endRefreshing];
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.tableView.mj_header removeFromSuperview];
//        });
//        if ([responseObj[@"status"] intValue] == 0) {
//
//            _MyTrendDataArray = [MyTrendModel objectArrayWithKeyValuesArray:responseObj[@"result"]];
//
//            if (_MyTrendDataArray.count >8) {
//                //添加上拉加载更多
//                self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(tapFooter)];
//            }
//
//            [self.tableView reloadData];
//
//        }else if([responseObj[@"status"] intValue] == -1)
//        {
//            [MBProgressHUD show:@"请求错误" icon:nil view:self.view];
//        }
//
//    } failure:^(NSError *error) {
//        MYLog(@"%@",error);
//        [self.tableView.mj_header endRefreshing];
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.tableView.mj_header removeFromSuperview];
//        });
//
//        if (error) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            [MBProgressHUD show:@"网络连接超时" icon:nil view:self.view];
//        }
//    }];
//
//}
//
//
//#pragma Mark- action
//
//#pragma mark 上拉加载方法
//- (void)tapFooter{
//    static int flag = 1;
//    flag ++;//每次上拉都加载新的数据
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        //请求更多数据
//        NSMutableDictionary *paramers = [NSMutableDictionary dictionary];
//        paramers[@"mobile"] = [Config getMobile];
//        paramers[@"page"] = [NSString stringWithFormat:@"%d",flag];
//        paramers[@"pageSize"] = @"10";//数量
//
//        [WMNetWork post:ChargingLog parameters:paramers success:^(id responseObj) {
//            if ([responseObj[@"status"] intValue] == 0) {
//                NSMutableArray *tempArray = [MyTrendModel objectArrayWithKeyValuesArray:responseObj[@"result"]];
//
//                for (int i = 0; i<tempArray.count; i++) {
//                    MYLog(@"%@",tempArray[i]);
//                    [_MyTrendDataArray addObject:tempArray[i]];
//                }
//
//                if (tempArray.count<10) {
//                  [self.tableView.mj_footer endRefreshingWithNoMoreData];
//                }
//
//                [self.tableView reloadData];
//
//            }else if([responseObj[@"status"] intValue] == -1)
//            {
//                [MBProgressHUD show:@"请求错误" icon:nil view:self.view];
//            }
//
//        } failure:^(NSError *error) {
//            MYLog(@"%@",error);
//            if (error) {
//                [MBProgressHUD show:@"请求错误" icon:nil view:self.view];
//            }
//        }];
//
//        //通知主线程更新UI界面
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableView reloadData];
//        });
//    });
//    //结束刷新
//    [self.tableView.mj_footer endRefreshing];
//}

-(void)loadDataSource{
    [WMNetWork post:ChargeNoticeList parameters:nil success:^(id responseObj) {
        if ([responseObj[@"status"] intValue] == 0) {
            NSMutableArray *array = [NSMutableArray arrayWithObject:responseObj[@"list"]];
            for (NSDictionary *dict in array[0]) {
                MyNoticationModel *model = [MyNoticationModel objectWithKeyValues:dict];
                [self.MyTrendDataArray addObject:model];
                NSLog(@"%@",model.subTitle);
            }
            [self.tableView reloadData];
//            //结束刷新
//            [self.tableView.mj_footer endRefreshing];
        }
        
    }failure:^(NSError *error) {
        
    }];
        
}


-(void)creatUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, StatusBarH + 44, XYScreenWidth, XYScreenHeight-44 -StatusBarH) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 121.5;
    [self.tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.backgroundColor = RGBA(235, 235, 242, 1.0);
    [self.tableView registerNib:[UINib nibWithNibName:@"MyNoticationTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"notiCell"];
//    [_tableView registerClass:[MyNoticationTableViewCell class] forCellReuseIdentifier:@"notiCell"];
    [self.view addSubview:_tableView];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView代理方法
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    return 68;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 12;
//}

//-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//
//    UIView *view = [UIView new];
//    view.backgroundColor = [UIColor clearColor];
//    return view;
//}

//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//
//    return _MyTrendDataArray.count;
//}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}

//设置每个区有多少行共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.MyTrendDataArray.count;
}

//响应点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYLog(@"点击了系统更新");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdetifier = @"notiCell";
    MyNoticationTableViewCell * SystemTableCell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier];
    if (SystemTableCell == nil) {
        SystemTableCell = [[[NSBundle mainBundle] loadNibNamed:@"MyNoticationTableViewCell" owner:nil options:nil] lastObject];
    }
    SystemTableCell.selectionStyle = UITableViewCellSelectionStyleNone;
    SystemTableCell.notiModel = self.MyTrendDataArray[indexPath.row];
    return SystemTableCell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0.1;
//}

//section底部间距
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 15.0;


//}


@end
