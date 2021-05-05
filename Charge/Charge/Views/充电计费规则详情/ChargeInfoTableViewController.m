//
//  ChargeInfoTableViewController.m
//  Charge
//
//  Created by 罗小友 on 2018/10/27.
//  Copyright © 2018 com.XinGuoXin.cn. All rights reserved.
//

#import "ChargeInfoTableViewController.h"
#import "ChargeInfoModel.h"
#import "ChargeInfoTableViewCell.h"



@interface ChargeInfoTableViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong)UITableView *tableView;


@property (nonatomic ,strong)NSMutableArray *dataSource;
@end

@implementation ChargeInfoTableViewController

-(NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, StatusBarH + 44, XYScreenWidth, XYScreenHeight)];
    tableView.rowHeight = 80;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:@"ChargeInfoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"infocell"];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    UIView *views = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XYScreenWidth, StatusBarH + 44)];
//    views.backgroundColor = RGB_COLOR(29, 167, 145, 1.0);
    views.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, StatusBarH, 50, 44);
    [btn setImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchDown];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"计费规则";
    label.font = [UIFont systemFontOfSize:17];
    [views addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(views.mas_centerX);
        make.top.mas_equalTo(StatusBarH + 10);
        
    }];
   
    
    [views addSubview:btn];
    [self.view addSubview:views];
    //获取计费详情
    [self loadChargeIfo];
}

-(void)goback{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)loadChargeIfo{
    if (!(self.id == nil)) {
        NSDictionary *paramer = @{
                                  @"stationId" :self.id
                                  };
        [WMNetWork get:ChargeCostList parameters:paramer success:^(id responseObj) {
            NSMutableArray *array = [NSMutableArray mj_objectArrayWithKeyValuesArray:responseObj[@"chargSubList"]];
            for (NSDictionary *dict in array) {
                ChargeInfoModel *infoModel = [ChargeInfoModel yy_modelWithDictionary:dict];
                [self.dataSource addObject:infoModel];
                [self.tableView reloadData];
            }
            
        } failure:^(NSError *error) {
            
        }];
    }else{
        [MBProgressHUD showSuccess:@"桩ID为空"];
        NSLog(@"hah");
    }

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChargeInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infocell" forIndexPath:indexPath];
//    if (cell == nil) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"ChargeInfoTableViewCell" owner:nil options:nil] lastObject];;
//    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
   
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
       
    }   
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


@end
