//
//  YZWebViewController.m
//  Charge
//
//  Created by 罗小友 on 2019/3/16.
//  Copyright © 2019 com.XinGuoXin.cn. All rights reserved.
//

#import "YZWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface YZWebViewController ()<UIWebViewDelegate>
@property (nonatomic ,strong)UIWebView *webView;
@end

@implementation YZWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, XYScreenWidth, XYScreenHeight)];
    webView.delegate = self;
    [self.view addSubview:webView];
    
    NSString *filePath  = [NSString stringWithFormat:@"%@%@%@",H5BaseURL,@"/refund_submit.jsp?userId=",[Config getOwnID]];
    NSURL *localurl = [NSURL URLWithString:filePath];
    [webView loadRequest:[NSURLRequest requestWithURL:localurl]];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //提供一个方法给H5调用
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //定义好JS要调用的方法, share就是调用的share方法名

    context[@"goBack"] = ^() {
        dispatch_async( dispatch_get_main_queue(), ^{
             [self.navigationController popViewControllerAnimated:YES];
        });
       
    };
}


@end
