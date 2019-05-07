//
//  ChangePayViewController.h
//  Charge
//
//  Created by olive on 16/8/19.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePayViewController : UIViewController

@property (nonatomic, copy) NSString *chargeTimeStr;//充电时长
@property (nonatomic, copy) NSString *powersStr;//已充电量
@property (nonatomic, copy) NSString *chargeMoneyStr;//电费
@property (nonatomic, copy) NSString *fuwufei;//服务费
@property (nonatomic, copy) NSString *fuwufeiyouhui;//服务费优惠
@property (nonatomic, copy) NSString *xiaofeizongjine;//消费总金额



@property (nonatomic, copy) NSString *alertTitle;//余额不足提示信息

@end
