//
//  loginModel.h
//  Charge
//
//  Created by olive on 16/6/21.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface loginModel : NSObject

@property (copy, nonatomic) NSString *id;//用户手机号
@property (copy, nonatomic) NSString *mobile;//用户手机号
@property (copy, nonatomic) NSString *avatar;//用户头像地址
@property (copy, nonatomic) NSString *email;//email
@property (copy, nonatomic) NSString *nick;//用户昵称
@property (copy, nonatomic) NSString *age;
@property (assign, nonatomic) NSString  *sex;//性别
@property (copy, nonatomic) NSString *signature;//签名
@property (copy, nonatomic) NSString *userName;//签名
@property (copy, nonatomic) NSString *token;//token
@property (copy, nonatomic) NSString *checkCharging;//检查是否是新手机登陆
@property (copy, nonatomic) NSString *inviteCode;//用户自己的邀请码
@end
