//
//  RechargeDetailsTableViewCell.m
//  Charge
//
//  Created by olive on 16/9/1.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "RechargeDetailsTableViewCell.h"
#import "XFunction.h"

@interface RechargeDetailsTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *costProject;//消费项目
@property (strong, nonatomic) IBOutlet UILabel *costTime;//消费时间
@property (strong, nonatomic) IBOutlet UILabel *costMoney;//消费金额

@property (strong, nonatomic) NSString *tempCreatDate;
@property (strong, nonatomic) NSString *tempDesc;
@property (strong, nonatomic) NSString *tempTradeFee;
@property (strong, nonatomic) NSString *tempTradeType;
@property (strong, nonatomic) NSString *tempId;

@property (strong, nonatomic) UserBalanceModel *tempUserBalanceModel;

@end

@implementation RechargeDetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)setUseModel:(UserBalanceModel *)useModel
{
    _useModel = useModel;
    self.costTime.text = self.useModel.createDate;
    self.costProject.text = self.useModel.desc;

    if ([self.useModel.tradeType intValue] == 1) {//充值
        self.costMoney.textColor = RGBA(9, 130, 113, 1);
        self.costMoney.text = [NSString stringWithFormat:@"%.2f",[self.useModel.tradeFee doubleValue]];
        
    }else if ([self.useModel.tradeType intValue] == 0)//充电扣费
    {
        self.costMoney.textColor = RGBA(235, 97, 0, 1);
        self.costMoney.text = [NSString stringWithFormat:@"%.2f",[self.useModel.tradeFee doubleValue]];
    }else if ([self.useModel.tradeType intValue] == 2)//预约扣费
    {
        self.costMoney.textColor = RGBA(235, 97, 0, 1);
        self.costMoney.text = [NSString stringWithFormat:@"%.2f",[self.useModel.tradeFee doubleValue]];
    }
}

@end
