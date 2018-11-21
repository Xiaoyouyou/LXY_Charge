//
//  ChooseView.h
//  Charge
//
//  Created by 罗小友 on 2018/10/31.
//  Copyright © 2018 com.XinGuoXin.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DaohangClick)(NSString *a ,NSString *b,NSString *addr);
typedef void(^GotoChargeDetail)(NSString *stationID);
@interface ChooseView : UIView
-(instancetype)initWithFrame:(CGRect)frame;
@property (nonatomic ,copy)DaohangClick daohang;
@property (nonatomic,copy) GotoChargeDetail detail;
@end
