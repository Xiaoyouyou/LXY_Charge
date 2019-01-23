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

-(void)awakeFromNib{
    [super awakeFromNib];
    self.cancel.layer.masksToBounds = YES;
    self.cancel.layer.cornerRadius = 10;
    self.sure.layer.masksToBounds = YES;
    self.sure.layer.cornerRadius = 10;
}


- (IBAction)btnZhiLiu:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (_zhiliu.selected == YES) {
        [self.dict setValue:@"1" forKey:@"acFlag"];
        _jiaoliu.selected = NO;
    }else{
         [self.dict removeObjectForKey:@"acFlag"];
    }
    
}

- (IBAction)btnJiaoliu:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (_jiaoliu.selected == YES) {
         [self.dict setValue:@"0" forKey:@"acFlag"];
        _zhiliu.selected = NO;
    }else{
         [self.dict removeObjectForKey:@"acFlag"];
    }
}




- (IBAction)kongxianYES:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (_yesKongxian.selected == YES) {
         [self.dict setValue:@"00" forKey:@"state"];
        _noKongxian.selected = NO;
    }else{
        [self.dict removeObjectForKey:@"state"];
    }
}

- (IBAction)kongxianNO:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (_noKongxian.selected == YES) {
         [self.dict setValue:@"02" forKey:@"state"];
        _yesKongxian.selected = NO;
    }else{
        [self.dict removeObjectForKey:@"state"];
    }
}
- (IBAction)mainfeiYES:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (_yesKaifang.selected == YES) {
         [self.dict setValue:@"0" forKey:@"freePark"];
        _noKaifang.selected = NO;
    }else{
        [self.dict removeObjectForKey:@"freePark"];
    }
}
- (IBAction)mianfeiNO:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (_noKaifang.selected == YES) {
         [self.dict setValue:@"1" forKey:@"freePark"];
        _yesKaifang.selected = NO;
    }else{
        [self.dict removeObjectForKey:@"freePark"];
    }
}



- (IBAction)chooseTypeBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSLog(@"%ld",sender.tag);
    NSString *str = [NSString stringWithFormat:@"%d",(int)sender.tag];
    if (sender.tag == 0 ) {
        if (sender.selected == YES) {
          
        }else{
           
        }
       
    }else if (sender.tag == 1 & sender.selected == YES){
        if (sender.selected == YES) {
             [self.dict setValue:@"直流" forKey:str];
        }else{
            [self.dict removeObjectForKey:str];
        }
       
    }else if (sender.tag == 2){
        if (sender.selected == YES) {
             [self.dict setValue:@"是" forKey:str];
        }else{
            [self.dict removeObjectForKey:str];
        }
       
    }else if (sender.tag == 3){
        if (sender.selected == YES) {
            [self.dict setValue:@"否" forKey:str];
        }else{
            [self.dict removeObjectForKey:str];
        }
        
    }else if (sender.tag == 4 ){
        if (sender.selected == YES) {
            [self.dict setValue:@"0" forKey:@"freePark"];
        }else{
            [self.dict removeObjectForKey:@"freePark"];
        }
        
    }else if (sender.tag == 5 ){
        if (sender.selected == YES) {
            [self.dict setValue:@"1" forKey:@"freePark"];
        }else{
            [self.dict removeObjectForKey:@"freePark"];
        }
        
    }
    
    
    
}
- (IBAction)cancleBtn:(id)sender {
    NSLog(@"点击的取消按钮");
    self.cancelBlock();
}

- (IBAction)sureBtn:(id)sender {
    NSLog(@"点击的是确认按钮%@",self.dict);
    self.chooseBlock(_dict);
}
@end
