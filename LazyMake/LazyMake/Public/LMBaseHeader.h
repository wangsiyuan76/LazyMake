//
//  LMBaseHeader.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/3/31.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#ifndef LMBaseHeader_h
#define LMBaseHeader_h

#import "UILabel+SizeToFit.h"
#import <Masonry.h>
#import <YYKit.h>
#import "VETool.h"
#import "UIViewController+RunTime.h"
#import "VEAPIClient.h"
#import <SDWebImageManager.h>
#import "UIImageView+WebCache.h"
#import "VEUserModel.h"
#import "MBProgressHUD+LM.h"
#import "VELoadingView.h"

//需要横屏或者竖屏，获取屏幕宽度与高度
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000 // 当前Xcode支持iOS8及以上

#define SCREEN_WIDTH ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)
#define SCREENH_HEIGHT ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)
#define SCREEN_SIZE ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale):[UIScreen mainScreen].bounds.size)
#else
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#endif

//获取导航栏+状态栏的高度
#define RectNavAndStatusHight  self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height


//自定义高效率的 NSLog
#ifdef DEBUG
#define LMLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define LMLog(...)
#endif

//处理NSLogDa打印不完整的log
#ifdef DEBUG
#define LMLongLog(format, ...) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )
#else
#define LMLongLog(format, ...)
#endif


//判断是否为齐刘海机型
#define LL_iPhoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

//14.判断当前的iPhone设备/系统版本
//判断是否是ipad
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//判断iPhone4系列
#define kiPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone5系列
#define kiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone6系列
#define kiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iphone6+系列
#define kiPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneX
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

#define IS_IPHONE_X_MAIN ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? YES : NO)

#define Height_StatusBar ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 44.0 : 20.0)
#define Height_NavBar ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 88.0 : 64.0)
#define Height_TabBar ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 83.0 : 49.0)
#define Height_SafeAreaBottom ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 34 : 0)



//获取系统版本
#define IOS_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//导航栏主体色
#define MAIN_NAV_COLOR [UIColor colorWithHexString:@"15182A"]

//主体背景色
#define MAIN_BLACK_COLOR [UIColor colorWithHexString:@"#0B0E22"]

//隐私政策web地址
#define WEB_PRIVACY_URL @"https://vp.bizhijingling.com/jingling/tool_ios_privacy.html"

//会员充值协议
#define WEB_VIP_URL @"https://vp.bizhijingling.com/jingling/lazy_ios_pay_agreement.html"

//用户协议web地址
#define WEB_PROTOCOL_URL @"https://vp.bizhijingling.com/jingling/lazy_ios_agreement.html"

//上传规则web地址
#define WEB_PUSHRULE_URL @"https://vp.bizhijingling.com/jingling/lazy_ios_uploadrules.html"


// 接口地址
#define CORRECT_BASEURL @"https://tool.bizhijingling.com/ios_v1/"

//提交参数的key
#define PARAMETER_KEY @"a17Tg8gGDSTHryvGlusw6bykPdif8C7z"

//DES解密的KEY
#define DES_KEY @"ZVLx7Cbf"

//DES解密的IV
#define DES_IV @"TfLK5Pz2"

//存储本地时间与服务端时间的时间差的key
#define TIME_INTERVAL @"TIME_INTERVAL"

//加载更多数据的时候，提前加载的cell数量
#define LOAD_MORE_ADVANCE 6

//获取每页数量
#define PAGE_SIZE_NUM 20

//内购的password
#define PAY_PASSWORD @"f6a04e084865479491208a5e032071fd"

//第三方相关key
#define UMENG_KEY @"5e9037b90cafb289220002de"                       //友盟key
#define QQ_APPID @"1110413894"                                      //QQAppID
#define QQ_APPKey @"gLSGptguOMy4M6MK"                               //QQAppKey
#define WX_APPID @"wxfe8ecf2b2e594690"                               //微信AppKey
#define WX_APPSECRET @"325b1a9c65e7b4bd5a2b75947cc5247e"            //微信AppKey
#define LANSONG_KEY @"xr_LanSongSDK_ios.key"                       //蓝松key

static NSString * const TABLELEAVETOP = @"tableLeaveTop";
static NSString * const VETABLETOP = @"tableTop";
static NSString * const VEHOMETOP = @"homeTop";

static NSString * const LoadUserWorks = @"LoadUserWorks";                   //请求用户我的作品列表通知
static NSString * const USERLOGINSUCCEED = @"USERLOGINSUCCEED";               //登录成功的通知
static NSString * const PushDataSucceed = @"PushDataSucceed";                   //上传作品成功
static NSString * const SEARCHHISTORYKEY = @"searchHistoryKey";                //搜索历史记录的key
static NSString * const QQCustomerService = @"QQCustomerService";                //存QQ客服key
static NSString * const QQGroupNumber = @"QQGroupNumber";                     //存QQ群key
static NSString * const QQGroupNumberKey = @"QQGroupNumberKey";               //存QQ群key的key
static NSString * const PhoneCloseLogin = @"close_mobile_login";                 //存QQ客服key
static NSString * const SavePhotoVideoSucceedKey = @"SavePhotoVideoSucceedKey";         //保存相册成功
static NSString * const BaiDuAiKeyToken = @"BaiDuAiKeyToken";                //存百度ai的key

static NSString * const FindVideoPlayKey = @"FineVideoPlayKey";                    //发现页4g下是否可以播放视频
static NSString * const AETemplateVideoPlayKey = @"AETemplateVideoPlayKey";        //ae模板4g下是否可以播放视频

static NSString * const VENETERROR = @"网络异常";


static CGFloat const KTopBarHeight = 60.;
static CGFloat const KBottomBarHeight = 60.;
static CGFloat const kTabTitleViewHeight = 45.;

#endif /* LMBaseHeader_h */
