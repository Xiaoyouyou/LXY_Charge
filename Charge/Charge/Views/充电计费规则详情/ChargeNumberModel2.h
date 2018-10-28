//
//  ChargeNumberModel2.h
//  Charge
//
//  Created by 罗小友 on 2018/10/27.
//  Copyright © 2018 com.XinGuoXin.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChargeNumberModel2 : NSObject
@property (nonatomic ,strong)NSString *dc;//直流1或者交流0
@property (nonatomic ,strong)NSString *leftSeconds;//还有多久可以把电充满
@property (nonatomic ,strong)NSString *soc;  //电量百分比
@property (nonatomic ,strong)NSString *status; //表示车的状态：会返回以下状态给你那边，10断连，00空闲，01准备开始充电，02充电中，03充电结束，04启动失败，05预约状态，06故障状态
@end
