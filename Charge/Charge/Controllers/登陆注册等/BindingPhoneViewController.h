//
//  BindingPhoneViewController.h
//  Charge
//
//  Created by olive on 17/3/29.
//  Copyright © 2017年 com.XinGuoXin.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKAvoidKeyboardViewController.h"

@interface BindingPhoneViewController : WKAvoidKeyboardViewController

@property (nonatomic, copy) NSString *loginID;//后台存储的登陆信息id

@property (nonatomic, copy) NSString *nickName;//qq登陆名字
@property (nonatomic, copy) NSString *headerImage;//头像


@end
