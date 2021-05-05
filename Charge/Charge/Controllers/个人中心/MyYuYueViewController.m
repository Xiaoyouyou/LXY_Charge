//
//  MyYuYueViewController.m
//  Charge
//
//  Created by olive on 16/11/16.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//


#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BMKLocationkit/BMKLocationComponent.h>//引入定位功能所有的头文件
#import "MyYuYueViewController.h"
#import "YuYueTableViewCell.h"
#import "YuYueTableFooterView.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "YuYueChargeModel.h"
#import "Config.h"
#import "MJExtension.h"
#import "XFunction.h"
#import "Masonry.h"
#import "Singleton.h"
#import "WMNetWork.h"
#import "XStringUtil.h"
#import "TipView.h"
#import "NavView.h"
#import "API.h"

#define Check_OUTP_TIME 10

@interface MyYuYueViewController ()
<UITableViewDelegate,UITableViewDataSource>
{
    NSString *yuYueState;//预约状态
    NSString *yuYueMoney;//预约金额
    int mySeconds;
    int checkTime;//检测超时
    
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *arrayTitle;
@property (nonatomic, strong) TipView *tipview;
@property (nonatomic, strong) YuYueChargeModel *YuYueCharge;

@property (nonatomic, strong) NSString *distanceStr;
@property (nonatomic, strong) NSString *yuYueCost;//预约费

@property (nonatomic, strong) NSTimer *timer;//转菊花超时定时器

@property (nonatomic, copy) NSString *codeChargeNum;//预约桩号

@end

@implementation MyYuYueViewController
-(void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //查看预约信息
    NSMutableDictionary *paramers = [NSMutableDictionary dictionary];
    
    paramers[@"mobile"] = [Config getMobile];
    MYLog(@"getMobile = %@",[Config getMobile]);
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    [WMNetWork post:ReservationInfoCharge parameters:paramers success:^(id responseObj) {
        
        if (self.tipview) {
            self.tipview.alpha = 0;
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        MYLog(@"chaxunyuyueresponseObj = %@",responseObj);
        
        if ([responseObj[@"status"] intValue] == 0) {
            
            _YuYueCharge = [YuYueChargeModel yy_modelWithDictionary:responseObj[@"result"]];
            _codeChargeNum = _YuYueCharge.code;
            //MYLog(@"addr = %@,chargeCost = %@,code = %@",YuYueCharge.addr,YuYueCharge.chargingSub.chargeCost,YuYueCharge.code);
            //计算距离
            [self jiSuanDistance];
            //计算预约费
            [self jiSuaanYuYueCost];
            //开启tableview的透明度
            self.tableView.alpha = 1;
            //再次确认保存预约标志位
            [Config saveYuYueFlag:@"0"];
            
            [self.tableView reloadData];
        }
        
        if ([responseObj[@"status"] intValue] == -1) {
            [self initTipViewTipStr:@"您还没有预约" TipImage:@"NoneYuYue@2x.png"];
            //清除预约成功标志位
            [Config removeYuYueFlag];
            //移除预约结束时间
            [Config removeYuYueEndTime];
        }
    } failure:^(NSError *error) {
        MYLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //提示view
        [self initTipViewTipStr:@"您好，请检查网络" TipImage:@"NoneNetwork@2x.png"];
    }];
}

#pragma Mark- action

-(void)jiSuanDistance
{
    //获取保存的经纬度
    BMKMapPoint point1 = BMKMapPointForCoordinate([Config getCurrentLocation]);
    BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake([_YuYueCharge.latitudes doubleValue],[_YuYueCharge.longitude doubleValue]));
    CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
    
    _distanceStr = [NSString stringWithFormat:@"%.2fkm",distance/1000];
    
}

//计算预约费
-(void)jiSuaanYuYueCost
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startDate = [dateFormatter dateFromString:_YuYueCharge.startTime];
    
    NSDate *newCurrentDate = [NSDate date];
    NSString *value = [XStringUtil dateTimeDifferenceWithStartTimes:startDate endTime:newCurrentDate];
    //赋值计时器初始值
    mySeconds = [value intValue];
    
    double cost = mySeconds/60  * [_YuYueCharge.chargingSub.emptyCost doubleValue];
    
    _yuYueCost = [NSString stringWithFormat:@"%.2f",cost];
    
}

