//
//  VEHomeToolModel.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/1.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LMHomeToolListModel : VEBaseModel
@property (strong, nonatomic) NSArray *spaceid143;

@end

@interface VEHomeToolModel : VEBaseModel

@property (strong, nonatomic) NSString *hitsid;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *thumb;
@property (strong, nonatomic) NSString *linkurl;
 //类型:small_tool小工具；custom_tag:定制作品标签；custom_detail:定制作品详情；app_store:应用商店;
@property (strong, nonatomic) NSString *type;
//内容id;1:视频编辑;2:手持弹幕;3:多格视频;4:更换音乐;5:人像抠图;6:加封面;7:区域裁剪;8:提取音频;9:镜像视频;10:生成GIF;11:去水印;12:加减速;13:加滤镜;14:模板制作;15:视频倒放;16:视频拼接;0:更多工具
@property (strong, nonatomic) NSString *contentid;
@property (strong, nonatomic) NSString *imageName;

@property (strong, nonatomic) NSString *classifyId;
@property (strong, nonatomic) NSString *classifyName;
@property (strong, nonatomic) NSString *thumbUrl;

@end

NS_ASSUME_NONNULL_END
