//
//  JiFenTableViewCell.m
//  Charge
//
//  Created by olive on 2017/4/21.
//  Copyright © 2017年 com.XinGuoXin.cn. All rights reserved.
//

#import "JiFenTableViewCell.h"
#import "XFunction.h"

@implementation JiFenTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - 绘制Cell分割线
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    //上分割线，
    CGContextSetStrokeColorWithColor(context, RGBA(232, 233, 232, 1).CGColor);
    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width, 0.01));
    
    //下分割线
    CGContextSetStrokeColorWithColor(context, RGBA(232, 233, 232, 1).CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width, 0.01));
}

@end
