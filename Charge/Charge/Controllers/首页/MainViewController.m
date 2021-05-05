//
//  MainViewController.m
//  Charge
//
//  Created by olive on 16/6/3.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.

#import <BMKLocationKit/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入搜索功能头文件

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import "MainViewController.h"
#import "PersonMessageViewController.h"
#import "MyWalletViewController.h"
#import "MyReservationViewController.h"
#import "MyCollectViewController.h"
#import "SettingViewController.h"
#import "UIView+Extension.h"
#import "RecommendedViewController.h"
#import "QRCodeReaderViewController.h"
#import "MessageCentreViewController.h"
#import "ScoreViewController.h"
#import "LoginViewController.h"
#import "YBMonitorNetWorkState.h"
#import "QRCodeReader.h"
#import "XFunction.h"
#import "MBProgressHUD+MJ.h"
#import "AdvertisementView.h"
#import "MBProgressHUD.h"
#import "ChargeingViewController.h"
#import "OpenChangeViewController.h"
#import "ChargeingsViewController.h"
#import "ChargeDetailViewController.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import "JSONKit.h"
#import "JuDianChargeModel.h"
#import "Masonry.h"
#import "Config.h"
#import "XStringUtil.h"
#import "PersonSlideView.h"
#import "Masonry.h"
#import "WMNetWork.h"
#import "MainNavView.h"
#import "ChargingMessageModel.h"
#import "API.h"
#import "Singleton.h"
#import "ChargeDetalMes.h"
#import "PilesModel.h"
#import "ChargingSubModel.h"
#import "ChargeingsViewController.h"
#import "ChangePayViewController.h"
#import "ChargePointMesModel.h"
#import "QiPaoBMKPointAnnotation.h"
#import "KeFuViewController.h"
#import "CLLocation+YCLocation.h"
#import "JuDianQiPaoBMKAnnotation.h"
#import "AlertLoginView.h"
#import <ImageIO/ImageIO.h>
/*-----------罗小友-------------*/
#import "MeViewController.h"
#import "ScreeningViewController.h"
#import "ChooseView.h"
#import "ChargeDetailViewController.h"
#import "HomeActivitModel.h"
#import "HomeActivityController.h"

#define leftWidth (230)

@interface MainViewController ()<QRCodeReaderDelegate,CLLocationManagerDelegate,PersonSlideViewDelegate,UIGestureRecognizerDelegate,BMKGeoCodeSearchDelegate,UIScrollViewDelegate,BMKMapViewDelegate,BMKLocationAuthDelegate,BMKLocationManagerDelegate>
{
    UIButton *bgBtn;
    UIView *chargeingView;//充电状态view
    QRCodeReaderViewController *readerVc;//扫码
    UIButton *BgView;//黑色背景
    ChargeingViewController *chargeVC;//充电控制器
    
    int mySeconds;//充电总秒数
    
    AdvertisementView *adverView;
    UIView *coverView;//广告页遮盖
}

@property (strong, nonatomic) IBOutlet UIView *bgMapvView;

@property (strong, nonatomic) IBOutlet UILabel *saoMaLab;

@property (strong, nonatomic) IBOutlet UIView *saoMaChargeView; //扫码充电按钮view
@property (strong, nonatomic) IBOutlet UIImageView *refreshImageView;
//刷新imageView
@property (strong, nonatomic) BMKMapView *mapview;  //地图
@property (strong, nonatomic) BMKUserLocation *userLocation;  //定位



@property (strong, nonatomic) BMKLocationManager *locService;  //定位
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) QiPaoBMKPointAnnotation *qiPao;//气泡标注点
@property (strong, nonatomic) JuDianQiPaoBMKAnnotation *JuDianQiPao;//聚电气泡标注点

@property (strong, nonatomic) PersonSlideView *leftView;
@property (assign, nonatomic) NSTimeInterval *intervatTime;//时间差
@property (nonatomic, strong) ChargeDetalMes  *ChargeDetal;

@property (nonatomic, strong) BMKGeoCodeSearch *searcher;//初始化检索对象

@property (nonatomic, copy) NSString *locationCitys;//当前定位城市

@property (nonatomic) double LocationLatitude;//当前位置纬度
@property (nonatomic) double LocationLongitude;//当前位置经度

@property (nonatomic, strong) NSMutableArray *qiPaoArray;//添加的气泡数组
@property (nonatomic, strong) NSMutableArray *JuDianqiPaoArray;//添加的聚点桩气泡数组

@property (nonatomic, strong) NSMutableArray *chargingMess;//友桩充电桩数组
@property (nonatomic, strong) NSMutableArray *juDianChargingMess;//聚电桩数组
@property (nonatomic, strong) NSMutableArray *totalChargeArray;//总充电转数组
@property (strong, nonatomic) IBOutlet UIButton *refreshBtnPro;//刷新按钮属性

@property (nonatomic, strong) UIView *screen;


@property (nonatomic, strong)UIView *bannerBack;//轮播图的背景图
@property (nonatomic, strong)UIView *backView;//大的背景
@property (nonatomic, strong)NSMutableArray *bannerArray;//保存轮播图信息的数组
@property (nonatomic, strong)UIScrollView *scroll;//banner图
@property (nonatomic, strong)NSTimer *timer;//定时器
@property (nonatomic, strong)UIPageControl *pageControl;//分页器

- (IBAction)locationActionClick:(id)sender;
- (IBAction)PersonActionClick:(id)sender;
- (IBAction)MessageActionClick:(id)sender;
- (IBAction)refreshBtnAction:(id)sender;//界面气泡点刷新
- (IBAction)keFuBtnAction:(id)sender;//wode 按钮
- (IBAction)btnClick:(id)sender;


@end

@implementation MainViewController

-(NSMutableArray *)bannerArray{
    if(!_bannerArray){
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];//移除通知
}

//生命周期
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
     self.navigationController.navigationBarHidden = YES;
    //开启系统自带的侧滑
     self.navigationController.interactivePopGestureRecognizer.enabled = YES;
     self.navigationController.interactivePopGestureRecognizer.delegate = self;
    _mapview.delegate = self;
    _locService.delegate = self;
    [_mapview viewWillAppear];
    //检测定位
    [self checkDingWei];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [_mapview viewWillDisappear];
}



#pragma mark -- 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    //请求数据
    [self addActivtDataSource];
    //初始化
    self.qiPaoArray = [NSMutableArray array];
    self.JuDianqiPaoArray = [NSMutableArray array];
    self.totalChargeArray = [NSMutableArray array];
   
    //  [self.navigationController addChildViewController:screen];
    //  Do any additional setup after loading the view from its nib.
    //  初始化地图
    [self initMapView];
    //初始化子控制器
    [self initSubVC];
    //创建导航栏
    [self creatNav];
    //检测上次充电状态
    [self checkChargeing];
    //加载聚电桩数据
    //[self addJuDianCharge];
    //加载地图标注点
    [self addChargeAnnotation];
    //加载通知事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LeftViewPutUp) name:LeaveOutNoti object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChargeingMessageAction) name:ChargeingMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EndChargeingMessageAction) name:EndChargeingMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkChargeing) name:CheckChargingNotis object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(YiChangJieSuan:) name:JiTingChargeNot object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(YiChangJieSuan:) name:UNenoughChargeNot object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addChooseView) name:AddChooseView object:nil];
}








-(void)initMapView
{
//    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:BaiDuMap_appkey authDelegate:self];
    
    
    _mapview = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, XYScreenWidth, XYScreenHeight)];
//    _mapview.delegate = self;
    _mapview.userTrackingMode = BMKUserTrackingModeNone;
    _mapview.mapType = BMKMapTypeStandard;
    _mapview.showsUserLocation = YES;
    _mapview.zoomLevel = 12;//shezhi ditu suofang
//
//    _mapview.zoomEnabled = YES;
//    _mapview.showMapScaleBar=YES;
    
//    _mapview.minZoomLevel = 0;
    [self.bgMapvView addSubview:_mapview];
    
    BMKLocationViewDisplayParam* testParam = [[BMKLocationViewDisplayParam alloc] init];
    testParam.isRotateAngleValid = false;// 跟随态旋转角度是否生效
    testParam.isAccuracyCircleShow = false;// 精度圈是否显示
//    testParam.locationViewImgName = @"icon_compass";// 定位图标名称
//    testParam.locationViewOffsetX = 10;//定位图标偏移量(经度)
//    testParam.locationViewOffsetY = 0;// 定位图标偏移量(纬度)
    [_mapview updateLocationViewWithParam:testParam];
    
    
    //初始化实例
    _locService = [[BMKLocationManager alloc] init];
    //设置delegate
    _locService.delegate = self;
    //设置返回位置的坐标系类型
    _locService.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    //设置距离过滤参数
    _locService.distanceFilter = kCLDistanceFilterNone;
    //设置预期精度参数
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
    //设置应用位置类型
    _locService.activityType = CLActivityTypeAutomotiveNavigation;
    //设置是否自动停止位置更新
    _locService.pausesLocationUpdatesAutomatically = NO;
    //设置是否允许后台定位
