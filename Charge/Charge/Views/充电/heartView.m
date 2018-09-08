//
//  heartView.m
//  drawHeart
//
//  Created by 阿城 on 15/10/8.
//  Copyright © 2015年 阿城. All rights reserved.
//

#import "heartView.h"

@interface heartView ()
@property (nonatomic ,assign)CGFloat t;
@end

//颜色和透明度设置
#define RGBA(r,g,b,a)               [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]

@implementation heartView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
//    CGFloat endAngle = M_PI_4;
//    CGFloat radius = MIN(self.bounds.size.width * 0.25, self.bounds.size.height * 0.5) - 10;
//    CGPoint center1 = CGPointMake(self.bounds.size.width * 0.5 + radius, self.bounds.size.height * 0.5);
//    CGPoint center2 = CGPointMake(self.bounds.size.width * 0.5 - radius, self.bounds.size.height * 0.5);
//    
//    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center1 radius:radius startAngle:-M_PI endAngle:endAngle clockwise:1];
//    
//    [path addLineToPoint:CGPointMake(center1.x - radius, center1.y + radius * tan((M_PI - endAngle)*0.5))];
//    
//    [path addArcWithCenter:center2 radius:radius startAngle:M_PI - endAngle endAngle:0 clockwise:1];
//    
//      [path addClip];
//    [path setLineWidth:2];
//    [path setLineCapStyle:kCGLineCapRound];
//
//    [path stroke];

    //wave
    CGPoint zero = CGPointMake(0, self.bounds.size.height * (1-0.55));
    UIBezierPath *wave = [UIBezierPath bezierPath];
    [wave moveToPoint:zero];
    for (int i = 0; i < self.bounds.size.width; i++) {
        CGPoint p = relativeCoor(zero, i, 2*sin(M_PI /50 *i + _t ) );
        [wave addLineToPoint:p];
    }
    [wave addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
    [wave addLineToPoint:CGPointMake(0, self.bounds.size.height)];
    [RGBA(29, 162, 141, 1) set];
    [wave fill];
}

-(void)didMoveToSuperview{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(change) userInfo:nil repeats:YES];
    [timer fire];
    
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    view.image = [UIImage imageNamed:@"charging_car_back"];
    [self addSubview:view];
}

-(void)change{
    _t += M_PI * 0.05;
    if (_t == M_PI * 2) {
        _t = 0;
    }
    [self setNeedsDisplay];
}

CGPoint relativeCoor(CGPoint point, CGFloat x ,CGFloat y){
    return CGPointMake(point.x + x, point.y + y);
}
@end
