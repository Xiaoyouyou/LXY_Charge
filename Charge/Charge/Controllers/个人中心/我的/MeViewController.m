//
//  MeViewController.m
//  Charge
//
//  Created by 罗小友 on 2018/10/14.
//  Copyright © 2018年 com.XinGuoXin.cn. All rights reserved.
//

#import "MeViewController.h"
#import "Masonry.h"
#import "NavView.h"
#import "SettingViewController.h"
#import "API.h"
#import "MeVcWithMineView.h"
#import "MyWalletViewController.h"
#import "MyCollectViewController.h"
#import "PersonMessageViewController.h"
#import "MyCarViewController.h"
#import "ChargeMessageViewController.h"
#import "MeInvoiceViewController.h"
#import "PersonMessage.h"
#import "PersonMesCaches.h"
#import "ChuZiViewController.h"


@interface MeViewController ()
//导航
@property (nonatomic ,strong)NavView *nav;
//topView
@property (nonatomic ,strong)UIView *topView;
//mineView
@property (nonatomic ,strong)UIView *mineView;

@property (nonatomic ,strong) UILabel *userName;
@property (nonatomic ,strong) UIButton *userLevel;

//bottomView
@property (nonatomic ,strong)UIView *bottomView;
@property (nonatomic ,strong)NSArray *topTitleArr;
@property (nonatomic ,strong)NSMutableArray *bottomTitleArr;
@property (nonatomic ,strong)NSArray *btnFunction;
@property (nonatomic ,strong)NSArray *btnImage;
@end

@implementation MeViewController

-(NSArray *)topTitleArr{
    if(!_topTitleArr){
        _topTitleArr = @[@"余额",@"积分"];
    }
    return _topTitleArr;
};

-(NSMutableArray *)bottomTitleArr{
    if(!_bottomTitleArr){
        _bottomTitleArr = [NSMutableArray array];
    }
    return _bottomTitleArr;
};
-(NSArray *)btnFunction{
    if(!_btnFunction){
        _btnFunction = @[@"我的钱包",@"我的收藏",@"我要开票",@"我的车辆",@"充电记录",@""];
    }
    return _btnFunction;
};

-(NSArray *)btnImage{
    if(!_btnImage){
        _btnImage = @[@"qqq",@"shoucang",@"kaipiao",@"mycar",@"chongdian",@""];
    }
    return _btnImage;
};

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1.0];
    //添加导航条和站位view
    [self addNavigationBar];
    //添加子view
    //加载余额
    [self loadbalance];
}

-(void)loadbalance{
    if ([Config getOwnID] == nil) {
        return;
    }
    NSDictionary *paramer = @{
                              @"userId" : [Config getOwnID]
                              };
    [WMNetWork get:GetBalance parameters:paramer success:^(id responseObj) {
        [self.bottomTitleArr removeAllObjects];
        [self.bottomTitleArr addObject:responseObj[@"balance"]];
        [self.bottomTitleArr addObject:@"00"];
        [self addSomeSubViews:self.bottomTitleArr];
    } failure:^(NSError *error) {
        
    }];
    
    NSMutableDictionary *paramers = [NSMutableDictionary dictionary];
    paramers[@"userId"] =[Config getOwnID];
    paramers[@"token"] =[Config getToken];
    [WMNetWork get:GetPerMes parameters:paramers success:^(id responseObj) {
        
        NSLog(@"PerMesresponseObj = %@",responseObj);
        if ([responseObj[@"status"] intValue] == 401) {
            [Config removeOwnID];//移除ID
            [Config removeUseName];//移除用户名字
            //退出登陆时通知主控制器收起左滑界面
//            if ([Config getOwnID] == nil || [Config getToken] == nil) {
//
//                LoginViewController *loginVC = [[LoginViewController alloc] init];
//                UINavigationController *nav = [[UINavigationController alloc] init];
//                [nav addChildViewController:loginVC];
//                [self presentViewController:nav animated:YES completion:nil];
//            }
            return ;
        }
        
        if ([responseObj[@"status"] intValue] == 0) {
            
            PersonMessage  *per = [PersonMessage yy_modelWithDictionary:responseObj[@"result"]];
            [self saveDataWithSex:per.sex andAge:per.age andNick:per.nick andMobile:per.mobile andAvatar:per.avatar andSignature:per.signature];
            self.userName.text = per.userName;
            //图片路径赋值
        }
    } failure:^(NSError *error) {
        NSLog(@"error = %@",error);
        [MBProgressHUD show:@"网络连接超时" icon:nil view:self.view];
    }];
    
}


 //添加导航条和添加子view条
