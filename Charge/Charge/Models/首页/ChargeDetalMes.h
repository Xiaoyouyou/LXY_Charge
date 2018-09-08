//
//  ChargeDetalMes.h
//  Charge
//
//  Created by olive on 16/11/26.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChargingSubModel.h"
#import "PilesModel.h"

@interface ChargeDetalMes : NSObject

@property (nonatomic, copy) NSString *address;//地址
@property (nonatomic, copy) NSString *chargingId;//计费规则id
@property (nonatomic, strong) ChargingSubModel *chargingSub;//计费规则
@property (nonatomic, copy) NSString *id;//站id
@property (nonatomic, copy) NSString *fastCount;//直流（快充）数量
@property (nonatomic, copy) NSString *latitude;//纬度
@property (nonatomic, copy) NSString *longitude;//经度
@property (nonatomic, copy) NSString *name;//名字
@property (nonatomic, strong) NSArray *piles;//桩信息
@property (nonatomic, copy) NSString *slowCount;//交流（慢充）数量
@property (nonatomic, copy) NSString *isCollected;//收藏状态  1.为收藏 0.未收藏

@end