//    _locService.allowsBackgroundLocationUpdates = YES;
    //设置位置获取超时时间
    _locService.locationTimeout = 10;
    //设置获取地址信息超时时间
    _locService.reGeocodeTimeout = 10;
    
    
    
    
  //  启动LocationService
    [_locService setLocatingWithReGeocode:YES];
    [_locService startUpdatingLocation];

   // 初始化检索对象
    _searcher = [[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
}







//
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView{
    
    NSLog(@"地图加载完成");
    
}

/**
*地图绘制出有效数据时调用此接口
*@param mapView 地图View
*@param error 错误码
*/
- (void)mapViewDidRenderValidData:(BMKMapView *)mapView withError:(NSError *)error{
    
    NSLog(@"地图加载失败：%@",error);
}

/**
*地图渲染完毕后会调用此接口
*@param mapView 地图View
*/
- (void)mapViewDidFinishRendering:(BMKMapView *)mapView{
    
    NSLog(@"地图渲染完成");
    
}


//
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didUpdateLocation:(BMKLocation * _Nullable)location orError:(NSError * _Nullable)error

{
    if (error)
    {
        NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
    } if (location) {//得到定位信息，添加annotation
            
                if (location.location) {
                    NSLog(@"LOC = %@",location.location);
                }
                if (location.rgcData) {
                    NSLog(@"rgc = %@",[location.rgcData description]);
                }
                
                if (location.rgcData.poiList) {
                    for (BMKLocationPoi * poi in location.rgcData.poiList) {
                        NSLog(@"poi = %@, %@, %f, %@, %@", poi.name, poi.addr, poi.relaiability, poi.tags, poi.uid);
                    }
                }
                
                if (location.rgcData.poiRegion) {
                    NSLog(@"poiregion = %@, %@, %@", location.rgcData.poiRegion.name, location.rgcData.poiRegion.tags, location.rgcData.poiRegion.directionDesc);
                }

            }
    if (!self.userLocation) {
    self.userLocation = [[BMKUserLocation alloc] init];
    }
    self.userLocation.location = location.location;
    
    BMKCoordinateRegion region;
    region.center.latitude  = location.location.coordinate.latitude ;
    region.center.longitude = location.location.coordinate.longitude;
    NSLog(@"didUpdateUserLocation lat %f,long %f",location.location.coordinate.latitude,location.location.coordinate.longitude);
  
    //将定位的点居中显示
    _mapview.showsUserLocation = YES;//显示定位图层
    _mapview.zoomLevel = 12;
    _mapview.region = region;
    //保存
    MYLog(@"当前的坐标是: %f,%f",location.location.coordinate.latitude,location.location.coordinate.longitude);
    self.LocationLatitude = location.location.coordinate.latitude;
    self.LocationLongitude = location.location.coordinate.longitude;
    NSLog(@"LocationLatitude = %f,LocationLongitude = %f",self.LocationLatitude,self.LocationLongitude);
    //保存当前地理位置
    [Config saveCurrentLocation:self.userLocation];
    
    //发起反向地理编码检索
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){self.LocationLatitude, self.LocationLongitude};
    BMKReverseGeoCodeSearchOption *reverseGeoCodeSearchOption = [[
                                                                  BMKReverseGeoCodeSearchOption alloc]init];
    reverseGeoCodeSearchOption.location = pt;
    BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {MYLog(@"反geo检索发送成功");}
    else
    {MYLog(@"反geo检索发送失败");}
    [_mapview updateLocationData:self.userLocation];
    [_locService stopUpdatingLocation];
    
}



//添加活动图片
-(void)addActivtView{
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XYScreenWidth, XYScreenHeight)];
    _backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
//    [[UIApplication sharedApplication].keyWindow addSubview:_backView];
    [self.view addSubview:_backView];
    
    
    _bannerBack = [[UIView alloc] initWithFrame:CGRectMake(30, (XYScreenHeight - XYScreenWidth + 60) / 2, XYScreenWidth - 60, XYScreenWidth - 60)];
    _bannerBack.backgroundColor = [UIColor whiteColor];
    _bannerBack.layer.masksToBounds = YES;
    _bannerBack.layer.cornerRadius = 6;
    [_backView addSubview:_bannerBack];
    
    
    _scroll = [[UIScrollView alloc] initWithFrame:_bannerBack.bounds];
    _scroll.pagingEnabled = YES;
    _scroll.delegate = self;
    [_bannerBack addSubview:_scroll];
   
    
    UIImageView *back = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"functionBtn"]];
    back.userInteractionEnabled = YES;
    back.layer.masksToBounds = YES;
    back.layer.borderColor = [UIColor grayColor].CGColor;
    back.layer.borderWidth = 1;
    back.layer.cornerRadius = 10;
    [_bannerBack addSubview:back];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bannerBack.mas_top).mas_offset(10);
        make.right.mas_equalTo(_bannerBack.mas_right).mas_offset(-10);
        make.size.mas_offset(CGSizeMake(20, 20));
    }];
    UITapGestureRecognizer *tapp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    [back addGestureRecognizer:tapp];
    
    
    //
    
    //创建 初始化
    _pageControl = [[UIPageControl alloc]init];
    //设置指示器默认显示的颜色
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    //设置当前选中的颜色
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    //设置当前默认显示位置
    _pageControl.currentPage = 0;
    //将pageControl添加到视图中
    [_bannerBack addSubview:_pageControl];
    //设置frame
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bannerBack).mas_offset((_bannerBack.frame.size.width - 150) / 2);
        make.bottom.mas_equalTo(_bannerBack.mas_bottom).mas_offset(-15);
        make.size.mas_equalTo(CGSizeMake(150, 20));
        make.right.mas_equalTo(_bannerBack).mas_offset(-(_bannerBack.frame.size.width - 150) / 2);
    }];
    
//    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
//    back.layer.masksToBounds = YES;
//    back.layer.cornerRadius = 20;
//    [_backView addSubview:back];
//    [back mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(_bannerBack.mas_top).mas_offset(0);
//        make.right.mas_equalTo(_bannerBack.mas_right).mas_offset(10);
//        make.size.mas_offset(CGSizeMake(40, 40));
//    }];
//    [back setImage:[UIImage imageNamed:@"functionBtn"] forState:UIControlStateNormal];
//    [back addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchDown];
    
}


#pragma mark - 地图标记点代理方法

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[QiPaoBMKPointAnnotation class]]) {
        NSString *AnnotationViewID = @"myAnnotation";
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
//            annotationView.annotation = annotation;
            annotationView.image = [UIImage imageNamed:@"qipaopoint.png"];
        }
        return annotationView;
        
    }else if ([annotation isKindOfClass:[JuDianQiPaoBMKAnnotation class]])
    {
        NSString *AnnotationViewID = @"judianAnnotation";
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
//            annotationView.annotation = annotation;
            annotationView.image = [UIImage imageNamed:@"judianqipao@2x.png"];
        }
        return annotationView;
    }else
    {
        return nil;
    }
    return nil;
}






//请求活动数据
-(void)addActivtDataSource{
    [WMNetWork get:ChargeHomeBannerList parameters:nil success:^(id responseObj) {
        //加载完数据检测是否有上次充电的状态
        NSLog(@"0---%@",[NSThread currentThread]);  /////
        NSString *status = responseObj[@"status"];
        NSLog(@"-------%ld",status.integerValue);
        if(status.integerValue == 0){
            //添加活动view
            [self addActivtView];
            
            NSArray *dataArray = responseObj[@"data"];
            for (int i = 0; i < dataArray.count; i++) {
                HomeActivitModel *model = [HomeActivitModel yy_modelWithDictionary:dataArray[i]];
                [self.bannerArray addObject:model];
            }
            
            //
            _scroll.contentSize = CGSizeMake(self.bannerBack.frame.size.width * self.bannerArray.count, self.bannerBack.frame.size.height);
            //设置点的个数
            _pageControl.numberOfPages = self.bannerArray.count;
            
            for (int i = 0; i < self.bannerArray.count; i++) {
                [_scroll addSubview:[self addSubViewToBannerWithModel:self.bannerArray[i] withFrame:CGRectMake(self.bannerBack.frame.size.width * i,0, self.bannerBack.frame.size.width, self.bannerBack.frame.size.height) withTag:(i + 1)]];
            }
            //启动定时器
            [self initTimerFunction];
        }else{
              NSLog(@"暂无活动-------status：%ld",status.integerValue);
        }
        
        
    
       
    }failure:^(NSError *error) {
        MYLog(@"%@",error);
    }];
}