//初始化tipView
-(void)initTipViewTipStr:(NSString *)tipStr TipImage:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    NSString *str = tipStr;
    
    self.tipview  = [[TipView alloc] initWithFrame:CGRectZero image:image andshowText:str];
    self.tipview.alpha = 1;
    [self.tipview SetUpMasonry];
    [self.view addSubview:self.tipview];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refresh)];
    [self.tipview addGestureRecognizer:tap];
    
    
    [self.tipview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.navigationController.navigationBarHidden = NO;
 //   self.title = @"我的预约";
 //   UIImage *image = [UIImage imageNamed:@"back"];
 //   image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
 //   self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.arrayTitle = @[@[@""],@[@"预约桩号",@"当前预约金额",@"预约截止时间"],@[@"服务费",@"停车费"]];
    
    //创建nav
    NavView *nav = [[NavView alloc] initWithFrame:CGRectZero title:@"我的预约"];
    nav.backBlock = ^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    };
    
    [self creatUI];
}

#pragma  mark - 初始化
-(void)creatUI
{
    UIView *view = [[UIView alloc] init];
    
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
        make.height.mas_equalTo(64);
    }];
    
    
    UIView *backView = [[UIView alloc] init];
    [self.view addSubview:backView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backViewClick)];
    [backView addGestureRecognizer:tap1];
    
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@"back"];
    [backView addSubview:backImageView];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(16);
        make.top.equalTo(backView).offset(10);
        make.size.mas_equalTo(CGSizeMake(20.5,20.5));
    }];
    
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(22);
        make.size.mas_equalTo(CGSizeMake(42,42));
        
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"我的预约";
    titleLab.font = [UIFont fontWithName:@"Helvetica Bold" size:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(34);
        make.size.mas_equalTo(CGSizeMake(133, 22));
        make.centerX.equalTo(view);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, XYScreenWidth, XYScreenHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.tableView];
    
    YuYueTableFooterView *YuYueFooterView = [YuYueTableFooterView creatYuYueTableFooterView];
    __weak MyYuYueViewController *weakSelf = self;
    YuYueFooterView.quXiaoYuYueBlcok = ^{
        
        //初始化转菊花定时器
        //设置超时时间
        checkTime = Check_OUTP_TIME;
        //初始化超时时间
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(CheckoutTimeAction) userInfo:nil repeats:YES];
        
        //取消预约
        //转菊花
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //取消预约点击事件
        //连接socket取消电桩
        [[Singleton sharedInstance] socketConnectHost];
        //延时0.5秒
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([Singleton sharedInstance].isLink) {
                //发送取消预约指令
//                [[Singleton sharedInstance] cancelChargeNum:_codeChargeNum];
                MYLog(@"_codeChargeNum = %@",_codeChargeNum);
                //收到取消预约指令回复
                [Singleton sharedInstance].CancelYuYueChargeStatusMesBlock = ^(NSString *chargeStr){
                    //取消预约成功
                    //清除预约成功标志位
                    [Config removeYuYueFlag];
                    //移除预约结束时间
                    [Config removeYuYueEndTime];
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [MBProgressHUD showSuccess:@"取消预约成功"];
                    self.tableView.alpha = 0;
                    [self initTipViewTipStr:@"您还没有预约" TipImage:@"NoneYuYue@2x.png"];
                    [self.timer invalidate];
                    self.timer = nil;
                };
            }else
            {
                [self.timer invalidate];
                self.timer = nil;
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD show:@"网络连接失败,请重试!" icon:nil view:self.view];
            }
        });
    };
    self.tableView.tableFooterView = YuYueFooterView;
}


#pragma mark - action

