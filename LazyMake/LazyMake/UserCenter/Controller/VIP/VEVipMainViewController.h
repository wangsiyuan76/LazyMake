//
//  VEVipMainViewController.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/3.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger){
    VipMouthType_Home = 0,              //默认入口
    VipMouthType_UserCenter = 1,        //个人中心
    VipMouthType_DanMu = 2,             //手持弹幕
    VipMouthType_AEVideo = 3,           //模板视频
    VipMouthType_OneImage = 4,           //一键抠图
    VipMouthType_CreateVideo = 5,           //视频制作

}VipMouthType;

@interface VEVipMainViewController : UIViewController

@property (assign, nonatomic) VipMouthType comeType;


@end

NS_ASSUME_NONNULL_END
