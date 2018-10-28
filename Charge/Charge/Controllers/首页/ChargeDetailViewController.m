//
//  ChargeDetailViewController.m
//  Charge
//
//  Created by olive on 16/6/8.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "ChargeDetailViewController.h"
#import "DetailZhuangWeiViewController.h"
#import "ZhuangWeiMesViewController.h"
#import "ChuZhiViewController.h"
#import "Masonry.h"
#import "Config.h"
#import "API.h"
#import "XFunction.h"
#import "PilesModel.h"
#import "ChargeDetalMes.h"
#import "WMNetWork.h"
#import "TipView.h"
#import "MBProgressHUD+MJ.h"
#import "MJExtension.h"
#import "ChargingSubModel.h"
#import "YuYueViewController.h"
#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>
#import "CLLocation+YCLocation.h"


#import "ChargeNumberModel1.h"
#import "ChargeNumberModel2.h"
//#import <CoreLocation/CoreLocation.h>

@interface ChargeDetailViewController ()<BMKLocationServiceDelegate>
{
    UIView *view1;
}

@property (strong, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (strong, nonatomic) IBOutlet UIView *subView;
@property (strong, nonatomic) IBOutlet UIButton *collectBtn;
//数据模型
@property (nonatomic, strong) ChargeDetalMes *ChargeDetal;//请求下来的总数据模型
@property (nonatomic, strong) NSMutableArray *dataArray;//桩位模型数组
@property (nonatomic, strong) NSMutableDictionary *dataDict;//详情模型字典
@property (nonatomic, strong) NSMutableArray *all_chargingSub;//分段计时的数组模型

//地图相关
@property (strong,nonatomic) BMKLocationService *locService;
@property (nonatomic, assign) BOOL isUpdateLocation;//是否更新地理位置

@property (nonatomic) double  endLatitude;
@property (nonatomic) double  endLongitude;

//当前位置与充电点距离
@property (nonatomic, copy) NSString *distanceStr;

//字典数据
@property (nonatomic, strong) NSMutableDictionary *dict;
@property (nonatomic, strong) TipView *tipview;//提示view

@property (nonatomic, strong) NSMutableDictionary *cheWeiDict;//
@property (nonatomic, assign) NSInteger j;//空闲桩数量

@property (nonatomic, copy) NSString *balance;//余额

@property (nonatomic, strong) CLLocation *location;

//装列表的数组
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSMutableArray *A;
@property (nonatomic, strong) NSMutableArray *B;
@property (nonatomic, strong) NSMutableArray *zhuangID;



- (IBAction)collectBtnAction:(UIButton *)sender;
- (IBAction)daoHangAction:(id)sender;
- (IBAction)yuYueAction:(id)sender;

@end

@implementation ChargeDetailViewController

#pragma mark - 百度地图位置更新代理方法

-(NSMutableArray *)array{
    if(!_array){
        _array = [NSMutableArray array];
    }
    return _array;
}

-(NSMutableArray *)A{
    if(!_A){
        _A = [NSMutableArray array];
    }
    return _A;
}

-(NSMutableArray *)B{
    if(!_B){
        _B = [NSMutableArray array];
    }
    return _B;
}

-(NSMutableArray *)zhuangID{
    if(!_zhuangID){
        _zhuangID = [NSMutableArray array];
    }
    return _zhuangID;
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    MYLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    if (self.isUpdateLocation == 1) {
       //更新保存经纬度
        [Config saveCurrentLocation:userLocation];
        self.isUpdateLocation =0;
    }
    [_locService stopUserLocationService];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //初始化状态
    self.isUpdateLocation = 1;//加载1次位置更新的置位
    //初始化百度地图定位
    _locService = [[BMKLocationService alloc] init];
    _locService.delegate = self;
    //启动locationService
    [_locService startUserLocationService];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backClick)];
//    [self.backView addGestureRecognizer:tap];
    [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    //加载桩列表数据
    [self loadZhuangWeiNumber];
    //按钮框
    [self creatDetailBtnKuang];
    
    //加载数据
    [self initData];
}

