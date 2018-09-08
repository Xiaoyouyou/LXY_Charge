//
//  YuYueTableFooterView.m
//  Charge
//
//  Created by olive on 16/6/30.
//  Copyright © 2016年 com.XinGuoXin.cn. All rights reserved.
//

#import "YuYueTableFooterView.h"

@interface YuYueTableFooterView ()<UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *quXiaoYuYue;
- (IBAction)quXiaoYuYueActin:(id)sender;

@end

@implementation YuYueTableFooterView

+(instancetype)creatYuYueTableFooterView
{
      return [[[NSBundle mainBundle]loadNibNamed:@"YuYueTableFooterView" owner:nil options:nil]lastObject];
}

-(void)awakeFromNib
{
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.quXiaoYuYue.layer.masksToBounds = YES;
    self.quXiaoYuYue.layer.cornerRadius = 5;
    
}

- (IBAction)quXiaoYuYueActin:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"您确定取消预约吗？"
                                                       message:nil
                                                       delegate:self
                                                cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"确定", nil];
    
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        self.quXiaoYuYueBlcok();
    }
}

@end
