//
//  MainNavView.h
//  Charge
//
//  Created by olive on 17/4/7.
//  Copyright © 2017年 com.XinGuoXin.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainNavView : UIView

@property (nonatomic, copy) void (^leftBlock)(void);
@property (nonatomic, copy) void (^rightBlock)(void);


- (id)initWithFrame:(CGRect)frame title:(NSString *)title leftImgae:(NSString *)leftImage rightImage:(NSString *)rightImage;//设置左边按钮，右边按钮

@end
