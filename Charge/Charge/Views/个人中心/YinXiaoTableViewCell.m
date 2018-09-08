//
//  YinXiaoTableViewCell.m
//  Charge
//
//  Created by olive on 16/6/12.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "YinXiaoTableViewCell.h"
#import "XFunction.h"

@interface  YinXiaoTableViewCell()
@property (strong, nonatomic) IBOutlet UISwitch *yinXiaoSwitch;

@end

@implementation YinXiaoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.yinXiaoSwitch.onTintColor = RGBA(29, 167, 146, 1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
