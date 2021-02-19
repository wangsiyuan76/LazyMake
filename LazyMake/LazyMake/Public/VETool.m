//
//  VETool.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/3/31.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VETool.h"
#import "sys/utsname.h"
#import <AVFoundation/AVFoundation.h>
#import <photos/Photos.h>
#include <CommonCrypto/CommonDigest.h>
#import "ZFDownloadManager.h"

@implementation VETool

//改变按钮的布局样式
+ (void)changeBtnStyleWithType:(LMBtnImageTitleType)type distance:(CGFloat)distance andBtn:(UIButton *)btn{
    if (type == LMBtnImageTitleType_ImageTop) {                 //图片上文字下
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        CGFloat totalHeight = (btn.imageView.frame.size.height + btn.titleLabel.frame.size.height);
        [btn setImageEdgeInsets:UIEdgeInsetsMake(-(totalHeight - btn.imageView.frame.size.height), 0, 5, -btn.imageView.frame.size.width-btn.titleLabel.frame.size.width/2+6)];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake((totalHeight - btn.titleLabel.frame.size.height)+distance, -btn.imageView.frame.size.width, 0,0.0)];
    }else if (type == LMBtnImageTitleType_ImagRight){            //图片又文字左
        CGFloat labelWidth = btn.titleLabel.intrinsicContentSize.width;
        CGFloat imageWidth = btn.imageView.frame.size.width;
        CGFloat space = distance; //定义两个元素交换后的间距
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, - imageWidth - space,0,imageWidth + space);
        btn.imageEdgeInsets = UIEdgeInsetsMake(2, labelWidth + space, 0,  -labelWidth - space);
    }
}

/**
 计算内容高度

 @param content 内容
 @param lineSpacing 行间距
 @param font 字体
 @param maxW 最大宽度
 @param lineNum 最大行数
 @return 高度
 */
+ (CGFloat)contentHeight:(NSString *)content lineSpacing:(NSInteger)lineSpacing font:(UIFont *)font maxWidth:(CGFloat)maxW maxLineNum:(NSInteger)lineNum{
    if ([content isNotBlank]) {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:content];
        text.font = font;
        text.lineSpacing = lineSpacing;
        
        YYTextContainer *container = [YYTextContainer new];
        container.size = CGSizeMake(maxW, CGFLOAT_MAX);
        if (lineNum > 0) {
            container.maximumNumberOfRows = lineNum;
        }
        // 生成排版结果
        YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:text];
        return layout.textBoundingSize.height;
    }
    return 0;
}

+ (NSString *) convertNSStringWithDate:(NSString *) date format:(NSString * _Nullable)fmoratStr{
    NSDate *editDate = [NSDate dateWithTimeIntervalSince1970:date.integerValue];
    if ([fmoratStr isNotBlank]) {
        return [editDate stringWithFormat:fmoratStr];
    }
    return [editDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
}

/**
 将某个时间转化成 时间戳
 */
+ (NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format]; //(@"YYYY-MM-dd HH:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate* date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate
    
    //时间转时间戳的方法:
    
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
        
    return timeSp;
}

/// 获取系统当前时间
/// @param formatStr YYYY-MM-dd HH:mm:ss
+(NSString*)getCurrentTimesFormat:(NSString *)formatStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatStr];
    NSDate *dateNow = [NSDate date];
    NSString *currentTime = [formatter stringFromDate:dateNow];
    return currentTime;
}

/**
 计算两个时间戳相差多少分钟  2020-04-14 21:46:48   2020-04-14 14:26:01
*/
+ (int)compareTwoTime:(NSInteger)time1 time2:(NSInteger)time2{
    NSTimeInterval balance = time2 /1000- time1 /1000;
    if (time2 > time1) {
        balance = time2 /1000- time1 /1000;
    }else{
        balance = time1 /1000- time2 /1000;
    }
    NSString*timeString = [[NSString alloc]init];
    timeString = [NSString stringWithFormat:@"%f",balance /60];
    timeString = [timeString substringToIndex:timeString.length-7];
    int timeInt = [timeString intValue];
    return timeInt;
}

