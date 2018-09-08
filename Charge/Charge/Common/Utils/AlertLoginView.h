//
//  AlertLoginView.h
//  Charge
//
//  Created by melon on 16/1/22.
//  Copyright © 2016年 XingGuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertLoginView : UIView

- (void)awakeFromNib;

@property (copy, nonatomic) void(^hideAlertLoginView)(void);
@property (copy, nonatomic) void(^toLoginView)(void);

@end
