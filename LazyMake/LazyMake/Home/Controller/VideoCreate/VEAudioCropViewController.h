//
//  VEAudioCropViewController.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/5/13.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEAudioCropViewController : UIViewController

@property (copy, nonatomic) void (^cropAudioBlock)(NSString *audioPath, BOOL ifAddFile);

@property (strong, nonatomic) NSString *videoPath;      //视频地址
@property (strong, nonatomic) NSString *videoOutPath;      //要提取的视频地址

@property (assign, nonatomic) CGRect videoFrame;         //视频位置
@property (strong, nonatomic) NSString *audioPath;      //音频地址
@property (assign, nonatomic) double audioDur;      //音频时长
@property (assign, nonatomic) BOOL ifAddF;    
@property (assign, nonatomic) BOOL hasOut;          //是否从视频提取音乐


@end

NS_ASSUME_NONNULL_END
