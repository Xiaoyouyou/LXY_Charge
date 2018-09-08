//
//  QianMingTableViewCell.m
//  Charge
//
//  Created by olive on 16/7/30.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "QianMingTableViewCell.h"

@interface QianMingTableViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *qianMingLab;

@end

@implementation QianMingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setQianMing:(NSString *)qianMing
{
    _qianMing = qianMing;
    self.qianMingLab.text = qianMing;

}

@end
