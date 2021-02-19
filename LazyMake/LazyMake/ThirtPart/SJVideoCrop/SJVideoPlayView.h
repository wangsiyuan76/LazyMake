//
//  SJVideoPlayView.h
//  VideoPlayDemo
//
//  Created by shengjie zhang on 2019/3/25.
//  Copyright © 2019 shengjie zhang. All rights reserved.
//



#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class SJMediaInfoConfig;
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CropPlayerStatus) {
    CropPlayerStatusPause,             // 结束或暂停
    CropPlayerStatusPlaying,           // 播放中
    CropPlayerStatusPlayingBeforeSeek  // 拖动之前是播放状态
};

@protocol SJVideoPlayViewDelegate <NSObject>

@required
-(void)SJVideoReadyToPlay;
- (void)SJVideoPlay;
- (void)SJVideoStop;
- (void)SJVideoEnd;

@end

@interface SJVideoPlayView : UIView
- (id)initWithFrame:(CGRect)frame localUrl:(NSURL *)localUrl;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, assign) CropPlayerStatus playerStatus;
@property (nonatomic ,strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) SJMediaInfoConfig *mediaConfig;
@property (nonatomic, strong) UIImageView *playImage;               //暂停时的图标

-(void)play;
-(void)stop;
-(void)playPauseClick;
@property (nonatomic,weak) id <SJVideoPlayViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
