//
//  XStringUtil.h
//  xuemiyun
//
//  Created by xueyiwangluo on 15/1/10.
//  Copyright (c) 2015年 广州学易网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageView+WebCache.h"

@interface XStringUtil : NSObject
////生成MD5字符串
//+ (NSString *)MD5:(NSString *)str;

//是否是空字符串
+ (BOOL)isEmpty:(NSString *)str;

//是否是包括空白的字符串
+ (BOOL)isContainsBlank:(NSString *)str;

//是否为电话号码
+ (BOOL)isPhoneNumber:(NSString *)str;

//去掉电话号码的空白字符
+ (NSString *)trimPhoneNumber:(NSString *)str;

//获取短描述,超出范围的用省略号表示
+ (NSString *)getShortText:(NSString *)str maxLen:(int)maxLen;

//是否为数字字符
+ (BOOL)isNumberString:(NSString *)str;

//将字母字符串转为数字序号
+ (NSInteger)getIndexWithStringLetter:(NSString *)letter;

//URL编码
+ (NSString *)urlEncode:(NSString *)str;

//将字典转为字符串
+ (NSString *)getJsonStringWithDict:(NSDictionary *)body;

//将数组转为字符串
+ (NSString *)getJsonStringWithArray:(NSArray *)body;

//是否为手机号
+ (BOOL)isMobileNumber:(NSString *)phoneNum;

//1.用户名 - 2.密码 （英文、数字都可，且不包含特殊字符）
+ (BOOL)validateStrWithRange:(NSString *)range str:(NSString *)str;
//普通字符串字符串转16进制
+ (NSString *)stringFromHexString:(NSString *)hexString;
//16进制转字符串
+ (NSString *)hexStringFromString:(NSString *)string;
//将NSData转换成16进制的字符串
+ (NSString *)convertDataToHexStr:(NSData *)data;

//计算两个时间差，NSDate类型传值
+ (NSString *)dateTimeDifferenceWithStartTimes:(NSDate *)startTimes endTime:(NSDate *)endTimees;
//计算两个时间差
+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTimes;
//获取汉字的拼音
+ (NSString *)transform:(NSString *)chinese;
//MD5加密
+ (NSString *)stringToMD5:(NSString *)str;
//
+(NSString *)returnHexadecimalString:(NSString *)hexadecimalString;
//字符转ascll
+(NSString *)ascllString:(NSString *)str;

+(NSString *)ascllStr:(NSString *)str;
@end
