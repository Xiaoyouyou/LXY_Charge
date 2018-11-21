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
@property (strong, nonatomic) IBOutlet UILabel *FlashMoney;

@property (strong, nonatomic) IBOutlet UILabel *FlashTime;
@property (strong, nonatomic) IBOutlet UILabel *serverCost;


@property (strong, nonatomic) IBOutlet UILabel *electricCost;

@property (strong, nonatomic) IBOutlet UILabel *elecDegree;

@end

@implementation ChargeMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(ChargeMessageModel *)model
{
    self.ZhanDianName.text = model.stationName;
    self.FlashTime.text = [NSString stringWithFormat:@"%@ —— %@",model.createDate,model.endDate];
    self.serverCost.text = [NSString stringWithFormat:@"服务费:￥%@元",model.serverCost];
    
    
    self.electricCost.text = [NSString stringWithFormat:@"电费:￥%@元",model.electricCost];
    
    self.elecDegree.text = [NSString stringWithFormat:@"充电度数:%@kwh",model.elecDegree];
    self.FlashMoney.text = [NSString stringWithFormat:@"消费金额 %@元",model.totalCost];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
