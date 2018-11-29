//
//  ChooseView.m
//  Charge
//
//  Created by 罗小友 on 2018/10/31.
//  Copyright © 2018 com.XinGuoXin.cn. All rights reserved.
//

#import "ChooseView.h"
#import "ChooseModel.h"
#import "ChooseTableViewCell.h"
#import "ShaixuanView.h"





@interface ChooseView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UIScrollView *scroll;

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong)NSMutableArray *dataSource;
//状态按钮
@property (nonatomic,strong) UIButton *selectedBtn;
//筛选界面
@property (nonatomic,strong) ShaixuanView *views;


@end

@implementation ChooseView

-(NSMutableArray *)dataSource{
    if(!_dataSource){
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self addSubViews:frame];
        
        NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
        CLLocationCoordinate2D userLocation =  [Config getCurrentLocation];
        NSString *strla = [NSString stringWithFormat:@"%lf", userLocation.latitude ];
        NSString *strlo = [NSString stringWithFormat:@"%lf", userLocation.longitude ];
            [paramer setValue:@"0" forKey:@"priceOrderby"];
            [paramer setValue:strla forKey:@"latitude"];
            [paramer setValue:strlo forKey: @"longitude"];
            [self loadDataSource:paramer];
    };
    return self;
};
//创建子view
-(void)addSubViews:(CGRect)frame{
    UIView *topBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XYScreenWidth, 44)];
    topBackView.backgroundColor = [UIColor whiteColor];
    NSArray *btnTitle = @[@"距离最近",@"价格最低",@"筛选"];
    for (int i = 0; i < btnTitle.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:[NSString stringWithFormat:@"%@",btnTitle[i]] forState:UIControlStateNormal];
        [btn setTitleColor:RGB_COLOR(29, 167, 145, 1.0) forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.frame = CGRectMake(i * (XYScreenWidth / 3), 0, XYScreenWidth / 3, 44);
        btn.tag = i;
        [btn addTarget:self action:@selector(chooseType:) forControlEvents:UIControlEventTouchDown];
        [topBackView addSubview:btn];
    }
    [self addSubview:topBackView];
    //添加tableView
    //添加tableView
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0,44, XYScreenWidth, 450)];
    self.scroll = scroll;
    scroll.backgroundColor = RGB_COLOR(109, 109, 109, 1.0);
    [self addSubview:scroll];
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 2, XYScreenWidth, 450) style:UITableViewStylePlain];
    [table registerNib:[UINib nibWithNibName:@"ChooseTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"chooseCell"];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = table;
    table.delegate = self;
    table.dataSource = self;
    [scroll addSubview:table];
   
}
-(void)chooseType:(UIButton *)button{
//    NSDictionary *paramer = @{
//                              //                                  @"province" : [Config get]//手机位置所在省
//                              //                                   @"city" :  [Config ],    //手机位置所在市
//                              //                                  @"longitude": //手机位置经度 数字类型
//                              //                                  @"latitude": //手机位置纬度 数字类型
//                              //                                  @"state":        //充电站状态，传00查可用站，不传或传其他字符查所有
//                              @"priceOrderby":@0//是否根据价格排序，传0根据距离近远排序，传1根据价格低高排序。
//                              //                                  @"acFlag":      //交流直流标志，传1查含有直流的充电站，传0查交流充电站，不传查所有
//                              };
     NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    if (button!= self.selectedBtn) {
        self.selectedBtn.selected = NO;
        button.selected = YES;
        self.selectedBtn = button;
    }else{
        self.selectedBtn.selected = YES;
    }
    
    NSLog(@"点击了按钮--%ld",button.tag);
    CLLocationCoordinate2D userLocation =  [Config getCurrentLocation];
    NSString *strla = [NSString stringWithFormat:@"%lf", userLocation.latitude ];
    NSString *strlo = [NSString stringWithFormat:@"%lf", userLocation.longitude ];
    if (button.tag == 0) {
   
         [paramer setValue:@"0" forKey:@"priceOrderby"];
         [paramer setValue:strla forKey:@"latitude"];
         [paramer setValue:strlo forKey: @"longitude"];
        [self loadDataSource:paramer];
        if( self.views){
            [self.views removeFromSuperview];
            self.views = nil;
        }
    }else if (button.tag == 1) {
        [paramer setValue:strla forKey:@"latitude"];
        [paramer setValue:strlo forKey: @"longitude"];
        [paramer setValue:@"1" forKey:@"priceOrderby"];
        [self loadDataSource:paramer];
        if( self.views){
            [self.views removeFromSuperview];
            self.views = nil;
        }
    }else if (button.tag == 2){
        //弹框 然后选择条件
        [self addChooseViewInThisView];
    }
}

-(void)loadDataSource:(NSMutableDictionary *)paramer{
    //发送默认排序请求
//    NSDictionary *paramer = @{
//                              //                                  @"province" : [Config get]//手机位置所在省
//                              //                                   @"city" :  [Config ],    //手机位置所在市
//                              //                                  @"longitude": //手机位置经度 数字类型
//                              //                                  @"latitude": //手机位置纬度 数字类型
//                              //                                  @"state":        //充电站状态，传00查可用站，不传或传其他字符查所有
//                              @"priceOrderby":@0//是否根据价格排序，传0根据距离近远排序，传1根据价格低高排序。
//                              //                                  @"acFlag":      //交流直流标志，传1查含有直流的充电站，传0查交流充电站，不传查所有
//                              };
    [WMNetWork get:ChargeChooseList
        parameters:paramer success:^(id responseObj) {
            NSLog(@"%@",responseObj);
            NSMutableArray *muarray = responseObj[@"result"];
            [self.dataSource removeAllObjects];
            for (NSDictionary *dict in muarray) {
                ChooseModel *model = [ChooseModel objectWithKeyValues:dict];
                [self.dataSource addObject:model];
            }
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.dataSource.count;
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chooseCell" forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.daohang = ^(NSString *la, NSString *lo, NSString *address) {
           weakSelf.daohang(la, lo,address);
    };
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChooseModel *model = self.dataSource[indexPath.row];
    self.detail(model.stationId);
}

//添加筛选界面到这个view上
-(void)addChooseViewInThisView{
    if(self.views == nil){
        self.views = [[ShaixuanView alloc] initWithFrame:CGRectMake(0, 88, XYScreenWidth, 200)];
        __weak typeof(self) weakSelf = self;
        self.views.cancelBlock = ^{
            [weakSelf.views removeFromSuperview];
            weakSelf.views = nil;
        };
        self.views.chooseBlock = ^(NSDictionary *type) {
            NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
  
//  @{
//                                      //                                  @"province" : [Config get]//手机位置所在省
//                                      //                                   @"city" :  [Config ],    //手机位置所在市
//                                      //                                  @"longitude": //手机位置经度 数字类型
//                                      //                                  @"latitude": //手机位置纬度 数字类型
//                                      //                                  @"state":        //充电站状态，传00查可用站，不传或传其他字符查所有
//                                      @"priceOrderby":@0//是否根据价格排序，传0根据距离近远排序，传1根据价格低高排序。
//                                      //                                  @"acFlag":      //交流直流标志，传1查含有直流的充电站，传0查交流充电站，不传查所有
//                                      };
            [paramer setValue:@"00" forKey:@"state"];
            if (([type objectForKey:@"0"] == nil && [type objectForKey:@"1"] == nil) || ([type objectForKey:@"0"] && [type objectForKey:@"1"]) ) {
                [paramer setValue:@"" forKey:@"acFlag"];
            }else if([type objectForKey:@"0"]){
                [paramer setValue:@"0" forKey:@"acFlag"];
            }else{
                [paramer setValue:@"1" forKey:@"acFlag"];
            }
            [weakSelf loadDataSource:paramer];
            [weakSelf.views removeFromSuperview];
            weakSelf.views = nil;
            NSLog(@"%@",type);
            NSLog(@"请求数据啊");
        };
        [self.scroll addSubview:self.views];
    }
   
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}
@end
