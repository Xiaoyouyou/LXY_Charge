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
#define StatusH [UIApplication sharedApplication].statusBarFrame.size.height + 44
@interface MyCarViewController ()<UITableViewDelegate,UITableViewDataSource
>
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)NSMutableDictionary *dict;
@property (nonatomic ,strong)NSArray *array;
@end

@implementation MyCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化nav
    [self addNavigationBar];
    //添加tableView
    [self addtableView];
   
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
    tableView.rowHeight = 80;
    [self.view addSubview:tableView];
//    [tableView registerNib:[UINib nibWithNibName:@"MyCarTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyCarCell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return self.array.count;
     return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCarTableViewCell *cell = [MyCarTableViewCell creatMyCarCell];
    return cell;
}

@end
