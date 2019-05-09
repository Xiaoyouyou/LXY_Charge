//
//  DetailZhuangWeiHeaderView.h
//  Charge
//
//  Created by olive on 16/6/8.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailZhuangWeiHeaderView : UIView

@property (nonatomic, strong) UIImageView *pictImageView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *FutitleLab;
@property (nonatomic, strong) UILabel *diastaceLab;
@property (nonatomic, strong) UILabel *fastLab;
@property (nonatomic, strong) UILabel *slowLab;
@property (nonatomic, strong) UIImageView *fastImageView;
@property (nonatomic, strong) UIImageView *slowImageView;

@property (nonatomic ,strong)NSArray *picArray;
@end
