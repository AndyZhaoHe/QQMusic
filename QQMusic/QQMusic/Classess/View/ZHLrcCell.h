//
//  ZHLrcCell.h
//  QQMusic
//
//  Created by 赵赫 on 15/9/11.
//  Copyright (c) 2015年 Andyzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHLrcLabel;

@interface ZHLrcCell : UITableViewCell

/** 歌词的label */
@property (nonatomic, weak, readonly) ZHLrcLabel *lrcLabel;


+ (instancetype)lrcCellWithTableView:(UITableView *)tableView;

@end
