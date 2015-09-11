//
//  ZHMusicTool
//  QQMusic
//
//  Created by 赵赫 on 15/9/11.
//  Copyright (c) 2015年 Andyzhao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZHMusic;

@interface ZHMusicTool : NSObject

+ (NSArray *)musics;

+ (void)setPlayingMusic:(ZHMusic *)playingMusic;

+ (ZHMusic *)playingMusic;

+ (ZHMusic *)nextMusic;

+ (ZHMusic *)previousMusic;



@end
