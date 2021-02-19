//
//  VEHomeSearchHeadView.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/30.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEHomeSearchHeadView : UIView <UITextFieldDelegate>

@property (copy, nonatomic) void (^clickSearchBlock)(NSString *searchContent);
@property (copy, nonatomic) void (^clickBackBlock)(void);

@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) UITextField *searchText;
@property (strong, nonatomic) UIButton *searchBtn;
@property (strong, nonatomic) UIView *searchView;

@end

NS_ASSUME_NONNULL_END
