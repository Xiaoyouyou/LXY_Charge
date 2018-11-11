//
//  MyCollectViewController.m
//  Charge
//
//  Created by olive on 16/6/7.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "MyCollectViewController.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import "MyCollectTableViewCell.h"
#import "ChargeDetailViewController.h"
#import "MBProgressHUD+MJ.h"
#import "XFunction.h"
#import "MJExtension.h"
#import "API.h"
#import "Config.h"
#import "UseCollectChargeModel.h"
#import "CLLocation+YCLocation.h"
#import "MJRefresh.h"
#import "TipView.h"
#import "WMNetWork.h"
#import "Masonry.h"
#import "NavView.h"

#import "LoginViewController.h"
@interface MyCollectViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray; //收藏充电站数组

@property (nonatomic) double  zhuangLatitude;//纬度
@property (nonatomic) double  zhuanglongitude;//经度
@property (nonatomic, copy) NSString *distanceStr;//距离

@property (nonatomic, assign) BOOL isUpdateLocation;//是否更新地理位置
//地图相关
@property (strong,nonatomic) BMKLocationService *locService;

@property (nonatomic, strong) NSMutableArray *distanceArray;//距离数组
@property (nonatomic, strong) NSMutableArray *ChargeIdArray;//充电站id数组
@property (nonatomic, strong) TipView *tipview;//提示view

@end

@implementation MyCollectViewController

-(NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(NSMutableArray *)distanceArray
{
    if (_distanceArray == nil) {
        _distanceArray = [NSMutableArray array];
    }
    return _distanceArray;
}

-(NSMutableArray *)ChargeIdArray
{
    if (_ChargeIdArray == nil) {
        _ChargeIdArray = [NSMutableArray array];
    }
    return _ChargeIdArray;
}

-(void)viewWillAppear:(BOOL)animated
{ 
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    MYLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    if (self.isUpdateLocation == 1) {
        self.nowLatitude = userLocation.location.coordinate.latitude;
        self.nowLongitude = userLocation.location.coordinate.longitude;
        
        [Config saveCurrentLocation:userLocation];
        self.isUpdateLocation =0;
    }
    
    [_locService stopUserLocationService];
}


#pragma Mark- action

-(void)jiSuanDistance
{
    for (int i = 0; i<_dataArray.count; i++) {
    UseCollectChargeModel *chargeModel = _dataArray[i];
    double lat = [chargeModel.latitude doubleValue];
    double lng = [chargeModel.longitude doubleValue];
        
    //获取保存的经纬度
    BMKMapPoint point1 = BMKMapPointForCoordinate([Config getCurrentLocation]);
    BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(lat,lng));
    CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
        
    _distanceStr = [NSString stringWithFormat:@"%.2fkm",distance/1000];
   // MYLog(@"_distanceStr = %@",_distanceStr);
    [self.distanceArray addObject:_distanceStr];//增加距离数组
        
    //增加收藏充电站的id数组
    [self.ChargeIdArray addObject:chargeModel.id];
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
      self.navigationController.navigationBarHidden = YES;
  //  self.title = @"收藏";
  //  UIImage *image = [UIImage imageNamed:@"back"];
  //  image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
  //  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    //初始化nav
    NavView *nav = [[NavView alloc] initWithFrame:CGRectZero title:@"我的收藏"];
    nav.backBlock = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:nav];
    
    [nav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(StatusBarH + 44);
    }];
    
    //初始化
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, StatusBarH + 44, XYScreenWidth, XYScreenHeight - StatusBarH - 44) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //添加下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
    }];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
 
}

//下拉刷新加载数据
-(void)loadNewData
{
    NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
    parmas[@"userId"] = [Config getOwnID];
    parmas[@"token"] = [Config getToken];
    
    [WMNetWork post:CollectionList parameters:parmas success:^(id responseObj) {
        //结束下拉刷新状态
        [self.tableView.mj_header endRefreshing];
        //   MYLog(@"collectResponseObj = %@",responseObj);
        //异常登陆
        if ([responseObj[@"status"] intValue] == 401) {
            
//            LoginViewController *login = [[LoginViewController alloc] init];
//            [self.navigationController pushViewController:login animated:YES];
            
            [Config removeOwnID];//移除ID
            [Config removeUseName];//移除用户名字
            //退出登陆时通知主控制器收起左滑界面
            [[NSNotificationCenter defaultCenter] postNotificationName:LeaveOutNoti object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
            [MBProgressHUD showError:@"账号异常登录"];
            
            return ;
            
        }
        
        if (self.tipview) {
            self.tipview.alpha = 0;
        }
        
     //   MYLog(@"collect responseObj = %@",responseObj);
        if ([responseObj[@"status"] intValue] == 0) {
            _dataArray = [UseCollectChargeModel objectArrayWithKeyValuesArray:[responseObj objectForKey:@"result"]];
            //  MYLog(@"_dataArray = %@",_dataArray);
            
            if (_dataArray.count == 0) {
                MYLog(@"没有收藏");
                UIImage *image = [UIImage imageNamed:@"NoneCollect@2x.png"];
                NSString *str = @"您还没有收藏";
                
                self.tipview  = [[TipView alloc] initWithFrame:CGRectZero image:image andshowText:str];
                self.tipview.alpha = 1;
                [self.tipview SetUpMasonry];
                [self.view addSubview:self.tipview];
                
                [self.tipview mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(self.view);
                    make.right.equalTo(self.view);
                    make.bottom.equalTo(self.view);
                    make.top.equalTo(self.view).offset(StatusBarH + 44);
                    
                }];
                return ;
            }
            //计算距离
            [self jiSuanDistance];
            [self.tableView reloadData];
        }
        
    } failure:^(NSError *error) {
        
        //结束下拉刷新状态
        [self.tableView.mj_header endRefreshing];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        UIImage *image = [UIImage imageNamed:@"NoneNetwork@2x.png"];
        NSString *str = @"您好，请检查网络";
        
        self.tipview  = [[TipView alloc] initWithFrame:CGRectZero image:image andshowText:str];
        self.tipview.alpha = 1;
        [self.tipview SetUpMasonry];
        [self.view addSubview:self.tipview];
        
        [self.tipview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(StatusBarH + 44);
        }];
    }];
}

