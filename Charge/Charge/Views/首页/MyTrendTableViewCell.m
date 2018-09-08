//
//  MyTrendTableViewCell.m
//  Charge
//
//  Created by olive on 16/8/31.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "MyTrendTableViewCell.h"

@interface MyTrendTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *stationNameLab;//充电站名称
@property (strong, nonatomic) IBOutlet UILabel *endTimeLab;//结束时间
@property (strong, nonatomic) IBOutlet UILabel *costLab;//消费金额

@property (nonatomic, copy) NSString *tempCost;


@end

@implementation MyTrendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
  //  self.stationNameLab.text = self.stationNames;
    //self.endTimeLab.text = self.endTimes;
    //self.costLab.text = self.costs;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - set方法

-(void)setCosts:(NSString *)costs
{
    _costs = costs;
    self.costLab.text = [NSString stringWithFormat:@"消耗金额%@￥",costs];
}

-(void)setEndTimes:(NSString *)endTimes
{
    _endTimes = endTimes;
    self.endTimeLab.text = endTimes;
}

-(void)setStationNames:(NSString *)stationNames
{
    _stationNames = stationNames;
    self.stationNameLab.text = stationNames;
}

@end
