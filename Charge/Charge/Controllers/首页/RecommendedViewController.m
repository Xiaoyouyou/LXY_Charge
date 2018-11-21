//
//  RecommendedViewController.m
//  Charge
//
//  Created by olive on 16/6/6.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import "RecommendedViewController.h"
#import "SearchChargeTableViewCell.h"
#import "ChargeDetailViewController.h"
#import "PositionCityViewController.h"
#import "WMNetWork.h"
#import "XFunction.h"
#import "API.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "ChargePointMesModel.h"
#import "ZhouBianChargeModel.h"
#import "MJExtension.h"
#import "Masonry.h"
#import "Config.h"

@interface RecommendedViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) IBOutlet UILabel *cityChooseLab;//城市选择
@property (strong, nonatomic) IBOutlet UITextField *intPutMuDiDi;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *destanceTextField;
@property (strong, nonatomic) NSMutableArray  *chargingMess; //充电站数据
@property (nonatomic, strong) NSMutableArray *ZhouBianChargeModelArray;//新的模型对象数组
@property (nonatomic, strong) NSMutableArray *chargingPointArray;//排序后全部充电点数组

@property (nonatomic, strong) UITableView *tableview1;//存搜索tableview
@property (strong, nonatomic) IBOutlet UIView *lineView;//线view

@property (strong, nonatomic) NSMutableArray *tempArray;//搜索tableView数据

@property (nonatomic, strong) NSString *cityStr;//城市选择

- (IBAction)cacelBtn:(id)sender;

@end

@implementation RecommendedViewController

-(NSMutableArray *)tempArray
{
    if (_tempArray == nil) {
        _tempArray = [NSMutableArray array];
    }
    return _tempArray;
}

-(NSMutableArray *)chargingMess
{
    if (_chargingMess == nil) {
        _chargingMess = [NSMutableArray array];
    }
    return _chargingMess;
}

-(NSMutableArray *)chargingPointArray
{
    if (_chargingPointArray == nil) {
        _chargingPointArray = [NSMutableArray array];
    }
    return _chargingPointArray;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //如果充电点数据有值，先清除数据再获取值
    if (self.chargingPointArray) {
        [self.chargingPointArray removeAllObjects];
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
       NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
    //充电点字典
    NSMutableDictionary *tempdict = [NSMutableDictionary dictionary];
    //全部数据距离数组
    NSMutableArray *temparray = [NSMutableArray array];
    //新的模型数组
    NSMutableArray *modelArray = [NSMutableArray array];

        parmas[@"province"] = nil;
        parmas[@"city"] = self.cityStr;
        MYLog(@"self.locationCity = %@",self.locationCity);
        parmas[@"page"] = @"1";
        parmas[@"pageSize"] = @"100";
        [WMNetWork post:RecommendList parameters:parmas success:^(id responseObj) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        MYLog(@"responseObjffff = %@",responseObj);
            
        if ([responseObj[@"status"] intValue] == 0) {
        //存数据
        _chargingMess = [ZhouBianChargeModel objectArrayWithKeyValuesArray:[responseObj objectForKey:@"result"]];
        //MYLog(@"_chargingMess = %@",_chargingMess);
            
        //获取保存的经纬度
        BMKMapPoint point1 = BMKMapPointForCoordinate([Config getCurrentLocation]);
            
        for (ZhouBianChargeModel *zhouBian in _chargingMess) {
                
        BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake([zhouBian.latitudes doubleValue],[zhouBian.longitude doubleValue]));
        CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
        NSString *distanceStr = [NSString stringWithFormat:@"%.1fkm",distance/1000];
        NSNumber *nums = @([distanceStr floatValue]);
        [tempdict setObject:zhouBian forKey:nums];
        [temparray addObject:nums];

        }
            //升序
            [temparray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj1 floatValue] > [obj2 floatValue];
            }];
            //模型转字典，增加距离数据
            for (int i = 0; i < temparray.count; i++) {
                
                ZhouBianChargeModel *listmes = [tempdict objectForKey:temparray[i]];
                NSMutableDictionary *dicts = listmes.keyValues;
                [dicts setObject:temparray[i] forKey:@"distance"];
                [modelArray addObject:dicts];
                
            }
            _ZhouBianChargeModelArray = [ZhouBianChargeModel objectArrayWithKeyValuesArray:modelArray];
            
            for (ZhouBianChargeModel *zhouBian in _ZhouBianChargeModelArray) {
                
                [self.chargingPointArray addObject:zhouBian];
            }
            [self.tableView reloadData];
        }
        MYLog(@"responseObj = %@",self.chargingPointArray);

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        MYLog(@"error = %@",error);
    }];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.topView.frame = CGRectMake(StatusBarH + 5, 0, XYScreenWidth, XYScreenHeight);
    // Do any additional setup after loading the view from its nib.
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self setting];
    self.cityStr = self.locationCity;//初始城市赋值
    
    //创建搜索的tableview
     [self creatTempTableView];
    
    self.destanceTextField.delegate = self;
}

