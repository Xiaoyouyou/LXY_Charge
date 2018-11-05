//
//  ZhuangWeiMesViewController.m
//  Charge
//
//  Created by olive on 16/6/8.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "ZhuangWeiMesViewController.h"
#import "DetailZhuangWeiViewTableViewCell.h"
#import "ChargeNumberCell.h"
#import "ZhuangWeiHeaderView.h"
#import "XFunction.h"
#import "PilesModel.h"
#import "Masonry.h"

@interface ZhuangWeiMesViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZhuangWeiHeaderView *zhuangWei;
@property (nonatomic, strong) NSArray *dataArray;//数据数组

@property (nonatomic, copy) NSString *free;
@property (nonatomic, copy) NSString *zhiliu;
@property (nonatomic, copy) NSString *jiaoliu;
@property (nonatomic, copy) NSString *total;

@property (nonatomic, assign) NSInteger j;



@end

@implementation ZhuangWeiMesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    _j = 0;
//
//    //遍历数据数组获取空闲的充电桩
//    for (int i = 0; i<self.dataArray.count; i++) {
//       PilesModel *pileMes =  self.dataArray[i];
//    if ([pileMes.status isEqualToString:@"1"]) {
//        _j++;
//        }
//    }
//
//    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    _zhuangWei = [[ZhuangWeiHeaderView alloc]initWithFrame:CGRectMake(0, 0, XYScreenWidth, 62)];
//    _zhuangWei.zhiliu = self.zhiliu;
//    _zhuangWei.jiaoliu = self.jiaoliu;
//    _zhuangWei.total = self.total;
//    _zhuangWei.free = [NSString stringWithFormat:@"空闲：%ld",(long)_j];
//
//    [self.view addSubview:_zhuangWei];
//
    NSLog(@"%@",self.zhuangID);
    [self creatUI];

}

-(void)creatUI
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 100;
    [self.tableView registerNib:[UINib nibWithNibName:@"ChargeNumberCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ChargeNumberCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView代理方法

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 50;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

//设置每个区有多少行共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chargeNumber.count;
}

//响应点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYLog(@"响应单击事件");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChargeNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChargeNumberCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    static NSString *cellIdetifier = @"ListsCells";
//    DetailZhuangWeiViewTableViewCell *listcell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier];
//
//    if (listcell == nil) {
//        UINib *nib = [UINib nibWithNibName:@"DetailZhuangWeiViewTableViewCell" bundle:nil];
//        [tableView registerNib:nib forCellReuseIdentifier:cellIdetifier];
//        listcell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier];
//    }
//
    cell.model1 = self.zhuangA[indexPath.row];
    cell.model2 = self.zhzuangB[indexPath.row];
    cell.ZhuangID.text = [NSString stringWithFormat:@"%@",self.zhuangID[indexPath.row]];
//    PilesModel *pileMes =  self.dataArray[indexPath.row];
//    listcell.selectionStyle = UITableViewCellSelectionStyleNone;
//    listcell.zhuangNum.text = pileMes.name;
//    if ([pileMes.type isEqualToString:@"0"]) {
//        listcell.status.image = [UIImage imageNamed:@"mans.png"];
//        listcell.types.text = @"慢";
//
//    }else if ([pileMes.type isEqualToString:@"1"])
//    {
//        listcell.status.image = [UIImage imageNamed:@"kuais@2x.png"];
//        listcell.types.text = @"快";
//    }
//
//    if ([pileMes.status isEqualToString:@"1"]) {
//        listcell.statusImage.image = [UIImage imageNamed:@"free@2x.png"];
//    }else if ([pileMes.status isEqualToString:@"3"])
//    {
//        listcell.statusImage.image = [UIImage imageNamed:@"zhanYong@2x.png"];
//    }else if([pileMes.status isEqualToString:@"2"])
//    {
//        listcell.statusImage.image = [UIImage imageNamed:@"faults@2x.png"];
//    }else if([pileMes.status isEqualToString:@"4"])
//    {
//        listcell.statusImage.image = [UIImage imageNamed:@"YuYues@2x.png"];
//    }else if([pileMes.status isEqualToString:@"5"])
//    {
//        listcell.statusImage.image = [UIImage imageNamed:@"OutsLine@2x.png"];
//    }else if([pileMes.status isEqualToString:@"0"])
//    {
//        listcell.statusImage.image = [UIImage imageNamed:@"stop@2x.png"];
//    }

    return cell;
}

////tableView间距处理代理方法
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 16;
//}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

//-(void)setChargeDataModel:(NSArray *)chargeDataModel
//{
//    _chargeDataModel = chargeDataModel;
//    self.dataArray = chargeDataModel;
//}

#pragma mark - set方法

-(void)setDict:(NSMutableDictionary *)dict
{
    _dict = dict;
    self.zhiliu =  [NSString stringWithFormat:@"直流：%@",[dict objectForKey:@"fastCount"]];
    self.jiaoliu = [NSString stringWithFormat:@"交流：%@",[dict objectForKey:@"slowCount"]];
    NSInteger zhiLiuCount  = [[dict objectForKey:@"fastCount"] integerValue];
    NSInteger jiaoLiuCount  = [[dict objectForKey:@"slowCount"] integerValue];
    NSInteger total = zhiLiuCount + jiaoLiuCount;
    
    self.total = [NSString stringWithFormat:@"总数：%ld",(long)total];
}

@end
