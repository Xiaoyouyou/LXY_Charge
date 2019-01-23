//
//  ZhuangWeiMesViewController.h
//  Charge
//
//  Created by olive on 16/6/8.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PilesModel.h"


@interface ZhuangWeiMesViewController : UIViewController

@property (nonatomic, strong) NSArray *chargeNumber;//充电站个数
@property (nonatomic, strong) NSMutableArray *zhuangID;//充电站ID

@property (nonatomic, strong) NSArray *zhuangA;//充电站个数
@property (nonatomic, strong) NSString *stationID;//充电站个数

@property (nonatomic, strong) NSArray *zhzuangB;//充电站个数
@property(nonatomic, strong)  NSMutableDictionary *dict;//充电桩数量字典


@end
