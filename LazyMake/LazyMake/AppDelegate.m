//
//  AppDelegate.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/3/31.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "AppDelegate.h"
#import <LanSongEditorFramework/LanSongEditor.h>
#import "VELoadDelegate.h"
#import <LanSongFFmpegFramework/LSOVideoEditor.h>
//#import <DouyinOpenSDK/DouyinOpenSDKApplicationDelegate.h>
//#import <WXApi.h>
//#import <TencentOpenAPI/TencentOAuth.h>

@interface AppDelegate () /*<WXApiDelegate>*/

@property(assign, nonatomic)UIBackgroundTaskIdentifier backIden;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    self.tabBar = (VEBaseTabBarController *)[VELoadDelegate createRootViewController];
    [self.window setRootViewController:self.tabBar];
    [self.window makeKeyAndVisible];
    [VELoadDelegate seetingNavBarStyle];
    [VELoadDelegate loadAllThird];
    
//    [WXApi registerApp:WX_APPID universalLink:@"https://vp.bizhijingling.com/"];
//    [WXApi startLogByLevel:WXLogLevelDetail logBlock:^(NSString * _Nonnull log) {
//        LMLog(@"log=======%@",log);
//    }];
//
//    [[DouyinOpenSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
//    [[DouyinOpenSDKApplicationDelegate sharedInstance] registerAppId:@"awm9qozbjn2ot2s5"];
    return YES;
}


#pragma mark - UISceneSession lifecycle

//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options  API_AVAILABLE(ios(13.0)) API_AVAILABLE(ios(13.0)) API_AVAILABLE(ios(13.0)){
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}
//
//
//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions  API_AVAILABLE(ios(13.0)){
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}

// 支持所有iOS系统


//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
#warning 这里
        //关闭U-Push自带的弹出框
//        [UMessage setAutoAlert:NO];
//        //必须加这句代码
//        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
#warning 这里
//        //必须加这句代码
//        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
     [self beginBackGroundTask];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
     [self endBackGround];
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//控制旋转方向
-  (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window  {
    return UIInterfaceOrientationMaskPortrait;
}


//#define __IPHONE_10_0    100000
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 100000
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    #warning 这里
    return YES;
    
//    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响。
//    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
//    [WXApi handleOpenURL:url delegate:self];
//    if ([[DouyinOpenSDKApplicationDelegate sharedInstance] application:app openURL:url sourceApplication:nil annotation:nil]) {
//    }
//    if (!result) {
//        return YES;
//    }
//    return result;
}
    
- (void)application:(UIApplication *)application handleIntent:(nonnull INIntent *)intent completionHandler:(nonnull void (^)(INIntentResponse * _Nonnull))completionHandler{}
#endif

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    #warning 这里
return YES;
//    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
//    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
//    if ([[DouyinOpenSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation]) {
//    }
//    if (!result) {
//        // 其他如支付等SDK的回调
//         return YES;
//    }
//    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
     #warning 这里
     return YES;
//    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
//    if (!result) {
//        // 其他如支付等SDK的回调r
//        return YES;
//    }
//    return result;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{
    NSURL *url = userActivity.webpageURL;
    #warning 这里
//    [TencentOAuth HandleUniversalLink:url];
////    [WXApi handleOpenUniversalLink:userActivity delegate:self];
//     BOOL result = [[UMSocialManager defaultManager] handleUniversalLink:userActivity options:nil];
//    LMLog(@"xx====%d",result);
    return YES;
}

//开始后台运行的一些任务;
-(void)beginBackGroundTask
{
    NSLog(@"begin  backGround task...");
//    [LSOVideoEditor cancelFFmpeg];
//    if(NSClassFromString(@"LSOVideoEditor") != nil){
        [LSOVideoEditor cancelFFmpeg];
//        if([LSOVideoEditor respondsToSelector:@selector(cancelFFmpeg)]){
//            [LSOVideoEditor cancelFFmpeg];
//        }
//    }
    
    _backIden = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        //在时间到之前会进入这个block
        [self endBackGround];
    }];
}
//注销后台
-(void)endBackGround
{
    NSLog(@"endBackGround called.");
    [[UIApplication sharedApplication] endBackgroundTask:_backIden];
    _backIden = UIBackgroundTaskInvalid;
}

#pragma mark - 暂时用不到
//微信登录
//- (void)onResp:(BaseResp *)resp{
//    LMLog(@"===ddddd==%@",resp);
//    if ([resp isKindOfClass:[SendAuthResp class]] ) {
//        SendAuthResp *sendRe = (SendAuthResp *)resp;
//        if ([sendRe.state isEqualToString:@"LoginForApp"]) {
//            [[self class]getWechatAccessTokenWithCode:sendRe.code];
//        }
//    }
//}

//微信登录
+ (void)getWechatAccessTokenWithCode:(NSString *)code{
    NSMutableDictionary *loginDatas = [NSMutableDictionary new];
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WX_APPID,WX_APPSECRET,code];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data){
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                [loginDatas setObject:dic[@"access_token"] forKey:@"access_token"];
                [loginDatas setObject:dic[@"openid"] forKey:@"openid"];
                [loginDatas setObject:dic[@"refresh_token"] forKey:@"refresh_token"];
                
                //根据accesstoken和openid获取用户信息
                NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",dic[@"access_token"], dic[@"openid"]];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSURL *zoneUrl = [NSURL URLWithString:url];
                    NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
                    NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (data){
                            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                            
                            //33_eG6znnBPNxwLP4T114zuk0yThWfhyTDr4kYV_bpOJSMYj887h5KFgF1lGDRvPCceKLaYP29mXlm8QKnqhJgMEd2fg7eG8WNxwuKnhcBggsE
                            [loginDatas setObject:dic[@"nickname"] forKey:@"nickname"];
                            [loginDatas setObject:dic[@"unionid"] forKey:@"unionid"];
                            LMLog(@"dic========%@",dic);
                            
                            NSMutableDictionary *parDic = [[NSMutableDictionary alloc]init];
//                            [parDic setObject:resp.accessToken?:@"" forKey:@"token"];
                            [parDic setObject:@"weixin" forKey:@"type"];
                            [parDic setObject:dic[@"openid"]?:@"" forKey:@"openid"];
                            //            [parDic setObject:resp.name?:@"" forKey:@"nickname"];
                            //            [parDic setObject:[NSString stringWithFormat:@"%zd",time] forKey:@"expires_in"];
                            //            [parDic setObject:resp.iconurl?:@"" forKey:@"avatar"];
                            //            [parDic setObject:[VETool phoneUUID]?:@"" forKey:@"devicecode"];
                            //            [parDic setObject:[VETool versionNumber] forKey:@"version"];
                            //            NSString *sexNum = @"0";
                            //            if ([resp.unionGender containsString:@"男"]) {
                            //                sexNum = @"1";
                            //            }else if ([resp.unionGender containsString:@"女"]){
                            //                sexNum = @"2";
                            //            }
                            //            [parDic setObject:sexNum forKey:@"sex"];
                            //            [self loginForAppWithModel:parDic];
                        }
                    });
                });
            }
        });
    });
}


@end
