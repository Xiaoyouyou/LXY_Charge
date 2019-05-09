//
//  SGShareViewController.h
//  XiGuMobileGame
//
//  Created by 罗小友 on 2018/12/30.
//  Copyright © 2018 zhujin zhujin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChargeShareView : UIView
-(instancetype)initWithFrame:(CGRect)frame;
@property (nonatomic ,strong)NSString *url;
@property (nonatomic ,strong)NSString *title1;
@property (nonatomic ,strong)NSString *msg;
@property (nonatomic ,strong)NSString *icon;
@end

NS_ASSUME_NONNULL_END