-(void)refresh
{
    self.tipview.alpha = 0;
    //查看预约信息
    NSMutableDictionary *paramers = [NSMutableDictionary dictionary];
    
    paramers[@"mobile"] = [Config getMobile];
    MYLog(@"getMobile = %@",[Config getMobile]);
    
    [MBProgressHUD showMessage:@"" toView:self.view];
    //延时1秒
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [WMNetWork post:ReservationInfoCharge parameters:paramers success:^(id responseObj) {
            
            if (self.tipview) {
                self.tipview.alpha = 0;
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            MYLog(@"chaxunyuyueresponseObj = %@",responseObj);
            
            if ([responseObj[@"status"] intValue] == 0) {
                
                _YuYueCharge = [YuYueChargeModel yy_modelWithDictionary:responseObj[@"result"]];
                _codeChargeNum = _YuYueCharge.code;
                //保存预约结束时间
                [Config saveYuYueEndTime:_YuYueCharge.endTime];
                //预约成功存预约成功标志位
                [Config saveYuYueFlag:@"0"];
                
                //计算距离
                [self jiSuanDistance];
                //计算预约费
                [self jiSuaanYuYueCost];
                //开启tableview的透明度
                self.tableView.alpha = 1;
                [self.tableView reloadData];
            }
            
            if ([responseObj[@"status"] intValue] == -1) {
                [self initTipViewTipStr:@"您还没有预约" TipImage:@"NoneYuYue@2x.png"];
                //清除预约成功标志位
                [Config removeYuYueFlag];
                //移除预约结束时间
                [Config removeYuYueEndTime];
            }
        } failure:^(NSError *error) {
            MYLog(@"%@",error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //提示view
            [self initTipViewTipStr:@"您好，请检查网络" TipImage:@"NoneNetwork@2x.png"];
        }];
    });
}


-(void)backViewClick
{
    [self.presentingViewController.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


-(void)back
{
    //[self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView代理方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 63;
    }else
    {
        return 50;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

//设置每个区有多少行共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 1;
    }else if(section == 1)
    {
        return 3;
    }else
    {
        return 2;
    }
}


//响应点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        static NSString *cellIdetifier = @"YuYueCell";
        YuYueTableViewCell * YuYueCell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier];
        if (YuYueCell == nil) {
            YuYueCell = [[[NSBundle mainBundle]loadNibNamed:@"YuYueTableViewCell" owner:nil options:nil]lastObject];
        }
        YuYueCell.address = _YuYueCharge.addr;
        YuYueCell.title = _YuYueCharge.name;
        YuYueCell.price = [NSString stringWithFormat:@"%@元/度",_YuYueCharge.chargingSub.chargeCost];
        YuYueCell.distance = _distanceStr;
        
        YuYueCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return YuYueCell;
    }else
    {
        static NSString *cellIdetifier = @"newCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdetifier];
        }
        
             [cell.textLabel setText:self.arrayTitle[indexPath.section][indexPath.row]];
             cell.textLabel.font = TableViewCellFont;
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        if (indexPath.section == 1 && indexPath.row == 0) {
            [cell.detailTextLabel setText:_YuYueCharge.code];
            cell.detailTextLabel.textColor = RGBA(29, 167, 146, 1);
            cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
         
        }
        if (indexPath.section == 1 && indexPath.row == 1) {
           [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@元",_YuYueCharge.chargingSub.emptyCost]];
         
           cell.detailTextLabel.textColor = RGBA(122, 123, 124, 1);
           cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        }
        
        if (indexPath.section ==2 && indexPath.row == 0) {
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@元/小时",_YuYueCharge.chargingSub.serviceCost]];
            cell.detailTextLabel.textColor = RGBA(122, 123, 124, 1);
            cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
     
        }
        
        if (indexPath.section == 2 && indexPath.row == 1) {
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@元/小时",_YuYueCharge.chargingSub.parkingCharge]];
            cell.detailTextLabel.textColor = RGBA(122, 123, 124, 1);
            cell.detailTextLabel.font = [UIFont systemFontOfSize:13];

        }
        
        if (indexPath.section == 1 && indexPath.row == 2) {
            
          [cell.detailTextLabel setText:_YuYueCharge.endTime];
          cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
          cell.detailTextLabel.textColor = RGBA(122, 123, 124, 1);
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15.0;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(void)CheckoutTimeAction
{
    checkTime--;
    MYLog(@"checkTime = %d",checkTime);
    if (checkTime == 0) {
        [self.timer invalidate];
        self.timer = nil;
        //清除菊花
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"服务器连接超时" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        
        [alertVc addAction:sureAction];
        [self presentViewController:alertVc animated:YES completion:nil];
    }
}
@end
