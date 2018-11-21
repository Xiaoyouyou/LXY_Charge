//
//  MyCarListModel.h
//  Charge
//
//  Created by 罗小友 on 2018/10/25.
//  Copyright © 2018年 com.XinGuoXin.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCarListModel : NSObject

@property (nonatomic ,strong)NSString *id;
@property (nonatomic ,strong)NSString *brand;//品牌
@property (nonatomic ,strong)NSString *img;
@property (nonatomic ,strong)NSString *pattern;//型号
@property (nonatomic ,strong)NSString *plate_number;//chepai
@property (nonatomic ,strong)NSString *type;//车辆类型
@property (nonatomic ,strong)NSString *electricizeType;//车充类型

@end
