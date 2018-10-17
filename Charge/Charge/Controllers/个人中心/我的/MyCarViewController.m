//
//  MyCarViewController.m
//  Charge
//
//  Created by 罗小友 on 2018/10/15.
//  Copyright © 2018年 com.XinGuoXin.cn. All rights reserved.
//

#import "MyCarViewController.h"
#import "MyAddCarViewController.h"
#import "NavView.h"
#import "Masonry.h"

@interface MyCarViewController ()

@end

@implementation MyCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化nav
    NavView *nav = [[NavView alloc] initWithFrame:CGRectZero title:@"我的车辆" leftImgae:@"back@2x.png" rightButton:@"添加车辆"];
    nav.backBlock = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    nav.rightBlock = ^{
        NSLog(@"点击了右边的按钮");
        MyAddCarViewController *addCar = [[MyAddCarViewController alloc] init];
        [self.navigationController pushViewController:addCar animated:YES];
    };
    [self.view addSubview:nav];
    CGFloat statusH = [UIApplication sharedApplication].statusBarFrame.size.height + 44;
    [nav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(statusH);
    }];
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

@end
