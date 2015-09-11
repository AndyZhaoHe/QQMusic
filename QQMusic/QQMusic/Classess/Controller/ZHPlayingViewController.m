//
//  ZHPlayingViewController.m
//  QQ音乐
//
//  Created by 赵赫 on 15/9/9.
//  Copyright (c) 2015年 Andyzhao. All rights reserved.
//

#import "ZHPlayingViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ZHMusic.h"
#import "ZHAudioTool.h"
#import "ZHMusicTool.h"
#import "NSString+ZHTime.h"
#import "CALayer+PauseAimate.h"
#import "ZHLrcView.h"
#import "ZHLrcLabel.h"


@interface ZHPlayingViewController ()<AVAudioPlayerDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (weak, nonatomic) IBOutlet UISlider *slidervView;
@property (weak, nonatomic) IBOutlet UIImageView *songView;



@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;


// 播放暂停按钮
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;
//
// 歌词的View
@property (weak, nonatomic) IBOutlet ZHLrcView *lrcView;
// 歌词的Label
@property (weak, nonatomic) IBOutlet ZHLrcLabel *lrcLabel;

/** 进度的定时器 */
@property (nonatomic, strong) NSTimer *progressTimer;

/** 歌词的定时器 */
@property (nonatomic, strong) CADisplayLink *lrcTimer;

/** 当前播放器 */
@property (nonatomic, weak) AVAudioPlayer *currentPlayer;

@end

@implementation ZHPlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置毛玻璃效果
    [self setBlurView];
    
    // 设置Slider
    [self setSlider];
  
    // 播放歌曲
    [self startPlayingMusic];
    
    // 设置lrcView
    [self setlrcView];
 
  
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

- (void)setlrcView
{
    self.lrcView.contentSize = CGSizeMake(self.view.bounds.size.width * 2, 0);
    self.lrcView.delegate = self;
    self.lrcView.pagingEnabled = YES;
    self.lrcView.showsVerticalScrollIndicator = NO;
    self.lrcView.showsHorizontalScrollIndicator = NO;
    self.lrcView.lrcLabel = self.lrcLabel;

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
    blurView.barStyle = UIBarStyleBlack;
    blurView.frame = self.view.bounds;
    [self.backgroundImageView addSubview:blurView];

}

- (UIStatusBarStyle)preferredStatusBarStyle
{

    return UIStatusBarStyleLightContent;

}

#pragma mark - 开始播放歌曲
- (void)startPlayingMusic
{

    // 1.获取正在播放的歌曲
    ZHMusic *playingMusic = [ZHMusicTool playingMusic];
    
    // 2.设置界面基本信息
    self.backgroundImageView.image  = [UIImage imageNamed:playingMusic.icon];
    self.songView.image = [UIImage imageNamed:playingMusic.icon];
    self.songLabel.text = playingMusic.name;
    self.singerLabel.text = playingMusic.singer;
    
    // 3.播放音乐
    AVAudioPlayer *currentPlayer = [ZHAudioTool playMusicWithMuiscName:playingMusic.filename];
    currentPlayer.delegate = self;
    self.currentPlayer = currentPlayer;
    self.currentTimeLabel.text = [NSString stringWithTime:currentPlayer.currentTime];
    self.totalTimeLabel.text = [NSString stringWithTime:currentPlayer.duration];
    // 4.给iconView添加动画
    [self addIconViewAnimate];
    
    // 5.添加定时器
    [self addProgressTimer];
    
    // 6.改变选中(暂停状态)
    self.playOrPauseBtn.selected = YES;
    
    // 7.将歌词名称传递给LrcView
    self.lrcView.lrcname = playingMusic.lrcname;
    // 8.添加歌词的定时器
    [self addLrcTimer];

}

#pragma mark - 对定时器的操作
- (void)addProgressTimer
{
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];

    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

#pragma mark - 更新进度信息
- (void)updateProgressInfo
{
    // 1.更新当前播放时间Lable
    self.currentTimeLabel.text = [NSString stringWithTime:self.currentPlayer.currentTime];
    
    // 2.进度条
    self.slidervView.value = self.currentPlayer.currentTime / self.currentPlayer.duration;

}

