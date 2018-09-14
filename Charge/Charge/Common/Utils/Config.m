//
//  Config.m
//  Charge
//
//  Created by olive on 15/10/9.
//  Copyright © 2015年 XingGuo. All rights reserved.
//

#import "Config.h"

NSString *const KService = @"xingguo";
NSString *const KAccount = @"account";
NSString *const KPortrait = @"portrait";

NSString *const KUserID = @"userID";


NSString *const KThirdLoginID = @"ThirdLoginID";

NSString *const KUserLocation = @"userLocation";
NSString *const KUserName = @"userName";
NSString *const KMobile = @"mobile";

NSString *const KChargeType = @"ChargeingType"; //用户充电状态
NSString *const KCurrentDate = @"KCurrentDate"; //当前时间

NSString *const KCurrentPower = @"KCurrentPower";//当前电量

NSString *const KCurrentPay = @"KCurrentPay";//当前电费

NSString *const KCurrentChargeNum = @"KCurrentChargeNum";//当前充电的充电桩号

NSString *const KCurrentEndChargeFlag = @"KCurrentEndChargeFlag";//正常结束标志位

NSString *const KToken = @"KToken";//用户登陆后的token标示

NSString *const YuYueFlags = @"YuYueFlags";//预约标志位

NSString *const YuYueEndTime = @"YuYueEndTime";//预约结束时间
NSString *const IntChargeNum = @"IntChargeNum";//输入的充电桩号

NSString *const ThirdLoginType = @"ThirdLoginType";//第三方登陆状态


@implementation Config

+(void)saveThirdLoginID:(NSString *)ID{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    [userDefaults setObject:ID forKey:KThirdLoginID];
    [userDefaults synchronize];
}
+(NSString*)getThirdLoginID{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *ID = [userDefaults objectForKey:KThirdLoginID];
    
    if (ID) {return ID;}
    return nil;
}
+(void)saveOwnAccount:(NSString *)account
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:account forKey:KAccount];
    [userDefaults synchronize];
    
//    [SSKeychain setPassword:password forService:KService account:account];
}

+(NSString*)getOwnAccount
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *account = [userDefaults objectForKey:KAccount];
    
//    NSString *password = [SSKeychain passwordForService:KService account:account];
//    if (account) {
//        return @[account,password];
//    }
    
//    if (account) {
      return account;
//    }
//    return nil;
}

+(void)savePortrait:(NSString *)portrait
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:portrait forKey:KPortrait];
    [userDefaults synchronize];
    
}
+ (NSString *)getPortrait
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *portrait = [userDefaults objectForKey:KPortrait];
    
    return portrait;
}

+(void)saveOwnID:(NSString*)userID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:userID forKey:KUserID];
    
    [userDefaults synchronize];

}
+(NSString*)getOwnID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [userDefaults objectForKey:KUserID];
    
    if (userID) {return userID;}
    return nil;

}
+(void)removeOwnID{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:nil forKey:KUserID];
}


+(void)saveUseName:(NSString *)useName;
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:useName forKey:KUserName];
    
    [userDefaults synchronize];

}

+(NSString *)getUseName
{
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     NSString *UseName = [userDefaults objectForKey:KUserName];
    
    return UseName;
}


+(void)removeUseName{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:nil forKey:KUserName];

}

+ (void)saveMobile:(NSString *)mobile
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:mobile forKey:KMobile];
    
    [userDefaults synchronize];
    
}

//获取
+(NSString*)getMobile
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mobile = [userDefaults objectForKey:KMobile];
    
    return mobile;
}

//保存用户充电状态
+(void)saveUseCharge:(NSString *)chargeing
{
    NSUserDefaults *UseCharge = [NSUserDefaults standardUserDefaults];
    [UseCharge setObject:chargeing forKey:KChargeType];
    [UseCharge synchronize];
    
}
//移除用户充电状态
+(void)removeUseCharge
{
    NSUserDefaults *UseCharge = [NSUserDefaults standardUserDefaults];
    [UseCharge setObject:nil forKey:KChargeType];
}
//获取用户充电状态
+(NSString*)getUseCharge
{
    NSUserDefaults *UseCharge = [NSUserDefaults standardUserDefaults];
    NSString *use = [UseCharge objectForKey:KChargeType];
    return use;
}

