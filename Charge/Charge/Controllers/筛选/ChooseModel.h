//
//  ChooseModel.h
//  Charge
//
//  Created by 罗小友 on 2018/11/1.
//  Copyright © 2018 com.XinGuoXin.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChooseModel : NSObject
@property (nonatomic ,strong)NSString *addr; //站点地址
@property (nonatomic ,strong)NSString *chargingId;//
@property (nonatomic ,strong)NSString *dcCount;//个数
@property (nonatomic ,strong)NSString *distance;//距离
@property (nonatomic ,strong)NSString *latitude;//
@property (nonatomic ,strong)NSString *longitude;//
@property (nonatomic ,strong)NSString *price;//价格
@property (nonatomic ,strong)NSString *stationId;//
@property (nonatomic ,strong)NSString *stationName;//站点名称
@end
