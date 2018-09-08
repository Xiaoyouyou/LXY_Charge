//
//  StartSearchViewController.h
//  Charge
//
//  Created by olive on 16/7/8.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "WKAvoidKeyboardViewController.h"

@interface StartSearchViewController : UIViewController<BMKMapViewDelegate, BMKPoiSearchDelegate>

@property (nonatomic, copy) void (^qiDianBlock)(NSString *);

@end
