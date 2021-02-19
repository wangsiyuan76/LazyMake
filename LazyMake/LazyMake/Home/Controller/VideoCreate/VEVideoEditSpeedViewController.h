//
//  VEVideoEditSpeedViewController.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/5/8.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VESelectVideoModel.h"
#import <LanSongEditorFramework/LanSongEditor.h>
#import <LanSongFFmpegFramework/LSOVideoEditor.h>
NS_ASSUME_NONNULL_BEGIN

@interface VEVideoEditSpeedViewController : UIViewController
@property (strong, nonatomic) VESelectVideoModel *videoModel;
@property (assign, nonatomic) LMEditVideoType videoType;
@end

NS_ASSUME_NONNULL_END
