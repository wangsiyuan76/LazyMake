//
//  VELoadDelegate.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/3/31.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VELoadDelegate.h"
#import "ViewController.h"
#import "VEBaseTabBarController.h"
#import <LanSongEditorFramework/LanSongEditor.h>
#import <LanSongFFmpegFramework/LanSongFFmpeg.h>
//#import <UMCommonLog/UMCommonLogManager.h>

@implementation VELoadDelegate

+ (UITabBarController *)createRootViewController{
    VEBaseTabBarController *rootVC = [[VEBaseTabBarController alloc]init];
    return rootVC;;
}

+ (void)seetingNavBarStyle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance]setBarTintColor:MAIN_NAV_COLOR];                   //导航栏颜色
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName :[UIColor whiteColor]};
    [[UINavigationBar appearance]setBackIndicatorImage:[UIImage imageNamed:@"vm_icon_back"]];
    [[UINavigationBar appearance]setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"vm_icon_back"]];
    [[UINavigationBar appearance]setShadowImage:[UIImage new]];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-1000, 0)
                                                         forBarMetrics:UIBarMetricsDefault];
}


/// 初始化各个第三方平台
+ (void)loadAllThird{
    [[self class]createUMeng];
    [[self class]loadLanSong];
}

///初始化蓝松
+ (void)loadLanSong{
    BOOL bo = [LanSongEditor initSDK:LANSONG_KEY];
    if (bo) {        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
         //获取沙盒文件路径
         NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
         NSString *documentPath = [documentPaths objectAtIndex:0];
         
         //获取文件夹路径
         NSString *userId = @"LazyMake";
         NSString *emoticonPath = [NSString stringWithFormat:@"%@/box2/%@",documentPath,userId];
         // 判断文件夹是否存在，如果不存在，则创建
         if (![[NSFileManager defaultManager]fileExistsAtPath:emoticonPath]){
             NSError *error;
             [fileManager createDirectoryAtPath:emoticonPath withIntermediateDirectories:YES attributes:nil error:&error];
             if (error){
                 LMLog(@"插入失败");
             }
         }else{
             LMLog(@"该文件夹已存在");
         }
        [LSOFileUtil setGenTempFileDir:emoticonPath];

    }else{
        LMLog(@"蓝松初始化失败");
    }
    [LanSongFFmpeg initLanSongFFmpeg];
    /*
     删除sdk中所有的临时文件.
     */
    [LSOFileUtil deleteAllSDKFiles];
}

/// 初始化友盟
+ (void)createUMeng{
    //开发者需要显式的调用此函数，日志系统才能工作
////       [UMCommonLogManager setUpUMCommonLogManager];
//
//    [UMConfigure initWithAppkey:UMENG_KEY channel:@"App Store"];
//    [UMConfigure setLogEnabled:YES];
//
//     // Push's basic setting
//    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
//    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
//    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert;
    [[self class]setupUSharePlatforms];
}


/// 设置友盟第三方平台的各个key
+ (void)setupUSharePlatforms
{
//    /*
//     设置微信的appKey和appSecret
//     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
//     */
//  BOOL x =  [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WX_APPID appSecret:WX_APPSECRET redirectURL:@"https://vp.bizhijingling.com/"];
//    LMLog(@"=====%d",x);
//    /* 设置分享到QQ互联的appID
//     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
//     100424468.no permission of union id
//     [QQ/QZone平台集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3
//     */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQ_APPID appSecret:QQ_APPKey redirectURL:@"https://vp.bizhijingling.com/"];
//    
    /*
     设置新浪的appKey和appSecret
     [新浪微博集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_2
     */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
}
@end
