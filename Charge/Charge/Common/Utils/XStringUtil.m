//
//  XStringUtil.m
//  xuemiyun
//
//  Created by xueyiwangluo on 15/1/10.
//  Copyright (c) 2015年 广州学易网络科技有限公司. All rights reserved.
//

#import "XStringUtil.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation XStringUtil
////生成MD5字符串
//+ (NSString *)MD5:(NSString *)str
//{
//    const char *cStr = [str UTF8String];
//    unsigned char digest[16];
//    CC_MD5(cStr, (int)strlen(cStr), digest ); // This is the md5 call
//    
//    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
//    
//    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
//        [output appendFormat:@"%02x", digest[i]];
//    
//    return  output;
//
//}

//是否是空字符串
+ (BOOL)isEmpty:(NSString *)str
{
    return [str isKindOfClass:[NSNull class]] || str == nil || [str length] <= 0;
}

//是否是包括空白的字符串
+ (BOOL)isContainsBlank:(NSString *)str
{
    return [self isEmpty:str] ||
    ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0);
}

//是否为电话号码
+ (BOOL)isPhoneNumber:(NSString *)str
{
    if([str isKindOfClass:[NSNull class]]){
        return NO;
    }
    if(! [XStringUtil isNumberString:str]){
        return NO;
    }
    
    long len = [str length];
    if(len != 11){
        return NO;
    }
    
    for(int i = 0; i < len; i++){
        unichar c = [str characterAtIndex:i];
        if(! isdigit(c)){
            return NO;
        }
    }
    
    return YES;
}

//去掉电话号码的空白字符
+ (NSString *) trimPhoneNumber:(NSString *)str
{
    NSCharacterSet * invalidNumberSet = [NSCharacterSet characterSetWithCharactersInString:@" -\n_!@#$%^&*()[]{}'\".,<>:;|\\/?+=\t~` "];
    
    NSString  * result  = @"";
    NSScanner * scanner = [NSScanner scannerWithString:str];
    NSString  * scannerResult;
    
    [scanner setCharactersToBeSkipped:nil];
    
    while (![scanner isAtEnd])
    {
        if([scanner scanUpToCharactersFromSet:invalidNumberSet intoString:&scannerResult])
        {
            result = [result stringByAppendingString:scannerResult];
        }
        else
        {
            if(![scanner isAtEnd])
            {
                [scanner setScanLocation:[scanner scanLocation]+1];
            }
        }
    }
    
    return result;
}

//获取短描述,超出范围的用省略号表示
+ (NSString *)getShortText:(NSString *)str maxLen:(int)maxLen
{
    if([XStringUtil isEmpty:str]){
        return str;
    }
    str = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    if(str.length > maxLen){
        NSString *moreStr = @"…";
        str = [str substringWithRange:NSMakeRange(0, (NSUInteger) (maxLen - moreStr.length))];
        str = [str stringByAppendingString:moreStr];
    }
    
    return str;
}

//是否为数字字符
+ (BOOL)isNumberString:(NSString *)str
{
    if([str isKindOfClass:[NSNull class]]){
        return NO;
    }
    if([XStringUtil isContainsBlank:str]){
        return NO;
    }
    
    long len = str.length;
    for(int i = 0; i < len; i++){
        unichar c = [str characterAtIndex:i];
        if(!isnumber(c)){
            return NO;
        }
    }
    return YES;
}

//URL编码
+ (NSString *)urlEncode:(NSString *)str
{
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[str UTF8String];
    long sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

//将字典转为字符串
+ (NSString *)getJsonStringWithDict:(NSDictionary *)body
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}

//将数组转为字符串
+ (NSString *)getJsonStringWithArray:(NSArray *)body
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}

//将字母字符串转为数字序号
+ (NSInteger)getIndexWithStringLetter:(NSString *)letter
{
    NSArray *array = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",\
                       @"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",];

    return [array indexOfObject:letter];
}


+ (BOOL)isMobileNumber:(NSString *)phoneNum
{
    if (phoneNum.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if (([regextestmobile evaluateWithObject:phoneNum] == YES)
        || ([regextestcm evaluateWithObject:phoneNum] == YES)
        || ([regextestct evaluateWithObject:phoneNum] == YES)
        || ([regextestcu evaluateWithObject:phoneNum] == YES))
    {
        NSString *str;
        
        if([regextestcm evaluateWithObject:phoneNum] == YES) {
            str = @"中国移动";
        } else if([regextestct evaluateWithObject:phoneNum] == YES) {
            str = @"中国电信";
        } else if ([regextestcu evaluateWithObject:phoneNum] == YES) {
            str = @"中国联通";
        } else {
            str = @"未知卡商";
        }
        
        NSLog(@"手机SIM卡供应商：%@", str);
        return YES;
    }
    else
    {
        return NO;
    }
    
}

// 1.用户名 - 2.密码 （英文、数字都可，且不包含特殊字符）
+ (BOOL)validateStrWithRange:(NSString *)range str:(NSString *)str
{
    // eg: range = {4,20}
    NSString * regex = [NSString stringWithFormat:@"^[A-Za-z0-9]%@$",range] ;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}

//普通字符串转换为十六进制的。
+ (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr]; 
    } 
    return hexStr; 
}

// 十六进制转换为普通字符串的。
+ (NSString *)stringFromHexString:(NSString *)hexString { //
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"------字符串=======%@",unicodeString);
    return unicodeString;
}

