//
//  UIViewController+RunTime.m
//  DemoAssemble
//
//  Created by lirch on 2017/11/9.
//  Copyright © 2017年 lirch. All rights reserved.
//

#import "UIViewController+RunTime.h"


@implementation UIViewController (RunTime)

//-(void)errorLog:(SEL)sel{
//    NSLog(@"\n-----------\n%@\n-----------\n",NSStringFromSelector(sel));
//}
//+(void)load{
//#if DEBUG
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        Class class = [self class];
//        SEL originalSelector = @selector(viewWillAppear:);
//        SEL swizzledSelector = @selector(mrc_viewWillAppear:);
//        // class_getInstanceMethod    获取到的是实方法
//        // class_getClassMethod       获取到的是类方法
//        Method originalMethod = class_getInstanceMethod(class, originalSelector);
//        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
//        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
//
//        if (success) {
//            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
//        }else{
//            method_exchangeImplementations(originalMethod, swizzledMethod);
//        }
//    });
//#else
//#endif
//}
////
////- (void)dealloc
////{
////    NSLog(@"runtime Dealloc *** %@",NSStringFromClass([self class]));
////}
////
//- (void)mrc_viewWillAppear:(BOOL)animated{
////    [self mrc_viewWillAppear:animated];
//    //添加颜色不要用这种方法，会出bug，会出现一个 UIInputWindowController 的东西
////    if (![self isKindOfClass:NSClassFromString(@"UIInputWindowController")]) {
////        self.view.backgroundColor = [UIColor whiteColor];
////    }
//    NSLog(@"runtime *** %@",NSStringFromClass([self class]));
//}
/////*重写父类方法，重写的方法和父类方法都会执行，会有一个警告
////-(void)viewWillAppear:(BOOL)animated{
////    NSLog(@"******Category is implementing a method which will also be implemented by its primary class");
////}*/

UIViewController * currViewController(void)
{
    UITabBarController *tab = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    if ([tab isKindOfClass:[UITabBarController class]])
    {
        UIViewController *vc = ([(UINavigationController *)[[tab viewControllers] objectAtIndex:tab.selectedIndex] visibleViewController]);
        if (vc.presentedViewController)
        {
            if (vc.presentedViewController.presentedViewController)
            {
                return vc.presentedViewController.presentedViewController;
            }
            return vc.presentedViewController;
        }
        else
        {
            return vc;
        }
    }else{
        return [UIViewController getCurrentVC];
    }
    return nil;
}

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    
    return currentVC;
}


@end
