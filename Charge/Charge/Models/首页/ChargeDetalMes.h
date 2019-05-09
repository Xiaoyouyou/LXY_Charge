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
#import "All_chargingSubModel.h"

@interface ChargeDetalMes : NSObject

//@property (nonatomic, copy) NSString *address;//地址
//@property (nonatomic, copy) NSString *chargingId;//计费规则id
//
//@property (nonatomic, strong)NSArray <All_chargingSubModel*> *all_chargingSub;//分段计费模型
//
//@property (nonatomic, strong) ChargingSubModel *chargingSub;//计费规则
//@property (nonatomic, copy) NSString *id;//站id
//@property (nonatomic, copy) NSString *fastCount;//直流（快充）数量
//@property (nonatomic, copy) NSString *latitude;//纬度
//@property (nonatomic, copy) NSString *longitude;//经度
//@property (nonatomic, copy) NSString *name;//名字
//@property (nonatomic, strong) NSArray *piles;//桩信息
//
//@property (nonatomic, copy) NSString *slowCount;//交流（慢充）数量
//@property (nonatomic, copy) NSString *isCollected;//收藏状态  1.为收藏 0.未收藏


@property (nonatomic, copy) NSString *address;//地址
@property (nonatomic, strong)NSString * acCount;    //交流桩数量
@property (nonatomic, strong)NSString * dcCount;    //直流桩数量
@property (nonatomic, copy) NSString *latitude;//纬度
@property (nonatomic, copy) NSString *longitude;//经度
@property (nonatomic, copy) NSString *name;//名字
@property (nonatomic, copy) NSString *isCollected;//收藏状态  1.为收藏 0.未收藏
@property (nonatomic, copy) NSString * stationId;//站id




@property (nonatomic, copy) NSString *payWay;//支付方式
@property (nonatomic, copy) NSString *parkNote;// 停车说明
@property (nonatomic, copy) NSString *openTime;//开放时间
@property (nonatomic, copy) NSString *feeNote;//收费说明   加一行  平段是1.09，峰段1.49
@property (nonatomic, copy) NSString *stationPic;

@property (nonatomic, copy) NSString *cTimeRange;// 当前时段
@property (nonatomic, copy) NSString *elecFee;//  当前时段电费
@property (nonatomic, copy) NSString *serverFee;//当前时段服务费
@property (nonatomic, copy) NSString *serverDiscount;//当前时段优惠金额
@property (nonatomic, copy) NSArray *picList; //轮播图数组
@property (nonatomic, copy) NSString *gdlongitude; // 该站点的高德地图经度坐标
@property (nonatomic, copy) NSString *gdlatitude; // 该站点的高德地图纬度坐标


@end

