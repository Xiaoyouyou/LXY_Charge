//
//  ChargeMessageModel.h
//  Charge
//
//  Created by 罗小友 on 2018/10/30.
//  Copyright © 2018 com.XinGuoXin.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChargeMessageModel : NSObject

@property (nonatomic ,strong)NSString *stationId;// 站点
@property (nonatomic ,strong)NSString *stationName;// 站点名称 江白云高站
@property (nonatomic ,strong)NSString *createDate;//开始充电时间2018-10-27 02:03:19
@property (nonatomic ,strong)NSString *endDate;//  结束充电时间 2018-10-27 02:03:50
@property (nonatomic ,strong)NSString *totalCost;// 消费金额（元） 2.54
@property (nonatomic ,strong)NSString *electricCost;// 充电电量（kwh） 2.70
@end
