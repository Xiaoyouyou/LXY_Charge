//
//  DetailZhuangWeiViewController.m
//  Charge
//
//  Created by olive on 16/6/8.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "DetailZhuangWeiViewController.h"
#import "ChargeInfoTableViewController.h"
#import "ZhuangWeiMesViewController.h"
#import "DetailZhuangBtnView.h"
#import "DetailZhuangWeiHeaderView.h"
#import "DetailZhuangWeiTableViewCell.h"
#import "XFunction.h"
#import "Masonry.h"
#import "ChargeDetalMes.h"


@interface DetailZhuangWeiViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    DetailZhuangWeiHeaderView *detailView;
    DetailZhuangBtnView *btnView;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *arraytitle;
@property (strong, nonatomic) NSArray *FuTitle;

@property (copy, nonatomic) NSString *picture;//站照片
@property (copy, nonatomic) NSString *chargeFee;//电费
@property (copy, nonatomic) NSString *parkingFee;//停车费
@property (copy, nonatomic) NSString *servesFee;//服务费
@property (copy, nonatomic) NSString *yuYueFee;//预约费
@property (copy, nonatomic) NSString *startTimes;//开始时间
@property (copy, nonatomic) NSString *payType;//支付方式
@property (copy, nonatomic) NSString *endTimes;//结束时间



@property (strong, nonatomic) NSMutableDictionary *dataDict;//模型数组

@end

@implementation DetailZhuangWeiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //初始化数据
//    self.arraytitle = @[@"电费",@"停车费",@"服务费",@"预约费用",@"支付方式",@"开放时间"];
     self.arraytitle = @[@"当前时段",@"电费",@"服务费",@"活动优惠",@"总计",@"开放时间",@"停车费",@"支付方式",@"收费说明"];
    // self.FuTitle = @[@"0.5元/度",@"免费",@"免费",@"5元",@"00:00~24:00",@"微信"];
    
    [self creatUI];
}


-(void)loadSource{
    NSDictionary *paramer = @{
                              @"userId" : [Config getOwnID]
                              };
    [WMNetWork get:GetBalance parameters:paramer success:^(id responseObj) {
//        [self.bottomTitleArr removeAllObjects];
//        [self.bottomTitleArr addObject:responseObj[@"balance"]];
//        [self.bottomTitleArr addObject:@"00"];
//        [self addSomeSubViews:self.bottomTitleArr];
    } failure:^(NSError *error) {
        
    }];
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
    
    //tableview 中的 topview
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XYScreenWidth, 100 + 200)];
    self.tableView.tableHeaderView = backView;
    detailView = [[DetailZhuangWeiHeaderView alloc]initWithFrame:CGRectMake(0, 0, XYScreenWidth, 90 + 200)];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:_model.stationPic]];
    detailView.pictImageView.image = [UIImage imageWithData:data]; // 取得图片
    
    detailView.titleLab.text = _model.name;
    detailView.FutitleLab.text = _model.address;
    detailView.fastLab.text = [NSString stringWithFormat:@"交流(%@)",_model.acCount];
    detailView.slowLab.text = [NSString stringWithFormat:@"直流(%@)",_model.dcCount];
    detailView.diastaceLab.text = [self.dataDict objectForKey:@"distance"]; //千米数
    detailView.picArray = _model.picList;
    [backView addSubview:detailView];
    //tableview 中的 bottomView
//    btnView = [[DetailZhuangBtnView alloc] initWithFrame:CGRectMake(0, 97, XYScreenWidth, 36) count: self.all_chargingSub.count];
//     __weak typeof(self) weakSelf = self;
//    btnView.btnClickBlock = ^(UIButton *sender) {
//       MYLog(@"响应单击事件");
//                NSLog(@"sender:%ld",sender.tag);
//        [weakSelf setDataToCell:weakSelf.all_chargingSub[sender.tag]];
//        [weakSelf.tableView reloadData];
//    };
//    [backView addSubview:btnView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView代理方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == self.arraytitle.count - 1){
        return 88;
    }else{
        return 44;
    }
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    return 1;
//}

//设置每个区有多少行共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arraytitle.count;
}

//响应点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 &indexPath.row == 0){
        ChargeInfoTableViewController *chargeInfo = [[ChargeInfoTableViewController alloc] init];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:chargeInfo];
        chargeInfo.id = self.id;        
        [self presentViewController:chargeInfo animated:YES completion:nil];
    }
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
    if ( indexPath.row == 0) {
        Cell.detailTextLabel.textColor = [UIColor blackColor];
        Cell.detailTextLabel.text = [NSString stringWithFormat:@"%@  >",_model.cTimeRange];
    }else if ( indexPath.row == 1)
    {
        Cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元/度",_model.elecFee];
    }else if ( indexPath.row ==2)
    {
        Cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元/度",_model.serverFee];
    }else if ( indexPath.row == 3)
    {
        Cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元/度",_model.serverDiscount];
    }else if ( indexPath.row == 4)
    {
        float all = _model.elecFee.floatValue + _model.serverFee.floatValue - _model.serverDiscount.floatValue;
        Cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2lf元/度",all];
    }else if ( indexPath.row == 5)
    {
        Cell.detailTextLabel.text = _model.openTime;
        
    }else if (indexPath.row == 6)
    {
        Cell.detailTextLabel.text = _model.parkNote;
    }else if ( indexPath.row == 7)
    {
        Cell.detailTextLabel.text = _model.payWay;
        
    }else if ( indexPath.row == 8)
    {
        Cell.textLabel.textAlignment = NSTextAlignmentCenter;
        Cell.detailTextLabel.numberOfLines = 0;
        NSString *str = _model.feeNote;
        str = [str stringByReplacingOccurrencesOfString:@"，"withString:@"\n"];
        NSLog(@"replaceStr=%@",str);
        Cell.detailTextLabel.text = str;
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
    
//    self.name = [self.dataDict objectForKey:@"name"];
//    self.address = [self.dataDict objectForKey:@"address"];
//    self.fastCount = [self.dataDict objectForKey:@"fastCount"];
//    self.slowCount = [self.dataDict objectForKey:@"slowCount"];
   
   
  
//    [_dict setObject:_ChargeDetal.feeNote forKey:@"feeNote"];//收费说明   加一行  平段是1.09，峰段1.49

}


-(void)setModel:(ChargeDetalMes *)model{
    _model = model;
}

-(void)setDataToCell:(NSDictionary *)dataSource
{

    self.chargeFee =[dataSource objectForKey:@"chargeCost"];
    self.parkingFee = [dataSource objectForKey:@"parkingCharge"];
    self.servesFee = [dataSource objectForKey:@"serviceCost"];
    self.yuYueFee = [dataSource objectForKey:@"emptyCost"];
    self.startTimes = [dataSource objectForKey:@"startTime"];
    self.endTimes = [dataSource objectForKey:@"endTime"];
    NSLog(@"%@",dataSource[@"address"]);
//    self.name = [dataSource objectForKey:@"id"];
//    self.address = [dataSource objectForKey:@"ruleId"];
//    self.fastCount = [dataSource objectForKey:@"discountRate"];
}

//-(void)setPlist:(NSMutableArray *)plist{
//    _plist = plist;
//
//}


@end
