//
//  Config.h
//  Charge
//
//  Created by olive on 15/10/9.
//  Copyright © 2015年 XingGuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

@interface Config : NSObject

////保存手动输入的充电桩号
//+(void)saveInPutChargeNum:(NSString *)ChargeNum;
////获得保存输入的充电桩号
//+(NSString* )getInPutChargeNum;
////移除输入的充电桩号
//+(void)removeInPutChargeNum;


//保存第三方登陆类型
+(void)saveThirdLoginType:(NSString *)LoginType;
//获取第三方登陆类型
+(NSString* )getThirdLoginType;
//移除第三方登陆类型
+(void)removeThirdLoginType;


//保存预约结束时间
+(void)saveYuYueEndTime:(NSString *)EndTime;
//获取预约结束时间
+(NSString* )getYuYueEndTime;
//移除预约结束时间
+(void)removeYuYueEndTime;


//保存token
+(void)saveYuYueFlag:(NSString *)Flag;
//获取token
+(NSString* )getYuYueFlag;
//移除token
+(void)removeYuYueFlag;


//保存token
+(void)saveToken:(NSString *)Token;
//获取token
+(NSString* )getToken;
//移除token
+(void)removetoken;


//保存正常结束标志位
+(void)saveNormalEndChargingFlag:(NSString *)flag;
//获取正常结束标志位
+(NSString* )getNormalEndChargingFlag;
//移除正常结束标志位
+(void)removeNormalEndChargingFlag;

//保存当前时间
+(void)saveCurrentDate:(NSDate *)Currentdate;
//获取当前时间
+(NSDate* )getCurrentDate;
//移除当前时间
+(void)removeCurrentDate;

//保存当前充电电量
+(void)saveCurrentPower:(NSString *)CurrentPower;
//获取当前充电电量
+(NSString* )getCurrentPower;
//移除当前充电电量
+(void)removeCurrentPower;

//保存当前充电电费
+(void)saveChargePay:(NSString *)ChargePay;
//获取当前充电电费
+(NSString* )getChargePay;
//移除当前充电电费
+(void)removeChargePay;


//保存当前充电桩桩号
+(void)saveChargeNum:(NSString *)ChargeNum;
//获取当前充电桩桩号
+(NSString* )getChargeNum;
//移除当前充电桩桩号
+(void)removeChargeNum;




//保存手机号
+ (void)saveMobile:(NSString *)mobile;
//获取手机号
+(NSString*)getMobile;


//保存账号
+ (void)saveOwnAccount:(NSString *)account;
//获取账号
+(NSString*)getOwnAccount;


//保存用户头像
+ (void)savePortrait:(NSString *)portrait;
//获取用户头像
+ (NSString *)getPortrait;


//保存用户ID
+(void)saveOwnID:(NSString*)userID;
//获取用户ID
+(NSString*)getOwnID;
//移除用户ID
+(void)removeOwnID;


//保存用户充电状态
+(void)saveUseCharge:(NSString *)chargeing;
//获取用户用户充电状态
+(NSString*)getUseCharge;
//移除用户充电状态
+(void)removeUseCharge;




//保存用户名字
+(void)saveUseName:(NSString *)useName;
//获取用户名字
+(NSString *)getUseName;


+(void)removeUseName;
/**
 *  //保存第三方登陆的ID
 *
 *  @param ID iD
 */
+(void)saveThirdLoginID:(NSString*)ID;
/**
 *  获取第三方登陆的ID
 *
 *  @return ID
 */
+(NSString*)getThirdLoginID;
/**
 *  保存用户当前的位置
 *
 *  @param location 位置
 */
+(void)saveCurrentLocation:(BMKUserLocation*)locations;
/**
 *  获取当前的位置
 *
 *  @return 位置
 */
+(CLLocationCoordinate2D)getCurrentLocation;


//保存用户自己的邀请码
+(void)saveUserInviteCode:(NSString *)inviteCode;
//获取用户自己的邀请码
+(NSString*)getInviteCode;
//移除用户自己的邀请码
+(void)removeInviteCode;


//保存电费
+(void)saveElecMoney:(NSString *)elecMoney;
//获取电费
+(NSString*)getelecMoney;
//移除电费
+(void)removeElecMoney;


//保存服务费
+(void)savesServiceMoney:(NSString *)serviceMoney;
//获取服务费
+(NSString*)getfuwufei;
//移除服务费
+(void)removeServiceMoney;



//保存服务优惠费
+(void)saveDiscountMoney:(NSString *)discountMoney;
//获取服务优惠费
+(NSString*)getfuwufeiyouhui;
//移除服务优惠费
+(void)removeIDiscountMoney;





@end
