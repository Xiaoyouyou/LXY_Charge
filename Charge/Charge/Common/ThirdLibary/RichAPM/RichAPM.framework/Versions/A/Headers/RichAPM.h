//
//  RichInfoAPM.h
//  Richinfo APM
//
//  Created by xieweizhi on 7/16/15.
//  Copyright © 2015 xieweizhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RichAPM : NSObject

//! 开启监控
+ (void)startWithAppID:(NSString *)appID;

//! 返回当前RichAPM的appID
+ (NSString *)appID;

//! Upload data when connected via WIFI.(只在WIFI下上报数据)
+ (void)setUploadDataWIFIOnly:(BOOL)wifiOnly;

@end
