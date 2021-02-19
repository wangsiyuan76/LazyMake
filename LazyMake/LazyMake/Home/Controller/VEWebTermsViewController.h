//
//  VEWebTermsViewController.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/7.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEWebTermsViewController : UIViewController

@property (copy, nonatomic) void (^backBlock)(void);
@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) NSString *loadUrl;

@end

NS_ASSUME_NONNULL_END