/**
获取与服务端时间同步后的本地时间
*/
+ (NSInteger)createLoadNetTime{
    NSDate * date = [NSDate date];

    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    //设置时间间隔（秒）（这个我是计算出来的，不知道有没有简便的方法 )

//    NSTimeInterval time = 365 * 24 * 60 * 60;//一年的秒数
    NSNumber *num = [[NSUserDefaults standardUserDefaults]objectForKey:TIME_INTERVAL];
    NSTimeInterval time = num.integerValue;

    //得到一年之前的当前时间（-：表示向前的时间间隔（即去年），如果没有，则表示向后的时间间隔（即明年））

    NSDate * lastYear = [date dateByAddingTimeInterval:-time];

    //转化为字符串
    NSString * startDate = [dateFormatter stringFromDate:lastYear];

    return [[self class]timeSwitchTimestamp:startDate andFormatter:@"yyyy-MM-dd HH:mm:ss"];
}

/// 返回一个颜色渐变图片
/// @param startColor 开始色
/// @param endColor 结束的颜色
/// @param ifVertical 是否纵向渐变
+(UIImage *)colorGradientWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor ifVertical:(BOOL)ifVertical imageSize:(CGSize)imageSize{
    CGSize size = imageSize;
    UIImage *bgImage;
    UIGraphicsBeginImageContextWithOptions(size, YES, 1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    if (ifVertical) {
        gradientLayer.endPoint = CGPointMake(0, 1);
    }
    gradientLayer.locations = @[@(1),@(0.5)];//渐变点
    [gradientLayer setColors:@[(id)startColor.CGColor,(id)endColor.CGColor]];
    [gradientLayer renderInContext:context];
    bgImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return bgImage;
}

/// 改变一个lab的行间距
/// @param label label description
/// @param space space description
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];

}

/// 改变一个lab的字间距
/// @param label label description
/// @param space space description
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space {

    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(space)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];

}

/*
 自定义方法：获取缓存大小
 由于缓存文件存在沙箱中，我们可以通过NSFileManager API来实现对缓存文件大小的计算。
 遍历文件夹获得文件夹大小，返回多少 M
 */
+ (float) getCacheSize{
    NSString *folderPath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES) firstObject];
    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject]) != nil ){
        //获取文件全路径
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [[self class] fileSizeAtPath :fileAbsolutePath];
    }

    return folderSize/( 1024.0 * 1024.0);
}

// 清除缓存
+ (void)clearFile{
    [[ZFDownloadManager sharedDownloadManager] clearAllFinished];

    NSString * cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES ) firstObject];
    NSArray * files = [[NSFileManager defaultManager ] subpathsAtPath :cachePath];
    //NSLog ( @"cachpath = %@" , cachePath);
    for ( NSString * p in files) {
        
        NSError * error = nil ;
        //获取文件全路径
        NSString * fileAbsolutePath = [cachePath stringByAppendingPathComponent :p];
        
        if ([[NSFileManager defaultManager ] fileExistsAtPath :fileAbsolutePath]) {
            [[NSFileManager defaultManager ] removeItemAtPath :fileAbsolutePath error :&error];
        }
    }
}

// 计算 单个文件的大小
+ ( long long ) fileSizeAtPath:( NSString *) filePath{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath :filePath]){
        return [[manager attributesOfItemAtPath :filePath error : nil] fileSize];
    }
    return 0;
}

/// 获取app版本号
+ (NSString *)versionNumber{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}

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
                      withFont:(CGFloat)font
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpacing;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:font], NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f};
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

//设置毛玻璃效果
+(void)blurEffect:(UIView *)view{

    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectVIew = [[UIVisualEffectView alloc]initWithEffect:effect];
    effectVIew.frame = view.bounds;
    [view addSubview:effectVIew];

}

//数组中的随机色值
+ (UIColor *)backgroundRandomColor{
    NSArray *colorArr = @[@"#ffeaec",@"#fbd3e0",@"#ebd5f0",@"#e2d9f0",@"#d9dcf0",@"#d3eafc",@"#ceeefd",@"#cdf2f7",@"#cdeae8",@"#dbefdc",@"#e9f3db",@"#f5f8d7",@"#fdf5d2",@"#ffebcc",@"#ffddd2",@"#eeeeee",@"#e0e6e9",@"#e5dedb"];
    int value = arc4random() % colorArr.count;
    NSString *colorStr = [colorArr objectAtIndex:value];
    return [UIColor colorWithHexString:colorStr];
}


/// 对象转换为字典
+ (NSDictionary*)getObjectData:(id)obj{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);//获得属性列表
    for(int i = 0;i < propsCount; i++){
        objc_property_t prop = props[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];//获得属性的名称
        id value = [obj valueForKey:propName];//kvc读值
        if(value == nil){
            value = [NSNull null];
        }else{
            value = [[self class] getObjectInternal:value];//自定义处理数组，字典，其他类
            [dic setObject:value forKey:propName];
        }
    }
    return dic;
}

