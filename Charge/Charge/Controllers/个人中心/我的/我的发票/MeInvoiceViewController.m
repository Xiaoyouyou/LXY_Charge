//
//  MeInvoiceViewController.m
//  Charge
//
//  Created by 罗小友 on 2018/11/3.
//  Copyright © 2018 com.XinGuoXin.cn. All rights reserved.
//

#import "MeInvoiceViewController.h"

@interface MeInvoiceViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *shibieNumber;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *invoicePrice;
@property (strong, nonatomic) IBOutlet UIButton *chooseType;
@property (strong, nonatomic) IBOutlet UIButton *choosInvoiceType;
@property (strong, nonatomic) IBOutlet UITextField *kaiTou;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *shiBieHao;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *address;
@property (strong, nonatomic) IBOutlet UIButton *chooseEmailType;

@property (strong, nonatomic) IBOutlet UITextField *beizhu;
@property (strong, nonatomic) NSMutableDictionary *pamaer;
@end

@implementation MeInvoiceViewController
//参数字典
-(NSMutableDictionary *)pamaer{
    if (!_pamaer) {
        _pamaer = [NSMutableDictionary dictionary];
    }
    return _pamaer;
}

- (IBAction)upLoadBtnClick:(UIButton *)sender {
    //提交开发票申请
    [self.pamaer setValue:[Config getMobile] forKey:@"phone"];
    [self.pamaer setValue:@"顺风" forKey:@"express"];
    NSLog(@"%@",self.pamaer);
    //    [self.pamaer setValue:@"" forKey:@"userId"];
    [WMNetWork post:ChargeInvoiceList parameters:self.pamaer success:^(id responseObj) {
        if([responseObj[@"status"] isEqualToString:@"0"]){
            [MBProgressHUD showSuccess:responseObj[@"msg"]];
        }else if ([responseObj[@"status"] isEqualToString:@"1"]){
            [MBProgressHUD showSuccess:@"开发票申请失败"];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.pamaer setValue:@"0" forKey:@"companyType"];
    [self.pamaer setValue:@"0" forKey:@"invType"];
    NavView *nav = [[NavView alloc] initWithFrame:CGRectZero title:@"申请开发票"];
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
    
    
    [super viewDidLoad];
    //    self.carModels.delegate = self;
    //    self.carNumber.delegate = self;
    self.invoicePrice.tag = 10;
    self.invoicePrice.delegate = self;
    self.kaiTou.tag = 11;
    self.kaiTou.delegate = self;
    self.email.tag = 12;
    self.email.delegate = self;
    self.address.tag = 13;
    self.address.delegate = self;
    self.shibieNumber.tag = 14;
    self.shibieNumber.delegate = self;
    self.beizhu.tag = 15;
    self.beizhu.delegate = self;
    
  
    self.scrollView.scrollEnabled = YES;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeKeyoBoard)];
    [self.scrollView addGestureRecognizer:tap];
    
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
//    CGSize keyboardSize = [aValue CGRectValue].size;
    //重新定义ScrollView的尺寸
    //    if (self.carBrand.frame.origin.y > keyboardOrigin.y ) {
    //        CGFloat a = self.carBrand.frame.origin.y - keyboardOrigin.y + 30;
    if ([self.email isFirstResponder]) {
        [self.scrollView setContentOffset:CGPointMake(0,20 ) animated:YES];
    }
    if ([self.address isFirstResponder]) {
        [self.scrollView setContentOffset:CGPointMake(0,70 ) animated:YES];
    }
    if ([self.beizhu isFirstResponder]) {
        [self.scrollView setContentOffset:CGPointMake(0,180 ) animated:YES];
    }
    
    //    }
}

- (void) keyboardDidHide:(NSNotification *) notif
{
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark -- UITextFieldDelegate method
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}






-(void)removeKeyoBoard{
    [self.invoicePrice resignFirstResponder];
    [self.address resignFirstResponder];
    [self.email resignFirstResponder];
    [self.kaiTou resignFirstResponder];
    [self.shibieNumber resignFirstResponder];
    [self.beizhu resignFirstResponder];
    NSLog(@"%@",@"移除键盘");
}