#pragma mark - action
-(void)jiSuanDistance
{
    BMKMapPoint point1 = BMKMapPointForCoordinate([Config getCurrentLocation]);
    BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(self.endLatitude,self.endLongitude));
    CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
    
    _distanceStr = [NSString stringWithFormat:@"%.1fkm",distance/1000];
    [_dict setObject:self.distanceStr forKey:@"distance"];//距离
    
}
#pragma arguments  加载桩位个数数据
-(void)loadZhuangWeiNumber{
    
    if (self.id == nil) {
        return ;
    }
    NSDictionary *parames = @{
                              @"stationId" : self.id
                              };
    [WMNetWork get:Chargenumber parameters:parames success:^(id responseObj) {
        NSLog(@"responseObj:%@",responseObj);
        self.array = [NSMutableArray arrayWithObject:responseObj[@"piles"]][0];
//        for (int i = 0; i < self.array.count; i++) {
//            NSArray *arr = self.array[i];
            for (NSDictionary *dict in self.array) {
                NSMutableArray *arr1 = [NSMutableArray arrayWithObject:dict[@"cdqList"]][0];
                NSMutableArray *arr2 = [NSMutableArray arrayWithObject:dict[@"cdzCode"]][0];
                [self.zhuangID addObject:arr2];
//                for (NSArray *array3 in arr1) {
                
                        ChargeNumberModel1 *model1 = [ChargeNumberModel1 objectWithKeyValues:arr1[0]];
                        [self.A addObject:model1];
                    
                        ChargeNumberModel2 *model2 = [ChargeNumberModel2 objectWithKeyValues:arr1[1]];
                        [self.B addObject:model2];                    
                }
//            }
//        }
//        NSArray *array = self.array[0];
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - 初始化    点击地图上的电桩浮标，然后显示出来的充电桩详情界面
-(void)initData
{
    MYLog(@"查询充电站详情成功");
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    
    NSMutableDictionary *parames1 = [NSMutableDictionary dictionary];
    parames1[@"stationId"] = self.id;
//    parames1[@"currTime"] = currentDate;
    parames1[@"userId"] = [Config getOwnID];
    MYLog(@"selfid = %@",self.id);
    
    MYLog(@"getOwnID = %@",[Config getOwnID]);
    MYLog(@"parames1 = %@",parames1);

    [MBProgressHUD showMessage:@"" toView:self.view];
    //查询充电站详情
    [WMNetWork get:CheckStationDetail parameters:parames1 success:^(id responseObj) {
     //   MYLog(@"responseObj查询充电站详情 = %@",responseObj);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
       // MYLog(@"responseObj = %@",responseObj[@"result"]);
        if ([responseObj[@"status"] intValue] == 0) {
            MYLog(@"查询充电站详情成功");
            //如果提示框有创建就透明
            if (self.tipview) {
                self.tipview.alpha = 0;
            }
//            {
//                result =     {
//                    acCount = 0;
//                    address = "\U5e7f\U4e1c\U7701\U5e7f\U5dde\U5e02\U5927\U677e\U5c97\U505c\U8f66\U573a";
//                    dcCount = 27;
//                    isCollected = 0;
//                    latitude = "23.280026";
//                    longitude = "113.246371";
//                    name = "\U767d\U4e91\U6c5f\U9ad8\U7ad9";
//                    stationId = 7de026ea82e54d7f93dd28bfeebaec03;
//                };
//                status = 0;
//            }

            
            _ChargeDetal = [ChargeDetalMes objectWithKeyValues:responseObj[@"result"]];
            //充电站经纬度
            self.endLatitude = [_ChargeDetal.latitude doubleValue];
            self.endLongitude = [_ChargeDetal.longitude doubleValue];
        
//            NSMutableArray *array = [PilesModel objectArrayWithKeyValuesArray:_ChargeDetal.piles];
            //初始化数组
//            self.dataArray = [NSMutableArray arrayWithArray:array];
            //桩位数据字典
            _cheWeiDict = [NSMutableDictionary dictionary];
//            [_cheWeiDict setObject:_ChargeDetal.fastCount forKey:@"fastCount"];//快充
//            [_cheWeiDict setObject:_ChargeDetal.slowCount forKey:@"slowCount"];//慢充
//
            //初始化字典
            _dict = [NSMutableDictionary dictionary];
            [_dict setObject:_ChargeDetal.name forKey:@"name"];//充电站点名字
            [_dict setObject:_ChargeDetal.address forKey:@"address"];//充电站点地址
            [_dict setObject:_ChargeDetal.latitude forKey:@"latitude"];//站点经度
            [_dict setObject:_ChargeDetal.longitude forKey:@"longitude"];//站点纬度
//            [_dict setObject:_ChargeDetal.chargingId forKey:@"chargingId"];//计费规则id
//            [_dict setObject:_ChargeDetal.fastCount forKey:@"fastCount"];//快充
//            [_dict setObject:_ChargeDetal.slowCount forKey:@"slowCount"];//慢充
            [_dict setObject:_ChargeDetal.dcCount forKey:@"dcCount"];//zhi充
            [_dict setObject:_ChargeDetal.acCount forKey:@"acCount"];//jiao充
            [_dict setObject:_ChargeDetal.stationId forKey:@"id"];//站点id
        /*-----------------------------------------------*/
         
//            if(_ChargeDetal.piles == NULL){
//                 MYLog(@"_ChargeDetal 的值为NULL = %@",_ChargeDetal.all_chargingSub);
//            }else{
//                self.all_chargingSub = [NSMutableArray arrayWithArray:_ChargeDetal.piles];
//                MYLog(@"all_chargingSub:%@",_ChargeDetal.all_chargingSub);
//            }
        /*-----------------------------------------------*/
            
//            if (_ChargeDetal.chargingSub == NULL) {
//                MYLog(@"_ChargeDetal 的值为NULL = %@",_ChargeDetal.chargingSub);
//            }else
//            {
//                [_dict setObject:_ChargeDetal.chargingSub.chargeCost forKey:@"chargeCost"];//电费价格
//                [_dict setObject:_ChargeDetal.chargingSub.discountRate forKey:@"discountRate"];//折扣率
//                [_dict setObject:_ChargeDetal.chargingSub.emptyCost forKey:@"emptyCost"];//预约费
//                [_dict setObject:_ChargeDetal.chargingSub.endTime forKey:@"endTime"];//结束时间
//                [_dict setObject:_ChargeDetal.chargingSub.parkingCharge forKey:@"parkingCharge"];//停车费
//                [_dict setObject:_ChargeDetal.chargingSub.serviceCost forKey:@"serviceCost"];//服务费
//                [_dict setObject:_ChargeDetal.chargingSub.startTime forKey:@"startTime"];//起始时间
//
//                self.dataDict = _dict;
//            }
             self.dataDict = _dict;
            //计算距离
            [self jiSuanDistance];
            //创建子控制器
            [self creatSubVC];
            //判断是否收藏
            if ([_ChargeDetal.isCollected isEqualToString:@"0"]) {
                _collectBtn.selected = NO;
            }else if ([_ChargeDetal.isCollected isEqualToString:@"1"])
            {
                _collectBtn.selected = YES;
            }
        }
    }failure:^(NSError *error) {
        MYLog(@"%@",error);
        MYLog(@"dict = %@, self.dataArray = %@",self.dataDict,self.dataArray);
        if (error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //创建子控制器
            [self creatSubVC];
            
            UIImage *image = [UIImage imageNamed:@"NoneNetwork@2x.png"];
            NSString *str = @"您好，请检查网络";
            
            self.tipview  = [[TipView alloc] initWithFrame:CGRectZero image:image andshowText:str];
            self.tipview.alpha = 1;
            [self.tipview SetCenterMasonry];
            [self.subView addSubview:self.tipview];
            
            [self.tipview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.subView);
            }];
        }
    }];
}

-(void)creatSubVC
{
    //桩位控制器
    ZhuangWeiMesViewController *ZhuangWeiMesVC = [[ZhuangWeiMesViewController alloc] init];
    ZhuangWeiMesVC.chargeNumber = self.array;//桩位控制器数据
    ZhuangWeiMesVC.zhuangA = self.A;
    ZhuangWeiMesVC.zhzuangB = self.B;
    ZhuangWeiMesVC.zhuangID = self.zhuangID;
  //  ZhuangWeiMesVC.dict = self.cheWeiDict;//桩的数量字典
    
    ZhuangWeiMesVC.view.frame = self.subView.frame;
    [self addChildViewController:ZhuangWeiMesVC];
    [self.subView addSubview:ZhuangWeiMesVC.view];
    
    [ZhuangWeiMesVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.subView);
    }];
    
    //详情控制器
    DetailZhuangWeiViewController *DetailZhuangWeiVC = [[DetailZhuangWeiViewController alloc]init];
    DetailZhuangWeiVC.id = self.id;
