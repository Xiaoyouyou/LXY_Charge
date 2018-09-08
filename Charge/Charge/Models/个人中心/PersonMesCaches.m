//
//  PersonMesCaches.m
//  Charge
//
//  Created by olive on 16/8/18.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "PersonMesCaches.h"
#import "XFunction.h"

@implementation PersonMesCaches
#pragma mark - NSCoding协议方法

//当进行解档操作的时候就会调用该方法
//在该方法中要写清楚要提取对象的哪些属性
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    MYLog(@"调用了initWithCoder方法");
    if (self =[super init]) {
        self.age = [aDecoder decodeObjectForKey:@"age"];
        self.nick = [aDecoder decodeObjectForKey:@"nick"];
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.signature = [aDecoder decodeObjectForKey:@"signature"];
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
    }
    return self;
}

//当进行归档操作的时候就会调用该方法
//在该方法中要写清楚要存储对象的哪些属性
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    MYLog(@"调用了encodeWithCoder方法");
    [aCoder encodeObject:_age forKey:@"age"];
    [aCoder encodeObject:_nick forKey:@"nick"];
    [aCoder encodeObject:_avatar forKey:@"avatar"];
    [aCoder encodeObject:_mobile forKey:@"mobile"];
    [aCoder encodeObject:_signature forKey:@"signature"];
    [aCoder encodeObject:_sex forKey:@"sex"];
    
}
@end
