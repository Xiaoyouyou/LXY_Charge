//
//  ChargeMessageViewController.m
//  Charge
//
//  Created by 罗小友 on 2018/10/29.
//  Copyright © 2018 com.XinGuoXin.cn. All rights reserved.
//

#import "ChargeMessageViewController.h"
#import "ChargeMessageTableViewCell.h"
#import "ChargeMessageModel.h"

@interface ChargeMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UITableView *table;
@property (nonatomic ,strong)NavView *nav;

@property (nonatomic ,strong)NSMutableArray *dataSource;
@end

@implementation ChargeMessageViewController

-(NSMutableArray *)dataSource{
    if(!_dataSource){
        _dataSource= [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB_COLOR(244, 244, 244, 1.0);
    // Do any additional setup after loading the view.
   self.nav = [[NavView alloc]initWithFrame:CGRectMake(0, 0, XYScreenWidth, StatusBarH + 44) title:@"充电记录"];//设置左边按钮初始化
    __weak typeof(self) weakself = self;
    self.nav.backBlock = ^{
        [weakself.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:self.nav];
    
    
    
    [self addTableView];
    
    [self loadChargeMessageList];
}

-(void)loadChargeMessageList{
    NSDictionary *paramer = @{
                                @"mobile": [Config getMobile],
                                @"token": [Config getToken]
                              };
    [WMNetWork get:ChargeMessageList parameters:paramer success:^(id responseObj) {
       NSMutableArray *array = [NSMutableArray arrayWithArray:responseObj[@"result"]];
        for (NSDictionary *dict in array ) {
          ChargeMessageModel *model =  [ChargeMessageModel objectWithKeyValues:dict];
            [self.dataSource addObject:model];
            [self.table reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"请求充电记录失败:%@",error);
    }];
}



-(void)addTableView{
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 88, XYScreenWidth, XYScreenHeight) style:UITableViewStylePlain];
    [self.view addSubview:self.table];
    self.table.delegate = self;
    self.table.rowHeight = 94;
    self.table.dataSource = self;
    [self.table registerNib:[UINib nibWithNibName:@"ChargeMessageTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"messageCell"];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChargeMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataSource[indexPath.row];
    return cell;
}







@end