-(void)addNavigationBar{
    self.nav = [[NavView alloc]
                initWithFrame:CGRectZero title:@"我的" leftImgae:@"back@2x.png" rightButton:@"设置"];
    __weak typeof(self) weakSelf = self;
    self.nav.backBlock = ^{
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    };
   //右边设置按钮的点击事件
    self.nav.rightBlock = ^{
        SettingViewController *settingVC = [[SettingViewController alloc] init];
        [weakSelf.navigationController pushViewController:settingVC animated:YES];
    };
    [self.view addSubview:self.nav];
    CGFloat statusH = [UIApplication sharedApplication].statusBarFrame.size.height + 44;
    [self.nav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(statusH);
    }];
    
    self.topView = [[UIView alloc] init];
    [self.view addSubview:self.topView];
    self.topView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoMYMessage)];
    [self.topView addGestureRecognizer:tap];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nav.mas_bottom).offset(0);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(120);
        
    }];
    
    self.mineView = [[UIView alloc] init];
    self.mineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mineView];
    [self.mineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(2);
        make.right.equalTo(self.view.mas_right).offset(-2);
        make.height.mas_equalTo(@60);
    }];
    
    
    UIView *lineView = [[UIView alloc] init];
    [self.mineView addSubview:lineView];
    lineView.backgroundColor = RGB_COLOR(154, 154, 154, 1.0);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mineView);
        make.centerY.equalTo(self.mineView);
        make.height.mas_offset(40);
        make.width.mas_offset(1);
    }];
    
    
    self.bottomView = [[UIView alloc] init];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mineView.mas_bottom).offset(1);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
}