#pragma mark - action
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView代理方法
//实现左滑删除方法
//第一个参数：表格视图对象
//第二个参数：编辑表格的方式
//第三个参数：操作cell对应的位置
//-(void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
//{
//    //如果是删除
//    if(editingStyle==UITableViewCellEditingStyleDelete)
//    {
//        //点击删除按钮调用这里的代码
//        //   1.数据源删除
//        //   @[indexPath]=[NSArray arrayWithObjects:indexPath,nil];
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        params[@"userId"] = [Config getOwnID];
//        params[@"stationId"] = self.ChargeIdArray[indexPath.section];
//        NSString *alertString = nil;
//        
//        alertString = @"取消收藏";
//        [WMNetWork post:CancelCollect parameters:params success:^(id responseObj) {
//            
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//            if ([responseObj[@"status"] intValue] == 0) {
//                [MBProgressHUD showError:alertString];
//                
//                [_dataArray removeObjectAtIndex:indexPath.section];
//                [_distanceArray removeObjectAtIndex:indexPath.section];
//                
//                //UI上删除:将要删除的所有的cell的indexPath组成的数组
//                //[tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
//                
////                if (_dataArray.count == 0 && _distanceArray.count == 0) {
////                    MYLog(@"没有收藏");
////                    UIImage *image = [UIImage imageNamed:@"NoneCollect@2x.png"];
////                    NSString *str = @"您还没有收藏";
////                    
////                    self.tipview  = [[TipView alloc] initWithFrame:CGRectZero image:image andshowText:str];
////                    self.tipview.alpha = 1;
////                    [self.tipview SetUpMasonry];
////                    [self.view addSubview:self.tipview];
////                    
////                    [self.tipview mas_makeConstraints:^(MASConstraintMaker *make) {
////                        make.edges.equalTo(self.view);
////                    }];
////              
////                }
//
//                  [tableView reloadData];
//                
//            }else if ([responseObj[@"status"] intValue] == -1)
//            {
//                
//                [MBProgressHUD showSuccess:responseObj[@"message"]];
//            }
//            
//        } failure:^(NSError *error) {
//            MYLog(@"error = %@",error);
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            [MBProgressHUD show:@"网络连接超时" icon:nil view:self.view];
//        }];
//    }
//}

//修改删除按钮为中文的删除
//-(NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexPath
//{
//    return @"取消";
//}

//是否允许编辑行，默认是YES
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 121;
}

//设置每个区有多少行共有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//响应点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UseCollectChargeModel *chargeModel = _dataArray[indexPath.section];
    
    ChargeDetailViewController *chargeVCc = [[ChargeDetailViewController alloc] init];
    chargeVCc.id = chargeModel.id;

    [self presentViewController:chargeVCc animated:YES completion:nil];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdetifier = @"MyCollectCell";
    MyCollectTableViewCell * MyCollectCell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier];
    if (MyCollectCell == nil) {
        MyCollectCell = [[[NSBundle mainBundle]loadNibNamed:@"MyCollectTableViewCell" owner:nil options:nil]lastObject];
    }
    UseCollectChargeModel *chargeModel = _dataArray[indexPath.section];
    
    MyCollectCell.addresss = chargeModel.address;//地址
    MyCollectCell.fastLabs = chargeModel.fastCount;//快充
    MyCollectCell.slowLabs = chargeModel.slowCount;//慢充
    MyCollectCell.titleNames = chargeModel.name; //充电站名字
    MyCollectCell.distance = _distanceArray[indexPath.section];//距离
    

    MyCollectCell.daoHangBlock = ^{
       // if (![self checkServicesInited]) return;
       // _naviType = BN_NaviTypeReal;
   //    [self startNaviEndLat:[chargeModel.latitude doubleValue] andEndLng:[chargeModel.longitude doubleValue]];
        MYLog(@"开始导航");
        [self daoHangAction:chargeModel.address startLat:[chargeModel.latitude doubleValue] startLng:[chargeModel.longitude doubleValue]];
    };

    [MyCollectCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return MyCollectCell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

   return _dataArray.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark - 导航
-(void)daoHangAction:(NSString *)address startLat:(double)latitude startLng:(double)longitude
{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"您将导航至：%@",address]message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //百度坐标转高德坐标
    CLLocation *desLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
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
            
            NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:终点&mode=driving",[Config getCurrentLocation].latitude , [Config getCurrentLocation].longitude,latitude,longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
        }else
        {
            [MBProgressHUD showError:@"您还没有安装百度地图APP"];
        }
        
    }];
    
    UIAlertAction *gaoDeAction = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //高德地图
        CLLocation *desLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
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
@end
