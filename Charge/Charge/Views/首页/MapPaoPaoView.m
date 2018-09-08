//
//  MapPaoPaoView.m
//  Charge
//
//  Created by olive on 16/7/6.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "MapPaoPaoView.h"
#import "XFunction.h"
#import "Masonry.h"

@interface  MapPaoPaoView()
{
    UIButton *daoHangBtn;
    UIButton *yuYueBtn;
}
@end

@implementation MapPaoPaoView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        [self creatUI];
        [self creatYueShu];
    }
    return self;
}

-(void)creatUI
{
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text= @"太古汇1区充电点";
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.textColor = [UIColor blackColor];
    [self addSubview:titleLab];
    
    UILabel *distanceLab = [[UILabel alloc] init];
    distanceLab.text= @"600m";
    distanceLab.font = [UIFont systemFontOfSize:12];
    distanceLab.textColor = [UIColor blackColor];
    [self addSubview:distanceLab];
    
    UILabel *addressLab = [[UILabel alloc] init];
    addressLab.text= @"天河区xxx路xx号xx";
    addressLab.font = [UIFont systemFontOfSize:13];
    addressLab.textColor = [UIColor blackColor];
    [self addSubview:addressLab];
    
    daoHangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [daoHangBtn setTitle:@"导航" forState:UIControlStateNormal];
    daoHangBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [daoHangBtn setTitleColor:RGBA(29, 146, 234, 1) forState:UIControlStateNormal];
    [self addSubview:daoHangBtn];
   
    yuYueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [yuYueBtn setTitle:@"预约" forState:UIControlStateNormal];
    yuYueBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [yuYueBtn setTitleColor:RGBA(29, 146, 234, 1) forState:UIControlStateNormal];
    [self addSubview:yuYueBtn];
}

-(void)creatYueShu
{
//   [daoHangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//       make.bottom.equalTo(self);
//       make.left.equalTo(self);
//       make.size.height.mas_equalTo();
//       
//   }];
}

@end
