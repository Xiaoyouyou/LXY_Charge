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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化nav
    [self addNavigationBar];
    //添加tableView
    [self addtableView];
    [self addDataSource];
   
}

//添加数据
-(void)addDataSource{
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    [parame setValue:[Config getOwnID] forKey:@"userId"];
//    [parame setValue:@"" forKey:@""];
    [WMNetWork get:ChargeMyCareList parameters:parame success:^(id responseObj) {
//
        if ([responseObj[@"status"] isEqualToString:@"0"]) {
            NSMutableArray *muarr = [NSMutableArray objectArrayWithKeyValuesArray:responseObj[@"result"]];
            for (NSDictionary *dict in muarr ) {
                MyCarListModel *carListModel = [MyCarListModel objectWithKeyValues:dict];
                [self.dataSource addObject:carListModel];
            }
            [self.tableView reloadData];
        }else if([responseObj[@"status"] isEqualToString:@"-1"]){
            [MBProgressHUD show:responseObj[@"result"] icon:nil view:self.view];
        }
      
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)addNavigationBar{
    //初始化nav
    NavView *nav = [[NavView alloc] initWithFrame:CGRectZero title:@"我的车辆" leftImgae:@"back@2x.png" rightButton:@"添加车辆"];
    nav.backBlock = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    nav.rightBlock = ^{
        NSLog(@"点击了右边的按钮");
        MyAddCarViewController *addCar = [[MyAddCarViewController alloc] init];
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


-(void)addtableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,StatusH, XYScreenWidth, XYScreenHeight) style:UITableViewStylePlain];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.autoresizingMask = YES;
    tableView.rowHeight = 110;
    [self.view addSubview:tableView];
    self.tableView = tableView;
//    [tableView registerNib:[UINib nibWithNibName:@"MyCarTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyCarCell"];
    
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.listModel = self.dataSource[indexPath.row];
    return cell;
}

@end
