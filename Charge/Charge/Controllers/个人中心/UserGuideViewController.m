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
#import <WebKit/WebKit.h>
@interface UserGuideViewController ()<WKNavigationDelegate>

@property(strong,nonatomic) WKWebView * webView;

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
        make.height.mas_equalTo(StatusBarH +44);
    }];
    
    [self creatUI];//创建UI
    
}

-(void)creatUI
{
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, StatusBarH +  44, XYScreenWidth, XYScreenHeight - StatusBarH - 44)];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
    NSURL *url = [[NSURL alloc] initWithString:UserGuide];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];

}

#pragma mark - webView代理

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
   
    [MBProgressHUD showMessage:@"" toView:self.view];
      //修改图片的大小（会变形的）
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
  dispatch_async(dispatch_get_main_queue(), ^{
       
   });
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
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
