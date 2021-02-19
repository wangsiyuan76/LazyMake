//
//  SJVideoCropView.h
//  VideoPlayDemo
//
//  Created by shengjie zhang on 2019/3/27.
//  Copyright © 2019 shengjie zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SJVideoCropViewDelegate <NSObject>

@optional

/**
 手指移动到的时间
 */
- (void)cutBarDidMovedToTime:(CGFloat)time;

/**
 松开手指
 */
- (void)cutBarTouchesDidEnd;

/**
 点击播放，暂停按钮
 */
- (void)clickPlayBtn:(BOOL)ifSelect;

/**
 提取封面
 */
- (void)addCoverAllImage:(NSArray * _Nullable)allImage;

@end

@class SJMediaInfoConfig,AVAsset;
NS_ASSUME_NONNULL_BEGIN

@interface SJVideoCropView : UIView
-(instancetype)initWithFrame:(CGRect)frame mediaConfig:(SJMediaInfoConfig *)config;
@property (nonatomic, strong) AVAsset *avAsset;
@property (nonatomic,weak) id <SJVideoCropViewDelegate>delegate;
-(void)loadThumbnailData;
@property (nonatomic,assign) CGFloat siderTime;
@property (nonatomic, strong) UIButton *playBtn;        //播放按钮
@property (nonatomic, assign) int beginTime;        //开始播放时间
@property (nonatomic, assign) int endTime;          //结束播放时间
@property (nonatomic, assign) CGFloat timeData;         //播放时长
@property (nonatomic, strong) NSMutableArray *imagesArray;  //视频所有的图片

/**
 更新进度
 
 @param progress 进度
 */
- (void)updateProgressViewWithProgress:(CGFloat)progress;
@end

NS_ASSUME_NONNULL_END
