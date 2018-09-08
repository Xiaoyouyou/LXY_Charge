//
//  QiPaoBMKPointAnnotation.h
//  Charge
//
//  Created by olive on 16/7/5.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface QiPaoBMKPointAnnotation : BMKPointAnnotation

@property (nonatomic, strong) NSString *id;
@property (nonatomic) double LocationLatitude;//纬度
@property (nonatomic) double LocationLongitude;//经度
@property (nonatomic, strong) UIImage *image;//图片
@property (nonatomic, strong) NSString *address;//地址

@end
