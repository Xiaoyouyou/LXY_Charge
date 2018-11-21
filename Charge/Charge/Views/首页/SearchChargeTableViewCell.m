//
//  SearchChargeTableViewCell.m
//  Charge
//
//  Created by olive on 16/6/6.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "SearchChargeTableViewCell.h"

@interface SearchChargeTableViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *chargeName;//充电站名称
@property (strong, nonatomic) IBOutlet UILabel *chargeAddress;//充电站地址
@property (strong, nonatomic) IBOutlet UILabel *fastLab;//快
@property (strong, nonatomic) IBOutlet UILabel *slowLab;//慢
@property (strong, nonatomic) IBOutlet UILabel *distabceLab;//距离
@property (strong, nonatomic) IBOutlet UILabel *costLab;//花费

@end

@implementation SearchChargeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -- set方法

//计费
-(void)setTempCostLab:(NSString *)tempCostLab
{
    _tempCostLab = tempCostLab;
    self.costLab.text = tempCostLab;
}

////快充
//-(void)setTempFastLab:(NSString *)tempFastLab
//{
//    _tempFastLab = tempFastLab;
//    self.fastLab.text = [NSString stringWithFormat:@"快(%@)",tempFastLab];
//}

////慢充
//-(void)setTempSlowLab:(NSString *)tempSlowLab
//{
//    _tempSlowLab = tempSlowLab;
//    self.slowLab.text = [NSString stringWithFormat:@"慢(%@)",tempSlowLab];
//}

//充电站名
-(void)setTempChargeName:(NSString *)tempChargeName
{
    _tempChargeName = tempChargeName;
    self.chargeName.text = tempChargeName;
    
}
//距离
-(void)setTempDistabceLab:(NSString *)tempDistabceLab
{
    _tempDistabceLab = tempDistabceLab;
//    if(tempDistabceLab.floatValue > 1000){
//     CGFloat distabce = tempDistabceLab.floatValue/1000;
        self.distabceLab.text = [NSString stringWithFormat:@"%.2lfkm",tempDistabceLab.floatValue];
//    }else{
//        self.distabceLab.text = [NSString stringWithFormat:@"%.2lfm",tempDistabceLab.floatValue];
//    }
}

//充电桩地址
-(void)setTempChargeAddress:(NSString *)tempChargeAddress
{
    _tempChargeAddress = tempChargeAddress;
    self.chargeAddress.text = tempChargeAddress;

}

@end
