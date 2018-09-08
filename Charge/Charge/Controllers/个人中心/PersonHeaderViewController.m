//
//  PersonHeaderViewController.m
//  Charge
//
//  Created by olive on 17/4/11.
//  Copyright © 2017年 com.XinGuoXin.cn. All rights reserved.
//

#import "PersonHeaderViewController.h"
#import "XFunction.h"
#import "Masonry.h"
#import "NavView.h"

@interface PersonHeaderViewController ()

@end

@implementation PersonHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    //初始化nav
    NavView *nav = [[NavView alloc] initWithFrame:CGRectZero title:@"个人头像"];
    nav.backBlock = ^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    };
    
    [self.view addSubview:nav];
    
    [nav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
    
    [self SomeThingSetting];
    
}

-(void)SomeThingSetting
{
    UIImageView *bgImgaeView = [[UIImageView alloc] init];
    bgImgaeView.image = [UIImage imageNamed:@""];
    [self.view addSubview:bgImgaeView];
    
    [bgImgaeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(self.view.frame.size.width);
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
