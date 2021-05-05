//
//  AppAgreementViewController.m
//  Charge
//
//  Created by olive on 16/9/2.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "AppAgreementViewController.h"
#import "XFunction.h"
#import "NavView.h"
#import "Masonry.h"
#import <WebKit/WebKit.h>
@interface AppAgreementViewController ()<WKNavigationDelegate>

@property (nonatomic,strong) WKWebView *webView;

@end

@implementation AppAgreementViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
  //  self.title = @"软件许可及服务协议";
 //   UIImage *image = [UIImage imageNamed:@"back"];
  //  image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
  //  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    //初始化自定义nav
    NavView *nav = [[NavView alloc] initWithFrame:CGRectZero title:@"软件许可及服务协议"];
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

    [self creatUI];//创建UI
}

#pragma mark - Action

-(void)creatUI
{
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, StatusBarH + 44, XYScreenWidth, XYScreenHeight-64)];
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    
    NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"protocol" ofType:@"html"];
    NSURL *localurl = [NSURL fileURLWithPath:filePath isDirectory:NO];
    [self.webView loadRequest:[NSURLRequest requestWithURL:localurl]];
    
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
