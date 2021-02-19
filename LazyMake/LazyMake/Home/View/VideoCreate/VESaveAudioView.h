//
//  VESaveAudioView.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/26.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface VESaveAudioView : UIView
@property (copy, nonatomic) void (^clickSubBtnBlock)(NSInteger btnTag, NSString *titleStr);
@property (strong, nonatomic) NSString *audioName;
@property (strong, nonatomic) UITextField *contentText;

@end

NS_ASSUME_NONNULL_END
