//
//  JuDianQiPaoBMKAnnotation.h
//  Charge
//
//  Created by olive on 17/3/20.
//  Copyright © 2017年 com.XinGuoXin.cn. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface JuDianQiPaoBMKAnnotation : BMKPointAnnotation

@property (nonatomic, strong) NSString *id;
@property (nonatomic) double LocationLatitude;//纬度
@property (nonatomic) double LocationLongitude;//经度
@property (nonatomic, strong) UIImage *image;//图片
@property (nonatomic, strong) NSString *address;//地址

@end
