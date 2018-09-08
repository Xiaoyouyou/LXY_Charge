//
//  UserGuideViewController.m
//  Charge
//
//  Created by olive on 17/1/13.
//  Copyright © 2017年 com.XinGuoXin.cn. All rights reserved.
//

#import "UserGuideViewController.h"
#import "XFunction.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "Masonry.h"
#import "NavView.h"
#import "API.h"

@interface UserGuideViewController ()<UIWebViewDelegate>

@property(strong,nonatomic) UIWebView * webView;

@end

@implementation UserGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.webView.backgroundColor = [UIColor redColor];
    
    //初始化自定义nav
    NavView *nav = [[NavView alloc] initWithFrame:CGRectZero title:@"用户指南"];
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
    
    [self creatUI];//创建UI
    
}

-(void)creatUI
{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, XYScreenWidth, XYScreenHeight-64)];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    NSURL *url = [[NSURL alloc] initWithString:UserGuide];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];

}

#pragma mark - webView代理

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    MYLog(@"webViewDidStartLoad");
    
      [MBProgressHUD showMessage:@"" toView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)web{
    
    MYLog(@"webViewDidFinishLoad");
      [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}

-(void)webView:(UIWebView*)webView  DidFailLoadWithError:(NSError*)error{
    
    MYLog(@"DidFailLoadWithError");
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:@"网络加载失败"];
    
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
