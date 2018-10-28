//
//  DetailZhuangWeiViewController.h
//  Charge
//
//  Created by olive on 16/6/8.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "All_chargingSubModel.h"

@interface DetailZhuangWeiViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *all_chargingSub;
@property(nonatomic, strong) NSString *id;//充电站的id
@property (nonatomic, strong) NSMutableDictionary *chargeDeatlModel;

@end
