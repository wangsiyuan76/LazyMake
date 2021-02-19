//
//  VEMoreLatticeVideoMainView.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/6/8.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VEMoreGridVideoModel.h"
#import "VESelectVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LMMoreLatticeVideoSubView : UIView <UIScrollViewDelegate>

//裁剪视频回调
@property (copy, nonatomic) void (^clickCropBlock)(NSInteger selectIndex,VESelectVideoModel *changeModel);
//替换视频回调
@property (copy, nonatomic) void (^clickChangeBlock)(NSInteger selectIndex,VESelectVideoModel *changeModel);
//播放完成回调
@property (copy, nonatomic) void (^playSucceedBlock)(NSInteger selectIndex);

//有视频时展示的样式
@property (strong, nonatomic) UIView *cropView;
@property (strong, nonatomic) UIButton *cropBtn;
@property (strong, nonatomic) UIView *changeView;
@property (strong, nonatomic) UIButton *changeBtn;

//没有视频时展示的样式
@property (strong, nonatomic) UIButton *addBtn;
@property (strong, nonatomic) UILabel *addLab;

//model
@property (strong, nonatomic) VESelectVideoModel *videoModel;
@property (assign, nonatomic) NSInteger index;

//播放相关
@property (strong, nonatomic) UIScrollView *playScrollView;
@property (strong, nonatomic) AVPlayer *avPlayer;                             //视频播放器
@property (strong, nonatomic) AVPlayerItem *playItem;                        //播放单元
@property (strong, nonatomic) AVPlayerLayer *playerLayer;                   //播放界面（layer）

//停止，销毁播放器
- (void)stopPlayer;
//改变播放器的大小
- (void)changePlayViewSize;
// 改变展示样式
// @param ifPlay 是否有视频
- (void)changeShowStyleIfPlay:(BOOL)ifPlay;

@end

@interface VEMoreLatticeVideoMainView : UIView

@property (copy, nonatomic) void (^changeVideoArrBlock)(NSMutableArray *changeArr);
@property (copy, nonatomic) void (^playSucceedBlock)(void);             //播放完成后的回调

@property (strong, nonatomic) VEMoreGridVideoModel *model;          //布局方式
@property (strong, nonatomic) NSMutableArray *videoArr;             //所有的视频数组
@property (assign, nonatomic) NSInteger playStyle;                  //0同时播放 1顺序播放
@property (assign, nonatomic) NSInteger playIndex;                  //顺序播放时，当前播放的下标

@property (strong, nonatomic) NSMutableArray *subViewArr;           

//改变里面subView的布局方法
- (void)changeAllSubViewFrame;
//暂停播放全部
- (void)stopAllVideo;
//开始播放全部
- (void)playAllVideo;
// 改变播放方式 0同时播放 1顺序播放
- (void)changePlayStyle:(NSInteger)playStyle andVideoArr:(NSMutableArray *)videoArr;
//改变音量
- (void)changeAllVolume:(CGFloat)volume;
//释放所有播放器
- (void)releaseAllPlayer;

@end

NS_ASSUME_NONNULL_END
