//
//  TipView.h
//  Charge
//
//  Created by olive on 16/12/2.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipView : UIView

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image andshowText:(NSString *)showText;
-(void)SetUpMasonry;//偏上显示约束
-(void)SetCenterMasonry;//居中约束

@end