+ (id)getObjectInternal:(id)obj{
    if([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSNull class]]) {
        return obj;
    }
    if([obj isKindOfClass:[NSArray class]]) {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++) {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    if([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys){
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self getObjectData:obj];
}

/**
 *  手机型号
 *
 *  @return e.g. iPhone  https://www.theiphonewiki.com/wiki/Models  设备参考资料
 */
+(NSString *)phoneModel{
  // 需要#import "sys/utsname.h"
     struct utsname systemInfo;
     uname(&systemInfo);
     NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
     
     //iPhone
     if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
     if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
     if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
     if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
     if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
     if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
     if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
     if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
     if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
     if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
     if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
     if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
     if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
     if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
     if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
     if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
     if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
     if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
     if ([deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
     if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
     if ([deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
     if ([deviceString isEqualToString:@"iPhone10,1"])    return @"iPhone 8";
     if ([deviceString isEqualToString:@"iPhone10,4"])    return @"iPhone 8";
     if ([deviceString isEqualToString:@"iPhone10,2"])    return @"iPhone 8 Plus";
     if ([deviceString isEqualToString:@"iPhone10,5"])    return @"iPhone 8 Plus";
     if ([deviceString isEqualToString:@"iPhone10,3"])    return @"iPhone X";
     if ([deviceString isEqualToString:@"iPhone10,6"])    return @"iPhone X";
     if ([deviceString isEqualToString:@"iPhone11,8"])    return @"iPhone XR";
     if ([deviceString isEqualToString:@"iPhone11,2"])    return @"iPhone XS";
     if ([deviceString isEqualToString:@"iPhone11,6"])    return @"iPhone XS Max";
     if ([deviceString isEqualToString:@"iPhone12,1"])    return @"iPhone 11";
     if ([deviceString isEqualToString:@"iPhone12,3"])    return @"iPhone 11 Pro";
     if ([deviceString isEqualToString:@"iPhone12,5"])    return @"iPhone 11 ProMax";
     if ([deviceString isEqualToString:@"iPhone13,1"])    return @"iPhone 12";
     if ([deviceString isEqualToString:@"iPhone13,3"])    return @"iPhone 12 Pro";


     //iPod
     if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
     if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
     if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
     if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
     if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
     
     //iPad
     if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
     if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
     if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
     if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
     if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
     if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
     if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
     if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
     
     if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
     if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
     if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
     if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
     if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
     if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
     
     if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air";
     if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air";
     if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air";
     if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
     if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
     if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
     if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
     
     if ([deviceString isEqualToString:@"iPad4,4"]
         ||[deviceString isEqualToString:@"iPad4,5"]
         ||[deviceString isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
     
     if ([deviceString isEqualToString:@"iPad4,7"]
         ||[deviceString isEqualToString:@"iPad4,8"]
         ||[deviceString isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
     
     return deviceString;

}

/**
 *  手机系统版本
 *
 *  @return e.g. 8.0
 */
+(NSString *)phoneVersion{
    return [[UIDevice currentDevice] systemVersion];
}

/**
*  获取设备标示UUDI
*/
+(NSString *)phoneUUID{
    return [[UIDevice currentDevice] identifierForVendor].UUIDString;
}

/**
*  获取设备网络状态
*/
+ (NSString *)networkingStatesFromStatebar {
  UIApplication *app = [UIApplication sharedApplication];
        id statusBar = nil;
    //    判断是否是iOS 13
        NSString *network = @"";
        if (@available(iOS 13.0, *)) {
            UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].keyWindow.windowScene.statusBarManager;
            
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wundeclared-selector"
            if ([statusBarManager respondsToSelector:@selector(createLocalStatusBar)]) {
                UIView *localStatusBar = [statusBarManager performSelector:@selector(createLocalStatusBar)];
                if ([localStatusBar respondsToSelector:@selector(statusBar)]) {
                    statusBar = [localStatusBar performSelector:@selector(statusBar)];
                }
            }
    #pragma clang diagnostic pop
            if (statusBar) {
                id currentData = [[statusBar valueForKeyPath:@"_statusBar"] valueForKeyPath:@"currentData"];
                id _wifiEntry = [currentData valueForKeyPath:@"wifiEntry"];
                id _cellularEntry = [currentData valueForKeyPath:@"cellularEntry"];
                if (_wifiEntry && [[_wifiEntry valueForKeyPath:@"isEnabled"] boolValue]) {
    //              If wifiEntry is enabled, is WiFi.
                    network = @"WIFI";
                } else if (_cellularEntry && [[_cellularEntry valueForKeyPath:@"isEnabled"] boolValue]) {
                    NSNumber *type = [_cellularEntry valueForKeyPath:@"type"];
                    if (type) {
                        switch (type.integerValue) {
                            case 0:
    //                            无sim卡
                                network = @"NONE";
                                break;
                            case 1:
                                network = @"1G";
                                break;
                            case 4:
                                network = @"3G";
                                break;
                            case 5:
                                network = @"4G";
                                break;
                            default:
    //                            默认WWAN类型
                                network = @"WWAN";
                                break;
                                }
                            }
                        }
                    }
        }else {
            statusBar = [app valueForKeyPath:@"statusBar"];
            
            if (IS_IPHONE_X_MAIN) {
    //            刘海屏
                    id statusBarView = [statusBar valueForKeyPath:@"statusBar"];
                    UIView *foregroundView = [statusBarView valueForKeyPath:@"foregroundView"];
                    NSArray *subviews = [[foregroundView subviews][2] subviews];
                    
                    if (subviews.count == 0) {
    //                    iOS 12
                        id currentData = [statusBarView valueForKeyPath:@"currentData"];
                        id wifiEntry = [currentData valueForKey:@"wifiEntry"];
                        if ([[wifiEntry valueForKey:@"_enabled"] boolValue]) {
                            network = @"WIFI";
                        }else {
    //                    卡1:
                            id cellularEntry = [currentData valueForKey:@"cellularEntry"];
    //                    卡2:
                            id secondaryCellularEntry = [currentData valueForKey:@"secondaryCellularEntry"];

                            if (([[cellularEntry valueForKey:@"_enabled"] boolValue]|[[secondaryCellularEntry valueForKey:@"_enabled"] boolValue]) == NO) {
    //                            无卡情况
                                network = @"NONE";
                            }else {
    //                            判断卡1还是卡2
                                BOOL isCardOne = [[cellularEntry valueForKey:@"_enabled"] boolValue];
                                int networkType = isCardOne ? [[cellularEntry valueForKey:@"type"] intValue] : [[secondaryCellularEntry valueForKey:@"type"] intValue];
                                switch (networkType) {
                                        case 0://无服务
                                        network = [NSString stringWithFormat:@"%@-%@", isCardOne ? @"Card 1" : @"Card 2", @"NONE"];
                                        break;
                                        case 3:
                                        network = [NSString stringWithFormat:@"%@-%@", isCardOne ? @"Card 1" : @"Card 2", @"2G/E"];
                                        break;
                                        case 4:
                                        network = [NSString stringWithFormat:@"%@-%@", isCardOne ? @"Card 1" : @"Card 2", @"3G"];
                                        break;
                                        case 5:
                                        network = [NSString stringWithFormat:@"%@-%@", isCardOne ? @"Card 1" : @"Card 2", @"4G"];
                                        break;
                                    default:
                                        break;
                                }
                                
                            }
                        }
                    
                    }else {
                        
                        for (id subview in subviews) {
                            if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarWifiSignalView")]) {
                                network = @"WIFI";
                            }else if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarStringView")]) {
                                network = [subview valueForKeyPath:@"originalText"];
                            }
                        }
                    }
                    
                }else {
    //                非刘海屏
                    UIView *foregroundView = [statusBar valueForKeyPath:@"foregroundView"];
                    NSArray *subviews = [foregroundView subviews];
                    
                    for (id subview in subviews) {
                        if ([subview isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
                            int networkType = [[subview valueForKeyPath:@"dataNetworkType"] intValue];
                            switch (networkType) {
                                case 0:
                                    network = @"NONE";
                                    break;
                                case 1:
                                    network = @"2G";
                                    break;
                                case 2:
                                    network = @"3G";
                                    break;
                                case 3:
                                    network = @"4G";
                                    break;
                                case 5:
                                    network = @"WIFI";
                                    break;
                                default:
                                    break;
                            }
                        }
                    }
                }
        }

        if ([network isEqualToString:@""]) {
            network = @"NO DISPLAY";
        }
        return network;
}


/// 网络是否是wifi
+(BOOL)netWorkIsWifi{
    NSString *str = [[self class]networkingStatesFromStatebar];
    if ([str isEqualToString:@"WIFI"]) {
        return YES;
    }
    return NO;
}

/**
 视频分解成图片
 
 @param fileUrl 视频路径
 @param fps 帧率 一般为30
 @param splitCompleteBlock 处理回调
 */
+ (void)splitVideo:(NSURL *)fileUrl fps:(float)fps splitCompleteBlock:(void(^)(BOOL success, NSMutableArray *splitimgs))splitCompleteBlock {
    if (!fileUrl) {
        return;
    }
    NSMutableArray *splitImages = [NSMutableArray array];
    NSDictionary *optDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *avasset = [[AVURLAsset alloc] initWithURL:fileUrl options:optDict];
    
    CMTime cmtime = avasset.duration; //视频时间信息结构体
    Float64 durationSeconds = CMTimeGetSeconds(cmtime); //视频总秒数
    
    NSMutableArray *times = [NSMutableArray array];
    Float64 totalFrames = durationSeconds * fps; //获得视频总帧数
    CMTime timeFrame;
    for (int i = 1; i <= totalFrames; i++) {
        timeFrame = CMTimeMake(i, fps); //第i帧  帧率
        NSValue *timeValue = [NSValue valueWithCMTime:timeFrame];
        [times addObject:timeValue];
    }
    
    AVAssetImageGenerator *imgGenerator = [[AVAssetImageGenerator alloc] initWithAsset:avasset];
    //防止时间出现偏差
    imgGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    imgGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    
    NSInteger timesCount = [times count];
    
    // 获取每一帧的图片
    [imgGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        BOOL isSuccess = NO;
        switch (result) {
            case AVAssetImageGeneratorCancelled:
                if (requestedTime.value == timesCount) {
                    isSuccess = YES;
                }
                break;
            case AVAssetImageGeneratorFailed:
                if (requestedTime.value == timesCount) {
                    isSuccess = YES;
                }
                break;
            case AVAssetImageGeneratorSucceeded: {
                UIImage *frameImg = [UIImage imageWithCGImage:image];
                [splitImages addObject:frameImg];
                
                if (requestedTime.value == timesCount) {
                    isSuccess = YES;
                }
            }
                break;
        }
        if (splitCompleteBlock) {
            splitCompleteBlock(isSuccess,splitImages);
        }
    }];
}

/**
* 获取视频缩略图
*/
+ (NSArray *)thumbnailImageRequestWithVideoUrl:(NSURL *)videoUrl{
    if (videoUrl == nil){
        return nil;
    }

    AVURLAsset *urlAsset = [AVURLAsset assetWithURL:videoUrl];
    NSInteger otherNum = 1;
    long int second = urlAsset.duration.value/urlAsset.duration.timescale;
    if (second / 6 > 1) {
        otherNum = second / 6;
    }
    NSMutableArray *imageArr = [NSMutableArray new];
    for (int x = 0; x <= second-otherNum; x+=otherNum) {
        //根据AVURLAsset创建AVAssetImageGenerator
        AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
        /*截图
        * requestTime:缩略图创建时间
        * actualTime:缩略图实际生成的时间
        */
        NSError *error = nil;
        CMTime requestTime = CMTimeMake(x, 1);
        //CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要活的某一秒的第几帧可以使用CMTimeMake方法)
        CMTime actualTime;
        CGImageRef cgImage = [imageGenerator copyCGImageAtTime:requestTime actualTime:&actualTime error:&error];
        if(error)
        {
        NSLog(@"截取视频缩略图时发生错误，错误信息：%@", error.localizedDescription);
        return nil;
        }

        CMTimeShow(actualTime);
        UIImage *image = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        [imageArr addObject:image];
    }
    return imageArr;
}

/*
 截取指定时间的视频缩略图
 */
+ (UIImage *)thumbnailImageRequestWithVideoUrl:(NSURL *)videoUrl andTimeDur:(NSInteger)timeDur{
    if (videoUrl == nil){
        return nil;
    }

    AVURLAsset *urlAsset = [AVURLAsset assetWithURL:videoUrl];

    //根据AVURLAsset创建AVAssetImageGenerator
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    /*截图
    * requestTime:缩略图创建时间
    * actualTime:缩略图实际生成的时间
    */
    NSError *error = nil;
    CMTime requestTime = CMTimeMake(timeDur, 1);
    //CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要活的某一秒的第几帧可以使用CMTimeMake方法)
    CMTime actualTime;
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:requestTime actualTime:&actualTime error:&error];
    if(error){
        NSLog(@"截取视频缩略图时发生错误，错误信息：%@", error.localizedDescription);
        return nil;
    }

    CMTimeShow(actualTime);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return image;
}

//设置viwe锚点
+ (void)hf_setAnchorPoint:(CGPoint)anchorPoint supView:(UIView *)subV{
    CGPoint newPoint = CGPointMake(subV.bounds.size.width * anchorPoint.x, subV.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(subV.bounds.size.width * subV.layer.anchorPoint.x, subV.bounds.size.height * subV.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, subV.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, subV.transform);
    
    CGPoint position = subV.layer.position;
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    subV.layer.position = position;
    subV.layer.anchorPoint = anchorPoint;
}

/**
 *   创建保存视频音乐的文件夹
 */
+ (void)createEmoticonFolderBlock:(void (^)(BOOL ifSucceed,NSString *fileUrl,NSError * error))finshBlock{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    //获取沙盒文件路径
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [documentPaths objectAtIndex:0];

    //获取文件夹路径
    NSString *userId = @"Music";
    NSString *emoticonPath = [NSString stringWithFormat:@"%@/%@",documentPath,userId];
    // 判断文件夹是否存在，如果不存在，则创建
    if (![[NSFileManager defaultManager]fileExistsAtPath:emoticonPath]){
        NSError *error;
        [fileManager createDirectoryAtPath:emoticonPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error){
            if (finshBlock) {
                finshBlock(NO,emoticonPath,error);
            }
            LMLog(@"插入失败");
        }else{
            if (finshBlock) {
                finshBlock(YES,emoticonPath,nil);
            }
        }
    }else{
        LMLog(@"该文件夹已存在");
        if (finshBlock) {
            finshBlock(YES,emoticonPath,nil);
        }
    }
    
}

/**
 *   创建保存AE模板文件夹
 */
+ (void)createAEDataFolderBlock:(void (^)(BOOL ifSucceed,NSString *fileUrl,NSError * error))finshBlock{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    //获取沙盒文件路径
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [documentPaths objectAtIndex:0];
    
    //获取文件夹路径
    NSString *userId = @"LazyMake";
    NSString *emoticonPath = [NSString stringWithFormat:@"%@/AE/%@",documentPath,userId];
    // 判断文件夹是否存在，如果不存在，则创建
    if (![[NSFileManager defaultManager]fileExistsAtPath:emoticonPath]){
        NSError *error;
        [fileManager createDirectoryAtPath:emoticonPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error){
            if (finshBlock) {
                finshBlock(YES,emoticonPath,error);
            }
            LMLog(@"插入失败");
        }else{
            if (finshBlock) {
                finshBlock(YES,emoticonPath,nil);
            }
        }
    }else{
        if (finshBlock) {
            finshBlock(YES,emoticonPath,nil);
        }
    }
}

//文字转图片;
+(UIImage *)createImageWithText2:(NSString *)text imageSize:(CGSize)size txtColor:(UIColor *)textColor
{
    //文字转图片;
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    [paragraphStyle setLineSpacing:15.f];  //行间距
    [paragraphStyle setParagraphSpacing:2.f];//字符间距
    
    NSDictionary *attributes = @{NSFontAttributeName            : [UIFont systemFontOfSize:60],
                                 NSForegroundColorAttributeName : textColor,
                                 NSBackgroundColorAttributeName : [UIColor clearColor],
                                 NSParagraphStyleAttributeName : paragraphStyle, };
    
    UIImage *image  = [self imageFromString:text attributes:attributes size:size];
    return image;
}
/**
 把文字转换为图片;
 @param string 文字,
 @param attributes 文字的属性
 @param size 转换后的图片宽高
 @return 返回图片
 */
+ (UIImage *)imageFromString:(NSString *)string attributes:(NSDictionary *)attributes size:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);  //图片底部颜色;
    CGContextFillRect(context, CGRectMake(0, 0, size.width, 300));
    
    [string drawInRect:CGRectMake(0, 0, size.width, size.height) withAttributes:attributes];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


//判断相册是否有新建文件夹
+ (BOOL)isExistFolder:(NSString *)folderName {
    //首先获取用户手动创建相册的集合
    PHFetchResult *collectonResuts = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    __block BOOL isExisted = NO;
    //对获取到集合进行遍历
    [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PHAssetCollection *assetCollection = obj;
        //folderName是我们写入照片的相册
        if ([assetCollection.localizedTitle isEqualToString:folderName])  {
            isExisted = YES;
        }
    }];
    
    return isExisted;
}

//相册新建文件夹
+ (void)createFolder:(NSString *)videoPath name:(NSString *)name {
    if (![self isExistFolder:name]) {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            //添加HUD文件夹
            [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:name];
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                NSLog(@"创建相册文件夹成功!");
                [self saveVideo:videoPath name:name];
            } else {
                NSLog(@"创建相册文件夹失败:%@", error);
            }
        }];
    }else{
        [self saveVideo:videoPath name:name];
    }
}

//保存视频
+ (void)saveVideo:(NSString *)videoUrl name:(NSString *)name{
    NSURL *url = [NSURL fileURLWithPath:videoUrl];
    //标识保存到系统相册中的标识
    __block NSString *localIdentifier;
    //首先获取相册的集合
    PHFetchResult *collectonResuts = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    //对获取到集合进行遍历
    [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PHAssetCollection *assetCollection = obj;
        //folderName是我们写入照片的相册
        if ([assetCollection.localizedTitle isEqualToString:name])  {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                //请求创建一个Asset
                PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url];
                //请求编辑相册
                PHAssetCollectionChangeRequest *collectonRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                //为Asset创建一个占位符，放到相册编辑请求中
                PHObjectPlaceholder *placeHolder = [assetRequest placeholderForCreatedAsset];
                //相册中添加视频
                [collectonRequest addAssets:@[placeHolder]];
                
                localIdentifier = placeHolder.localIdentifier;
                [[NSNotificationCenter defaultCenter]postNotificationName:SavePhotoVideoSucceedKey object:localIdentifier];
            } completionHandler:^(BOOL success, NSError *error) {
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD showSuccess:@"视频已保存到相册"];
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD showSuccess:@"视频存到相册失败"];
                    });
                }
            }];
        }
    }];
}

