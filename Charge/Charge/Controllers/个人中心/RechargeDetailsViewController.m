//
//  RechargeDetailsViewController.m
//  Charge
//
//  Created by olive on 16/9/1.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "RechargeDetailsViewController.h"
#import "RechargeDetailsTableViewCell.h"
#import "XFunction.h"
#import "WMNetWork.h"
#import "MJRefresh.h"
#import "UserBalanceModel.h"
#import "Config.h"
#import "API.h"
#import "TipView.h"
#import "Masonry.h"
#import "NavView.h"
#import "MJExtension.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"


//定义枚举类型
typedef enum {
    ChargePaytradeType=0,//默认 0 充电扣费
    BalancetradeType,// 1 余额充值
} chargePayType;


@interface RechargeDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) TipView *tipview;
@property (nonatomic,assign) int InActionType; //操作类型


@end

@implementation RechargeDetailsViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark 上拉加载方法
- (void)tapFooter{
    static int flag = 1;
    flag ++;//每次上拉都加载新的数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //请求更多数据
        NSMutableDictionary *paramers = [NSMutableDictionary dictionary];
        paramers[@"userId"] = [Config getOwnID];
        paramers[@"page"] = [NSString stringWithFormat:@"%d",flag];
        paramers[@"pageSize"] = @"10";//数量
        
        [WMNetWork post:BalanceDetailList parameters:paramers success:^(id responseObj) {
            if ([responseObj[@"status"] intValue] == 0) {
                NSMutableArray *tempArray = [UserBalanceModel mj_objectArrayWithKeyValuesArray:responseObj[@"result"]];
                MYLog(@"tempArray = %@",tempArray);
                for (int i = 0; i<tempArray.count; i++) {
                    MYLog(@"%@",tempArray[i]);
                    [_dataArray addObject:tempArray[i]];
                }
                
                if (tempArray.count<10) {
                }
                
                [self.tableView reloadData];
                
            }else if([responseObj[@"status"] intValue] == -1)
            {
                [MBProgressHUD show:@"请求错误" icon:nil view:self.view];
            }
            
        } failure:^(NSError *error) {
            MYLog(@"%@",error);
            if (error) {
                [MBProgressHUD show:@"请求错误" icon:nil view:self.view];
            }
        }];
        
        //通知主线程更新UI界面
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
    //结束刷新
    [self.tableView.mj_footer endRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"余额明细";
//    UIImage *image = [UIImage imageNamed:@"back"];
//    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    //初始化自定义nav
    NavView *nav = [[NavView alloc] initWithFrame:CGRectZero title:@"余额明细"];
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
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
    }];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    //进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
}

-(void)loadNewData
{
    NSMutableDictionary *paramers = [NSMutableDictionary dictionary];
    paramers[@"userId"] = [Config getOwnID];
    paramers[@"page"] = @"1";
    paramers[@"pageSize"] = @"11";//数量
    
    [WMNetWork get:BalanceDetailList parameters:paramers success:^(id responseObj) {
        if (self.tipview) {
            self.tipview.alpha = 0;
        }
        
        [self.tableView.mj_header endRefreshing];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_header removeFromSuperview];
        });
        
        if ([responseObj[@"status"] intValue] == 0 ) {
            _dataArray = [UserBalanceModel mj_objectArrayWithKeyValuesArray:responseObj[@"result"]];
            
            if (_dataArray.count == 0) {
                MYLog(@"没有明细消费记录");
                UIImage *image = [UIImage imageNamed:@"noneCost@2x.png"];
                NSString *str = @"您还没有明细记录";
                
                self.tipview  = [[TipView alloc] initWithFrame:CGRectZero image:image andshowText:str];
                self.tipview.alpha = 1;
                [self.tipview SetUpMasonry];
                [self.view addSubview:self.tipview];
                
                [self.tipview mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.view);
                    make.right.equalTo(self.view);
                    make.top.equalTo(self.view).offset(44 + StatusBarH);
                    make.bottom.equalTo(self.view);
                }];
                return ;
            }
            
            if (_dataArray.count >8) {
                //添加上拉加载更多
                self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(tapFooter)];
            }
            
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        MYLog(@"%@",error);
        
        [self.tableView.mj_header endRefreshing];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_header removeFromSuperview];
        });
        if (error) {
    
            UIImage *image = [UIImage imageNamed:@"NoneNetwork@2x.png"];
            NSString *str = @"您好，请检查网络";
            
            self.tipview  = [[TipView alloc] initWithFrame:CGRectZero image:image andshowText:str];
            self.tipview.alpha = 1;
            [self.tipview SetUpMasonry];
            [self.view addSubview:self.tipview];
            
            [self.tipview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view);
                make.right.equalTo(self.view);
                make.top.equalTo(self.view).offset(64);
                make.bottom.equalTo(self.view);
            }];
        }
    }];
}



#pragma Mark- action
-(void)creatUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, StatusBarH + 44, XYScreenWidth, XYScreenHeight-StatusBarH - 44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor =[UIColor redColor];
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
    
    return 52;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//设置每个区有多少行共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

//响应点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYLog(@"点击了系统更新");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdetifier = @"MyTrendCell";
    RechargeDetailsTableViewCell * RechargeDetailsTableCell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier];
    if (RechargeDetailsTableCell == nil) {
        RechargeDetailsTableCell = [[[NSBundle mainBundle]loadNibNamed:@"RechargeDetailsTableViewCell" owner:nil options:nil]lastObject];
    }
    
    UserBalanceModel *useModel =  _dataArray[indexPath.row];
    RechargeDetailsTableCell.useModel = useModel;
    
    [RechargeDetailsTableCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return RechargeDetailsTableCell;
}

@end
