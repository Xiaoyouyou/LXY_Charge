//
//  SettingFooterView.h
//  Charge
//
//  Created by olive on 16/6/7.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingFooterView : UIView

@property (nonatomic, copy) void (^tuiChuDengLuBlock)(void);


+(instancetype)creatSettingFooterView;

@end