-(void)addSomeSubViews:(NSMutableArray *)arr{
    
    /*---------top----------*/
    UIImageView *userIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grayIcon.png"] highlightedImage:[UIImage imageNamed:@"grayIcon.png"]];
    userIcon.layer.masksToBounds = YES;
    userIcon.layer.cornerRadius = 30;
    userIcon.layer.borderWidth = 1.0;
    [self.topView addSubview:userIcon];
    [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topView.mas_centerX);
        make.top.equalTo(self.topView.mas_top).mas_offset(20);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
     UILabel *userName = [[UILabel alloc] init];
    userName.font = [UIFont systemFontOfSize:12];
//    userName.text = @"185****3020";
    userName.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:userName];
    [userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topView.mas_centerX);
        make.top.equalTo(userIcon.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    self.userName = userName;
    
    UIButton *userLevel = [UIButton buttonWithType:UIButtonTypeCustom];
    [userLevel setTitle:@"充值" forState:UIControlStateNormal];
    userLevel.titleLabel.font = [UIFont systemFontOfSize:16];
    [userLevel setTitleColor:RGB_COLOR(29, 167, 145, 1.0) forState:UIControlStateNormal];
    userLevel.titleLabel.textAlignment = NSTextAlignmentCenter;
    [userLevel addTarget:self action:@selector(gotopay) forControlEvents:UIControlEventTouchDown];
    [self.topView addSubview:userLevel];
    [userLevel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_topView.mas_right).mas_offset(-20);
        make.centerY.equalTo(_topView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    self.userLevel = userLevel;
    /*---------mine----------*/
    
    int count = 2;
    for (int i = 0; i < count; i++) {
         CGFloat x = (XYScreenWidth / count + 2) * i;
         CGFloat w = XYScreenWidth / count - 4;
         CGFloat y = 0;
         CGFloat h = 60;
        MeVcWithMineView *backView = [[MeVcWithMineView alloc] initWithFrame:CGRectMake(x, y, w, h) TopTitle:self.topTitleArr[i] BottomTitle:arr[i]];
        [self.mineView addSubview:backView];
    }
    /*---------bottom----------*/
    //九宫格布局button 假设有n个btn
    NSInteger n = self.btnFunction.count;
    //每一行有三个
    int Xitem = 2;
    
    for (int i = 0; i < n; i ++) {
        CGFloat w = XYScreenWidth / 2;
        CGFloat x = w * (i%Xitem);
        CGFloat h = 60;
        CGFloat y = h  * (i/Xitem);
        
        UIButton *btn = [[UIButton alloc] init];;
        [btn setTitle:self.btnFunction[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:self.btnImage[i]] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];//调整图片大小5:2
        btn.backgroundColor = [UIColor whiteColor];
        btn.tag = i;
        [btn addTarget:self action:@selector(someFunction:) forControlEvents:UIControlEventTouchDown];
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        btn.frame = CGRectMake(x, y, w, h);
        [self.bottomView addSubview:btn];
    }
}
//
////积分
//    ScoreViewController *scoreVC = [[ScoreViewController alloc] init];
//    // KeFuViewController *kefuVC = [[KeFuViewController alloc]init];
//    [self.navigationController pushViewController:scoreVC animated:YES];
////设置
//    SettingViewController *settingVC = [[SettingViewController alloc] init];
//    [self.navigationController pushViewController:settingVC animated:YES];



-(void)someFunction:(UIButton *)sender{
    
    if ([Config getOwnID] == nil || [Config getToken] == nil) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] init];
        [nav addChildViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        [self.bottomTitleArr removeAllObjects];
        [self.bottomTitleArr addObject:@"00"];
        [self.bottomTitleArr addObject:@"00"];
        [self addSomeSubViews:self.bottomTitleArr];
    }else{
        if(sender.tag == 0){
            MyWalletViewController *MyWalletVC = [[MyWalletViewController alloc]init];
            [self.navigationController pushViewController:MyWalletVC animated:YES];
        }else if (sender.tag == 1){
            MyCollectViewController *MyCollectVC = [[MyCollectViewController alloc] init];
            [self.navigationController pushViewController:MyCollectVC animated:YES];
        }else if (sender.tag == 2){
            MeInvoiceViewController *invoice = [[MeInvoiceViewController alloc] init];
            [self.navigationController pushViewController:invoice animated:YES];
        }else if (sender.tag == 3){
            MyCarViewController * carVc = [[MyCarViewController alloc] init];
            [self.navigationController pushViewController:carVc animated:YES];
        }else if (sender.tag == 4){
            ChargeMessageViewController *message = [[ChargeMessageViewController alloc]init];
            [self.navigationController pushViewController:message animated:YES];
        }else if (sender.tag == 5){
            
        }
        NSLog(@"%ld",sender.tag);
    }
    
    
   
}

-(void)gotoMYMessage{
    //个人信息
      PersonMessageViewController *personVC = [[PersonMessageViewController alloc] init];
        [self.navigationController pushViewController:personVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -- 保存个人信息缓存

- (void)saveDataWithSex:(NSString *)Sex andAge:(NSString *)Age andNick:(NSString *)Nick andMobile:(NSString *)Mobile andAvatar:(NSString *)Avatar andSignature:(NSString *)Signature
{
    PersonMesCaches *perCaches = [[PersonMesCaches alloc]init];
    perCaches.sex = Sex;
    perCaches.age = Age;
    perCaches.nick = Nick;
    perCaches.mobile = Mobile;
    perCaches.avatar = Avatar;
    perCaches.signature = Signature;
    
    //获取文件路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //文件类型可以随便取，不一定要正确的格式
    NSString *targetPath = [docPath stringByAppendingPathComponent:@"mes.plist"];
    
    //将自定义对象保存在指定路径下
    [NSKeyedArchiver archiveRootObject:perCaches toFile:targetPath];
    NSLog(@"文件已储存");
}


//调支付
-(void)gotopay{
    ChuZiViewController *chuziVC = [[ChuZiViewController alloc] init];
    [self.navigationController pushViewController:chuziVC animated:YES];
}
@end
