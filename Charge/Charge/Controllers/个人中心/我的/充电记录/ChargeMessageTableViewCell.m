//
//  ChargeMessageTableViewCell.m
//  Charge
//
//  Created by 罗小友 on 2018/10/30.
//  Copyright © 2018 com.XinGuoXin.cn. All rights reserved.
//

#import "ChargeMessageTableViewCell.h"
#import "ChargeMessageModel.h"

@interface ChargeMessageTableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *ZhanDianName;
@property (strong, nonatomic) IBOutlet UILabel *FlashStatus;
@property (strong, nonatomic) IBOutlet UILabel *FlashMoney;

@property (strong, nonatomic) IBOutlet UILabel *FlashTime;

@end

@implementation ChargeMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(ChargeMessageModel *)model
{
    self.ZhanDianName.text = model.stationName;
    self.FlashTime.text = model.endDate;
    self.FlashStatus.text = @"完成充电";
    self.FlashMoney.text = [NSString stringWithFormat:@"消费金额 %@元",model.totalCost];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
