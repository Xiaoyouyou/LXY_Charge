//
//  DetailZhuangBtnView.h
//  Charge
//
//  Created by 罗小友 on 2018/9/11.
//  Copyright © 2018年 com.XinGuoXin.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailZhuangBtnView : UIView

@property (nonatomic ,copy) void(^btnClickBlock)(UIButton *sender);

-(instancetype)initWithFrame:(CGRect)frame count:(NSUInteger)count;

@end
