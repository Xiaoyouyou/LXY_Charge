//
//  NavView.h
//  Charge
//
//  Created by olive on 16/12/9.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavView : UIView

@property (nonatomic, copy) void (^backBlock)(void);
@property (nonatomic, copy) void (^rightBlock)(void);


- (id)initWithFrame:(CGRect)frame title:(NSString *)title;//设置左边按钮初始化
- (id)initWithFrame:(CGRect)frame title:(NSString *)title rightTitle:(NSString *)rightTitle;//设置右边按钮初始化
- (id)initWithFrame:(CGRect)frame title:(NSString *)title leftImgae:(NSString *)leftImage rightImage:(NSString *)rightImage;//设置左边按钮，右边按钮

- (id)initWithFrame:(CGRect)frame title:(NSString *)title leftImgae:(NSString *)leftImage rightButton:(NSString *)rightStr;

-(void)setRightBtnMasonry;//设置右边按钮约束

//hidden  right Btn
-(BOOL)hidRightBtn;
@end