//计算两个日期时间差(NSdate)
+ (NSString *)dateTimeDifferenceWithStartTimes:(NSDate *)startTimes endTime:(NSDate *)endTimees
{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval start = [startTimes timeIntervalSince1970]*1;
    NSTimeInterval end = [endTimees timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;

    NSString *second = [NSString stringWithFormat:@"%f",value];

   return second;
}

+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTimes{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTimes];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    int second = (int)value %60;//秒
    int minute = (int)value /60%60;
    int house = (int)value / (24 * 3600)%3600;
    int day = (int)value / (24 * 3600);
    NSString *str;
    if (day != 0) {
        str = [NSString stringWithFormat:@"%d天%d小时%d分%d秒",day,house,minute,second];
    }else if (day==0 && house != 0) {
        str = [NSString stringWithFormat:@"%d小时%d分%d秒",house,minute,second];
    }else if (day== 0 && house== 0 && minute!=0) {
        str = [NSString stringWithFormat:@"%d分%d秒",minute,second];
    }else{
        str = [NSString stringWithFormat:@"%d秒",second];
    }
    return str;
}

+ (NSString *)transform:(NSString *)chinese
{
    //将NSString装换成NSMutableString
    NSMutableString *pinyin = [chinese mutableCopy];
    //将汉字转换为拼音(带音标)
   // CFStringTransform((__bridgeCFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    NSLog(@"%@", pinyin);
    //去掉拼音的音标
   // CFStringTransform((__bridgeCFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    NSLog(@"%@", pinyin);
    //返回最近结果
    return pinyin;
}


+(NSString *)stringToMD5:(NSString *)str
{
    
    //1.首先将字符串转换成UTF-8编码, 因为MD5加密是基于C语言的,所以要先把字符串转化成C语言的字符串
    const char *fooData = [str UTF8String];
    
    //2.然后创建一个字符串数组,接收MD5的值
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    //3.计算MD5的值, 这是官方封装好的加密方法:把我们输入的字符串转换成16进制的32位数,然后存储到result中
    CC_MD5(fooData, (CC_LONG)strlen(fooData), result);
    /**
     第一个参数: 要加密的字符串
     第二个参数: 获取要加密字符串的长度
     第三个参数: 接收结果的数组
     */
    
    //4.创建一个字符串保存加密结果
    NSMutableString *saveResult = [NSMutableString string];
    
    //5.从result 数组中获取加密结果并放到 saveResult中
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [saveResult appendFormat:@"%02x", result[i]];
    }
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
    return saveResult;
}




//计算方法
+(NSString *)returnHexadecimalString:(NSString *)hexadecimalString{
    NSString *string = [[NSString alloc]initWithFormat:@"%@", hexadecimalString];
    NSString *aSting = [string substringWithRange:NSMakeRange(0, 2)];
    NSString *bSting = [string substringWithRange:NSMakeRange(2, string.length - 2)];
    int sum = 0;
    for (int i = 0; i < bSting.length - 1; i +=2) {
        NSString * str = [bSting substringWithRange:NSMakeRange(i, 2)];
        int abc = [self numberWithHexString:str];
        sum += abc;
        NSLog(@"sum:%d",sum);
    }
    NSLog(@"sum^_^:%d",sum);
    int ret = sum & 0xff;
    NSLog(@"ret:%d",ret);
    NSString * checkCode = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",ret]];
    NSLog(@"checkCode:%@",checkCode);
    NSString *returnString = [[NSString alloc] initWithFormat:@"%@%@%@",aSting,bSting,checkCode];
    NSLog(@"returnString:%@",returnString);
    return returnString;
    
}

//十六进制字符串转为10进制整数
+(int)numberWithHexString:(NSString *)hexString{
    const char *hexChar = [hexString cStringUsingEncoding:NSUTF8StringEncoding];
    int hexNumber;
    sscanf(hexChar, "%x", &hexNumber);
    return hexNumber;
}

////字符串转ASCll
+(NSString *)ascllString:(NSString *)str{
//    NSString *str0 = @"0123456789ABCDEF";
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//    NSUInteger len = [str length];
//    for(NSUInteger i=0; i<len; i++)
//    {
//        [array addObject:[NSNumber numberWithChar:[str0 characterAtIndex:i]]];
//    }
//    NSMutableString *str1 = [NSMutableString string];
    NSData *data = [str  dataUsingEncoding:NSUTF8StringEncoding]; // UTF-8编码
//   NSString *str1 =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSMutableString *result = [NSMutableString string];
    Byte *bytes = (Byte *)[data bytes];
    for (int i = 0; i < [data length]; i++) {
        [result appendFormat:@"%02hhx", (unsigned char)bytes[i]];
        
    }
    NSLog(@"result:%ld", result.length);
    NSInteger a = result.length;
    if (result.length < 64) {
        NSLog(@"%ld", (64 -result.length));
        for (int i = 0; i < (64 - a); i++) {
            [result appendString:[NSString stringWithFormat:@"%@",@"0"]];
           NSLog(@"result:%d", i);
        }
    }
    NSLog(@"%ld",result.length);
    
    return [result uppercaseString];
}



////字符串转ASCll
+(NSString *)ascllStr:(NSString *)str{
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//    NSUInteger len = [str length];
//    for(NSUInteger i=0; i<len; i++)
//    {
//        [array addObject:[NSNumber numberWithChar:[str characterAtIndex:i]]];
//    }
    NSMutableString *str2 = [NSMutableString string];
    for (int i = 0; i < str.length; i++) {
        NSString * str1 = [NSString stringWithFormat:@"%hu",[str characterAtIndex:i]];
        [str2 appendString:str1];
    }
    
    return str2;
}



@end
