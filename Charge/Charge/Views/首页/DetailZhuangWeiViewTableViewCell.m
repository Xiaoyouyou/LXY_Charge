//
//  DetailZhuangWeiViewTableViewCell.m
//  Charge
//
//  Created by olive on 16/6/8.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "DetailZhuangWeiViewTableViewCell.h"
#import "XFunction.h"

@interface  DetailZhuangWeiViewTableViewCell()
@end

@implementation DetailZhuangWeiViewTableViewCell

-(void)awakeFromNib
{
    [super awakeFromNib];
   
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    //上分割线，
    CGContextSetStrokeColorWithColor(context,  RGBA(228, 229, 229, 1).CGColor);
    
    CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1));
    
    //下分割线
    CGContextSetStrokeColorWithColor(context, RGBA(228, 229, 229, 1).CGColor);
    
    CGContextStrokeRect(context, CGRectMake(5, rect.size.height, rect.size.width - 10, 1));
}

@end