-(UIView *)addSubViewToBannerWithModel:(HomeActivitModel *)model withFrame:(CGRect)frame withTag:(int)tag{
    UIView *views = [[UIView alloc] initWithFrame:frame];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d",tag]]];
    image.frame =  views.bounds;
    [views addSubview:image];
    
    //
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, views.frame.size.width, 44)];
    label1.text = model.name;
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:20];
    [views addSubview:label1];
    //
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(label1.frame),views.frame.size.width - 30, 88)];
    label2.text = model.desc;
    label2.numberOfLines = 0;
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:16];
    [views addSubview:label2];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 10;
    btn.tag = tag;
    btn.frame = CGRectMake((views.frame.size.width - 60) / 2, CGRectGetMaxY(label2.frame) + 60, 60, 45);
    [btn setTitle:@"了解详情" forState:UIControlStateNormal];
    [btn setTitleColor:RGB_COLOR(122, 193, 189, 1) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(gotoWebView:) forControlEvents:UIControlEventTouchDown];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [views addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(views.mas_bottom).mas_offset(-45);
        make.centerX.mas_equalTo(views.mas_centerX).mas_offset(0);
        make.size.mas_offset(CGSizeMake(90, 40));
    }];
    return views;
}




-(void)goBack{
    [_backView removeFromSuperview];
    [_bannerBack removeFromSuperview];
    [_timer invalidate];
    _timer = nil;
}


-(void)gotoWebView:(UIButton *)sender{
    NSLog(@"点击了第%ld个按钮",sender.tag);
    HomeActivityController *activity = [[HomeActivityController alloc] init];
    [self.navigationController pushViewController:activity animated:YES];
    HomeActivitModel *model = self.bannerArray[sender.tag -1];
    if(model.type.intValue == 4 && [Config getInviteCode] != nil){
            activity.url = [NSString stringWithFormat:@"%@%@",model.url,[Config getInviteCode] ];
    }else{
        activity.url = model.url;
    }
    activity.name = model.name;
    activity.des = model.desc;
    activity.icon = model.icon;

}

//添加定时器

-(void)initTimerFunction{
    //创建计时器
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(autoSelectPage) userInfo:nil repeats:YES];
    NSRunLoop *mainLoop = [NSRunLoop mainRunLoop];
    
    [mainLoop addTimer:timer forMode:NSRunLoopCommonModes];
    
    self.timer = timer;
}


-(void)autoSelectPage{
    //取出当前的偏移量
    CGPoint offset =  self.scroll.contentOffset;
    //取出当前的设置显示 的page指示
    NSInteger  currentPage = self.pageControl.currentPage;
    
    if (currentPage == (self.bannerArray.count - 1)) {
        //设置为初始值
        currentPage =0;
        offset = CGPointZero;
        //更新offset
        [self.scroll setContentOffset:offset animated:YES];
    }else{
        currentPage++;
        offset.x += self.bannerBack.bounds.size.width;
        //更新offset
        [self.scroll setContentOffset:offset animated:YES];
    }
    //更新pageControl显示
    self.pageControl.currentPage = currentPage;
    
}



#pragma mark  scrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //获取当前scrollview 的X轴方向的 偏移量
    CGFloat offset = self.scroll.contentOffset.x;
    //每个图片页面的宽度
    CGFloat pageWi =self.bannerBack.bounds.size.width;
    //设置当前的显示位置
    self.pageControl.currentPage = offset/pageWi;
}

//6、当手势滑动scrollview的时候停止定时器任务，滑动结束的时候开启定时任务
//当滑动开始的时候 ，停止计数器
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //取消定时器任务
    [self.timer invalidate];
}
//当滑动停止时启动定时器任务
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.timer fire];
    //设置自动滚动定时任务
    [self initTimerFunction];
}


////////////////////////////////////////////////////////////////////////////////

-(void)addJuDianCharge
{
   //[MBProgressHUD showMessage:@"" toView:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSString *urlString = JuDianCharge;
        // 一些特殊字符编码
        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *url = [NSURL URLWithString:urlString];
        // 2.创建请求 并：设置缓存策略为每次都从网络加载 超时时间10秒
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
        // 3.采用苹果提供的共享session
        NSURLSession *sharedSession = [NSURLSession sharedSession];
        // 4.由系统直接返回一个dataTask任务
        NSURLSessionDataTask *dataTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            // 网络请求完成之后就会执行，NSURLSession自动实现多线程
         //   NSLog(@"%@",[NSThread currentThread]);
            if (data && (error == nil)) {
                // 网络访问成功
                NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                //  NSLog(@"array = %@",array);
                
                if (_JuDianqiPaoArray.count>0) {
                    [_JuDianqiPaoArray removeAllObjects];
                }
    
                _juDianChargingMess = [JuDianChargeModel mj_objectArrayWithKeyValuesArray:array];
                for (JuDianChargeModel *judiancharPointMes in _juDianChargingMess) {
                    
                    //百度坐标转高德坐标
                    CLLocation *desLocation = [[CLLocation alloc] initWithLatitude:[judiancharPointMes.latitude doubleValue] longitude:[judiancharPointMes.longitude doubleValue]];
                    CLLocationCoordinate2D desCoordinate =  [desLocation locationBaiduFromMars].coordinate;
                    
                    _JuDianQiPao = [[JuDianQiPaoBMKAnnotation alloc] init];
                    _JuDianQiPao.coordinate = desCoordinate;//经纬度
                    _JuDianQiPao.title = judiancharPointMes.name;
                    _JuDianQiPao.LocationLatitude = [judiancharPointMes.latitude doubleValue];
                    _JuDianQiPao.LocationLongitude = [judiancharPointMes.longitude doubleValue];
                    _JuDianQiPao.address = judiancharPointMes.address;
                   // _qiPao.image = [UIImage imageNamed:@"judianqipao@2x.png"];
                    
                    [self.JuDianqiPaoArray addObject:_JuDianQiPao];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 更新界面
                   //    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    //如果全部充电电有数据就移除所有充电点
                    if (_totalChargeArray.count>0) {
                        [_mapview removeAnnotations:_totalChargeArray];
                        [_totalChargeArray removeAllObjects];
                    }
                    
                    [_totalChargeArray addObjectsFromArray:self.qiPaoArray];
                    [_totalChargeArray addObjectsFromArray:self.JuDianqiPaoArray];
                    [_mapview addAnnotations:_totalChargeArray];
                    [_mapview setZoomLevel:12];
                    [self.refreshImageView stopAnimating];
                    self.refreshBtnPro.userInteractionEnabled = YES;
                    
                    //NSLog(@"count = %lu",(unsigned long)_totalChargeArray.count);
                    //NSLog(@"totalArray = %@",_totalChargeArray);
                });
       
            } else {
                // 网络访问失败
                NSLog(@"error=%@",error);
              //  [MBProgressHUD hideHUDForView:self.view animated:YES];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.refreshImageView stopAnimating];
                    self.refreshBtnPro.userInteractionEnabled = YES;
                });
            }
        }];
        // 5.每一个任务默认都是挂起的，需要调用 resume 方法
        [dataTask resume];
        
    });
}

#pragma mark -- 基础设置

-(void)creatNav
{
    //初始化自定义nav
    MainNavView *navView = [[MainNavView alloc] initWithFrame:CGRectZero title:@"友桩" leftImgae:@"search@2x.png" rightImage:@"caidan@2x.png"];
    navView.leftBlock = ^{
        //周边推荐事件
        [self zhouBianTapAction];
    };
    navView.rightBlock = ^{
        //首页右边的按钮
        [self PersonActionClick:nil];
    };
    [self.view addSubview:navView];
    
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo([UIApplication sharedApplication].statusBarFrame.size.height + 44);
    }];
}


-(void)initSubVC
{
    BgView = [UIButton buttonWithType:UIButtonTypeCustom];
    BgView.frame =CGRectMake(0, 0, XYScreenWidth, XYScreenHeight);
    [BgView addTarget:self action:@selector(bgViewClick) forControlEvents:UIControlEventTouchUpInside];
    BgView.backgroundColor = [UIColor blackColor];
    BgView.alpha = 0;
    [self.view addSubview:BgView];
}

