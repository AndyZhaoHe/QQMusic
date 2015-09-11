//
//  ZHLrcLabel.m
//  QQMusic
//
//  Created by 赵赫 on 15/9/11.
//  Copyright (c) 2015年 Andyzhao. All rights reserved.
//

#import "ZHLrcLabel.h"

@implementation ZHLrcLabel

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGRect drawRect = CGRectMake(0, 0, self.bounds.size.width * self.progress, self.bounds.size.height);
    [[UIColor greenColor] set];
     UIRectFillUsingBlendMode(drawRect, kCGBlendModeSourceIn);
}

@end
