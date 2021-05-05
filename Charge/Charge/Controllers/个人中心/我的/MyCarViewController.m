//
//  MyCarViewController.m
//  Charge
//
//  Created by 罗小友 on 2018/10/15.
//  Copyright © 2018年 com.XinGuoXin.cn. All rights reserved.
//

#import "MyCarViewController.h"
#import "MyAddCarViewController.h"
#import "MyCarTableViewCell.h"
#import "NavView.h"
#import "Masonry.h"
#import "MJRefresh.h"

#import "MyCarListModel.h"

#define StatusH [UIApplication sharedApplication].statusBarFrame.size.height + 44
@interface MyCarViewController ()<UITableViewDelegate,UITableViewDataSource
>
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)NSMutableDictionary *dict;
@property (nonatomic ,strong)NSArray *array;
@property (nonatomic ,strong)NSMutableArray *dataSource;
@end

@implementation MyCarViewController

-(NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(void)viewWillAppear:(BOOL)animated{
    [self.tableView.mj_header beginRefreshing];
  
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   [self addtableView];
   
    //添加tableView
    
   
   
}

//添加数据
-(void)addDataSource{
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    [parame setValue:[Config getOwnID] forKey:@"userId"];
//    [parame setValue:@"" forKey:@""];
    [WMNetWork get:ChargeMyCareList parameters:parame success:^(id responseObj) {
       
        if ([responseObj[@"status"] isEqualToString:@"0"]) {
            [self.tableView.mj_header endRefreshing];
            NSMutableArray *muarr = [NSMutableArray arrayWithArray:responseObj[@"result"]];
            if (muarr.count == 0) {
                //初始化nav
                [self addNavigationBar:YES];
            }else{
                [self.dataSource removeAllObjects];
                [self addNavigationBar:NO];
                for (NSDictionary *dict in muarr ) {
                    MyCarListModel *carListModel = [MyCarListModel yy_modelWithDictionary:dict];
                    [self.dataSource addObject:carListModel];
                }
                [self.tableView reloadData];
            }
        }else if([responseObj[@"status"] isEqualToString:@"-1"]){
            [MBProgressHUD show:responseObj[@"result"] icon:nil view:self.view];
        }
      
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)addNavigationBar:(BOOL)hidRight{
    //初始化nav

   
    if (hidRight == YES) {
        NavView *nav = [[NavView alloc] initWithFrame:CGRectZero title:@"我的车辆" leftImgae:@"back@2x.png" rightButton:@"添加车辆"];
        nav.backBlock = ^{
            [self.navigationController popViewControllerAnimated:YES];
        };
        nav.rightBlock = ^{
            NSLog(@"点击了右边的按钮");
            MyAddCarViewController *addCar = [[MyAddCarViewController alloc] init];
            addCar.titles = @"添加车辆";
            [self.navigationController pushViewController:addCar animated:YES];
        };
        [self.view addSubview:nav];
        [nav mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.top.equalTo(self.view);
            make.height.mas_equalTo(StatusH);
        }];
    }else{
        NavView *nav = [[NavView alloc] initWithFrame:CGRectZero title:@"我的车辆" leftImgae:@"back@2x.png" rightButton:@""];
        nav.backBlock = ^{
            [self.navigationController popViewControllerAnimated:YES];
        };
        nav.rightBlock = ^{
            NSLog(@"点击了右边的按钮");
            MyAddCarViewController *addCar = [[MyAddCarViewController alloc] init];
            addCar.titles = @"添加车辆";
            [self.navigationController pushViewController:addCar animated:YES];
        };
        [self.view addSubview:nav];
        [nav mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.top.equalTo(self.view);
            make.height.mas_equalTo(StatusH);
        }];
    }
}


-(void)addtableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,StatusH, XYScreenWidth, XYScreenHeight) style:UITableViewStylePlain];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.autoresizingMask = YES;
    tableView.rowHeight = 110;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [tableView registerNib:[UINib nibWithNibName:@"MyCarTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyCarCell"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self addDataSource];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return self.array.count;
     return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCarTableViewCell *cell = [MyCarTableViewCell creatMyCarCell];
    MyCarListModel *listModel = self.dataSource[indexPath.row];
    cell.cancel = ^{
        [self deleteCar:listModel.id];
        [self.self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    };
    cell.change = ^{
        MyAddCarViewController *addCar = [[MyAddCarViewController alloc] init];
        addCar.titles = @"修改车辆";
        addCar.careID = listModel.id;
        addCar.carModel = listModel;
        [self.navigationController pushViewController:addCar animated:YES];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.listModel = listModel;
    return cell;
}


-(void)deleteCar:(NSString *)ID{
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    [parame setValue:ID forKey:@"id"];
    [parame setValue:[Config getOwnID] forKey:@"userId"];
    //    [parame setValue:@"" forKey:@""];
    [WMNetWork get:ChargeDeleteMyCare parameters:parame success:^(id responseObj) {
        //
        if ([responseObj[@"status"] isEqualToString:@"0"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                 [MBProgressHUD show:@"删除成功" icon:nil view:self.view];
                [self.tableView.mj_header beginRefreshing];
            });
           
//            NSMutableArray *muarr = [NSMutableArray objectArrayWithKeyValuesArray:responseObj[@"result"]];
//            for (NSDictionary *dict in muarr ) {
//                MyCarListModel *carListModel = [MyCarListModel objectWithKeyValues:dict];
//                [self.dataSource addObject:carListModel];
//            }
//            [self.tableView reloadData];
        }else if([responseObj[@"status"] isEqualToString:@"-1"]){
            [MBProgressHUD show:responseObj[@"result"] icon:nil view:self.view];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

@end