#pragma mark -- 地图代理方法  点击气泡
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
        MYLog(@"气泡点击了");
        [UIView animateWithDuration:0.5
                              delay:0.2
             usingSpringWithDamping:0.3
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             CGAffineTransform transform = CGAffineTransformMakeScale(1.2, 2.0);
                             view.transform = transform;
                             [UIView animateWithDuration:0.5
                                                   delay:0.0
                                  usingSpringWithDamping:0
                                   initialSpringVelocity:0
                                                 options:UIViewAnimationOptionCurveEaseInOut
                                              animations:^{
                                                  
                                                  CGAffineTransform transform = CGAffineTransformMakeScale(1.3, 1.3);
                                                  view.transform = transform;
                                                  
                                              } completion:^(BOOL finished) {
                                              }];
                         } completion:^(BOOL finished) {
                             
                            
                             for (QiPaoBMKPointAnnotation *pointAnnotation in self.qiPaoArray) {
                                 if (pointAnnotation == view.annotation) {
                            //跳转到桩位详情页
                                    ChargeDetailViewController *chargeVCc = [[ChargeDetailViewController alloc] init];
                                    chargeVCc.id = pointAnnotation.id;
                                    [self presentViewController:chargeVCc animated:YES completion:nil];
                                     //收起气泡
                                    [self.mapview deselectAnnotation:pointAnnotation animated:NO];
                                     CLLocationCoordinate2D newCLLocation = CLLocationCoordinate2DMake(pointAnnotation.LocationLatitude, pointAnnotation.LocationLongitude);
                                     [_mapview setCenterCoordinate:newCLLocation];
                                  //   [_mapview setCenterCoordinate:newCLLocation animated:YES];
                                 }
                             }
                             
                             for (QiPaoBMKPointAnnotation *pointAnnotation in self.JuDianqiPaoArray) {
                                 if (pointAnnotation == view.annotation) {
                                     
                                     //收起气泡
                                  //   [self.mapview deselectAnnotation:pointAnnotation animated:NO];
                                     //放置到地图中心
                                     CLLocationCoordinate2D newCLLocation = CLLocationCoordinate2DMake(pointAnnotation.LocationLatitude, pointAnnotation.LocationLongitude);
                                     [_mapview setCenterCoordinate:newCLLocation animated:YES];
                                     
                                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                         
                                         UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"您将导航至充电站：%@",pointAnnotation.address]message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                                         
                                         CLLocation *desLocation = [[CLLocation alloc] initWithLatitude:pointAnnotation.LocationLatitude longitude:pointAnnotation.LocationLongitude];
                                         CLLocationCoordinate2D desCoordinate =  desLocation.coordinate;
                                         
                                         //                                     UIAlertAction *yunYingShang = [UIAlertAction actionWithTitle:@"运营商：聚电" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                         //
                                         //                                     }];
                                         //                                     yunYingShang.enabled = NO;
                                         //                                     [yunYingShang setValue:[UIColor grayColor] forKey:@"titleTextColor"];
                                         
                                         
                                         UIAlertAction *GaoDeAction = [UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                             //收起气泡
                                             [self.mapview deselectAnnotation:pointAnnotation animated:NO];
                                             //苹果导航
                                             MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
                                             //目的地的位置
                                             MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:desCoordinate addressDictionary:nil]];
                                             NSLog(@"pointAnnotation.address = %@",pointAnnotation.address);
                                             toLocation.name = pointAnnotation.address;
                                             
                                             NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
                                             //打开苹果自身地图应用，并呈现特定的item
                                             [MKMapItem openMapsWithItems:@[currentLocation,toLocation] launchOptions:options];
                                         }];
                                         
                                         UIAlertAction *BaiDulAction = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                             
                                             //高德地图转百度地图
                                             CLLocation *desLocation = [[CLLocation alloc] initWithLatitude:pointAnnotation.LocationLatitude longitude:pointAnnotation.LocationLongitude];
                                             CLLocationCoordinate2D desCoordinate = [desLocation locationBaiduFromMars].coordinate;
                                             
                                             //收起气泡
                                             [self.mapview deselectAnnotation:pointAnnotation animated:NO];
                                             //百度地图
                                             if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
                                                 
                                                NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:终点&mode=driving",[Config getCurrentLocation].latitude , [Config getCurrentLocation].longitude, desCoordinate.latitude,  desCoordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
                                                 [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
                                             }else
                                             {
                                                 [MBProgressHUD showError:@"您还没有安装百度地图APP"];
                                             }
                                             
                                         }];
                                         
                                         UIAlertAction *gaoDeAction = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                             
                                             //收起气泡
                                             [self.mapview deselectAnnotation:pointAnnotation animated:NO];
                                             //高德地图
                                             CLLocation *desLocation = [[CLLocation alloc] initWithLatitude:pointAnnotation.LocationLatitude longitude:pointAnnotation.LocationLongitude];
                                             CLLocationCoordinate2D desCoordinate =  desLocation.coordinate;
                                             if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
                                                 
                                                 NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"导航功能",@"nav123456",desCoordinate.latitude,desCoordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                                 [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
                                             }else
                                             {
                                                 [MBProgressHUD showError:@"您还没有安装高德地图APP"];
                                             }
                                         }];
                                         UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                                             //收起气泡
                                             [self.mapview deselectAnnotation:pointAnnotation animated:NO];
                                         }];
                                         
                                         //                                     [alertVc addAction:yunYingShang];
                                         [alertVc addAction:GaoDeAction];
                                         [alertVc addAction:BaiDulAction];
                                         [alertVc addAction:gaoDeAction];
                                         [alertVc addAction:cancelAction];
                                         
                                         [self presentViewController:alertVc animated:YES completion:nil];
                                     });
                                     
                                 }
                             }
                             
                         }];
}

- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{
    
        [UIView animateWithDuration:0.1 animations:^{
            CGAffineTransform transform = CGAffineTransformMakeScale(1, 1);
            view.transform = transform;
        }];
}







//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    BMKCoordinateRegion region;
    region.center.latitude  = userLocation.location.coordinate.latitude ;
    region.center.longitude = userLocation.location.coordinate.longitude;
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
  
    //将定位的点居中显示
    _mapview.showsUserLocation = YES;//显示定位图层
    _mapview.zoomLevel = 12;
    _mapview.region = region;
//    _mapview.limitMapRegion = region;
    //保存
    MYLog(@"当前的坐标是: %f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    self.LocationLatitude = userLocation.location.coordinate.latitude;
    self.LocationLongitude = userLocation.location.coordinate.longitude;
    NSLog(@"LocationLatitude = %f,LocationLongitude = %f",self.LocationLatitude,self.LocationLongitude);
    //保存当前地理位置
    [Config saveCurrentLocation:userLocation];
    
    //发起反向地理编码检索
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){self.LocationLatitude, self.LocationLongitude};
    BMKReverseGeoCodeSearchOption *reverseGeoCodeSearchOption = [[
                                                                  BMKReverseGeoCodeSearchOption alloc]init];
    reverseGeoCodeSearchOption.location = pt;
    BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {MYLog(@"反geo检索发送成功");}
    else
    {MYLog(@"反geo检索发送失败");}
    [_mapview updateLocationData:userLocation];
//    NSArray *zoomLevelArr = @[@"2000000"];
//    [_mapview showAnnotations:zoomLevelArr animated:YES];
    [_locService stopUpdatingLocation];
}



//百度检索的代理方法
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error{
   
    if (error == BMK_SEARCH_NO_ERROR) {
        _locationCitys = result.addressDetail.city;
    }
    else { MYLog(@"抱歉，未找到结果");}
}

// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    MYLog(@"paopaoclick");
}

#pragma mark -- Action

//地图添加充电站气泡点
-(void)addChargeAnnotation
{
       // [MBProgressHUD showMessage:@"" toView:self.view];
        NSMutableDictionary *parames = [NSMutableDictionary dictionary];
        //加载锚点
        [WMNetWork get:PaintingMap parameters:parames success:^(id responseObj) {
           // [MBProgressHUD hideHUDForView:self.view animated:YES];
            //MYLog(@"加载瞄点：responseObj = %@",responseObj);
            //加载完数据检测是否有上次充电的状态
        //     [MBProgressHUD hideHUDForView:self.view animated:YES];
         //    [self checkChargeing];
            
            if (self.qiPaoArray.count>0) {
                [self.qiPaoArray removeAllObjects];
            }
            
            if([responseObj[@"status"] intValue] == 0) {
                MYLog(@"加载锚点成功");
              _chargingMess = [ChargePointMesModel mj_objectArrayWithKeyValuesArray:[responseObj objectForKey:@"result"]];
                
                    for (ChargePointMesModel *charPointMes in _chargingMess) {
                        _qiPao = [[QiPaoBMKPointAnnotation alloc] init];
                        _qiPao.coordinate = CLLocationCoordinate2DMake([charPointMes.latitude doubleValue], [charPointMes.longitude doubleValue]);
                        _qiPao.title = charPointMes.side_name;
                        _qiPao.id = charPointMes.id;
                        _qiPao.LocationLatitude = [charPointMes.latitude doubleValue];
                        _qiPao.LocationLongitude = [charPointMes.longitude doubleValue];
                       // _JuDianQiPao.image = [UIImage imageNamed:@"qipaopoint.png"];
                        [self.qiPaoArray addObject:_qiPao];
                    }
                    [_mapview setZoomLevel:12];
                    [_mapview addAnnotations:self.qiPaoArray];
             //   NSLog(@"qiPaoArray = %@",self.qiPaoArray);
                      [self addJuDianCharge];
            }
            
            if ([responseObj[@"status"] intValue] == -1) {
             //   [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD show:@"数据加载失败" icon:nil view:self.view];
            }
            
        }failure:^(NSError *error) {
            MYLog(@"%@",error);
            if (error) {
              //  [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.refreshImageView stopAnimating];
                self.refreshBtnPro.userInteractionEnabled = YES;
                
             // [MBProgressHUD show:@"网络连接超时" icon:nil view:self.view];
            }
        }];
}

