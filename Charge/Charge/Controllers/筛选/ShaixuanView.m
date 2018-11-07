//
//  ShaixuanView.m
//  Charge
//
//  Created by 罗小友 on 2018/11/7.
//  Copyright © 2018 com.XinGuoXin.cn. All rights reserved.
//

#import "ShaixuanView.h"
@interface ShaixuanView()
@property (strong, nonatomic) IBOutlet UIButton *jiaoliu;

@property (strong, nonatomic) IBOutlet UIButton *zhiliu;
@property (strong, nonatomic) IBOutlet UIButton *yesKongxian;
@property (strong, nonatomic) IBOutlet UIButton *noKongxian;
@property (strong, nonatomic) IBOutlet UIButton *yesKaifang;
@property (strong, nonatomic) IBOutlet UIButton *noKaifang;
@property (strong, nonatomic) IBOutlet UIButton *cancel;

@property (strong, nonatomic) IBOutlet UIButton *sure;


@property (strong, nonatomic)NSMutableDictionary *dict;
@end
@implementation ShaixuanView

-(NSMutableDictionary *)dict{
    if(!_dict){
        _dict= [NSMutableDictionary dictionary];
    }
    return _dict;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return [[[NSBundle mainBundle] loadNibNamed:@"ShaixuanView" owner:nil options:nil] lastObject];
}

- (IBAction)chooseTypeBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSLog(@"%ld",sender.tag);
    NSString *str = [NSString stringWithFormat:@"%d",(int)sender.tag];
    if (sender.tag == 0) {
        [self.dict setValue:@"交流" forKey:str];
    }else if (sender.tag == 1){
        [self.dict setValue:@"直流" forKey:str];
    }else if (sender.tag == 2){
        [self.dict setValue:@"是" forKey:str];
    }else if (sender.tag == 3){
        [self.dict setValue:@"否" forKey:str];
    }else if (sender.tag == 4){
        [self.dict setValue:@"是" forKey:str];
    }else if (sender.tag == 5){
        [self.dict setValue:@"否" forKey:str];
    }
    
    
}
- (IBAction)cancleBtn:(id)sender {
    NSLog(@"点击的取消按钮");
    self.cancelBlock();
}

- (IBAction)sureBtn:(id)sender {
    NSLog(@"点击的是确认按钮");
    self.chooseBlock(self.dict);
}
@end
