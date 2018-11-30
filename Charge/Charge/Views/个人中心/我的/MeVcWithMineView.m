//
//  MeVcWithMineView.m
//  Charge
//
//  Created by 罗小友 on 2018/10/14.
//  Copyright © 2018年 com.XinGuoXin.cn. All rights reserved.
//

#import "MeVcWithMineView.h"
#import <Masonry.h>

@interface MeVcWithMineView()
@property (nonatomic ,strong)UILabel *topLabel;
@property (nonatomic ,strong)UILabel *bottomLabel;
@end

@implementation MeVcWithMineView

-(instancetype)initWithFrame:(CGRect)frame TopTitle:(NSString *)topStr BottomTitle:(NSString *)bottomStr{
    if (self == [super initWithFrame:frame]) {
        UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        topLabel.text = topStr;
        topLabel.layer.borderColor = RGB_COLOR(231, 231, 231, 1.0).CGColor;
        topLabel.layer.borderWidth = 1;
        topLabel.textColor = RGB_COLOR(247, 135, 54, 1.0);
        topLabel.font = [UIFont systemFontOfSize:12];
        topLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:topLabel];
        
        UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        bottomLabel.layer.borderColor = RGB_COLOR(231, 231, 231, 1.0).CGColor;
        bottomLabel.layer.borderWidth = 1;
        bottomLabel.text = bottomStr;
        bottomLabel.font = [UIFont systemFontOfSize:12];
        bottomLabel.textColor = RGB_COLOR(154, 154, 154, 1.0);
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:bottomLabel];
        
        CGFloat H = self.frame.size.height / 2;
        [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self);
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.mas_offset(H);
            
        }];
        
        [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(topLabel.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.mas_offset(H);
        }];
    }
    return self;
}

-(void)layoutSubviews{
  
}

@end
