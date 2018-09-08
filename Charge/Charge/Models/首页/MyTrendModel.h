//
//  MyTrendModel.h
//  Charge
//
//  Created by olive on 17/1/4.
//  Copyright © 2017年 com.XinGuoXin.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTrendModel : NSObject

@property (nonatomic, copy) NSString *chargingStatus;//充电状态：0完成充电  1未完成
@property (nonatomic, copy) NSString *totalCost;//花费
@property (nonatomic, copy) NSString *createDate;//创建日期
@property (nonatomic, copy) NSString *stationId;//充电站ID
@property (nonatomic, copy) NSString *stationName;//充电站名称

@end
