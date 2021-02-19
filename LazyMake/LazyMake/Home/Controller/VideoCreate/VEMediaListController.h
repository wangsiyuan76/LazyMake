//
//  VEMediaListController.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/21.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "VEMediaListCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface VEMediaListController : UIViewController

@property (copy, nonatomic) void(^selectMusicBlock)(LMMediaModel *model);
@property (copy, nonatomic) void (^cropAudioBlock)(NSString *audioPath, BOOL ifAddFile, NSString *audioName);

@property (strong, nonatomic) NSString *videoUrl;
@property (assign, nonatomic) CGRect videoFrame;            //视频位置

@property (assign, nonatomic) BOOL ifShowCropView;          //是否显示裁剪音乐的弹框
@property (assign, nonatomic) NSInteger minS;               //建议裁剪最小时长
@property (assign, nonatomic) NSInteger maxS;               //建议裁剪最大时长

@end

NS_ASSUME_NONNULL_END
