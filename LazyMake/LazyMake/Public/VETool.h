//
//  VETool.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/3/31.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger) {
    LMBtnImageTitleType_ImageLeft,                      //图片在左文字右
    LMBtnImageTitleType_ImagRight,                      //图片又文字左
    LMBtnImageTitleType_ImageTop,                       //图片上文字下
    LMBtnImageTitleType_ImageBottom,                    //图片下文字上
}LMBtnImageTitleType;              //设置button按钮文字和图片的布局样式


typedef NS_ENUM(NSUInteger) {
    LMEditVideoTypeBack,                              //视频倒放
    LMEditVideoTypeMirror,                            //视频镜像
    LMEditVideoTypeSpeed,                             //视频加减速
    LMEditVideoTypeGIF,                               //视频生成GIF
    LMEditVideoTypeWatermark,                         //视频去水印
    LMEditVideoTypeCrop,                              //视频裁剪
    LMEditVideoTypeChangeAudio,                       //替换背景音乐
    LMEditVideoTypeCover,                             //增加封面
    LMEditVideoTypeFilter,                            //视频滤镜
    LMEditVideoTypeOutAudio,                         //提取背景音乐
    LMEditVideoTypeVideoSplice,                       //视频拼接
    LMEditVideoTypeVideoCatout,                       //人像抠图
    LMEditVideoTypeVideoLattice,                       //多格视频

    LMEditVideoTypeSelect,                            //普通视频选择
    LMEditVideoTypeVideoOutAudio,                     //视频选择音乐
    LMEditVideoTypeVideoOutAudioCrop,                 //视频选择音乐并且在当前页面裁剪

    LMEditVideoTypeSelectNo,                            //普通视频选择不裁剪


}LMEditVideoType;              // 编辑视频的几种类型

typedef NS_ENUM(NSUInteger) {
    
    LMAEVideoType_AllPic,                            //全部都是替换图片
    LMAEVideoType_AllText,                           //全部都是替换文字
    LMAEVideoType_AllVideo,                          //替换视频
    LMAEVideoType_PicVideo,                          //替换图片和视频
    LMAEVideoType_TextPic,                           //替换图片和文字
    LMAEVideoType_TextVideo,                         //替换文字和视频
    LMAEVideoType_TextPicVideo,                      //替换图片，文字和视频
    LMAEVideoType_Audio,                             //只有音乐（替换音乐）

}LMAEVideoType;              // 编辑视频的几种类型


@interface VETool : NSObject

//改变按钮的布局样式
+ (void)changeBtnStyleWithType:(LMBtnImageTitleType)type distance:(CGFloat)distance andBtn:(UIButton *)btn;

/// 返回一个颜色渐变图片
/// @param startColor 开始色
/// @param endColor 结束的颜色
/// @param ifVertical 是否纵向渐变
/// @param imageSize 图片大小
+(UIImage *)colorGradientWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor ifVertical:(BOOL)ifVertical imageSize:(CGSize)imageSize;

/**
 计算内容高度
 
 @param content 内容
 @param lineSpacing 行间距
 @param font 字体
 @param maxW 最大宽度
 @param lineNum 最大行数
 @return 高度
 */
+ (CGFloat)contentHeight:(NSString *)content lineSpacing:(NSInteger)lineSpacing font:(UIFont *)font maxWidth:(CGFloat)maxW maxLineNum:(NSInteger)lineNum;

/**
 时间戳转为时间

 @param date 时间戳
 @param fmoratStr yyyy-MM-dd HH:mm:ss
 @return 时间
 */
+ (NSString *)convertNSStringWithDate:(NSString *) date format:(NSString * _Nullable)fmoratStr;

/**
 将某个时间转化成 时间戳
 */
