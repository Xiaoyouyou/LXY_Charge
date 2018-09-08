//
//  CountLabel.m
//  CircleAnimation
//
//  Created by fujin on 15/10/20.
//  Copyright © 2015年 fujin. All rights reserved.
//

#import "CountLabel.h"
#define RGBA(r,g,b,a)      [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]

@interface CountLabel ()
{
    NSTimer *timer;
}
@end
@implementation CountLabel
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        self.text = @"0";
        self.font = [UIFont systemFontOfSize:38];
        self.textColor = RGBA(29, 167, 146, 1);
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)updateLabel:(NSInteger)percent withAnimationTime:(CGFloat)animationTime{
    CGFloat startPercent = [self.text integerValue];
    CGFloat endPercent = percent;
    
    CGFloat intever = animationTime/fabs(endPercent - startPercent);
    
    timer = [NSTimer scheduledTimerWithTimeInterval:intever target:self selector:@selector(IncrementAction:) userInfo:[NSNumber numberWithInteger:percent] repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];
    [timer fire];
}

-(void)IncrementAction:(NSTimer *)time{
    NSInteger change = [self.text integerValue];
    if(change < [time.userInfo integerValue]){
        change ++;
    }
    else{
        change --;
    }
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"%ld%%",(long)change]];
    
    [attributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:25]
                          range:NSMakeRange(self.text.length - 1, 1)];
    self.attributedText =attributedStr ;
    if ([self.text integerValue] == [time.userInfo integerValue]) {
        [time invalidate];
    }
    
}
-(void)clear{
    self.text = @"0";
}
@end
