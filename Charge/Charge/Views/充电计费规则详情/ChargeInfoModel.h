//
//  ChargeInfoModel.h
//  Charge
//
//  Created by 罗小友 on 2018/10/27.
//  Copyright © 2018 com.XinGuoXin.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChargeInfoModel : NSObject
@property (nonatomic ,strong)NSString *startTime;
@property (nonatomic ,strong)NSString *endTime;
@property (nonatomic ,strong)NSString *chargeCost;
@property (nonatomic ,strong)NSString *serviceCost;
@property (nonatomic ,strong)NSString *discountRate;
@property (nonatomic ,strong)NSString *emptyCost;
@property (nonatomic ,strong)NSString *id;
@property (nonatomic ,strong)NSString *parkingCharge;
@end
