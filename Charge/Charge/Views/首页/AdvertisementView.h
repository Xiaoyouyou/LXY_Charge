//
//  AdvertisementView.h
//  Charge
//
//  Created by olive on 17/4/10.
//  Copyright © 2017年 com.XinGuoXin.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvertisementView : UIView

@property (nonatomic, copy) void (^DisMissViewBlock)(void);

- (id)initWithFrame:(CGRect)frame;
-(void)dissmissView;


@end
