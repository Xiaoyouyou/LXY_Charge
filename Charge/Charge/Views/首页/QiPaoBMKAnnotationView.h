//
//  QiPaoBMKAnnotationView.h
//  Charge
//
//  Created by olive on 16/7/5.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface QiPaoBMKAnnotationView : BMKAnnotationView

@property (nonatomic, strong) NSMutableArray *annotationImages;
@property (nonatomic, strong) UIImageView *annotationImageView;

@end
