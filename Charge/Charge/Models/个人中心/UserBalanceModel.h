//
//  UserBalanceModel.h
//  Charge
//
//  Created by olive on 16/9/7.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserBalanceModel : NSObject

@property (nonatomic, copy) NSString *createDate;//创建时间
@property (nonatomic, copy) NSString *desc;//消费项目
@property (nonatomic, copy) NSString *id;//用户ID
@property (nonatomic, copy) NSString *tradeFee;//交易金额
@property (nonatomic, copy) NSString *tradeType;//交易类型


@end
