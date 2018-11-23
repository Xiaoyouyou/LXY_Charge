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
}

-(void)daohangEvent{
    self.daohang(self.model1.latitude, self.model1.longitude);
    NSLog(@"点击了导航按钮");
}
@end
