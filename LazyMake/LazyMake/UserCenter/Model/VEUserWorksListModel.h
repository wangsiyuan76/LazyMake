//
//  VEUserWorksListModel.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/27.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VEUserWorksListModel : VEBaseModel

@property (strong, nonatomic) NSString *wID;                //内容id      ddd
@property (strong, nonatomic) NSString *classify_id;     //分类id
@property (strong, nonatomic) NSString *userid;
@property (strong, nonatomic) NSString *status;             //发布状态
@property (strong, nonatomic) NSString *title;              //标题
@property (strong, nonatomic) NSString *thumb;              //封面地址
@property (strong, nonatomic) NSString *vedio;              //视频地址

@property (strong, nonatomic) NSString *size;              //视频大小
@property (strong, nonatomic) NSString *collect_num;              //视收藏量
@property (strong, nonatomic) NSString *download_num;              //视下载量
@property (strong, nonatomic) NSString *click_num;              //视频点击量
@property (strong, nonatomic) NSString *is_top;              //是否推荐
@property (strong, nonatomic) NSString *is_hot;              //是否热门
@property (strong, nonatomic) NSString *inputtime;              //发布时间
@property (strong, nonatomic) NSString *duration;              //视频时长

@property (strong, nonatomic) NSString *custom_id;              //关联模板id
@property (strong, nonatomic) NSString *avatar;              //用户头像
@property (strong, nonatomic) NSString *nickname;              //用户昵称

@end

NS_ASSUME_NONNULL_END
