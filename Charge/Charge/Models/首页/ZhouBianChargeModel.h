//
//  ZhouBianChargeModel.h
//  Charge
//
//  Created by olive on 16/12/7.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZhouBianChargeModel : NSObject
@property (nonatomic, copy) NSString *address;//充电站地址
@property (nonatomic, copy) NSString *id;//充电站ID
@property (nonatomic, copy) NSString *name;//充电站名字
@property (nonatomic, copy) NSString *latitudes;//纬度
@property (nonatomic, copy) NSString *longitude;//经度
@property (nonatomic, copy) NSString *fastCount;//快充
@property (nonatomic, copy) NSString *slowCount;//慢充
@property (nonatomic, copy) NSString *city_name;//城市名字
@property (nonatomic, copy) NSString *fee_rule;//计费规则
@property (nonatomic, copy) NSString *province_name;//省份名字
@property (nonatomic ,copy) NSNumber *distance;//距离



@end
