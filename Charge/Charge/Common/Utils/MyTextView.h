//
//  MyTextView.h
//  xuemiyun
//
//  Created by xueyiwangluo on 15/3/30.
//  Copyright (c) 2015年 广州学易网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTextView : UITextView

@property (nonatomic, strong) UILabel *placeholder;

- (id)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder;

@end