//选择车牌所在地
- (IBAction)carNumberAdress:(id)sender {
    //创建pickView
    [self.invoicePrice resignFirstResponder];
    [self.address resignFirstResponder];
    [self.email resignFirstResponder];
    [self.kaiTou resignFirstResponder];
    [self.shibieNumber resignFirstResponder];
    [self.beizhu resignFirstResponder];
    
}
//选择车辆类

//车充类型
- (IBAction)carChargeType:(UIButton *)sender {
    [self.invoicePrice resignFirstResponder];
    [self.address resignFirstResponder];
    [self.email resignFirstResponder];
    [self.kaiTou resignFirstResponder];
    [self.shibieNumber resignFirstResponder];
    [self.beizhu resignFirstResponder];
    [self.shibieNumber resignFirstResponder];
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"请选择发票性质" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"个人" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.pamaer setValue:@"0" forKey:@"companyType"];
        [self.chooseType setTitle:@"个人" forState:UIControlStateNormal];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"企业" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.chooseType setTitle:@"企业" forState:UIControlStateNormal];
        [self.pamaer setValue:@"1" forKey:@"companyType"];
    }];
    
    [alertVc addAction:cancelAction];
    [alertVc addAction:sureAction];
    [self presentViewController:alertVc animated:YES completion:nil];
}
//车辆类型
- (IBAction)searchCarBtn:(id)sender {
    [self.invoicePrice resignFirstResponder];
    [self.address resignFirstResponder];
    [self.email resignFirstResponder];
    [self.kaiTou resignFirstResponder];
    [self.shibieNumber resignFirstResponder];
    [self.beizhu resignFirstResponder];
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"请选择发票类型" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"纸质发票" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.choosInvoiceType setTitle:@"纸质发票" forState:UIControlStateNormal];
        [self.pamaer setValue:@"1" forKey:@"invType"];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"电子发票" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.choosInvoiceType setTitle:@"电子发票" forState:UIControlStateNormal];
        [self.pamaer setValue:@"0" forKey:@"invType"];
    }];
    
    [alertVc addAction:cancelAction];
    [alertVc addAction:sureAction];
    [self presentViewController:alertVc animated:YES completion:nil];
}


- (IBAction)ChooseEmailTypeBtn:(UIButton *)sender {
//key: express
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
//    ：开票的金额（数字类型，必传）
//    ：开票类型（0企业，1个人，必传）
//    ：发票类型（0电子发票，1纸质发票，必传）
//    ：发票抬头，必传
//    ：税号，开票类型为企业时必传
//    ：提交人电话，必传
//    ：电子邮件，发票类型为电子发票时必传
//    ：联系地址，发票类型为纸质发票时必传
//    ：备注信息，选传
//    ：快递（如圆通，申通，顺丰等），发票类型为纸质发票时必传
    if (textField.tag == 10) {
        NSString *str = [NSString stringWithFormat:@"%@",textField.text];
        [self.pamaer setValue:str forKey:@"price"];
    }else if (textField.tag == 11){
        NSString *str = [NSString stringWithFormat:@"%@",textField.text];
        [self.pamaer setValue:str forKey:@"invTitle"];
    }else if (textField.tag == 12){
        NSString *str = [NSString stringWithFormat:@"%@",textField.text];
        [self.pamaer setValue:str forKey:@"email"];
    }else if (textField.tag == 13){
        NSString *str = [NSString stringWithFormat:@"%@",textField.text];
        [self.pamaer setValue:str forKey:@"address"];
    }else if (textField.tag == 14){
        NSString *str = [NSString stringWithFormat:@"%@",textField.text];
        [self.pamaer setValue:str forKey:@"taxNumber"];
    }else if (textField.tag == 15){
        NSString *str = [NSString stringWithFormat:@"%@",textField.text];
        [self.pamaer setValue:str forKey:@"note"];
    }
    
    NSLog(@"----%@",textField.text);
}



@end
