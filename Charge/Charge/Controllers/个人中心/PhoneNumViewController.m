//
//  PhoneNumViewController.m
//  Charge
//
//  Created by olive on 16/6/27.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "PhoneNumViewController.h"
#import "ReplacePhoneNumViewController.h"
#import "Config.h"
#import "NavView.h"
#import "Masonry.h"

@interface PhoneNumViewController ()

@property (strong, nonatomic) IBOutlet UILabel *nowPhoneNumLab; //当前手机号
@property (strong, nonatomic) IBOutlet UIButton *sureBtn;

- (IBAction)sureBtnActionClick:(id)sender;

@end

@implementation PhoneNumViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  //  self.title = @"手机号";
   // UIImage *image = [UIImage imageNamed:@"back"];
  //  image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
  //  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    //初始化自定义nav
    NavView *nav = [[NavView alloc] initWithFrame:CGRectZero title:@"手机号"];
    nav.backBlock = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:nav];
    
    [nav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
    
    NSString *tempPhone = [Config getMobile];
    NSString *newPhone = [tempPhone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    
    self.nowPhoneNumLab.text = [NSString stringWithFormat:@"您当前的手机号为  %@",newPhone];
    [self someSetting];
}

-(void)someSetting
{
    self.sureBtn.layer.cornerRadius = 5;
    self.sureBtn.layer.masksToBounds = YES;
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

- (IBAction)sureBtnActionClick:(id)sender {
    ReplacePhoneNumViewController *replaceVC = [[ReplacePhoneNumViewController alloc] init];
    [self.navigationController pushViewController:replaceVC animated:YES];
}
@end