- (void)addIconViewAnimate
{

    // 1.创建基本动画
    CABasicAnimation *rotationAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    // 2.给动画设置一些属性
    rotationAnim.fromValue = @(0);
    rotationAnim.toValue = @(M_PI * 2);
    rotationAnim.repeatCount = NSIntegerMax;
    rotationAnim.duration = 35;
    
    // 3.将动画添加到iconView的layer上面
    [self.songView.layer addAnimation:rotationAnim forKey:nil];

    
}

#pragma mark 歌曲播放的控制
- (IBAction)playOrPause
{

    self.playOrPauseBtn.selected = !self.playOrPauseBtn.isSelected;
    
    if (self.currentPlayer.isPlaying) {
        
        [self.currentPlayer pause];
        
        [self.songView.layer pauseAnimate];
        
        [self removeProgressTimer];
        
        
    }else{
    
        [self.currentPlayer play];
        [self.songView.layer resumeAnimate];
        
        [self addProgressTimer];
    
    }
    
    
}
- (IBAction)previousMusic
{
    [self changeMusicWithNewMusic:[ZHMusicTool previousMusic]];

}
- (IBAction)nextMusic
{
    [self changeMusicWithNewMusic:[ZHMusicTool nextMusic]];

   
}

- (void)changeMusicWithNewMusic:(ZHMusic *)newMusic
{
    // 1.停止当前歌曲
    ZHMusic *playingMusic = [ZHMusicTool playingMusic];
    [ZHAudioTool stopMusicWithMusicName:playingMusic.filename];
    
    // 2.设置上一首歌曲设置成当前歌曲
    [ZHMusicTool setPlayingMusic:newMusic];
    
    // 3.更新界面信息
    [self startPlayingMusic];
}


#pragma mark 监听滑块的事件
- (IBAction)startSlider
{
    [self removeProgressTimer];
}
- (IBAction)endSlider
{
    // 1.更新歌曲播放进度
    self.currentPlayer.currentTime = self.slidervView.value *self.currentPlayer.duration;
    
    // 2.添加定时器
    [self addProgressTimer];

    
}
- (IBAction)sliderValueChange
{
    // 1.获取当前时间Lable应该显示的时间
    NSTimeInterval currentTime = self.slidervView.value *self.currentPlayer.duration;
    
    // 2.设置当前时间Lable显示文字
    self.currentTimeLabel.text = [NSString stringWithTime:currentTime];

}

- (IBAction)sliderClick:(UITapGestureRecognizer *)sender {
    
    // 1.获取用户点击的点
    CGPoint point = [sender locationInView:sender.view];
    
    // 2.点击的点在进度条中的比例
    CGFloat ratio = point.x / self.slidervView.bounds.size.width;
    
    // 3.获取当前歌曲应该播放的时间
    NSTimeInterval currentTime = self.currentPlayer.duration * ratio;
    
    self.currentPlayer.currentTime = currentTime;
    
    // 4.更新进度信息
    [self updateProgressInfo];
    
}

- (void)removeProgressTimer
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;

}

- (void)addLrcTimer
{
    self.lrcTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrc)];
    [self.lrcTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}
#pragma mark - 更新歌词
- (void)updateLrc
{
    self.lrcView.currentTime = self.currentPlayer.currentTime;
}
- (void)removeLrcTimer
{
    [self.lrcTimer invalidate];
    self.lrcTimer = nil;
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag) {
        [self nextMusic];
    }
    
}

#pragma mark - 实现UIScrollView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 1.取出scrollView偏移量
    CGPoint offset = scrollView.contentOffset;
    CGFloat offsetRatio = offset.x / scrollView.bounds.size.width;
    
    // 设置iconView和歌词Label的透明度
    self.songView.alpha = 1 - offsetRatio;
    self.lrcLabel.alpha = 1 - offsetRatio;
}

@end