//检测上次充电状态
-(void)checkChargeing
{
    MYLog(@"检测充电状态");
    //如果用户登陆过就检查上次充电状态
    MYLog(@"检测充电状态getMobile = %@",[Config getMobile]);
    if([Config getOwnID] == nil){
        return ;
    }
    NSDictionary *par = @{
                          @"userId" : [Config getOwnID]
                          };
    [WMNetWork get:ChargeMessge parameters:par success:^(id responseObj) {
        if([responseObj[@"chargInfo"][@"endTime"] isEqualToString:@""]){
            NSLog(@"9---");
            
            
            NSString *electric = responseObj[@"chargInfo"][@"electric"];//已充电量
            NSString *elecMoney = responseObj[@"chargInfo"][@"elecMoney"];//电费
            NSString *serviceMoney = responseObj[@"chargInfo"][@"serviceMoney"];//服务费
            NSString *discountMoney = responseObj[@"chargInfo"][@"discountMoney"];//服务优惠价格
            NSString *spendMoney = responseObj[@"chargInfo"][@"spendMoney"];//总电费
            
            //已充电量
            [Config saveCurrentPower:[NSString stringWithFormat:@"%.2fkwh",electric.floatValue]];
            //保存电费
            [Config saveElecMoney:[NSString stringWithFormat:@"%.2f￥",elecMoney.floatValue]];
            //保存服务费
            [Config savesServiceMoney:[NSString stringWithFormat:@"%.2f￥",serviceMoney.floatValue]];
            //保存服务优惠价格
            [Config saveDiscountMoney:[NSString stringWithFormat:@"%.2f￥",discountMoney.floatValue]];
            //保存总电费
            [Config saveChargePay: [NSString stringWithFormat:@"%.2f￥",spendMoney.floatValue]];
            
            
            
            
            
            //获取手机号
                if ([Config getMobile]) {
                    MYLog(@"[Config getNormalEndChargingFlag] = %@",[Config getNormalEndChargingFlag]);

//            if ([[Config getNormalEndChargingFlag] isEqualToString:@"0"]) {
                
                [MBProgressHUD showMessage:@"加载上次未结束充电状态" toView:self.view];
                //参数
                NSMutableDictionary *paramers = [NSMutableDictionary dictionary];
                paramers[@"mobile"] = [Config getMobile];//传参数用户手机号
                //网络请求
                [WMNetWork post:CheckLastChargingState parameters:paramers success:^(id responseObj) {
                    MYLog(@"%@",responseObj);
                    if ([responseObj[@"status"] intValue] == 0) {
                        //请求数据成功
                        MYLog(@"responseObj = %@",responseObj);
                        
                        ChargingMessageModel *chargeMes = [ChargingMessageModel yy_modelWithDictionary:responseObj[@"result"]];
                        if (chargeMes.pile_id == NULL && chargeMes.charging_power == NULL && chargeMes.start_time == NULL && chargeMes.charging_status == NULL) {
                            [MBProgressHUD hideHUDForView:self.view animated:YES];
                            [Config removeChargePay];//移除总电费
                            [Config removeCurrentPower];//移除当前电量
                            [Config removeElecMoney];//移除电费
                            [Config removeServiceMoney];//移除服务费
                            [Config removeIDiscountMoney];//移除服务费优惠
                            [Config removeChargeNum];//移除充电桩号
                            [Config removeCurrentDate];//移除当前时间
                            //存充电状态:0.代表结束充电
                            [Config saveUseCharge:@"0"];
                            //存正常结束充电标志位为1
                            [Config saveNormalEndChargingFlag:@"1"];//思路：开始充电的时候正常结束充电位置为为0.正常结束的时候为1
                                
//                            }];
                            
//                            [alertVc addAction:sureAction];
//
//                            [self presentViewController:alertVc animated:YES completion:nil];
                            //存正常结束充电标志位为1
                            [Config saveNormalEndChargingFlag:@"1"];//思路：开始充电的时候正常结束充电位置为为0.正常结束的时候为1
                            return ;
                        }
                        
                        if ([chargeMes.charging_status isEqualToString:@"1"]) {
                            //连接SCOKET
                            [[Singleton sharedInstance] socketConnectHost];//连接socket
                            //延时3秒
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                
                                if ([Singleton sharedInstance].isLink) {
                                    
                                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                    
                                    NSDate *startDate = [dateFormatter dateFromString:chargeMes.start_time];
                                    
                                    NSDate *currentDate = [NSDate date];
                                    
                                    NSString *value = [XStringUtil dateTimeDifferenceWithStartTimes:startDate endTime:currentDate];
                                    //赋值计时器初始值
                                    mySeconds = [value intValue];
                                    NSString *tmphh = [NSString stringWithFormat:@"%d",mySeconds/3600];
                                    if ([tmphh length] == 1)
                                    {
                                        tmphh = [NSString stringWithFormat:@"0%@",tmphh];
                                    }
                                    NSString *tmpmm = [NSString stringWithFormat:@"%d",(mySeconds/60)%60];
                                    if ([tmpmm length] == 1)
                                    {
                                        tmpmm = [NSString stringWithFormat:@"0%@",tmpmm];
                                    }
                                    NSString *tmpss = [NSString stringWithFormat:@"%d",mySeconds%60];
                                    if ([tmpss length] == 1)
                                    {
                                        tmpss = [NSString stringWithFormat:@"0%@",tmpss];
                                    }
                                    //跳转界面
                                    ChargeingsViewController *chargeingVC = [[ChargeingsViewController alloc]init];
                                    //赋值电量
                                    
                                    //赋值电费
                                    
                                    //                              //保存充电开始时间
                                    [Config saveCurrentDate:startDate];
                                    MYLog(@"startDate = %@",startDate);
                                    MYLog(@"getCurrentDate = %@",[Config getCurrentDate]);
                                    //保存当前充电桩桩号
                                    [Config saveChargeNum:chargeMes.pile_id];
                                    //发送继续充电指令
                                    [[Singleton sharedInstance] continueCharging];
                                    
                                    [self.navigationController pushViewController:chargeingVC animated:YES];
                                }else
                                {
                                    MYLog(@"socket连接失败");
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"服务器连接失败,请重试！" message:nil preferredStyle:UIAlertControllerStyleAlert];
                                    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                                        [self checkChargeing];
                                    }];
                                    
                                    [alertVc addAction:sureAction];
                                    [self presentViewController:alertVc animated:YES completion:nil];
                                }
                            });
                        }else if([chargeMes.charging_status isEqualToString:@"2"])
                        {
                            MYLog(@"充电结束");
                            //延时3秒
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                                
                                MYLog(@"start_time = %@,end_time = %@",chargeMes.start_time,chargeMes.end_time);
                                //计算充电时长
                                NSString *chargeTime = [XStringUtil dateTimeDifferenceWithStartTime:chargeMes.start_time endTime:chargeMes.end_time];
                                //跳转到结算界面
                                ChangePayViewController *ChangePayVC = [[ChangePayViewController alloc]init];
                                //处理的情况，1.电量。2.电费。3.时间
                                ChangePayVC.chargeTimeStr =  [NSString stringWithFormat:@"%@",chargeTime];//充电时间
                                ChangePayVC.powersStr = [NSString stringWithFormat:@"%@",[Config getCurrentPower]];//已充电量
                                ChangePayVC.chargeMoneyStr =  [NSString stringWithFormat:@"%@",[Config getelecMoney]];//电费
                                ChangePayVC.fuwufei = [NSString stringWithFormat:@"%@",[Config getfuwufei]];//服务费
                                ChangePayVC.fuwufeiyouhui =  [NSString stringWithFormat:@"%@",[Config getfuwufeiyouhui]];//服务优惠费
                                ChangePayVC.xiaofeizongjine = [NSString stringWithFormat:@"%@",[Config getChargePay]];//总电费
                                ChangePayVC.alertTitle = @"";
                                [self.navigationController pushViewController:ChangePayVC animated:YES];
                            });
                        }
                    }else
                    {
                        //请求数据失败
                        MYLog(@"没有上次充电状态");
                    }
                } failure:^(NSError *error) {
                    MYLog(@"%@",error);
                    [MBProgressHUD hideHUD];
                    if (error) {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"网络超时,退出APP重试!" message:nil preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                        }];
                        
                        [alertVc addAction:sureAction];
                        [self presentViewController:alertVc animated:YES completion:nil];
                    }
                }];
            }
          
        }else{
           NSLog(@"9---");
        }
        
    } failure:^(NSError *error) {
        
    }];

}