// 保存图片
+ (void)saveImage:(NSURL *__nullable)imageUrl toCollectionWithName:(NSString *)collectionName andImage:(UIImage * __nullable)subImage {
    // 1. 获取相片库对象
    PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
    // 2. 调用changeBlock
    [library performChanges:^{
        // 2.1 创建一个相册变动请求
        PHAssetCollectionChangeRequest *collectionRequest;
        // 2.2 取出指定名称的相册
        PHAssetCollection *assetCollection = [[self class] getCurrentPhotoCollectionWithTitle:collectionName];
        // 2.3 判断相册是否存在
        if (assetCollection) { // 如果存在就使用当前的相册创建相册请求
            collectionRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
        } else { // 如果不存在, 就创建一个新的相册请求
            collectionRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:collectionName];
        }
        // 2.4 根据传入的相片, 创建相片变动请求
        PHAssetChangeRequest *assetRequest;
        if (subImage) {
            assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:subImage];
        }else{
            assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:imageUrl];
        }
        // 2.4 创建一个占位对象
        PHObjectPlaceholder *placeholder = [assetRequest placeholderForCreatedAsset];
        // 2.5 将占位对象添加到相册请求中
        [collectionRequest addAssets:@[placeholder]];
        [[NSNotificationCenter defaultCenter]postNotificationName:SavePhotoVideoSucceedKey object:placeholder.localIdentifier];

    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        // 3. 判断是否出错, 如果报错, 声明保存不成功
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showSuccess:@"保存相册失败"];
            });
        } else {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [MBProgressHUD showSuccess:@"保存成功"];
//            });
        }
    }];
}

