//
//  SlideView.h
//  MakerMap
//
//  Created by kevin on 16/4/13.
//  Copyright © 2016年 kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^LeftViewBlock)(NSInteger indexRow);


@protocol PersonSlideViewDelegate <NSObject>
@optional

- (void)yuYueClick;
- (void)qianBaoClick;
- (void)keFuClick;
- (void)shouChangClick;
- (void)settingClick;
- (void)headerClick;
- (void)loginShow;//展示登陆界面
- (void)shouShiTuiChu;//手势退出


@end
@interface PersonSlideView : UIView

@property (nonatomic,copy)LeftViewBlock leftBlock;
@property (nonatomic, assign) id<PersonSlideViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame superView:(UIView *)superView;
- (void)handle:(LeftViewBlock)block;
- (void)leftViewShow:(BOOL)show;

@end