//保存当前时间
+(void)saveCurrentDate:(NSDate *)Currentdate
{
    NSUserDefaults *date = [NSUserDefaults standardUserDefaults];
    [date setObject:Currentdate forKey:KCurrentDate];
    [date synchronize];
}

//获取当前时间
+(NSDate* )getCurrentDate
{
    NSUserDefaults *newDate = [NSUserDefaults standardUserDefaults];
    NSDate *date = [newDate objectForKey:KCurrentDate];
    return date;
    
}
//移除当前时间
+(void)removeCurrentDate
{
    NSUserDefaults *CurrentDate = [NSUserDefaults standardUserDefaults];
    [CurrentDate setObject:nil forKey:KCurrentDate];
}


//保存当前充电电量
+(void)saveCurrentPower:(NSString *)CurrentPower
{
    NSUserDefaults *power = [NSUserDefaults standardUserDefaults];
    [power setObject:CurrentPower forKey:KCurrentPower];
    [power synchronize];
}
//获取当前充电电量
+(NSString* )getCurrentPower
{
    NSUserDefaults *power = [NSUserDefaults standardUserDefaults];
    NSString *str = [power objectForKey:KCurrentPower];
    return str;
}
//移除当前充电电量
+(void)removeCurrentPower
{
    NSUserDefaults *CurrentPower = [NSUserDefaults standardUserDefaults];
    [CurrentPower setObject:nil forKey:KCurrentPower];
}

//保存当前充电电费
+(void)saveChargePay:(NSString *)ChargePay
{
    NSUserDefaults *pay = [NSUserDefaults standardUserDefaults];
    [pay setObject:ChargePay forKey:KCurrentPay];
    [pay synchronize];
}
//获取当前充电电费
+(NSString* )getChargePay
{
    NSUserDefaults *pay = [NSUserDefaults standardUserDefaults];
    NSString *str = [pay objectForKey:KCurrentPay];
    return str;
}
//移除当前充电电费
+(void)removeChargePay
{
    NSUserDefaults *CurrentPay = [NSUserDefaults standardUserDefaults];
    [CurrentPay setObject:nil forKey:KCurrentPay];
}

//保存当前充电桩桩号
+(void)saveChargeNum:(NSString *)ChargeNum
{
    NSUserDefaults *Num = [NSUserDefaults standardUserDefaults];
    [Num setObject:ChargeNum forKey:KCurrentChargeNum];
    [Num synchronize];
   
}
//获取当前充电桩桩号
+(NSString* )getChargeNum
{
    NSUserDefaults *Num = [NSUserDefaults standardUserDefaults];
    NSString *NumStr = [Num objectForKey:KCurrentChargeNum];
    return NumStr;

}
//移除当前充电桩桩号
+(void)removeChargeNum
{
    NSUserDefaults *CurrentNum = [NSUserDefaults standardUserDefaults];
    [CurrentNum setObject:nil forKey:KCurrentChargeNum];
}


//保存正常结束标志位
+(void)saveNormalEndChargingFlag:(NSString *)flag
{
    NSUserDefaults *flagNum = [NSUserDefaults standardUserDefaults];
    [flagNum setObject:flag forKey:KCurrentEndChargeFlag];
    [flagNum synchronize];
}


//获取正常结束标志位
+(NSString* )getNormalEndChargingFlag
{
    NSUserDefaults *ChargingFlag = [NSUserDefaults standardUserDefaults];
    NSString *NumStr = [ChargingFlag objectForKey:KCurrentEndChargeFlag];
    return NumStr;
}
//移除正常结束标志位
+(void)removeNormalEndChargingFlag
{
    NSUserDefaults *ChargingFlag = [NSUserDefaults standardUserDefaults];
    [ChargingFlag setObject:nil forKey:KCurrentEndChargeFlag];
}


+(void)saveCurrentLocation:(BMKUserLocation *)locations{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@{@"latitude":[NSNumber numberWithDouble:locations.location.coordinate.latitude],@"longitude":[NSNumber numberWithDouble:locations.location.coordinate.longitude]} forKey:KUserLocation];
    [userDefaults synchronize];
    
}
+(CLLocationCoordinate2D)getCurrentLocation{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userDefaults objectForKey:KUserLocation];
    CLLocationCoordinate2D coordicate = CLLocationCoordinate2DMake([dict[@"latitude"] doubleValue], [dict[@"longitude"] doubleValue]);
    return coordicate;
}