+ (PHAssetCollection *)getCurrentPhotoCollectionWithTitle:(NSString *)collectionName {
     // 1. 创建搜索集合
     PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
     // 2. 遍历搜索集合并取出对应的相册
     for (PHAssetCollection *assetCollection in result) {
         if ([assetCollection.localizedTitle containsString:collectionName]) {
             return assetCollection;
         }
     }
     return nil;
 }

//相册新建文件夹，并保存视频
+ (void)savePhotosVideo:(NSString *)videoPath{
    NSString *photoName = @"LazyMake";
    [[self class]createFolder:videoPath name:photoName];
}

/// 将一个data转为字符串的形式
/// @param data 字符串
+ (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}

/** 获取文件的md5值*/
+ (NSString *)getFileMD5StrFromPath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path])
    {
        NSData *data = [NSData dataWithContentsOfFile:path];
        unsigned char digest[CC_MD5_DIGEST_LENGTH];
        CC_MD5( data.bytes, (CC_LONG)data.length, digest );
        NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
        for( int i = 0; i < CC_MD5_DIGEST_LENGTH; i++ )
        {
            [output appendFormat:@"%02x", digest[i]];
        }
        return output;
    }
    else
    {
        return @"";
    }
}


/// 视频压缩后存储的路径
+ (NSString *)creatSandBoxFilePathIfNoExist
{
    //沙盒路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSLog(@"databse--->%@",documentDirectory);
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];// 用时间, 给文件重新命名, 防止视频存储覆盖,
    [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    //创建目录
    NSString *createPath = [NSString stringWithFormat:@"%@/Video", pathDocuments];
    // 判断文件夹是否存在，如果不存在，则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        NSLog(@"FileImage is exists.");
    }
    
    NSString *resultPath = [createPath stringByAppendingPathComponent:[NSString stringWithFormat:@"outputJFVideo-%@.mov",[formater stringFromDate:[NSDate date]]]];
    NSLog(@"%@",resultPath);
    return resultPath;
}

