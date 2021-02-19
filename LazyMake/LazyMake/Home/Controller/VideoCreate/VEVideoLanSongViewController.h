//
//  VEVideoLanSongViewController.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/17.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VESelectVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VEVideoLanSongViewController : UIViewController
@property (strong, nonatomic) VESelectVideoModel *videoModel;
@property (assign, nonatomic) LMEditVideoType videoType;
@end

NS_ASSUME_NONNULL_END