#pragma mark - 设置
-(void)setting
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cityChooseAction)];
    self.cityChooseLab.userInteractionEnabled =YES;
    [self.cityChooseLab addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action

-(void)creatTempTableView
{
    self.tableview1 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableview1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableview1.delegate = self;
    self.tableview1.dataSource = self;
    self.tableview1.tag = 1;
    self.tableview1.alpha = 0;
    self.tableview1.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableview1];
    
    [self.tableview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
}

-(void)cityChooseAction
{
    PositionCityViewController *positionVC = [[PositionCityViewController alloc] init];
    positionVC.locationCitys = self.locationCity;//传当前定位城市过去
    positionVC.ChooseCityBlack = ^(NSString *CityName){
        
        _cityChooseLab.text = CityName;
        self.cityStr = CityName;
        
    };
    positionVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:positionVC animated:YES completion:nil];
}

#pragma mark - UITableView代理方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

//设置每个区有多少行共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   // MYLog(@"充电点数量 == %d",_chargingMess.count);
   // return self.chargingPointArray.count;
   // return 10;
    if (tableView.tag == 1) {
       return self.tempArray.count;
    }else
    {
       return self.chargingPointArray.count;
    }
}

//响应点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   ZhouBianChargeModel *ZhouBianchargeModel = self.chargingPointArray[indexPath.row];
    
   ChargeDetailViewController *chargeDetaiVC = [[ChargeDetailViewController alloc] init];
   chargeDetaiVC.id = ZhouBianchargeModel.id;
   [self presentViewController:chargeDetaiVC animated:YES completion:nil];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        static NSString *cellIdetifier = @"SearchCell";
        SearchChargeTableViewCell *SearchCell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier];
        if (SearchCell == nil) {
            SearchCell = [[[NSBundle mainBundle]loadNibNamed:@"SearchChargeTableViewCell" owner:nil options:nil]lastObject];
        }
        ZhouBianChargeModel *ZhouBianchargeModel = self.tempArray[indexPath.row];
        
        SearchCell.tempSlowLab = ZhouBianchargeModel.slowCount;
      //SearchCell.tempCostLab = chargeModel.fee_rule;
        SearchCell.tempFastLab = ZhouBianchargeModel.fastCount;
        SearchCell.tempChargeName = ZhouBianchargeModel.name;
        SearchCell.tempChargeAddress = ZhouBianchargeModel.address;
        SearchCell.tempCostLab = ZhouBianchargeModel.fee_rule;
        SearchCell.tempDistabceLab = [NSString stringWithFormat:@"%@km",ZhouBianchargeModel.distance];
        
        return SearchCell;
    }else{
        
    static NSString *cellIdetifier = @"SearchCell";
    SearchChargeTableViewCell *SearchCell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier];
    if (SearchCell == nil) {
        SearchCell = [[[NSBundle mainBundle]loadNibNamed:@"SearchChargeTableViewCell" owner:nil options:nil]lastObject];
    }
    ZhouBianChargeModel *ZhouBianchargeModel = self.chargingPointArray[indexPath.row];
    
    SearchCell.tempSlowLab = ZhouBianchargeModel.slowCount;
  //SearchCell.tempCostLab = chargeModel.fee_rule;
    SearchCell.tempFastLab = ZhouBianchargeModel.fastCount;
    SearchCell.tempChargeName = ZhouBianchargeModel.name;
    SearchCell.tempChargeAddress = ZhouBianchargeModel.address;
    SearchCell.tempCostLab = ZhouBianchargeModel.fee_rule;
    SearchCell.tempDistabceLab = [NSString stringWithFormat:@"%@km",ZhouBianchargeModel.distance];
    
    return SearchCell;
    }
}

- (IBAction)cacelBtn:(id)sender {
    [self.intPutMuDiDi resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TextField 代理
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger strLength = textField.text.length - range.length + string.length;
    
    if (strLength > 15){
        return NO;
    }
    NSString *text = nil;
    //如果string为空，表示删除
    if (string.length > 0) {
        if (self.tempArray) {
            [self.tempArray removeAllObjects];
        }

       text = [NSString stringWithFormat:@"%@%@",textField.text,string];
   
       for (int i = 0; i < self.chargingPointArray.count; i++) {
          ZhouBianChargeModel *ZhouBianchargeModel = self.chargingPointArray[i];
          NSRange chinese = [ZhouBianchargeModel.address rangeOfString:text options:NSCaseInsensitiveSearch];
           if (chinese.location != NSNotFound) {
               [self.tempArray addObject:ZhouBianchargeModel];
           }
        }
        
        self.tableView.alpha = 0;
        self.tableview1.alpha = 1;
        [self.tableview1 reloadData];
    
    }else{
        if (self.tempArray) {
           [self.tempArray removeAllObjects];
        }
      
        text = [NSString stringWithFormat:@"%@%@",textField.text,string];
        for (int i = 0; i < self.chargingPointArray.count; i++) {
            ZhouBianChargeModel *ZhouBianchargeModel = self.chargingPointArray[i];
            NSRange chinese = [ZhouBianchargeModel.address rangeOfString:text options:NSCaseInsensitiveSearch];
            if (chinese.location != NSNotFound) {
                [self.tempArray addObject:ZhouBianchargeModel];
            }
        }
         self.tableView.alpha = 0;
         self.tableview1.alpha = 1;
         [self.tableview1 reloadData];
    }
    if (strLength == 0) {
        self.tableView.alpha = 1;
        self.tableview1.alpha = 0;
        [self.tableView reloadData];
    }
    return YES;
}

@end
