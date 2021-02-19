//
//  VESelectVideoController.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/15.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VESelectVideoModel.h"
#import "VEMoreGridVideoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface VESelectVideoController : UIViewController

@property (copy, nonatomic) void (^dismissSelectBlock)(VESelectVideoModel *videoModel, NSString *videoPath);
@property (copy, nonatomic) void (^selectVideoOutAudioBlock)(NSString *audioPath, NSString *nameStr);

@property (assign, nonatomic) LMEditVideoType videoType;
@property (assign, nonatomic) CGRect videoFrame;
@property (strong, nonatomic) NSString *videoOutUrl;            //视频提取音乐的原视频地址
@property (assign, nonatomic) CGSize cropBili;                  //裁剪视频的比例

@property (assign, nonatomic) VEMoreGridVideoModel *moreGridModel;             //多格视频的类型model
@property (strong, nonatomic) NSArray *modelArr;                            //所有样式的分组
@property (assign, nonatomic) NSInteger selectModelIndex;                   //当前展示的样式的index

@property (assign, nonatomic) NSInteger minS;               //建议裁剪最小时长
@property (assign, nonatomic) NSInteger maxS;               //建议裁剪最大时长

@end

NS_ASSUME_NONNULL_END
