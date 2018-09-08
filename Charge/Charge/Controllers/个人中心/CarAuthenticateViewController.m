//
//  CarAuthenticateViewController.m
//  Charge
//
//  Created by olive on 16/6/28.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "CarAuthenticateViewController.h"
#import "XFunction.h"
#import "WMNetWork.h"
#import "MBProgressHUD+MJ.h"
#import "NSDate+Helper.h"
#import "API.h"

@interface CarAuthenticateViewController ()
@property (strong, nonatomic) IBOutlet UITextField *xingMinTextField;//姓名
@property (strong, nonatomic) IBOutlet UITextField *jiaShiTextField;//驾驶车型
@property (strong, nonatomic) IBOutlet UITextField *cheLiangTypeTextField;//车辆型号
@property (strong, nonatomic) IBOutlet UITextField *buyYearTextField;//购买年限
@property (strong, nonatomic) IBOutlet UITextField *huiYuanTextField;//会员
@property (strong, nonatomic) IBOutlet UIButton *jiaoLiuBtn;//交流按钮
@property (strong, nonatomic) IBOutlet UIButton *zhiLiuBtn;//直流按钮


@property (strong, nonatomic) IBOutlet UIView *yearSelectTapView;
@property (strong, nonatomic) IBOutlet UIView *xingMinView;
@property (strong, nonatomic) IBOutlet UIView *jiaShiView;
@property (strong, nonatomic) IBOutlet UIView *cheChongTypeView;
@property (strong, nonatomic) IBOutlet UIView *huiYuanNumView;
@property (strong, nonatomic) IBOutlet UIView *buyYearView;
@property (strong, nonatomic) IBOutlet UIButton *registerBtn;

@property (assign, nonatomic) BOOL iszhiliu;
@property (assign, nonatomic) BOOL isjiaoliu;

- (IBAction)registerAction:(id)sender;
- (IBAction)tapJiaoLiuBtn:(id)sender;
- (IBAction)tapZhiLiuBtn:(id)sender;

@end

@implementation CarAuthenticateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"车主认证";
    UIImage *image = [UIImage imageNamed:@"back"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    //倒圆角
    [self daoYuanJiao];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(creatPickerView)];
    [self.yearSelectTapView addGestureRecognizer:tap];
    
}

-(void)daoYuanJiao
{
    self.xingMinView.layer.cornerRadius = 5;
    self.xingMinView.clipsToBounds = YES;
    
    self.jiaShiView.layer.cornerRadius = 5;
    self.jiaShiView.clipsToBounds = YES;
    
    self.cheChongTypeView.layer.cornerRadius = 5;
    self.cheChongTypeView.clipsToBounds = YES;
    
    self.huiYuanNumView.layer.cornerRadius = 5;
    self.huiYuanNumView.clipsToBounds = YES;
    
    self.buyYearView.layer.cornerRadius = 5;
    self.buyYearView.clipsToBounds = YES;
    
    self.registerBtn.layer.cornerRadius = 5;
    self.registerBtn.clipsToBounds = YES;
}

-(void)creatPickerView
{
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.datePickerMode = UIDatePickerModeDate;
    
    picker.frame = CGRectMake(0, 40, 320, 200);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSDate *date = picker.date;
        
        self.buyYearTextField.text = [date stringWithFormat:@"yyyy-MM-dd"];;
        
    }];
    [alertController.view addSubview:picker];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark - action
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)registerAction:(id)sender {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"该功能未开通" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    //    一个uialertAction对象对应一个按钮
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];

    
    [alertVc addAction:sureAction];
    //    调用self的方法展现控制器
    [self presentViewController:alertVc animated:YES completion:^{
        
    }];

    

    
}


- (IBAction)tapJiaoLiuBtn:(id)sender {
    
    self.isjiaoliu = YES;
    self.iszhiliu = NO;
    [self.jiaoLiuBtn setTitleColor:RGBA(29, 167, 146, 1) forState:UIControlStateNormal];
    [self.jiaoLiuBtn setImage:[UIImage imageNamed:@"jiaoliuquan@2x.png"] forState:UIControlStateNormal];
    
    [self.zhiLiuBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.zhiLiuBtn setImage:[UIImage imageNamed:@"zhiliuquan@2x.png"] forState:UIControlStateNormal];
    
}

- (IBAction)tapZhiLiuBtn:(id)sender {
    
    self.isjiaoliu = NO;
    self.iszhiliu = YES;
    [self.jiaoLiuBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.jiaoLiuBtn setImage:[UIImage imageNamed:@"heiquan@2x.png"] forState:UIControlStateNormal];
    
    [self.zhiLiuBtn setTitleColor:RGBA(29, 167, 146, 1) forState:UIControlStateNormal];
    [self.zhiLiuBtn setImage:[UIImage imageNamed:@"lvQuan@2x.png"] forState:UIControlStateNormal];
    
}

#pragma mark - textField代理

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.xingMinTextField resignFirstResponder];
    [self.jiaShiTextField resignFirstResponder];
    [self.cheLiangTypeTextField resignFirstResponder];
    [self.huiYuanTextField resignFirstResponder];
    
    return YES;
}



@end
