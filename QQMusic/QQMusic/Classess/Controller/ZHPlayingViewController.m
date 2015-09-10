//
//  ZHPlayingViewController.m
//  QQ音乐
//
//  Created by 赵赫 on 15/9/9.
//  Copyright (c) 2015年 Andyzhao. All rights reserved.
//

#import "ZHPlayingViewController.h"

@interface ZHPlayingViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (weak, nonatomic) IBOutlet UISlider *slidervView;
@property (weak, nonatomic) IBOutlet UIImageView *songView;
@end

@implementation ZHPlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置毛玻璃效果
    [self setBlurView];
    
    // 设置Slider
    [self setSlider];
  
  
}

// 设置圆角不能再ViewDidLoad中,因为那时候的Frame还没有确定

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    self.songView.layer.cornerRadius = self.songView.frame.size.width  * 0.5;
    self.songView.layer.masksToBounds = YES;
    
    self.songView.layer.borderWidth = 7;
    self.songView.layer.borderColor = [UIColor colorWithRed:27/255.0 green:27/255.0 blue:27/255.0 alpha:1.0].CGColor;
}

- (void)setSlider
{
    [self.slidervView setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb"] forState:UIControlStateNormal];
    // 38 187 102
    [self.slidervView setMinimumTrackTintColor:[UIColor colorWithRed:38/255.0 green:187/255.0 blue:102/255.0 alpha:1.0]];



}

- (void)setBlurView
{
    UIToolbar *blurView = [[UIToolbar alloc] init];
    //blurView.translatesAutoresizingMaskIntoConstraints = NO;
    blurView.barStyle = UIBarStyleBlack;
    blurView.frame = self.view.bounds;
    [self.backgroundImageView addSubview:blurView];

}
@end
