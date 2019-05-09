//
//  SettingFooterView.m
//  Charge
//
//  Created by olive on 16/6/7.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "SettingFooterView.h"
#import "XFunction.h"
#import "XStringUtil.h"


@interface SettingFooterView ()

@property (strong, nonatomic) IBOutlet UIButton *tuiChuDengLu;
- (IBAction)tuiChuDengLu:(id)sender;

@end

@implementation SettingFooterView

+(instancetype)creatSettingFooterView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"SettingFooterView" owner:nil options:nil]lastObject];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tuiChuDengLu.layer.cornerRadius = 5;
    self.tuiChuDengLu.clipsToBounds = YES;
    //判断如果已经退出登录，就不让点退出登录了
    if([Config getOwnID] == nil){
        self.tuiChuDengLu.enabled = NO;
    }else{
        
       self.tuiChuDengLu.enabled = YES;
    }
    
}

- (IBAction)tuiChuDengLu:(id)sender {
    self.tuiChuDengLuBlock();
}
@end