// 搜索按 钮点击事件
- (void)zhouBianTapAction
{
    RecommendedViewController *recommendedVC = [[RecommendedViewController alloc] init];
    recommendedVC.locationCity = _locationCitys;
    [self presentViewController:recommendedVC animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)locationActionClick:(id)sender {
    //检测定位是否开启
    [self checkDingWei];
    //启动LocationService
    [_locService startUpdatingLocation];
    
}

-(void)dahangLA:(NSString *)a andLO:(NSString *)b andAddress:(NSString *)address{
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"您将导航至：%@",address]message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //百度坐标转高德坐标
    CLLocation *desLocation = [[CLLocation alloc] initWithLatitude:a.doubleValue longitude:b.doubleValue];
    CLLocationCoordinate2D desCoordinate =  [desLocation locationMarsFromBaidu].coordinate;
    
    UIAlertAction *GaoDeAction = [UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //苹果导航
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        //目的地的位置
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:desCoordinate addressDictionary:nil]];
        toLocation.name = address;
        
        NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
        //打开苹果自身地图应用，并呈现特定的item
        [MKMapItem openMapsWithItems:@[currentLocation,toLocation] launchOptions:options];
    }];
    
    UIAlertAction *BaiDulAction = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //百度地图
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
            
            NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:终点&mode=driving",[Config getCurrentLocation].latitude , [Config getCurrentLocation].longitude,a.doubleValue,b.doubleValue] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
        }else
        {
            [MBProgressHUD showError:@"您还没有安装百度地图APP"];
        }
    }];
    
    UIAlertAction *gaoDeAction = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //高德地图
        CLLocation *desLocation = [[CLLocation alloc] initWithLatitude:a.doubleValue longitude:b.doubleValue];
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

#pragma mark - 右边的排序按钮 中心按钮
BOOL btnStatus = YES;
- (IBAction)PersonActionClick:(id)sender {
//        if ([Config getOwnID]) {
//            //侧滑view
//            _leftView = [[PersonSlideView alloc]initWithFrame:CGRectMake(-leftWidth-5, 0, leftWidth, XYScreenHeight) superView:self.view];
//            _leftView.delegate = self;
//
//            [self.view addSubview:_leftView];
//            [_leftView handle:^(NSInteger indexRow) {
//                MYLog(@"%d",(int)indexRow);
//            }];
//            [_leftView leftViewShow:YES];
//
//        }else
//        {
//            [self loginShow];
//        }
  
//    [self.navigationController addChildViewController:screen];
    
    
    
    
    //排序按钮
    if (btnStatus == YES) {
        [[NSNotificationCenter defaultCenter] postNotificationName:AddChooseView object:nil];
        btnStatus = NO;
    }else{
        [self.screen removeFromSuperview];
        btnStatus = YES;
    }
}
#pragma mark -- 消息按钮

- (IBAction)MessageActionClick:(id)sender {
    if ([Config getOwnID] == nil || [Config getToken] == nil) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] init];
        [nav addChildViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
    }else{
        MessageCentreViewController *messageVC = [[MessageCentreViewController alloc] init];
        [self.navigationController pushViewController:messageVC animated:YES];
    }
}

-(void)bgViewClick
{
   [UIView animateWithDuration:0.2 animations:^{
       chargeingView.frame = CGRectMake(0,XYScreenHeight+352, XYScreenWidth, 352);
       BgView.alpha = 0;
   } completion:^(BOOL finished) {
       [chargeingView removeFromSuperview];
       [chargeVC removeFromParentViewController];
   }];
}

#pragma mark -- 扫码
- (void)scanActionClick{
    
    //检测相机权限是否开启
    //相机权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus ==AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。可能是家长控制权限
        authStatus ==AVAuthorizationStatusDenied)  //用户已经明确否认了这一照片数据的应用程序访问
    {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"开启相机权限" message:@"开启相机权限才能正常使用扫码功能。" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                [[UIApplication sharedApplication]openURL:url];
            }
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertVc addAction:sureAction];
        [alertVc addAction:cancelAction];
        
        [self presentViewController:alertVc animated:YES completion:nil];
        
    }else
    {
        //判断是否在充电状态
        if ([Config getUseCharge]) {
            ChargeingsViewController *chargeingVC = [[ChargeingsViewController alloc]init];
            [self.navigationController pushViewController:chargeingVC animated:YES];
        }else
        {
             [self saoMaAction];
        }
        
    }
}

//刷新重新加载气泡点
- (IBAction)refreshBtnAction:(id)sender {

    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"666" withExtension:@"gif"]; //加载GIF图片
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef) fileUrl, NULL);           //将GIF图片转换成对应的图片源
    size_t frameCout = CGImageSourceGetCount(gifSource);                                         //获取其中图片源个数，即由多少帧图片组成
    NSMutableArray *frames = [[NSMutableArray alloc] init];                                      //定义数组存储拆分出来的图片
    for (size_t i = 0; i < frameCout; i++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL); //从GIF图片中取出源图片
        UIImage *imageName = [UIImage imageWithCGImage:imageRef];                  //将图片源转换成UIimageView能使用的图片源
        [frames addObject:imageName];                                              //将图片加入数组中
        CGImageRelease(imageRef);
    }
    
    NSMutableArray *imgArray = [NSMutableArray array];
    for (int i=1; i<8; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ref%d.png",i]];
       // NSLog(@"数字是 = %@",[NSString stringWithFormat:@"refresh%d.png",i]);
        [imgArray addObject:image];
    }
    //把存有UIImage的数组赋给动画图片数组
     self.refreshImageView.animationImages = frames;
    //设置执行一次完整动画的时长
     self.refreshImageView.animationDuration = 1.3;
    //动画重复次数 （0为重复播放）
     self.refreshImageView.animationRepeatCount = 0;
    //开始播放动画
    [ self.refreshImageView startAnimating];
    //点击一次后不能再点击
    self.refreshBtnPro.userInteractionEnabled = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([[YBMonitorNetWorkState shareMonitorNetWorkState] getNetWorkState]) {
            NSLog(@"有网络");
        }else
        {
            NSLog(@"没有网");
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"未连接网络，请检查，WiFi或数据是否开启！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
         [self addChargeAnnotation];
    });

}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 个人中心代理方法
//预约
- (void)yuYueClick
{
    if ([Config getOwnID] == nil || [Config getToken] == nil) {
        LoginViewController *login = [[LoginViewController alloc] init];
        [self presentViewController:login animated:YES completion:nil];
    }else{
        MyReservationViewController *MyReservationVC = [[MyReservationViewController alloc]init];
        [self.navigationController pushViewController:MyReservationVC animated:YES];
    }
    
    
  
}
//钱包
- (void)qianBaoClick
{
    MyWalletViewController *MyWalletVC = [[MyWalletViewController alloc]init];
    [self.navigationController pushViewController:MyWalletVC animated:YES];
}
//积分
- (void)keFuClick
{
    ScoreViewController *scoreVC = [[ScoreViewController alloc] init];
   // KeFuViewController *kefuVC = [[KeFuViewController alloc]init];
    [self.navigationController pushViewController:scoreVC animated:YES];
}
//收藏
- (void)shouChangClick
{
    MyCollectViewController *MyCollectVC = [[MyCollectViewController alloc] init];
    [self.navigationController pushViewController:MyCollectVC animated:YES];
    
}
//设置
- (void)settingClick
{
    SettingViewController *settingVC = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}
//个人信息
- (void)headerClick
{
    PersonMessageViewController *personVC = [[PersonMessageViewController alloc] init];
    [self.navigationController pushViewController:personVC animated:YES];
}

- (void)loginShow//展示登陆界面
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] init];
    [nav addChildViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark -- 检测定位功能是否开启

-(void)checkDingWei
{
    //检测系统定位是否打开。
    if ([CLLocationManager locationServicesEnabled])
    {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"定位服务已关闭" message:@"请到设置->隐私->定位服务中开启【充电易】定位服务，以便您能够准确获得位置" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
               NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertVc addAction:sureAction];
            [alertVc addAction:cancelAction];
            
            [self presentViewController:alertVc animated:YES completion:nil];
        }
    }
    else
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"定位功能不可用，请检查！" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertVc addAction:sureAction];
        [self presentViewController:alertVc animated:YES completion:nil];
    }
}

#pragma mark - 退出登陆通知事件

-(void)LeftViewPutUp
{
   [_leftView leftViewShow:NO];
}
#pragma mark - 正在充电通知事件

-(void)ChargeingMessageAction
{
    self.saoMaLab.text = @"正在充电";
}

#pragma mark - 结束充电通知事件

-(void)EndChargeingMessageAction
{
   self.saoMaLab.text = @"扫码充电";
}

