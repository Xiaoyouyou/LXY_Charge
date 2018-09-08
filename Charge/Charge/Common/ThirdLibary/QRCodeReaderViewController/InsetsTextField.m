//
//  InsetsTextField.m
//  Charge
//
//  Created by olive on 16/1/12.
//  Copyright © 2016年 XingGuo. All rights reserved.
//

#import "InsetsTextField.h"

@implementation InsetsTextField
//控制placeHolder的位置
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 0);
}
//控制文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 0);
}

@end