+ (NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format;

/**
计算两个时间戳相差多少分钟
*/
+ (int)compareTwoTime:(NSInteger)time1 time2:(NSInteger)time2;

/**
获取与服务端时间同步后的本地时间
*/
+ (NSInteger)createLoadNetTime;

/// 改变一个lab的字间距
/// @param label label description
/// @param space space description
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/// 改变一个lab的行间距
/// @param label label description
/// @param space space description
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/// 获取系统当前时间
/// @param formatStr YYYY-MM-dd HH:mm:ss
+(NSString*)getCurrentTimesFormat:(NSString *)formatStr;

/**
 计算文本高度
 
 @param str         文本内容
 @param width       lab宽度
 @param lineSpacing 行间距(没有行间距就传0)
 @param font        文本字体大小
 
 @return 文本高度
 */
+(CGFloat)getTextHeightWithStr:(NSString *)str
                     withWidth:(CGFloat)width
               withLineSpacing:(CGFloat)lineSpacing
                      withFont:(CGFloat)font;

/*
 自定义方法：获取缓存大小
 */
+ (float) getCacheSize;

// 清除缓存
+ (void)clearFile;

/// 获取app版本号
+ (NSString *)versionNumber;

//设置毛玻璃效果
+(void)blurEffect:(UIView *)view;

//数组中的随机色值
+ (UIColor *)backgroundRandomColor;

/// 对象转换为字典
+ (NSDictionary*)getObjectData:(id)obj;

/**
 *  手机型号
 *
 *  @return e.g. iPhone
 */
+(NSString *)phoneModel;

/**
 *  手机系统版本
 *
 *  @return e.g. 8.0
 */
+(NSString *)phoneVersion;

/**
*  获取设备标示UUDI
*/
+(NSString *)phoneUUID;

/**
*  获取设备网络状态
*/
+ (NSString *)networkingStatesFromStatebar;

/// 网络是否是wifi
+(BOOL)netWorkIsWifi;

/**
 视频分解成图片
 
 @param fileUrl 视频路径
 @param fps 帧率 一般为30
 @param splitCompleteBlock 处理回调
 */
+ (void)splitVideo:(NSURL *)fileUrl fps:(float)fps splitCompleteBlock:(void(^)(BOOL success, NSMutableArray *splitimgs))splitCompleteBlock;

//设置viwe锚点
+ (void)hf_setAnchorPoint:(CGPoint)anchorPoint supView:(UIView *)subV;

/**
 *   创建保存视频音乐的文件夹
 */
+ (void)createEmoticonFolderBlock:(void (^)(BOOL ifSucceed,NSString *fileUrl,NSError *error))finshBlock;

//文字转图片;
+(UIImage *)createImageWithText2:(NSString *)text imageSize:(CGSize)size txtColor:(UIColor *)textColor;

/**
 把文字转换为图片;
 @param string 文字,
 @param attributes 文字的属性
 @param size 转换后的图片宽高
 @return 返回图片
 */
+ (UIImage *)imageFromString:(NSString *)string attributes:(NSDictionary *)attributes size:(CGSize)size;

//相册新建文件夹，并保存视频
+ (void)savePhotosVideo:(NSString *)videoPath;

/// 将一个data转为字符串的形式
/// @param data 字符串
+ (NSString *)convertDataToHexStr:(NSData *)data;

/** 获取文件的md5值*/
+ (NSString *)getFileMD5StrFromPath:(NSString *)path;

/**
 *   创建保存AE模板文件夹
 */
+ (void)createAEDataFolderBlock:(void (^)(BOOL ifSucceed,NSString *fileUrl,NSError * error))finshBlock;

/// 视频压缩后存储的路径
+ (NSString *)creatSandBoxFilePathIfNoExist;

/// 删除蓝松临时文件下的音频数据
+ (void)deleteAllLansonBoxDataIfAll:(BOOL)ifAll;

// 保存图片
+ (void)saveImage:(NSURL *__nullable)imageUrl toCollectionWithName:(NSString *)collectionName andImage:(UIImage * __nullable)subImage;


/// 百度抠图
/// @param image 图片
/// @param completion 成功
/// @param failure 失败
+(void)baiduCutoutImageWithImage:(UIImage *)image loadingStr:(NSString *__nullable)loadingStr Completion:(void (^)(UIImage *  _Nonnull image))completion failure:(void (^)(NSString * _Nonnull errorStr))failure;
/**
* 截取指定时间的视频缩略图
*/
+ (NSArray *)thumbnailImageRequestWithVideoUrl:(NSURL *)videoUrl;

/*
 截取指定时间的视频缩略图
 */
+ (UIImage *)thumbnailImageRequestWithVideoUrl:(NSURL *)videoUrl andTimeDur:(NSInteger)timeDur;
@end

NS_ASSUME_NONNULL_END
