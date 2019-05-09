//
//  HomeActivitModel.h
//  Charge
//
//  Created by 罗小友 on 2019/5/6.
//  Copyright © 2019 com.XinGuoXin.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeActivitModel : NSObject

@property (nonatomic ,strong)NSString *name;//活动名称

@property (nonatomic ,strong)NSString *url;//活动链接

@property (nonatomic ,strong)NSString *type;//活动类型

@property (nonatomic ,strong)NSString *desc;//活动描述

@property (nonatomic ,strong)NSString *icon;//活动icon

@end

NS_ASSUME_NONNULL_END
