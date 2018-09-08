//
//  PersonMessage.h
//  Charge
//
//  Created by olive on 16/8/17.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonMessage : NSObject

@property (copy, nonatomic) NSString *id;//用户id
@property (copy, nonatomic) NSString *mobile;//用户手机号
@property (copy, nonatomic) NSString *avatar;//用户头像地址
@property (copy, nonatomic) NSString *email;//email
@property (copy, nonatomic) NSString *nick;//用户昵称
@property (copy, nonatomic) NSString *age;
@property (copy, nonatomic) NSString *sex;//性别
@property (copy, nonatomic) NSString *signature;//签名
@property (copy, nonatomic) NSString *userName;//用户名

@end