//    DetailZhuangWeiVC.all_chargingSub = _all_chargingSub;
    DetailZhuangWeiVC.chargeDeatlModel = self.dataDict;//详情控制器数据
    DetailZhuangWeiVC.view.frame = self.subView.frame;
    [self addChildViewController:DetailZhuangWeiVC];
}

-(void)creatDetailBtnKuang
{
    view1 = [[UIView alloc] initWithFrame:CGRectMake(15, 7, XYScreenWidth/2-30, 30)];
    view1.backgroundColor = [UIColor whiteColor];
    view1.layer.cornerRadius = 6;
    view1.layer.masksToBounds = YES;
    [self.bgView addSubview:view1];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0,0, XYScreenWidth/2,44)];
    lab.text = @"桩位";
    lab.font = [UIFont systemFontOfSize:16];
    lab.textColor = [UIColor blackColor];
    lab.userInteractionEnabled = YES;
    lab.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:lab];
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(XYScreenWidth/2,0, XYScreenWidth/2,44)];
    lab1.text = @"详情";
    lab1.userInteractionEnabled = YES;
    lab1.font = [UIFont systemFontOfSize:16];
    lab1.textColor = [UIColor blackColor];
    lab1.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:lab1];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailAction)];
    [lab addGestureRecognizer:tap];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cheWeiAction)];
    [lab1 addGestureRecognizer:tap1];
}

