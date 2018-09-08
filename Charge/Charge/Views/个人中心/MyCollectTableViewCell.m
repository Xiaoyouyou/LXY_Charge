//
//  MyCollectTableViewCell.m
//  Charge
//
//  Created by olive on 16/6/7.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "MyCollectTableViewCell.h"

@interface MyCollectTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *titleName;//名字
@property (strong, nonatomic) IBOutlet UILabel *address;//地址
@property (strong, nonatomic) IBOutlet UILabel *distanceLab;//距离

@property (strong, nonatomic) IBOutlet UILabel *fastLab;//快充
@property (strong, nonatomic) IBOutlet UILabel *slowLab;//慢充

- (IBAction)daoHangBtnAction:(id)sender;


@end


@implementation MyCollectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)daoHangBtnAction:(id)sender {
    
    self.daoHangBlock();
}



#pragma mark - Set 方法

-(void)setAddresss:(NSString *)addresss
{
    _addresss = addresss;
    self.address.text = addresss;
}

-(void)setFastLabs:(NSString *)fastLabs
{
    _fastLabs = fastLabs;
    self.fastLab.text = [NSString stringWithFormat:@"快(%@)",fastLabs];
}

- (void)setSlowLabs:(NSString *)slowLabs
{
    _slowLabs = slowLabs;
    self.slowLab.text = [NSString stringWithFormat:@"慢(%@)",slowLabs];
    
}

-(void)setTitleNames:(NSString *)titleNames
{
    _titleNames = titleNames;
    self.titleName.text = titleNames;
    
}

-(void)setDistance:(NSString *)distance
{
    _distance = distance;
    self.distanceLab.text = distance;
    
}

@end
