//
//  ChargingMessageModel.h
//  Charge
//
//  Created by olive on 16/11/17.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChargingMessageModel : NSObject

@property (nonatomic, copy) NSString *pile_id;//桩id
@property (nonatomic, copy) NSString *charging_status;//充电状态：1充电中，2充电结束
@property (nonatomic, copy) NSString *charging_fee;//充电费用
@property (nonatomic, copy) NSString *charging_power;//充电电量
@property (nonatomic, copy) NSString *start_time;//充电开始时间
@property (nonatomic, copy) NSString *end_time;//充电结束时间

@end
