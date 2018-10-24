//
//  MyCarTableViewCell.m
//  Charge
//
//  Created by 罗小友 on 2018/10/21.
//  Copyright © 2018年 com.XinGuoXin.cn. All rights reserved.
//

#import "MyCarTableViewCell.h"

@implementation MyCarTableViewCell
+(instancetype)creatMyCarCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"MyCarTableViewCell" owner:self options:nil] lastObject];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
