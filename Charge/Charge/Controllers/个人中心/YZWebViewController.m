//
//  YZWebViewController.m
//  Charge
//
//  Created by 罗小友 on 2019/3/16.
//  Copyright © 2019 com.XinGuoXin.cn. All rights reserved.
//

#import "YZWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>
@interface YZWebViewController ()<WKNavigationDelegate,WKScriptMessageHandler,WKUIDelegate>
//@property (nonatomic ,strong)WKWebView *webView;
@end

@implementation YZWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置偏好设置
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // 默认为0
    config.preferences.minimumFontSize = 10;
    //是否支持JavaScript
    config.preferences.javaScriptEnabled = YES;
    //不通过用户交互，是否可以打开窗口
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    //JS调用OC 添加处理脚本
    
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, XYScreenWidth, XYScreenHeight) configuration:config];
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    
    NSString *filePath  = [NSString stringWithFormat:@"%@%@%@",H5BaseURL,@"/refund_submit.jsp?userId=",[Config getOwnID]];
    NSURL *localurl = [NSURL URLWithString:filePath];
    [webView loadRequest:[NSURLRequest requestWithURL:localurl]];
    
    
    
    WKUserContentController *userCC = config.userContentController;
    [userCC addScriptMessageHandler:self name:@"goBack"];
}


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"%@",NSStringFromSelector(_cmd));
    NSLog(@"%@",message.body);
    //登录
    if ([message.name isEqualToString:@"goBack"]) {
        dispatch_async( dispatch_get_main_queue(), ^{
             [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

@end
