//
//  SGShareViewController.m
//  XiGuMobileGame
//
//  Created by 罗小友 on 2018/12/30.
//  Copyright © 2018 zhujin zhujin. All rights reserved.
//

#import "ChargeShareView.h"
#import <ShareSDK/ShareSDK.h>

@interface ChargeShareView ()
@end

@implementation ChargeShareView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self addShareView];
    }
    return self;
}


- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    for (UIView *views in self.subviews) {
        CGPoint childPoint = [self convertPoint:point toView:views];
        UIView *view = [views hitTest:childPoint withEvent:event];
        if(view) return view;
    }
    
    if(![self pointInside:point withEvent:event]){
        return nil;
    }
    return self;
}


-(void)addShareView{

    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XYScreenWidth, XYScreenHeight)];
    [self addSubview:bottomView];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, XYScreenWidth, XYScreenHeight);
    [bottomView addSubview:effectView];

    UIView *btnBackeView = [[UIView alloc]initWithFrame:CGRectMake(0, XYScreenHeight , XYScreenWidth, XYScreenHeight/2)];
    [bottomView addSubview:btnBackeView];

    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchDown];
    [cancelBtn setImage:[UIImage imageNamed:@"functionBtn"]  forState:UIControlStateNormal];
    [btnBackeView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(btnBackeView.mas_centerX);
        make.bottom.mas_equalTo(btnBackeView.mas_bottom).mas_offset(-37);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];

    UIView *assitView = [[UIView alloc]init];
    [btnBackeView addSubview:assitView];
    [assitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(XYScreenWidth * 0.75);
        make.height.mas_equalTo(200);
        make.top.mas_equalTo(btnBackeView.mas_top);
        make.centerX.mas_equalTo(btnBackeView.mas_centerX);
    }];
    
    
    
    UIButton *weixin = [UIButton buttonWithType:UIButtonTypeCustom];
    [weixin addTarget:self action:@selector(weixinShare) forControlEvents:UIControlEventTouchDown];
    [weixin setImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateNormal];
    [assitView addSubview:weixin];
    [weixin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.top.left.mas_equalTo(assitView);
    }];

    
    UIButton *friendCircle = [UIButton buttonWithType:UIButtonTypeCustom];
    [friendCircle addTarget:self action:@selector(friendcircle) forControlEvents:UIControlEventTouchDown];
    [friendCircle setImage:[UIImage imageNamed:@"friend"] forState:UIControlStateNormal];
    [assitView addSubview:friendCircle];
    [friendCircle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.top.mas_equalTo(assitView.mas_top);
        make.centerX.mas_equalTo(assitView.mas_centerX);
    }];

   

    [UIView animateWithDuration:0.2 animations:^{
        bottomView.alpha = 1.0;
        btnBackeView.frame =CGRectMake(0, XYScreenHeight/2 , XYScreenWidth, XYScreenHeight/2);
        [bottomView addSubview:btnBackeView];
    }];

}




-(void)cancel{

    [self  removeFromSuperview];
//    [UIView animateWithDuration:0.2 animations:^{
//        .alpha = 0.0;
//        _buttonView.frame =CGRectMake(0, K_ScreenHeight , K_ScreenWidth, K_ScreenHeight/2);
//    } completion:^(BOOL finished) {
//        [_BottomView removeFromSuperview];
//    }];
}


//微信分享
-(void)weixinShare{
    [self shareRequestWithType:SSDKPlatformSubTypeWechatSession];
}

////qq分享
//-(void)qq{
//    [self shareRequestWithType:SSDKPlatformSubTypeQQFriend];
//}

//朋友圈分享
-(void)friendcircle{
    [self shareRequestWithType:SSDKPlatformSubTypeWechatTimeline];
}

////QQ空间分享
//-(void)qqSpace{
//    [self shareRequestWithType:SSDKPlatformSubTypeQZone];
//}
//
////新浪微博分享
//-(void)sina{
//    [self shareRequestWithType:SSDKPlatformTypeSinaWeibo];
//}


-(void)shareRequestWithType:(SSDKPlatformType)type{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //通用参数设置
    [parameters SSDKSetupShareParamsByText:self.msg
                                    images:self.icon
                                       url:[NSURL URLWithString:self.url]
                                     title:self.title1
                                      type:SSDKContentTypeWebPage];
    [ShareSDK share:type
         parameters:parameters
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//                  if(state == SSDKResponseStateBeginUPLoad){
//                      return ;
//                  }
         switch (state) {
             case SSDKResponseStateSuccess:
             {

                 [MBProgressHUD showSuccess:@"分享成功"];
                 [self cancel];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 break;
             }
             case SSDKResponseStateFail:
             {
                 [MBProgressHUD showSuccess:@"分享失败"];
                 NSLog(@"error=========%@",error);
                 break;
             }
             default:
                 break;
         }
     }];
}

@end
