//
//  MyAddCarViewController.m
//  Charge
//
//  Created by 罗小友 on 2018/10/17.
//  Copyright © 2018年 com.XinGuoXin.cn. All rights reserved.
//

#import "MyAddCarViewController.h"

@interface MyAddCarViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UIScrollView *backScrollView;
@property (strong, nonatomic) IBOutlet UITextField *carBrand;
//输入车型号
@property (strong, nonatomic) IBOutlet UITextField *carModels;
//选择车充类型
@property (weak, nonatomic) IBOutlet UIButton *searchCar;
//选择车辆类型
@property (strong, nonatomic) IBOutlet UIButton *carType;
//选择车牌所在地
@property (strong, nonatomic) IBOutlet UIButton *carNumberAddress;
//输入车牌号
@property (strong, nonatomic) IBOutlet UITextField *carNumber;
//确定按钮
@property (strong, nonatomic) IBOutlet UIButton *sureBtn;
//返回图片
@property (strong, nonatomic) IBOutlet UIButton *gobackBtn;

@property (nonatomic ,strong)NSMutableDictionary *pamaer;

//
//@property (nonatomic ,strong) UIButton *downBtn;
@property (nonatomic ,assign) BOOL keyboardVisiable;
@end

@implementation MyAddCarViewController

//参数字典
-(NSMutableDictionary *)pamaer{
    if (!_pamaer) {
        _pamaer = [NSMutableDictionary dictionary];
    }
    return _pamaer;
}
- (void) viewWillAppear:(BOOL)animated
{
    //注册键盘出现通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    //注册键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    //解除键盘出现通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    //解除键盘隐藏通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [super viewWillDisappear:animated];
}

- (void) keyboardDidShow:(NSNotification *) notif
{
   
    // 获得键盘尺寸
    NSDictionary *info = notif.userInfo;
    NSValue *aValue = [info objectForKeyedSubscript:UIKeyboardFrameEndUserInfoKey];
//    CGPoint keyboardOrigin = [aValue CGRectValue].origin;
    CGSize keyboardSize = [aValue CGRectValue].size;
    //重新定义ScrollView的尺寸
//    if (self.carBrand.frame.origin.y > keyboardOrigin.y ) {
//        CGFloat a = self.carBrand.frame.origin.y - keyboardOrigin.y + 30;
    if ([self.carNumber isFirstResponder]) {
        [self.backScrollView setContentOffset:CGPointMake(0,keyboardSize.height ) animated:YES];
    }
    
//    }
}

- (void) keyboardDidHide:(NSNotification *) notif
{
     [self.backScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark -- UITextFieldDelegate method
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.titles;
    //    self.carModels.delegate = self;
    //    self.carNumber.delegate = self;
    self.carBrand.tag = 123;
    self.carBrand.delegate = self;
    self.carModels.tag = 124;
    self.carModels.delegate = self;
    self.carNumber.tag = 125;
    self.carNumber.delegate = self;
    
    self.backScrollView.scrollEnabled = YES;
    
    //返回按钮裁圆角
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 6;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeKeyoBoard)];
    [self.backScrollView addGestureRecognizer:tap];
}





-(void)removeKeyoBoard{
    [self.carBrand resignFirstResponder];
    [self.carModels resignFirstResponder];
    [self.carNumber resignFirstResponder];
    NSLog(@"%@",@"移除键盘");
}

//返回
- (IBAction)gobackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//确定按钮
- (IBAction)sureBtn:(id)sender {
    [self.carNumber resignFirstResponder];
    [self.pamaer setValue:[Config getOwnID] forKey:@"userId"];
    NSLog(@"%@",self.pamaer);
//    [self.pamaer setValue:@"" forKey:@"userId"];
    if([self.titles isEqualToString:@"添加车辆"]){
        [WMNetWork post:ChargeAddMyCare parameters:self.pamaer success:^(id responseObj) {
            if([responseObj[@"status"] isEqualToString:@"0"]){
                [MBProgressHUD showSuccess:@"添加车辆成功"];
            }else if ([responseObj[@"status"] isEqualToString:@"1"]){
                [MBProgressHUD showSuccess:@"添加车辆失败"];
            }
        } failure:^(NSError *error) {
            
        }];
    }else if([self.titles isEqualToString:@"修改车辆"]){
         [self.pamaer setValue:@"13" forKey:@"id"];
        [WMNetWork post:ChargeEditMyCare parameters:self.pamaer success:^(id responseObj) {
            if([responseObj[@"status"] isEqualToString:@"0"]){
                [self.navigationController popViewControllerAnimated:YES];
                [MBProgressHUD showSuccess:@"修改车辆成功"];
            }else if ([responseObj[@"status"] isEqualToString:@"1"]){
                [MBProgressHUD showSuccess:@"修改车辆失败"];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    
    
   
    
    
    
}
//选择车牌所在地
- (IBAction)carNumberAdress:(id)sender {
    //创建pickView
    [self.carBrand resignFirstResponder];
    [self.carModels resignFirstResponder];
    [self.carNumber resignFirstResponder];
    
}
//选择车辆类

//车充类型
- (IBAction)carChargeType:(UIButton *)sender {
    [self.carBrand resignFirstResponder];
    [self.carModels resignFirstResponder];
    [self.carNumber resignFirstResponder];
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"请选择车充类型" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"直流" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.pamaer setValue:@"直流" forKey:@"electricizeType"];
        [self.searchCar setTitle:@"直流" forState:UIControlStateNormal];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"交流" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.searchCar setTitle:@"交流" forState:UIControlStateNormal];
        [self.pamaer setValue:@"交流" forKey:@"electricizeType"];
    }];
    
    [alertVc addAction:cancelAction];
    [alertVc addAction:sureAction];
    [self presentViewController:alertVc animated:YES completion:nil];
}
//车辆类型
- (IBAction)searchCarBtn:(id)sender {
    [self.carBrand resignFirstResponder];
    [self.carModels resignFirstResponder];
    [self.carNumber resignFirstResponder];
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"请选择车辆类型" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"个人" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.carType setTitle:@"个人" forState:UIControlStateNormal];
        [self.pamaer setValue:@"个人" forKey:@"type"];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"企业" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.carType setTitle:@"企业" forState:UIControlStateNormal];
        [self.pamaer setValue:@"企业" forKey:@"type"];
    }];
    
    [alertVc addAction:cancelAction];
    [alertVc addAction:sureAction];
    [self presentViewController:alertVc animated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{

}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 123) {
        NSString *str = [NSString stringWithFormat:@"%@",textField.text];
        [self.pamaer setValue:str forKey:@"brand"];
    }else if (textField.tag == 124){
        NSString *str = [NSString stringWithFormat:@"%@",textField.text];
        [self.pamaer setValue:str forKey:@"pattern"];
    }else if (textField.tag == 125){
        NSString *str = [NSString stringWithFormat:@"%@",textField.text];
        [self.pamaer setValue:str forKey:@"plateNumber"];
    }
    NSLog(@"----%@",textField.text);
}




@end