#pragma mark - 检查新手机登陆加载继续充电
-(void)checkChargingS
{
    //加载继续充电转圈
    [MBProgressHUD showMessage:@"加载上次未结束充电状态" toView:self.view];
    //参数
    NSMutableDictionary *paramers = [NSMutableDictionary dictionary];
    paramers[@"mobile"] = [Config getMobile];//传参数用户手机号
    //网络请求
    [WMNetWork post:CheckLastChargingState parameters:paramers success:^(id responseObj) {
        MYLog(@"%@",responseObj);
        if ([responseObj[@"status"] intValue] == 0) {
            //请求数据成功
            MYLog(@"responseObj = %@",responseObj);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            ChargingMessageModel *chargeMes = [ChargingMessageModel yy_modelWithDictionary:responseObj[@"result"]];
            MYLog(@"pile_id = %@\n,charging_fee = %@\n,charging_power = %@\n,start_time = %@\n,charging_status = %@\n",chargeMes.pile_id,chargeMes.charging_fee,chargeMes.charging_power,chargeMes.start_time,chargeMes.charging_status);
            
            if (chargeMes.pile_id == NULL && chargeMes.charging_power == NULL && chargeMes.start_time == NULL && chargeMes.charging_status == NULL) {
                MYLog(@"服务器断开了,充电结束");
                [MBProgressHUD hideHUDForView:self.view animated:YES];
//                UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"服务器断开了,充电结束." message:nil preferredStyle:UIAlertControllerStyleAlert];
//
//                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                
                    [Config removeChargePay];//移除总电费
                    [Config removeCurrentPower];//移除当前电量
                    [Config removeElecMoney];//移除电费
                    [Config removeServiceMoney];//移除服务费
                    [Config removeIDiscountMoney];//移除服务费优惠
                
                
                    [Config removeChargeNum];//移除充电桩号
                    [Config removeCurrentDate];//移除当前时间
                    //存充电状态:0.代表结束充电
                    [Config saveUseCharge:@"0"];
                    //存正常结束充电标志位为1
                    [Config saveNormalEndChargingFlag:@"1"];//思路：开始充电的时候正常结束充电位置为为0.正常结束的时候为1
                    //移除充电状态
                    [Config removeUseCharge];
                    
//                }];
                
//                [alertVc addAction:sureAction];
//
//                [self presentViewController:alertVc animated:YES completion:nil];
                //存正常结束充电标志位为1
                [Config saveNormalEndChargingFlag:@"1"];//思路：开始充电的时候正常结束充电位置为为0.正常结束的时候为1
                return ;
            }
            
            if ([chargeMes.charging_status isEqualToString:@"1"]) {
                //连接SCOKET
                [[Singleton sharedInstance] socketConnectHost];//连接socket
                //延时3秒
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    if ([Singleton sharedInstance].isLink) {
                        
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        
                        NSDate *startDate = [dateFormatter dateFromString:chargeMes.start_time];
                        
                        NSDate *currentDate = [NSDate date];
                        
                        NSString *value = [XStringUtil dateTimeDifferenceWithStartTimes:startDate endTime:currentDate];
                        //赋值计时器初始值
                        mySeconds = [value intValue];
                        NSString *tmphh = [NSString stringWithFormat:@"%d",mySeconds/3600];
                        if ([tmphh length] == 1)
                        {
                            tmphh = [NSString stringWithFormat:@"0%@",tmphh];
                        }
                        NSString *tmpmm = [NSString stringWithFormat:@"%d",(mySeconds/60)%60];
                        if ([tmpmm length] == 1)
                        {
                            tmpmm = [NSString stringWithFormat:@"0%@",tmpmm];
                        }
                        NSString *tmpss = [NSString stringWithFormat:@"%d",mySeconds%60];
                        if ([tmpss length] == 1)
                        {
                            tmpss = [NSString stringWithFormat:@"0%@",tmpss];
                        }
                        //跳转界面
                        ChargeingsViewController *chargeingVC = [[ChargeingsViewController alloc]init];
                        //赋值电量
                        
                        //赋值电费
                        
                        ////保存充电开始时间
                        [Config saveCurrentDate:startDate];
                        MYLog(@"startDate = %@",startDate);
                        MYLog(@"getCurrentDate = %@",[Config getCurrentDate]);
                        //保存当前充电桩桩号
                        [Config saveChargeNum:chargeMes.pile_id];
                        
                        [self.navigationController pushViewController:chargeingVC animated:YES];
                    }else
                    {
                        MYLog(@"socket连接失败");
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"服务器连接失败,请重试！" message:nil preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                        
                        }];
                        
                        [alertVc addAction:sureAction];
                        [self presentViewController:alertVc animated:YES completion:nil];
                    }
                });
            }else if([chargeMes.charging_status isEqualToString:@"2"])
            {
                MYLog(@"充电结束");
                //延时3秒
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                        //计算充电时长
                        NSString *chargeTime = [XStringUtil dateTimeDifferenceWithStartTime:chargeMes.start_time endTime:chargeMes.end_time];
                        //跳转到结算界面
                        ChangePayViewController *ChangePayVC = [[ChangePayViewController alloc]init];
                        //处理的情况，1.电量。2.电费。3.时间
                        ChangePayVC.chargeTimeStr =  [NSString stringWithFormat:@"%@",chargeTime];//充电时间
                        ChangePayVC.powersStr = [NSString stringWithFormat:@"%@",[Config getCurrentPower]];//已充电量
                        ChangePayVC.chargeMoneyStr =  [NSString stringWithFormat:@"%@",[Config getelecMoney]];//电费
                        ChangePayVC.fuwufei = [NSString stringWithFormat:@"%@",[Config getfuwufei]];//服务费
                        ChangePayVC.fuwufeiyouhui =  [NSString stringWithFormat:@"%@",[Config getfuwufeiyouhui]];//服务优惠费
                        ChangePayVC.xiaofeizongjine = [NSString stringWithFormat:@"%@",[Config getChargePay]];//总电费
                        ChangePayVC.alertTitle = @"";
                        [self.navigationController pushViewController:ChangePayVC animated:YES];
                });
            }
        }else
        {
            //请求数据失败
            MYLog(@"没有上次充电状态");
        }
    } failure:^(NSError *error) {
        MYLog(@"%@",error);
        [MBProgressHUD hideHUD];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        }
    }];
}

#pragma mark - 急停异常处理通知事件（推出结算界面）
-(void)YiChangJieSuan:(NSNotification *)noti
{
    ChangePayViewController  *ChangePay = [[ChangePayViewController alloc] init];
    
    if ([Config getChargePay] == NULL) {
        ChangePay.xiaofeizongjine =@"0￥";
    }else
    {
        ChangePay.xiaofeizongjine = [Config getChargePay];
    }
    
    if ([Config getCurrentPower] == NULL) {
        ChangePay.powersStr =@"0kwh";
    }else
    {
        ChangePay.powersStr = [Config getCurrentPower];
    }
    
    //计算时间
    NSDate *newCurrentDate = [NSDate date];
    NSString *value = [XStringUtil dateTimeDifferenceWithStartTimes:[Config getCurrentDate] endTime:newCurrentDate];
    //赋值计时器初始值
    mySeconds = [value intValue];
    NSString *tmphh = [NSString stringWithFormat:@"%d",mySeconds/3600];
    if ([tmphh length] == 1)
    {
        tmphh = [NSString stringWithFormat:@"0%@",tmphh];
    }
    NSString *tmpmm = [NSString stringWithFormat:@"%d",(mySeconds/60)%60];
    if ([tmpmm length] == 1)
    {
        tmpmm = [NSString stringWithFormat:@"0%@",tmpmm];
    }
    NSString *tmpss = [NSString stringWithFormat:@"%d",mySeconds%60];
    if ([tmpss length] == 1)
    {
        tmpss = [NSString stringWithFormat:@"0%@",tmpss];
    }
    
    ChangePay.chargeTimeStr = [NSString stringWithFormat:@"%@:%@:%@",tmphh,tmpmm,tmpss];
    
    if (noti.userInfo[@"unenoughMoney"] == nil) {
        ChangePay.alertTitle = @"";
    }else
    {
        ChangePay.alertTitle = @"提示：余额不足，自动停止充电并结算!";
    }
    
    [self.navigationController pushViewController:ChangePay animated:YES];
}

// 我的 按钮
- (IBAction)keFuBtnAction:(id)sender {
    //初始化客服控制器
        if ([Config getOwnID] == nil || [Config getToken] == nil) {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] init];
            [nav addChildViewController:loginVC];
            [self presentViewController:nav animated:YES completion:nil];
        }else{
        MeViewController *kefuVC = [[MeViewController alloc]init];
        [self.navigationController pushViewController:kefuVC animated:YES];
    }
   
//    KeFuViewController *kefuVC = [[KeFuViewController alloc]init];
//    [self.navigationController pushViewController:kefuVC animated:YES];
//    coverView = [[UIView alloc] init];
//    coverView.backgroundColor = [UIColor blackColor];
//    coverView.alpha = 0.6;
//    coverView.userInteractionEnabled = YES;
//    [self.view addSubview:coverView];
//    
//    adverView = [[AdvertisementView alloc] initWithFrame:CGRectMake(38, -483,XYScreenWidth-76, 483)];
//    [self.view addSubview:adverView];
//    
//    
//    __weak  AdvertisementView *weakAdverView = adverView;
//    __weak  UIView *weakCoverView = coverView;
//    adverView.DisMissViewBlock = ^{
//        NSLog(@"点击了");
//        
//        [UIView animateWithDuration:0.23 animations:^{
//            weakAdverView.frame = CGRectMake(38, -483,XYScreenWidth-76, 483);
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.3 animations:^{
//                weakCoverView.alpha = 0;
//            } completion:^(BOOL finished) {
//                [weakCoverView removeFromSuperview];
//                [weakAdverView removeFromSuperview];
//            }];
//        }];
//    };
//    
//    coverView.frame = CGRectMake(0, 0, XYScreenWidth, XYScreenHeight);
//    
//    [UIView animateWithDuration:0.18 animations:^{
//        adverView.frame = CGRectMake(38, 114, XYScreenWidth-76, 483);
//    } completion:^(BOOL finished) {
//       
//    }];
//
}

