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

-(void)setListModel:(MyCarListModel *)listModel{
    [self.chargeIamge sd_setImageWithURL:[NSURL URLWithString:listModel.img]];
    self.CarModels.text = listModel.pattern;
    self.CarNumber.text = listModel.plate_number;
    self.CarChargeType.text = listModel.brand;
}
- (IBAction)cancelBtn:(UIButton *)sender {
    self.cancel();
}
- (IBAction)changeBtn:(UIButton *)sender {
    self.change();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
