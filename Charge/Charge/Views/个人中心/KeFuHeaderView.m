//
//  KeFuHeaderView.m
//  Charge
//
//  Created by olive on 16/6/8.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "KeFuHeaderView.h"

@implementation KeFuHeaderView

+(instancetype)creatKeFuHeaderView
{
   return [[[NSBundle mainBundle]loadNibNamed:@"KeFuHeaderView" owner:nil options:nil]lastObject];
}

@end
