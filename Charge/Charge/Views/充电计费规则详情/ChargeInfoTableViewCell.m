//
//  ChargeInfoTableViewCell.m
//  Charge
//
//  Created by 罗小友 on 2018/10/27.
//  Copyright © 2018 com.XinGuoXin.cn. All rights reserved.
//

#import "ChargeInfoTableViewCell.h"

@interface ChargeInfoTableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *chargeLabel;
@property (strong, nonatomic) IBOutlet UILabel *serviceFee;

@end

@implementation ChargeInfoTableViewCell



- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(ChargeInfoModel *)model
{
    self.timeLabel.text = [NSString stringWithFormat:@"时间段: %@ - %@",model.startTime,model.endTime];
    self.chargeLabel.text = [NSString stringWithFormat:@"电费: %@元/kwh",model.chargeCost];
    self.serviceFee.text = [NSString stringWithFormat:@"电费: %@元/kwh",model.serviceCost];
}
@end
