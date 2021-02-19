//
//  VESelectVideoModel.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/16.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEBaseModel.h"
#import <Photos/PHAsset.h>
#import <LanSongEditorFramework/LanSongEditor.h>

NS_ASSUME_NONNULL_BEGIN

@interface VESelectVideoModel : VEBaseModel

@property (strong, nonatomic) UIImage *showImage;               //略缩图
@property (strong, nonatomic) NSString *timeStr;                //视频时长
@property (strong, nonatomic) NSString *videoUrl;               //视频url
@property (assign, nonatomic) BOOL ifLoading;                   //是否正在同步iCloud下载
@property (assign, nonatomic) BOOL ifSelect;                    //是否选中
@property (assign, nonatomic) CGFloat fileSize;                 //文件大小
@property (strong, nonatomic) PHAsset *phData;                  //相册中的数据
@property (assign, nonatomic) NSInteger num;
@property (assign, nonatomic) long int second;                  //秒
@property (assign, nonatomic) CGSize videoSize;                  //视频长宽高
@property (strong, nonatomic) LSOVideoAsset *videoAss;          //视频相关资源
@property (assign, nonatomic) CGSize showVideoSize;             //视频显示时的大小

@property (assign, nonatomic) CGFloat beginTime;             //视频开始时间
@property (assign, nonatomic) CGFloat endTime;               //视频结束时间
@property (strong, nonatomic) NSString *playID;

@end

NS_ASSUME_NONNULL_END
