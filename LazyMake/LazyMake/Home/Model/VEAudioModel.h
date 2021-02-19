//
//  VEAudioModel.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/23.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEAudioModel : NSObject

@property (assign, nonatomic) NSInteger beginTime;      //开始时间
@property (assign, nonatomic) NSInteger endTime;        //结束时间
@property (assign, nonatomic) CGFloat oldSize;          //原生音量
@property (assign, nonatomic) CGFloat soundtrackSize;    //配乐音量
@property (strong, nonatomic) NSString * _Nullable audioUrl;        //音乐路径
@property (strong, nonatomic) NSString * _Nullable catAudioUrl;        //裁剪后的音乐路径

@property (assign, nonatomic) CGFloat allTime;           //音乐总时长
@property (strong, nonatomic) NSString *audioName;        //提取音乐的音乐文件名

@property (assign, nonatomic) NSInteger previewBeginTime;    //预览音乐开始时间
@property (assign, nonatomic) double previewEndTime;      //预览音乐结束时间
@property (assign, nonatomic) CGFloat previewOldSize;        //预览音乐时原生音量
@property (assign, nonatomic) BOOL isAddFile;       //是否需要添加file://
/**
 * 多媒体文件中的音频总时长
 */
@property(nonatomic,assign) double aDuration;
@end

NS_ASSUME_NONNULL_END