#pragma mark - action

-(void)backClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)collectBtnAction:(UIButton *)sender {
    MYLog(@"点击了收藏");
    
    if (![Config getOwnID]) {
     [MBProgressHUD show:@"请先登录再收藏" icon:nil view:self.view];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [Config getOwnID];
    params[@"stationId"] = self.id;
    NSString *alertString = nil;
    if (sender.selected) {

        alertString = @"取消收藏";
        //上传收藏状态
        [WMNetWork post:CancelCollect parameters:params success:^(id responseObj) {
            
            if ([responseObj[@"status"] intValue] == 0) {
                [MBProgressHUD showError:alertString];
            }else if ([responseObj[@"status"] intValue] == -1)
            {
            [MBProgressHUD showSuccess:responseObj[@"message"]];
                [MBProgressHUD showError:alertString];
            }
            
        } failure:^(NSError *error) {
            MYLog(@"error = %@",error);
            [MBProgressHUD show:@"网络连接超时" icon:nil view:self.view];
        }];

        _collectBtn.selected = NO;
    } else {
          alertString = @"收藏成功";
        //上传收藏状态
        [WMNetWork post:Collect parameters:params success:^(id responseObj) {

            if ([responseObj[@"status"] intValue] == 0) {
                [MBProgressHUD showSuccess:responseObj[@"message"]];
            }else if ([responseObj[@"status"] intValue] == -1)
            {
                [MBProgressHUD showError:responseObj[@"message"]];
            }
            
        } failure:^(NSError *error) {
            MYLog(@"error = %@",error);
            [MBProgressHUD show:@"网络连接超时" icon:nil view:self.view];
        }];
        _collectBtn.selected = YES;
    }
}


//导航按钮的点击事件
- (IBAction)daoHangAction:(id)sender {

    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"您将导航至：%@",_ChargeDetal.address]message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        //百度坐标转高德坐标
        CLLocation *desLocation = [[CLLocation alloc] initWithLatitude:self.endLatitude longitude:self.endLongitude];
        CLLocationCoordinate2D desCoordinate =  [desLocation locationMarsFromBaidu].coordinate;
    
        UIAlertAction *GaoDeAction = [UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //苹果导航
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        //目的地的位置
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:desCoordinate addressDictionary:nil]];
        toLocation.name = _ChargeDetal.address;
        
        NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
        //打开苹果自身地图应用，并呈现特定的item
        [MKMapItem openMapsWithItems:@[currentLocation,toLocation] launchOptions:options];
    }];

    UIAlertAction *BaiDulAction = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //百度地图
         if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:终点&mode=driving",[Config getCurrentLocation].latitude , [Config getCurrentLocation].longitude,_endLatitude,_endLongitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
             [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
         }else
         {
           [MBProgressHUD showError:@"您还没有安装百度地图APP"];
         }
    }];
    
    UIAlertAction *gaoDeAction = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //高德地图
        CLLocation *desLocation = [[CLLocation alloc] initWithLatitude:self.endLatitude longitude:self.endLongitude];
        CLLocationCoordinate2D desCoordinate =  [desLocation locationMarsFromBaidu].coordinate;
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
    
           NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"导航功能",@"nav123456",desCoordinate.latitude,desCoordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
        }else
        {
            [MBProgressHUD showError:@"您还没有安装高德地图APP"];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];

    [alertVc addAction:GaoDeAction];
    [alertVc addAction:BaiDulAction];
    [alertVc addAction:gaoDeAction];
    [alertVc addAction:cancelAction];

    [self presentViewController:alertVc animated:YES completion:nil];
}

