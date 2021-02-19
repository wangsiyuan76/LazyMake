//
//  VECreateHUD.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/24.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VELoadingView.h"

NS_ASSUME_NONNULL_BEGIN

@interface VECreateHUD : NSObject

@property (strong, nonatomic) VELoadingView *loadHUD;

-(id) init;
/**
 显示的文字,比如: [NSString stringWithFormat:@"进度:%d",(int)(number.floatValue*100)]
 */
-(void)showProgress:(NSString *)text par:(double)par;

/**
 隐藏
 */
-(void)hide;

@end

NS_ASSUME_NONNULL_END
