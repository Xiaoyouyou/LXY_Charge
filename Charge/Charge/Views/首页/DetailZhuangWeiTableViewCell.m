//
//  DetailZhuangWeiTableViewCell.m
//  Charge
//
//  Created by olive on 16/9/19.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "DetailZhuangWeiTableViewCell.h"
#import "XFunction.h"

@implementation DetailZhuangWeiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    
    CGContextFillRect(context, rect);
    
    //上分割线，
    
    CGContextSetStrokeColorWithColor(context,RGBA(228, 229, 229, 1).CGColor);
    
    CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1));
    
    //下分割线
    
    CGContextSetStrokeColorWithColor(context,RGBA(228, 229, 229, 1).CGColor);
    
    CGContextStrokeRect(context, CGRectMake(5, rect.size.height, rect.size.width - 10, 1));
}
@end
