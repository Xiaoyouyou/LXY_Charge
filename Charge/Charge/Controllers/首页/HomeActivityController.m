//
//  HomeActivityController.m
//  Charge
//
//  Created by 罗小友 on 2019/5/7.
//  Copyright © 2019 com.XinGuoXin.cn. All rights reserved.
//

#import "HomeActivityController.h"

@interface HomeActivityController ()

@end

@implementation HomeActivityController


- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化自定义nav
    NavView *nav = [[NavView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) title:_name rightTitle:@"分享"];
    nav.backBlock = ^{
        [self.navigationController popViewControllerAnimated:YES];
    };
    nav.rightBlock = ^{
        //分享到朋友圈和微信
    };
    [self.view addSubview:nav];
    [nav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(StatusBarH + 44);
    }];
    
    
    //添加webView
    UIWebView *webView = [[UIWebView alloc] init];
    //    webView.delegate = self;
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(nav.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    NSURL *localurl = [NSURL URLWithString:_url];
    [webView loadRequest:[NSURLRequest requestWithURL:localurl]];
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
