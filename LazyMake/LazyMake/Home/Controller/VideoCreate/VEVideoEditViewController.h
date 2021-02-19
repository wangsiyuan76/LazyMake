//
//  VEVideoEditViewController.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/16.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VESelectVideoModel.h"
#import <LanSongEditorFramework/LanSongEditor.h>
#import <LanSongFFmpegFramework/LSOVideoEditor.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEVideoEditViewController : UIViewController
@property (copy, nonatomic) void (^dismissSelectBlock)(VESelectVideoModel *videoModel, NSString *videoPath);
@property (strong, nonatomic) VESelectVideoModel *videoModel;
@property (assign, nonatomic) LMEditVideoType videoType;
@property (assign, nonatomic) CGSize cropBili;
@property (assign, nonatomic) BOOL ifSplice;            //是否是视频拼接中的裁剪
@property (assign, nonatomic) BOOL ifHiddenCrop;            //是否不显示画面裁剪

@end

NS_ASSUME_NONNULL_END
