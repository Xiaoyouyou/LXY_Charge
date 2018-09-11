//
//  All_chargingSubModel.h
//  Charge
//
//  Created by 罗小友 on 2018/9/11.
//  Copyright © 2018年 com.XinGuoXin.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface All_chargingSubModel : NSObject

@property (nonatomic, copy) NSString *chargeCost;//电费价格
@property (nonatomic, copy) NSString *discountRate;//折扣率
@property (nonatomic, copy) NSString *emptyCost;//预约费
@property (nonatomic, copy) NSString *endTime;//结束时间
@property (nonatomic, copy) NSString *id;//计费规则id
@property (nonatomic, copy) NSString *parkingCharge;//停车费
@property (nonatomic, copy) NSString *ruleId;//计费规则
@property (nonatomic, copy) NSString *serviceCost;//服务费
@property (nonatomic, copy) NSString *startTime;//开始时间




@end
