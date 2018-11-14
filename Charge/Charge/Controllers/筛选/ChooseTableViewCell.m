//
//  ChooseTableViewCell.m
//  Charge
//
//  Created by 罗小友 on 2018/11/1.
//  Copyright © 2018 com.XinGuoXin.cn. All rights reserved.
//

#import "ChooseTableViewCell.h"
#import "ChooseModel.h"
@interface ChooseTableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *chargeName;
@property (strong, nonatomic) IBOutlet UILabel *chargeAddress;
@property (strong, nonatomic) IBOutlet UILabel *chargePrice;
@property (strong, nonatomic) IBOutlet UIView *daoHangView;
@property (strong, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic) ChooseModel *model1;
@end

@implementation ChooseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(daohangEvent)];
    [self.daoHangView addGestureRecognizer:tap];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(ChooseModel *)model{
    self.model1 = model;
    self.chargeName.text = model.stationName;
    self.chargeAddress.text = model.addr;
    self.chargePrice.text = [NSString stringWithFormat:@"%.2f元/度",[model.price floatValue]];
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.stationPic] placeholderImage:[UIImage imageNamed:@"icon-1"]];
}

-(void)daohangEvent{
    self.daohang(self.model1.latitude, self.model1.longitude);
    NSLog(@"点击了导航按钮");
}
@end
