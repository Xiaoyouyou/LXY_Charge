//
//  PilesModel.h
//  Charge
//
//  Created by olive on 16/11/26.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PilesModel : NSObject

@property (copy, nonatomic) NSString *address;//桩地址
@property (copy, nonatomic) NSString *id;//桩id
@property (copy, nonatomic) NSString *name;//桩名字
@property (copy, nonatomic) NSString *status;//桩状态 1正常，0关闭 2 故障
@property (copy, nonatomic) NSString *type;//桩类型(0位交流桩,1位直流桩)


@end
