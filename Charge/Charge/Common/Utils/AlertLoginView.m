//
//  AlertLoginView.m
//  Charge
//
//  Created by melon on 16/1/22.
//  Copyright © 2016年 XingGuo. All rights reserved.
//

#import "AlertLoginView.h"

@interface AlertLoginView()

@property (weak, nonatomic) IBOutlet UILabel *icon;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UIButton *bgTapBtn;

@end



@implementation AlertLoginView


- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.alpha = 0.0f;
        
        _alertView.layer.cornerRadius = 4;
        _alertView.layer.masksToBounds = YES;
        
        _icon.layer.borderColor = [UIColor blackColor].CGColor;
        _icon.layer.borderWidth = 1.6f;
        _icon.layer.cornerRadius = 22;
        _icon.layer.masksToBounds = YES;
        
        _cancelBtn.layer.borderColor = [UIColor redColor].CGColor;
        _cancelBtn.layer.borderWidth = 0.6f;
        _cancelBtn.layer.cornerRadius = 3;
        _cancelBtn.layer.masksToBounds = YES;
        
        _loginBtn.layer.cornerRadius = 3;
        _loginBtn.layer.masksToBounds = YES;
    }
    
    [_bgTapBtn addTarget:self action:@selector(dismissAlertLoginView:) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView animateWithDuration:0.3 animations:^{
        _alertView.frame = CGRectOffset(_alertView.frame, 0, -30);
        self.alpha = 1;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    }];
}

- (IBAction)dismissAlertLoginView:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        _alertView.frame = CGRectOffset(_alertView.frame, 0, 30);
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        if (self.hideAlertLoginView) {
            self.hideAlertLoginView();
        }
    }];
}

- (IBAction)toLoginView:(id)sender {
    if (self.toLoginView) {
        self.toLoginView();
    }
}

@end
