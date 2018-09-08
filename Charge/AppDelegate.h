//
//  AppDelegate.h
//  Charge
//
//  Created by olive on 16/6/3.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

typedef void (^WXPayResultBlock) (int errCode);
typedef void (^WXSendAuthRespResultBlock) (NSString* code,int errcode);

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
  BMKMapManager* _mapManager;
}

@property (strong, nonatomic) UIWindow *window;
@property (copy,nonatomic)WXPayResultBlock wxPayResultBlock;//微信支付回调
@property (copy,nonatomic)WXSendAuthRespResultBlock wxSendAuthRespResultBlock;//微信第三方登陆回调

@end

