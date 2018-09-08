//
//  SearchChargeTableViewCell.h
//  Charge
//
//  Created by olive on 16/6/6.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchChargeTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *tempChargeName;//充电站名称
@property (nonatomic, copy) NSString *tempChargeAddress;//充电站地址
@property (nonatomic, copy) NSString *tempFastLab;//快充
@property (nonatomic, copy) NSString *tempSlowLab;//慢充
@property (nonatomic, copy) NSString *tempDistabceLab;//距离
@property (nonatomic, copy) NSString *tempCostLab;//计费规则

@end
