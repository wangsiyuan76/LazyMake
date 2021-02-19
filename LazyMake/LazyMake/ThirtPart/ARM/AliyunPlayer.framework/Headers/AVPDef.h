//
//  AVPDef.h
//  AVPSDK
//
//  Created by shiping.csp on 2018/11/16.
//  Copyright © 2018 com.alibaba.AliyunPlayer. All rights reserved.
//

#ifndef AVPDef_h
#define AVPDef_h

#import <Foundation/Foundation.h>

#if TARGET_OS_OSX
#import <AppKit/AppKit.h>
#define AVPView NSView
#define AVPImage NSImage
#elif TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#define AVPView UIView
#define AVPImage UIImage
#endif // TARGET_OS_OSX

#import "AVPErrorCode.h"

/**
 * Convert playback URL before playback.
 *
 * For vid playback, try to convert the playback URL before playback
 *
 * @param   inputURL  [in]  input URL.
 * @param   srcFormat [in]  input format. should be "m3u8" "mp4", or "" if unknown.
 * @param   outputURL [out] output URL, convertURL function will malloc the memory, and user of PlayURLConverCallback need free it outside.
 *
 * @return  true if success.
 */
typedef bool (*PlayURLConverCallback)(const char* srcURL, const char* srcFormat, char** destURL);

typedef enum AVPStatus: NSUInteger {
    /** @brief 空转，闲时，静态 */
    AVPStatusIdle = 0,
    /** @brief 初始化完成 */
    AVPStatusInitialzed,
    /** @brief 准备完成 */
    AVPStatusPrepared,
    /** @brief 正在播放 */
    AVPStatusStarted,
    /** @brief 播放暂停 */
    AVPStatusPaused,
    /** @brief 播放停止 */
    AVPStatusStopped,
    /** @brief 播放完成 */
    AVPStatusCompletion,
    /** @brief 播放错误 */
    AVPStatusError
} AVPStatus;

 /**@brief 跳转模式，是否为精准跳转*/
typedef enum AVPSeekMode: NSUInteger {
    AVP_SEEKMODE_ACCURATE = 0x01,
    AVP_SEEKMODE_INACCURATE = 0x10,
} AVPSeekMode;

 /**@brief 渲染显示模式*/
typedef enum AVPScalingMode: NSUInteger {
    /**@brief 不保持比例平铺*/
    AVP_SCALINGMODE_SCALETOFILL,
    /**@brief 保持比例，黑边*/
    AVP_SCALINGMODE_SCALEASPECTFIT,
    /**@brief 保持比例填充，需裁剪*/
    AVP_SCALINGMODE_SCALEASPECTFILL,
} AVPScalingMode;

/**@brief 旋转模式*/
typedef enum AVPRotateMode: NSUInteger {
    AVP_ROTATE_0 = 0,
    AVP_ROTATE_90 = 90,
    AVP_ROTATE_180 = 180,
    AVP_ROTATE_270 = 270
} AVPRotateMode;

/**@brief 镜像模式*/
typedef enum AVPMirrorMode: NSUInteger {
    AVP_MIRRORMODE_NONE,
    AVP_MIRRORMODE_HORIZONTAL,
    AVP_MIRRORMODE_VERTICAL,
} AVPMirrorMode;

/**@brief 播放器事件类型*/
typedef enum AVPEventType: NSUInteger {
    /**@brief 准备完成事件*/
    AVPEventPrepareDone,
    /**@brief 自动启播事件*/
    AVPEventAutoPlayStart,
    /**@brief 首帧显示时间*/
    AVPEventFirstRenderedStart,
    /**@brief 播放完成事件*/
    AVPEventCompletion,
    /**@brief 缓冲开始事件*/
    AVPEventLoadingStart,
    /**@brief 缓冲完成事件*/
    AVPEventLoadingEnd,
    /**@brief 跳转完成事件*/
    AVPEventSeekEnd,
    /**@brief 循环播放开始事件*/
    AVPEventLoopingStart,
} AVPEventType;

/**@brief 获取信息播放器的key*/
typedef enum AVPPropertyKey: NSUInteger {
    /**@brief Http的response信息
     * 返回的字符串是JSON数组，每个对象带response和type字段。type字段可以是url/video/audio/subtitle，根据流是否有相应Track返回。
     * 例如：[{"response":"response string","type":"url"},{"response":"","type":"video"}]
     */
    AVP_KEY_RESPONSE_INFO = 0,

    /**@brief 主URL的连接信息
     * 返回的字符串是JSON对象，带url/ip/eagleID/cdnVia/cdncip/cdnsip等字段（如果解析不到则不添加）
     * 例如：{"url":"http://xxx","openCost":23,"ip":"11.111.111.11","cdnVia":"xxx","cdncip":"22.222.222.22","cdnsip":"xxx"}
     */
    AVP_KEY_CONNECT_INFO  = 1,
} AVPPropertyKey;

typedef enum AVPOption: NSUInteger {
    /**
     * @brief 渲染的fps。类型为Float
     */
    AVP_OPTION_RENDER_FPS = 0,
} AVPOption;

/**
 @brief AVPErrorModel为播放错误信息描述
 */
OBJC_EXPORT
@interface AVPErrorModel : NSObject

/**
 @brief code为播放错误信息code
 */
@property (nonatomic, assign) AVPErrorCode code;

/**
 @brief message为播放错误信息描述
 */
@property (nonatomic, copy) NSString *message;

/**
 @brief requestId为播放错误信息requestID
 */
@property (nonatomic, copy) NSString *requestId;

/**
 @brief videoId为播放错误发生的videoID
 */
@property (nonatomic, copy) NSString *videoId;

@end


/**
 @brief AVPTimeShiftModel直播时移描述
 */
OBJC_EXPORT
@interface AVPTimeShiftModel : NSObject

/**
 @brief startTime直播时移开始时间
 */
@property (nonatomic, assign) NSTimeInterval startTime;

/**
 @brief endTime直播时移结束时间
 */
@property (nonatomic, assign) NSTimeInterval endTime;

/**
 @brief currentTime直播时移当前时间
 */
@property (nonatomic, assign) NSTimeInterval currentTime;
@end

/**
 @brief logLevel
 */
typedef enum AVPLogLevel: NSUInteger {
    LOG_LEVEL_NONE    = 0,
    LOG_LEVEL_FATAL   = 8,
    LOG_LEVEL_ERROR   = 16,
    LOG_LEVEL_WARNING = 24,
    LOG_LEVEL_INFO    = 32,
    LOG_LEVEL_DEBUG   = 48,
    LOG_LEVEL_TRACE   = 56,
} AVPLogLevel;

#endif /* AVPDef_h */
