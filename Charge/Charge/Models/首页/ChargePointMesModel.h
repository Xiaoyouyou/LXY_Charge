//
//  ChargePointMesModel.h
//  Charge
//
//  Created by olive on 16/8/29.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChargePointMesModel : NSObject

@property (nonatomic, copy) NSString *address;//充电站地址
@property (nonatomic, copy) NSString *id;//充电站ID
@property (nonatomic, copy) NSString *side_name;//充电站名字
@property (nonatomic, copy) NSString *latitude;//纬度
@property (nonatomic, copy) NSString *longitude;//经度
@property (nonatomic, copy) NSString *count_fast;//快充
@property (nonatomic, copy) NSString *count_slow;//慢充

@end
