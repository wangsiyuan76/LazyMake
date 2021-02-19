//
//  VEVideoPreviewViewController.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/5/21.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VESelectVideoModel.h"
#import <LanSongEditorFramework/DrawPadConcatVideoExecute.h>
#import <LanSongFFmpegFramework/LSOVideoEditor.h>
NS_ASSUME_NONNULL_BEGIN

@interface VEVideoPreviewViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

NS_ASSUME_NONNULL_END
