//
//  VEAEVideoEditViewController+CreateView.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/26.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEAEVideoEditViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface VEAEVideoEditViewController (CreateView)
///选择图片、视频的view
- (void)createChangeImageVideoView;

//更换文字的view
- (void)createChangeTextView;

//裁剪配乐的view
- (void)cropAudioSizeView;

//调整配乐音量的view
- (void)createChangeAudioSizeView;

/// 底部菜单按钮
- (void)createBottomView;

//顶部完成按钮
-(void)createHeadView;

/// 跳转选择音乐页面
- (void)pushSelectAudioVC;

//初始化音乐播放器
- (void)createAudioPlayer;

//音乐播放进度回调
- (void)updateProgress;

//音乐裁剪view点击完成的回调
- (void)audioCropViewClick:(BOOL)ifSucceed;

//音乐调整音量view点击完成的回调
- (void)audioSizeViewClick:(BOOL)ifSucceed oldSize:(CGFloat)oldSize videoSize:(CGFloat)videoSize;

//改变图片和视频view的回调
- (void)imageVideoChangeViewClick:(BOOL)ifSucceed mediaArr:(NSArray *__nullable)mediaArr;

//改变文字view的回调
- (void)textViewChangeClick:(BOOL)ifSucceed selectIndex:(NSInteger)selectIndex changeArr:(NSArray * _Nonnull)changeArr;

//创建改变图片，视频view选择图片的大小
- (CGSize)setImageSize;

//创建改变图片，视频view的model数组
- (NSArray *)createImageVideoArr;

@end

NS_ASSUME_NONNULL_END