/// 删除蓝松临时文件下的音频数据
+ (void)deleteAllLansonBoxDataIfAll:(BOOL)ifAll{
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //创建目录
    NSString *createPath = [NSString stringWithFormat:@"%@/lansongBox", pathDocuments];
    BOOL fileExists = [fileManager fileExistsAtPath:createPath];
    NSError *err = [[NSError alloc]init];
    NSArray * fileList= [fileManager contentsOfDirectoryAtPath:createPath error:&err];
    LMLog(@"=====%@",fileList);
    if (fileExists && fileList.count > 0) {
        for (int x = 0; x < fileList.count; x++) {
             NSString *file = fileList[x];
            if (ifAll) {
                [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",createPath,file] error:&err];
            }else{
                if ([file containsString:@".m4a"]) {
                    [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",createPath,file] error:&err];
                }
            }
        }
    }
    NSArray * fileLis2t= [fileManager contentsOfDirectoryAtPath:createPath error:&err];
    LMLog(@"=====%@",fileLis2t);

    //删除从音乐库提取的本地音乐
    NSError *err2 = [[NSError alloc]init];
    NSArray * fileList2= [fileManager contentsOfDirectoryAtPath:pathDocuments error:&err2];
    if (fileList2.count > 0) {
        for (int x = 0; x < fileList2.count; x++) {
            NSString *file = fileList2[x];
            if ([file containsString:@".m4a"]) {
                [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",pathDocuments,file] error:&err];
            }
        }
    }
}

/// 百度抠图
/// @param image 图片
/// @param completion 成功
/// @param failure 失败
+(void)baiduCutoutImageWithImage:(UIImage *)image loadingStr:(NSString *__nullable)loadingStr Completion:(void (^)(UIImage *  _Nonnull image))completion failure:(void (^)(NSString * _Nonnull errorStr))failure{
    NSString *baiduToken = [[NSUserDefaults standardUserDefaults]objectForKey:BaiDuAiKeyToken];
    if (baiduToken.length < 1) {
        if (failure) {
            failure(@"百度ID获取失败");
        }
        return;
    }

    NSString *testURL = [NSString stringWithFormat:@"https://aip.baidubce.com/rest/2.0/image-classify/v1/body_seg?access_token=%@",baiduToken];
    testURL = [testURL  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:testURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置请求方法
    request.HTTPMethod = @"POST";
    //设置请求体
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *baseStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *urlEncode = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                             NULL,
                                                                             (__bridge CFStringRef)baseStr,
                                                                             NULL,
                                                                             (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                          CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    if (loadingStr.length > 0) {
        [MBProgressHUD showMessage:loadingStr];
    }else{
        [MBProgressHUD showMessage:@"提取中..."];

    }
    NSString *str =[NSString stringWithFormat:@"image=%@",urlEncode];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = data;
    NSURLSession *session  = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask =  [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
           if (error) {
               NSLog(@"error is %@",error);
               dispatch_async(dispatch_get_main_queue(), ^{
                   [MBProgressHUD hideHUD];
                   if (failure) {
                       failure(@"提取失败");
                   }
                });
           }else{
               NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
               NSString *personNum = [dic objectForKey:@"person_num"];
               if (personNum.integerValue < 1) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [MBProgressHUD hideHUD];
                          if (failure) {
                              failure(@"提取失败");
                          }
                      });
                   return;
               }
               NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:[dic objectForKey:@"foreground"] options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
               dispatch_async(dispatch_get_main_queue(), ^{
                   [MBProgressHUD hideHUD];
                   if (decodeData) {
                       UIImage *image = [UIImage imageWithData:decodeData];
                       if (completion) {
                           completion(image);
                       }
//                       VEVideoSucceedViewController *vc = [[VEVideoSucceedViewController alloc]init];
//                       vc.showImage = image;
//                       vc.videoSize = image.size;
//                       vc.ifImage = YES;
//                       [self.navigationController pushViewController:vc animated:YES];
                   }else{
                       if (failure) {
                           failure(@"提取失败");
                       }
                   }
               });
           }
    }];
    [dataTask resume];
}

@end
