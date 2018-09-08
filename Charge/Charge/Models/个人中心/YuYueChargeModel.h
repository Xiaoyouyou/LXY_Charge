//
//  YuYueChargeModel.h
//  Charge
//
//  Created by olive on 16/12/15.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChargingSub.h"

@interface YuYueChargeModel : NSObject

@property (copy, nonatomic) NSString *addr;//地址
@property (strong, nonatomic) ChargingSub *chargingSub;//桩详情
@property (copy, nonatomic) NSString *code;//电桩号
@property (copy, nonatomic) NSString *endTime;//结束时间
@property (copy, nonatomic) NSString *latitudes;//经度
@property (copy, nonatomic) NSString *longitude;//纬度
@property (copy, nonatomic) NSString *name;//桩名
@property (copy, nonatomic) NSString *startTime;//开始时间

@end
