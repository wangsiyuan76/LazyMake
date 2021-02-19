//
//  VEHomeTemplateModel.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/9.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LMHomeTemplateAEModel : VEBaseModel

@property (strong, nonatomic) NSString *type;                       //类型
@property (strong, nonatomic) NSString *desKey;                     //加密key      des_key
@property (strong, nonatomic) NSString *desIv;                     //加密iv      des_iv
@property (strong, nonatomic) NSString *textToImage;                // text_to_image
@property (strong, nonatomic) NSString *videoPreview;               //     video_preview
@property (strong, nonatomic) NSString *zipfile;                    //
@property (strong, nonatomic) NSString *zipfileSize;                //      zipfile_size
@property (strong, nonatomic) NSString *customv;                    //  修改版本
@property (strong, nonatomic) NSString *oneCutout;                  //是否一键抠图  one_cutout
@property (strong, nonatomic) NSArray *images;                      //

@property (assign, nonatomic) LMAEVideoType aeType;                // 制作类型
@property (strong, nonatomic) NSArray *aeTitleArr;                // 制作类型标题
@property (strong, nonatomic) NSArray *aeImageArr;                // 制作类型图片
@property (strong, nonatomic) NSArray *texts;                     // 制作类型文字

@end

@interface LMHomeTemplateAEImageModel : VEBaseModel
@property (strong, nonatomic) NSString *width;
@property (strong, nonatomic) NSString *height;                       
@property (strong, nonatomic) NSString *rotundity;                    //圆角

@end

@interface LMHomeTemplateAETextModel : VEBaseModel
@property (strong, nonatomic) NSString *fontText;                       //内容
@property (strong, nonatomic) NSString *fontUrl;
@property (strong, nonatomic) NSString *fontSize;

@end

@interface VEHomeTemplateModel : VEBaseModel

@property (strong, nonatomic) NSString *tID;                       //模板iD      id
@property (strong, nonatomic) NSString *lbfl;                      //分类id
@property (strong, nonatomic) NSString *title;                    //标题
@property (strong, nonatomic) NSString *thumb;                    //缩略图
@property (strong, nonatomic) NSString *descriptionStr;           //描述    description
@property (strong, nonatomic) NSString *statusStr;                   //发布状态
@property (strong, nonatomic) NSString *userid;                   //发布者id
@property (strong, nonatomic) NSString *ident;                    //0:正常;1:原创;2:独家;3:首发
@property (strong, nonatomic) NSString *isHot;                    //是否热门       is_hot
@property (strong, nonatomic) NSString *isFree;                   //是否收费       is_free
@property (strong, nonatomic) NSString *downloadNum;             //下载数量      download_num
@property (strong, nonatomic) NSString *collectNum;              //收藏数量      collect_num
@property (strong, nonatomic) NSArray *tags;                     //标签数组
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *isAcross;                //是否热门       is_across
@property (strong, nonatomic) NSString *oneCutout;               //是否一键抠图       one_cutout
@property (strong, nonatomic) NSString *inputtime;               //添加时间
@property (strong, nonatomic) NSString *symbolTime;              //       symbol_time
@property (strong, nonatomic) NSString *liveNum;                 //       live_num
@property (strong, nonatomic) NSString *views;                   // 制作数量
@property (strong, nonatomic) NSString *avatar;                  // 发布者头像
@property (strong, nonatomic) NSString *nickname;                // 发布者昵称
@property (strong, nonatomic) NSString *shareUrl;                // 分享链接
@property (strong, nonatomic) NSString *shareDes;                // 分享描述
@property (strong, nonatomic) LMHomeTemplateAEModel *customObj;               //ae模板内容参数值     custom_arr

@property (strong, nonatomic) NSString *unZipPath;                // 解压后的文件本地地址
@property (strong, nonatomic) NSString *zipPath;                  // 解压前的文件本地路径

@property (strong, nonatomic) NSString *vidoPath;                //本地视频的路径
@property (assign, nonatomic) CGSize vidoSize;                //本地视频的大小
@property (strong, nonatomic) UIImage *shareImage;                    //缩略图

@end

NS_ASSUME_NONNULL_END
