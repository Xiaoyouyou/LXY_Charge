//
//  ChooseView.h
//  Charge
//
//  Created by 罗小友 on 2018/10/31.
//  Copyright © 2018 com.XinGuoXin.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DaohangClick)(NSString *a ,NSString *b);
@interface ChooseView : UIView
-(instancetype)initWithFrame:(CGRect)frame;
@property (nonatomic ,strong)DaohangClick daohang;
@end
