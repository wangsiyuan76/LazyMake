//
//  VECreateVideoDirectionView.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/16.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VECreateVideoDirectionView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (copy, nonatomic) void (^clickSelectBlock)(NSInteger btnTag, BOOL ifSucceed);
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIButton *shadowBtn;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UIButton *topBtn;
@property (strong, nonatomic) UIButton *leftBtn;
@property (strong, nonatomic) UIButton *sureBtn;
@property (strong, nonatomic) UIPickerView *pickView;
@property (strong, nonatomic) UIView *lineView;

@property (strong, nonatomic) NSArray *listArr;
@property (assign, nonatomic) NSInteger selectIndex;
@end

NS_ASSUME_NONNULL_END