-(void)saoMaAction  //扫码事件处理
{
    //判断是否登陆
    MYLog(@"扫码状态界面的用户id获取情况 = %@",[Config getOwnID]);
    if([Config getOwnID] == nil || [Config getToken] == nil){
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] init];
        [nav addChildViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
    }else if ([Config getOwnID]) {
        
        
        
        NSDictionary *paramer = @{
                                  @"userId" : [Config getOwnID]
                                  };
        //判断用户余额够不够
        [WMNetWork post:GetBalance parameters:paramer success:^(id responseObj) {
            NSString * balance = responseObj[@"balance" ];
            
            if(balance.intValue < 2){
                //余额不足
                UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"账户余额不足，请先充值" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *sureAction= [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                }];
                
                [alertVc addAction:sureAction];
                //调用self的方法展现控制器
                [self presentViewController:alertVc animated:YES completion:nil];
                
            }else{
                //余额足
                static dispatch_once_t onceToken;
                
                dispatch_once(&onceToken, ^{
                    
                    QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
                    readerVc                   = [QRCodeReaderViewController readerWithCancelButtonTitle:@"" codeReader:reader startScanningAtLoad:YES  showTorchButton:NO];
                    
                    readerVc.delegate = self;
                });
                
                __weak MainViewController *weakSelf = self;
                
                [readerVc setCompletionWithBlock:^(NSString *resultAsString) {
                    MYLog(@"resultAsString = %@",resultAsString);
                    MYLog(@"length = %lu",(unsigned long)resultAsString.length);
                    
                    //二维码是24位数字
                    //if (resultAsString.length == 18) {
                    if (YES) {
                        NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
                        parmas[@"qrCode"] = resultAsString;//扫描结果10
                        parmas[@"token"] = [Config getToken];
                        [Config saveChargeNum:resultAsString];
                        //                       parmas[@"token"] = @"WG1mEQUUGqlnyvDz";
                        MYLog(@"token = %@",[Config getToken]);
                        
                        [WMNetWork get:ScanQrCode parameters:parmas success:^(id responseObj) {
                            
                            //  MYLog(@"responseObjrrrrrrr = %@",responseObj);
                            
                            if ([responseObj[@"status"] intValue] == 0) {
                                //    [MBProgressHUD hideHUDForView:readerVc.view animated:YES];
                                //                            [MBProgressHUD hideHUD];
                                OpenChangeViewController *openVC = [[OpenChangeViewController alloc] init];
                                
                                //                            NSString *equStr = responseObj[@"equipmentNum"];
                                NSString *equStr = responseObj[@"code"];//桩号
                                NSString *chargingStr = responseObj[@"stationName"];
                                openVC.equipmentNum = equStr;
                                openVC.chargingAddress = chargingStr;
                                MYLog(@"chargingStr地址 = %@",chargingStr);
                                [weakSelf.navigationController pushViewController:openVC animated:YES];
                                
                            }else if ([responseObj[@"status"] intValue] == 401)
                            {
                                //        [MBProgressHUD hideHUDForView:readerVc.view animated:YES];
                                //                              [MBProgressHUD hideHUD];
                                [Config removeOwnID];//移除ID
                                [Config removeUseName];//移除用户名字
                                
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                                
                                UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"手机号登陆异常" message:nil preferredStyle:UIAlertControllerStyleAlert];
                                UIAlertAction *sureAction= [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                                }];
                                
                                [alertVc addAction:sureAction];
                                //调用self的方法展现控制器
                                [weakSelf presentViewController:alertVc animated:YES completion:nil];
                                
                            }else
                            {
                                [MBProgressHUD showError:responseObj[@"message"]];
                            }
                        } failure:^(NSError *error) {
                            MYLog(@"error = %@",error);
                            if (error) {
                                [MBProgressHUD showError:@"服务器连接异常，请稍后再试"];
                            }
                        }];
                        
                    }else
                    {
                        NSString *temp =nil;
                        //遍历resultAsString 字符串
                        //                     NSString *tmp = nil;
                        //                     NSRange ance = [resultAsString rangeOfString:@"="];
                        //                     NSLog(@"ance = %@",NSStringFromRange(ance));
                        
                        for (int i = 0; i < resultAsString.length; i++) {
                            temp = [resultAsString substringWithRange:NSMakeRange(i,1)];
                            if ([temp isEqualToString:@"="]) {
                                NSString *b = [resultAsString substringFromIndex:i+1];
                                NSLog(@"充电桩号 = %@",b);
                                NSLog(@"充电桩号的长度 = %lu",(unsigned long)b.length);
                                if (b.length == 18) {
                                    NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
                                    parmas[@"qrCode"] = b;//扫描结果10
                                    parmas[@"qrCode"] = resultAsString;
                                    parmas[@"token"] = [Config getToken];
                                    MYLog(@"token = %@",[Config getToken]);
                                    
                                    [WMNetWork get:ScanQrCode parameters:parmas success:^(id responseObj) {
                                        
                                        //MYLog(@"responseObjrrrrrrr = %@",responseObj);
                                        
                                        if ([responseObj[@"status"] intValue] == 0) {
                                            //    [MBProgressHUD hideHUDForView:readerVc.view animated:YES];
                                            //                            [MBProgressHUD hideHUD];
                                            OpenChangeViewController *openVC = [[OpenChangeViewController alloc] init];
                                            
                                            NSString *equStr = responseObj[@"equipmentNum"];
                                            //                           NSString *equStr = resultAsString;
                                            NSString *chargingStr = responseObj[@"stationName"];
                                            NSLog(@"chargingStr = %@",chargingStr);
                                            openVC.equipmentNum = equStr;
                                            openVC.chargingAddress = chargingStr;
                                            MYLog(@"chargingStr地址 = %@",chargingStr);
                                            [weakSelf.navigationController pushViewController:openVC animated:YES];
                                            
                                        }else if ([responseObj[@"status"] intValue] == 401)
                                        {
                                            //        [MBProgressHUD hideHUDForView:readerVc.view animated:YES];
                                            //                              [MBProgressHUD hideHUD];
                                            [Config removeOwnID];//移除ID
                                            [Config removeUseName];//移除用户名字
                                            
                                            [weakSelf.navigationController popViewControllerAnimated:YES];
                                            
                                            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"手机号登陆异常" message:nil preferredStyle:UIAlertControllerStyleAlert];
                                            UIAlertAction *sureAction= [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                                            }];
                                            
                                            [alertVc addAction:sureAction];
                                            //调用self的方法展现控制器
                                            [weakSelf presentViewController:alertVc animated:YES completion:nil];
                                            
                                        }else
                                        {
                                            [MBProgressHUD showError:responseObj[@"message"]];
                                        }
                                    } failure:^(NSError *error) {
                                        MYLog(@"error = %@",error);
                                        if (error) {
                                            [MBProgressHUD showError:@"服务器连接异常，请稍后再试"];
                                        }
                                    }];
                                }else
                                {
                                    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"该二维码无效，或者不属于兴国充电桩" preferredStyle:UIAlertControllerStyleAlert];
                                    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                                        [weakSelf.navigationController popViewControllerAnimated:YES];
                                    }];
                                    
                                    [alertVc addAction:sureAction];
                                    [weakSelf presentViewController:alertVc animated:YES completion:nil];
                                }
                                return ;
                            }
                        }
                        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"该二维码无效，或者不属于兴国充电桩" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        }];
                        
                        [alertVc addAction:sureAction];
                        [weakSelf presentViewController:alertVc animated:YES completion:nil];
                    }
                }];
                
                [self.navigationController pushViewController:readerVc animated:YES];

            }
            
        } failure:^(NSError *error) {
            
        }];
        
    }else
    {
        [self loginShow];//登陆界面
    }
}

- (IBAction)btnClick:(id)sender{
    [self scanActionClick];
    
}


-(void)addChooseView{
    ChooseView *screen = [[ChooseView alloc]initWithFrame:CGRectZero];
    screen.detail = ^(NSString *stationID) {
        ChargeDetailViewController *chargeVCc = [[ChargeDetailViewController alloc] init];
        chargeVCc.id = stationID;
        [self presentViewController:chargeVCc animated:YES completion:nil];
    };
    [self.view addSubview:screen];
    self.screen = screen;
    screen.frame = CGRectMake(0, StatusBarH + 44,XYScreenWidth, XYScreenHeight );
    screen.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.4];
    screen.daohang = ^(NSString *a, NSString *b, NSString *addr) {
        [self dahangLA:a andLO:b andAddress:addr];
        
    };
}
@end
