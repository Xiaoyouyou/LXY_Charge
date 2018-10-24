//
//  MyAddCarViewController.m
//  Charge
//
//  Created by 罗小友 on 2018/10/17.
//  Copyright © 2018年 com.XinGuoXin.cn. All rights reserved.
//

#import "MyAddCarViewController.h"

@interface MyAddCarViewController ()

//输入车品牌
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

@end

@implementation MyAddCarViewController

//参数字典
-(NSMutableDictionary *)pamaer{
    if (!_pamaer) {
        _pamaer = [NSMutableDictionary dictionary];
    }
    return _pamaer;
}

//返回
- (IBAction)gobackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//确定按钮
- (IBAction)sureBtn:(id)sender {
//   NSString *str = [RSA encryptString:@"luoxianyou" publicKey:@"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnaLHjda2vJ/F0Vj2TCXsNUkWJKQwmD3Y52jYthayktjY7e9wwUR52t1cGADYshH/u03heeKPFXBH6dZg7L4ogy1Ad9/IcjQ3qfPw+uUaDNRFvC9JuErV7GdmU2siU8cDnSe/wn66vZWWZ8wl9+D+5xzCiq4Jjp61cQqEwhmClAwIDAQAB"];
//    NSLog(@"加密之后的字符串%@",str);
//    
//    NSString *str1 = [RSA decryptString:str publicKey:@"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAKdoseN1ra8n8XRWPZMJew1SRYkpDCYPdjnaNi2FrKS2Njt73DBRHna3VwYANiyEf+7TeF54o8VcEfp1mDsviiDLUB338hyNDep8/D65RoM1EW8L0m4StXsZ2ZTayJTxwOdJ7/Cfrq9lZZnzCX34P7nHMKKrgmOnrVxCoTCGYKUDAgMBAAECgYBz7qvqUk9SUj4DC8oebl1Z71SaVOPF48VC8Ru90Kmrc0gBT5g/mZ2YJwVL8Y+SqruR376m5bK8dTM6GH+w1Q444vd1IiUZRiT5pPgYLkQR/K0xD0cW4kB2jdaEi2NSI9UhjecnWO1W543qgY08LNIvM3oxPsn6OZAaV38xBa44uQJBANBKzJtVL7kia5Ne+SjbzJtteoEUwtee4ZCyTvxNQzc+Qdla8V0xGx2cAGO5y49UD1SF0RPv6YOk0kabuzPlkfUCQQDNwLXUS2j1tLQwSYqXla0xaXDaaIc93f3RnkEUqSV6GTQqGS2gEJHBBzkv35GAiS4nJIRSOZpvmsuh4v25gWgXAkAodX8M5R0h/veaZqZLM3ao8jkLfbbjHy99ZcVF6NQXlPZBfBLKIVG9DKJevKY3rwJTTrLwBnf7ZDacFH/mcr9JAkBBsNFc4ma0a+lLsW8qToNpTzzUvqLPQd0T2+7zZb2tafaZqkhC3odqlZ/QhRSzcRjnLmWAyxtfnpB9MzfGzmYpAkAmAZEWFYzLvFQ4S0rT9byIaEf+XLq6KKg+KlyxqC4ofvOkXa6ycTvwpNUubVZvLi2RdSn7PlEoJeHnC6r8037L"];
//    NSLog(@"解密之后的字符串%@",str1);
}
//选择车牌所在地
- (IBAction)carNumberAdress:(id)sender {
    //创建pickView
    
}
//选择车辆类
- (IBAction)searchCarBtn:(id)sender {
}
//充电类型
- (IBAction)carChargeType:(UIButton *)sender {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.carModels.delegate = self;
//    self.carNumber.delegate = self;
    self.carModels.tag = 123;
    self.carNumber.tag = 124;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)carModelsTextFiled:(UITextField *)sender forEvent:(UIEvent *)event {
    NSLog(@"----%@",sender.text);
}


@end
