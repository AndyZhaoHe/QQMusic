///
//  NSString+ZHTime.m
//  QQMusic
//
//  Created by 赵赫 on 15/9/11.
//  Copyright (c) 2015年 Andyzhao. All rights reserved.
//

#import "NSString+ZHTime.h"

@implementation NSString (ZHTime)

+ (NSString *)stringWithTime:(NSTimeInterval)time
{
    NSInteger min = time / 60;
    NSInteger second = (NSInteger)time % 60;
    
    return [NSString stringWithFormat:@"%02ld:%02ld", min, second];
}


@end


