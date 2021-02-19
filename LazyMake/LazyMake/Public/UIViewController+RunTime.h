//
//  UIViewController+RunTime.h
//  DemoAssemble
//
//  Created by lirch on 2017/11/9.
//  Copyright © 2017年 lirch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (RunTime)

UIViewController * currViewController(void);

+ (UIViewController *)getCurrentVC;

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC;

@end
