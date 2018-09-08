//
//  PositionCityViewController.h
//  Charge
//
//  Created by olive on 16/7/13.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PositionCityViewController : UIViewController

@property (copy, nonatomic) void(^ChooseCityBlack)(NSString *CityName);
@property (nonatomic, copy) NSString *locationCitys;//当前定位城市

@end
