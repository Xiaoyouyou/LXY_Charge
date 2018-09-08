//
//  DetailZhuangWeiViewController.m
//  Charge
//
//  Created by olive on 16/6/8.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "DetailZhuangWeiViewController.h"
#import "ZhuangWeiMesViewController.h"
#import "DetailZhuangWeiHeaderView.h"
#import "DetailZhuangWeiTableViewCell.h"
#import "XFunction.h"
#import "Masonry.h"

@interface DetailZhuangWeiViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    DetailZhuangWeiHeaderView *detailView;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *arraytitle;
@property (strong, nonatomic) NSArray *FuTitle;

@property (copy, nonatomic) NSString *chargeFee;//电费
@property (copy, nonatomic) NSString *parkingFee;//停车费
@property (copy, nonatomic) NSString *servesFee;//服务费
@property (copy, nonatomic) NSString *yuYueFee;//预约费
@property (copy, nonatomic) NSString *startTimes;//开始时间
@property (copy, nonatomic) NSString *payType;//支付方式
@property (copy, nonatomic) NSString *endTimes;//结束时间

@property (copy, nonatomic) NSString *name;//名字
@property (copy, nonatomic) NSString *address;//地址
@property (copy, nonatomic) NSString *fastCount;//快充
@property (copy, nonatomic) NSString *slowCount;//慢充
@property (copy, nonatomic) NSString *distances;//距离

@property (strong, nonatomic) NSMutableDictionary *dataDict;//模型数组

@end

@implementation DetailZhuangWeiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //初始化数据
    self.arraytitle = @[@"电费",@"停车费",@"服务费",@"预约费用",@"支付方式",@"开放时间"];
    // self.FuTitle = @[@"0.5元/度",@"免费",@"免费",@"5元",@"00:00~24:00",@"微信"];
    
    [self creatUI];
}

#pragma mark -- creatUI

-(void)creatUI
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
     self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    detailView = [[DetailZhuangWeiHeaderView alloc]initWithFrame:CGRectMake(0, 0, XYScreenWidth, 90)];
    detailView.titleLab.text = self.name;
    detailView.FutitleLab.text = self.address;
    detailView.fastLab.text = [NSString stringWithFormat:@"快(%@)",_fastCount];
    detailView.slowLab.text = [NSString stringWithFormat:@"慢(%@)",_slowCount];
    detailView.diastaceLab.text = self.distances;
    self.tableView.tableHeaderView = detailView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView代理方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

//设置每个区有多少行共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

//响应点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYLog(@"响应单击事件");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdetifier = @"detailCell";
    DetailZhuangWeiTableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier];
    if (Cell == nil) {
        Cell = [[DetailZhuangWeiTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdetifier];
    }
    NSString *content = self.arraytitle[indexPath.row];
    Cell.textLabel.text = [NSString stringWithFormat:@"%@",content];
    Cell.textLabel.font = TableViewCellFont;
    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Cell.detailTextLabel.font = TableViewCellFuTitleFont;
    if (indexPath.section == 0 && indexPath.row == 0) {
       Cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元/度",self.chargeFee];
    }else if (indexPath.section == 0 &indexPath.row == 1)
    {
        if ([self.parkingFee isEqualToString:@"0"]) {
          Cell.detailTextLabel.text = @"按物业停车场收费";
        }else
        {
          Cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元/分钟",_parkingFee];
        }

    }else if (indexPath.section == 0 && indexPath.row ==2)
    {
        if ([self.servesFee isEqualToString:@"0"]) {
            Cell.detailTextLabel.text = @"免费";
        }else
        {
            Cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元/分钟",self.servesFee];
        }
    }else if (indexPath.section == 0 && indexPath.row == 3)
    {
        if ([self.yuYueFee isEqualToString:@"0"]) {
            Cell.detailTextLabel.text = @"免费";
        }else
        {
            Cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元/分钟",self.yuYueFee];
        }
    }else if (indexPath.section == 0 && indexPath.row == 4)
    {
          Cell.detailTextLabel.text = @"微信支付";
     
    }else if (indexPath.section == 0 && indexPath.row == 5)
    {
          Cell.detailTextLabel.text = [NSString stringWithFormat:@"%@~%@",self.startTimes,self.endTimes];
    }
    
    return Cell;
}

//tableView间距处理代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 16;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark - setting 方法

-(void)setChargeDeatlModel:(NSMutableDictionary *)chargeDeatlModel
{
    _chargeDeatlModel = chargeDeatlModel;
    self.dataDict = chargeDeatlModel;
 //   MYLog(@"self.dataDictasdasdasdas = %@",self.dataDict);
    self.chargeFee =[self.dataDict objectForKey:@"chargeCost"];
    self.parkingFee = [self.dataDict objectForKey:@"parkingCharge"];
    self.servesFee = [self.dataDict objectForKey:@"serviceCost"];
    self.yuYueFee = [self.dataDict objectForKey:@"emptyCost"];
    self.startTimes = [self.dataDict objectForKey:@"startTime"];
    self.endTimes = [self.dataDict objectForKey:@"endTime"];
    
    self.name = [self.dataDict objectForKey:@"name"];
    self.address = [self.dataDict objectForKey:@"address"];
    self.fastCount = [self.dataDict objectForKey:@"fastCount"];
    self.slowCount = [self.dataDict objectForKey:@"slowCount"];
    self.distances = [self.dataDict objectForKey:@"distance"];
}

@end