//保存token
+(void)saveToken:(NSString *)Token
{
    NSUserDefaults *TokenNum = [NSUserDefaults standardUserDefaults];
    [TokenNum setObject:Token forKey:KToken];
    [TokenNum synchronize];
}
//获取token
+(NSString* )getToken
{
    NSUserDefaults *tokenNum = [NSUserDefaults standardUserDefaults];
    NSString *NumStr = [tokenNum objectForKey:KToken];
    return NumStr;
}

//移除token
+(void)removetoken
{
    NSUserDefaults *tokenNum = [NSUserDefaults standardUserDefaults];
    [tokenNum setObject:nil forKey:KToken];
}

//保存token
+(void)saveYuYueFlag:(NSString *)Flag
{
    NSUserDefaults *YuYue = [NSUserDefaults standardUserDefaults];
    [YuYue setObject:Flag forKey:YuYueFlags];
    [YuYue synchronize];
}

//获取token
+(NSString* )getYuYueFlag
{
    NSUserDefaults *YuYueFlag = [NSUserDefaults standardUserDefaults];
    NSString *yuYueStr = [YuYueFlag objectForKey:YuYueFlags];
    return yuYueStr;
}

//移除token
+(void)removeYuYueFlag
{
    NSUserDefaults *YuYue = [NSUserDefaults standardUserDefaults];
    [YuYue setObject:nil forKey:YuYueFlags];
}


//保存预约结束时间
+(void)saveYuYueEndTime:(NSString *)EndTime
{
    NSUserDefaults *YuYueEnd = [NSUserDefaults standardUserDefaults];
    [YuYueEnd setObject:EndTime forKey:YuYueEndTime];
    [YuYueEnd synchronize];
}

//获取预约结束时间
+(NSString* )getYuYueEndTime
{
    NSUserDefaults *YuYueEnd = [NSUserDefaults standardUserDefaults];
    NSString *yuYueStr = [YuYueEnd objectForKey:YuYueEndTime];
    return yuYueStr;
}

//移除预约结束时间
+(void)removeYuYueEndTime
{
    NSUserDefaults *YuYueEnd = [NSUserDefaults standardUserDefaults];
    [YuYueEnd setObject:nil forKey:YuYueEndTime];
}


//保存第三方登陆类型
+(void)saveThirdLoginType:(NSString *)LoginType
{
    NSUserDefaults *Type = [NSUserDefaults standardUserDefaults];
    [Type setObject:LoginType forKey:ThirdLoginType];
    [Type synchronize];
    
}
//获取第三方登陆类型
+(NSString* )getThirdLoginType
{
    NSUserDefaults * LoginType= [NSUserDefaults standardUserDefaults];
    NSString *yuYueStr = [LoginType objectForKey:ThirdLoginType];
    return yuYueStr;
}
//移除第三方登陆类型
+(void)removeThirdLoginType
{
    NSUserDefaults *LoginType = [NSUserDefaults standardUserDefaults];
    [LoginType setObject:nil forKey:ThirdLoginType];
}

////保存手动输入的充电桩号
//+(void)saveInPutChargeNum:(NSString *)ChargeNum
//{
//    NSUserDefaults *intPutNum = [NSUserDefaults standardUserDefaults];
//    [intPutNum setObject:ChargeNum forKey:IntChargeNum];
//    [intPutNum synchronize];
//}
////获得保存的输入的充电桩号
//+(NSString* )getInPutChargeNum
//{
//    NSUserDefaults *intPutNum = [NSUserDefaults standardUserDefaults];
//    NSString *yuYueStr = [intPutNum objectForKey:IntChargeNum];
//    return yuYueStr;
//}
////移除输入充电桩号
//+(void)removeInPutChargeNum
//{
//    NSUserDefaults *intPutNum = [NSUserDefaults standardUserDefaults];
//    [intPutNum setObject:nil forKey:IntChargeNum];
//}


@end