- (void)cheWeiAction{
    
    [UIView animateWithDuration:0.5 // 动画时长
                          delay:0.0 // 动画延迟
         usingSpringWithDamping:0.5// 类似弹簧振动效果 0~1
          initialSpringVelocity:2.0 // 初始速度
                        options:UIViewAnimationOptionCurveEaseIn // 动画过渡效果
                     animations:^{
                         view1.frame =CGRectMake(XYScreenWidth/2+15, 7, XYScreenWidth/2 -30, 30);
                     } completion:^(BOOL finished) {
                     }];
    ZhuangWeiMesViewController *ZhuangWeiVC = self.childViewControllers[0];
    DetailZhuangWeiViewController *DetailVC = self.childViewControllers[1];

    [ZhuangWeiVC.view removeFromSuperview];
    [self.view addSubview:DetailVC.view];
    
    [DetailVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.subView);
    }];
    //如过待加载的数据为null，则显示网络错误
    if (self.dict.count == 0 && self.dataArray.count == 0) {
        UIImage *image = [UIImage imageNamed:@"NoneNetwork@2x.png"];
        NSString *str = @"您好，请检查网络";
        
        self.tipview  = [[TipView alloc] initWithFrame:CGRectZero image:image andshowText:str];
        self.tipview.alpha = 1;
        [self.tipview SetCenterMasonry];
        [DetailVC.view addSubview:self.tipview];
        
        [self.tipview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(DetailVC.view);
        }];
    }
}

- (void)detailAction {
    
    [UIView animateWithDuration:0.5 // 动画时长
                          delay:0.0 // 动画延迟
         usingSpringWithDamping:0.5// 类似弹簧振动效果 0~1
          initialSpringVelocity:2.0 // 初始速度
                        options:UIViewAnimationOptionCurveEaseIn // 动画过渡效果
                     animations:^{
                         view1.frame = CGRectMake(15, 7, XYScreenWidth/2-30, 30);
                     } completion:^(BOOL finished) {
                     }];
    DetailZhuangWeiViewController *DetailVC = self.childViewControllers[0];
    ZhuangWeiMesViewController *ZhuangWeiVC = self.childViewControllers[1];
    
    [ZhuangWeiVC.view removeFromSuperview];
    [self.view addSubview:DetailVC.view];
    
    [DetailVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.subView);
    }];

    //如过待加载的数据为null，则显示网络错误
    if (self.dict.count == 0 && self.dataArray.count == 0) {
        UIImage *image = [UIImage imageNamed:@"NoneNetwork@2x.png"];
        NSString *str = @"您好，请检查网络";
        self.tipview  = [[TipView alloc] initWithFrame:CGRectZero image:image andshowText:str];
        self.tipview.alpha = 1;
        [self.tipview SetCenterMasonry];
        [DetailVC.view addSubview:self.tipview];
        
        [self.tipview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(DetailVC.view);
        }];
    }
}


