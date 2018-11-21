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
        self.backgroundColor = [UIColor whiteColor];
        UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        topLabel.text = topStr;
        topLabel.textColor = RGB_COLOR(154, 154, 154, 1.0);
        topLabel.font = [UIFont systemFontOfSize:15];
        topLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:topLabel];
        
        UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        bottomLabel.text = bottomStr;
        bottomLabel.font = [UIFont systemFontOfSize:15];
        bottomLabel.textColor = RGB_COLOR(247, 135, 54, 1.0);
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:bottomLabel];
        
        CGFloat H = self.frame.size.height / 2 - 2;
        [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self);
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.mas_offset(H);
            
        }];
//        UIView *lineView = [[UIView alloc] init];
//        [self addSubview:lineView];
//        lineView.backgroundColor = RGB_COLOR(154, 154, 154, 1.0);
//        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self);
//            make.centerY.equalTo(self);
//            make.height.mas_offset(self.mas_height);
//            make.width.mas_offset(1);
//        }];
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
