//
//  ChargingSub.h
//  Charge
//
//  Created by olive on 16/12/15.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChargingSub : NSObject

@property (nonatomic, copy) NSString *chargeCost;//电费价格
@property (nonatomic, copy) NSString *discountRate;//折扣率
@property (nonatomic, copy) NSString *emptyCost;//预约费
@property (nonatomic, copy) NSString *id;//充电桩id
@property (nonatomic, copy) NSString *parkingCharge;//停车费
@property (nonatomic, copy) NSString *serviceCost;//服务费


@end