//预约按钮的点击事件
- (IBAction)yuYueAction:(id)sender {
    //查询用户是否余额
    NSMutableDictionary *paramers = [NSMutableDictionary dictionary];
    paramers[@"userId"] = [Config getOwnID];
    [MBProgressHUD showMessage:@"" toView:self.view];
    [WMNetWork post:GetBalance parameters:paramers success:^(id responseObj) {
        [MBProgressHUD hideHUDForView:self.view];
        MYLog(@"responseObj = %@",responseObj);
        self.balance = responseObj[@"balance"];
        if ([self.balance floatValue]<=0) {
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"余额不足，请充值！" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
 /*-----------建议：点击确定之后，执行充值操作-------------------------*/
                
            }];
  
            [alertVc addAction:sureAction];
            //    调用self的方法展现控制器
            [self presentViewController:alertVc animated:YES completion:nil];

        }else
        {
            MYLog(@"有余额");
            //判断是否又桩可以预约
            if ([[_cheWeiDict objectForKey:@"fastCount"] isEqualToString:@"0"] && [[_cheWeiDict objectForKey:@"slowCount"] isEqualToString:@"0"]) {
                [MBProgressHUD showError:@"暂无可预约桩"];
            }else
            {
                //判断是否登陆先
                if ([Config getOwnID]) {
                    _j = 0;
                    //遍历数据数组获取空闲的充电桩
                    for (int i = 0; i<self.dataArray.count; i++) {
                        PilesModel *pileMes =  self.dataArray[i];
                        if ([pileMes.status isEqualToString:@"1"]) {
                            _j++;
                        }
                    }
                    //空闲桩为0,不能预约
                    if (_j == 0) {
                        [MBProgressHUD showError:@"暂无可预约桩"];
                        return;
                    }
                    //查看预约信息
                    NSMutableDictionary *paramers = [NSMutableDictionary dictionary];
                    paramers[@"mobile"] = [Config getMobile];
                    MYLog(@"getMobile = %@",[Config getMobile]);
                    
                    [MBProgressHUD showMessage:@"" toView:self.view];
                    [WMNetWork post:ReservationInfoCharge parameters:paramers success:^(id responseObj) {
                        
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        MYLog(@"chaxunyuyueresponseObj = %@",responseObj);
                        if ([responseObj[@"status"] intValue] == 0) {
                            //检测是否预约
                            [MBProgressHUD showError:@"您已经预约"];
                            return;
                        }
                        if ([responseObj[@"status"] intValue] == -1) {
                            //经过判断是否有余额，是否登录，是否有可以预约的电桩判断之后，然后就跳转到预约选择界面
                            YuYueViewController *YuYueVC = [[YuYueViewController alloc] init];
                            YuYueVC.zhiLiuFreeCount  =   [_cheWeiDict objectForKey:@"fastCount"];
                            YuYueVC.jiaoLiuFreeCount = [_cheWeiDict objectForKey:@"slowCount"];
                            YuYueVC.chargeID = self.id;
                            YuYueVC.freeCharge = [NSString stringWithFormat:@"%ld",(long)_j];
                            YuYueVC.yuYueCost = [self.dataDict objectForKey:@"emptyCost"];
                            [self presentViewController:YuYueVC animated:YES completion:nil];
                        }
                    } failure:^(NSError *error) {
                        MYLog(@"%@",error);
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    }];
                }else
                {
                    [self loginShow];//登陆界面
                }
            }
        }
    } failure:^(NSError *error) {
        MYLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view];
        if (error) {
            [MBProgressHUD showError:@"网络连接失败"];
        }
    }];
}

- (void)loginShow//展示登陆界面
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] init];
    [nav addChildViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
}
- (IBAction)backBtn:(UIButton *)sender {
}
@end
