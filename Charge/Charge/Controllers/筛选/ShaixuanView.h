//
//  ShaixuanView.h
//  Charge
//
//  Created by 罗小友 on 2018/11/7.
//  Copyright © 2018 com.XinGuoXin.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^sureBlock)(void);

typedef void(^cancelBlock)(void);

typedef void(^chooseTypeBlock)(NSDictionary *type);

@interface ShaixuanView : UIView
-(instancetype)initWithFrame:(CGRect)frame;

//@property (nonatomic ,copy)sureBlock sureBlock;
@property (nonatomic ,copy)cancelBlock cancelBlock;
@property (nonatomic ,copy)chooseTypeBlock chooseBlock;
@end
