//
//  VEAudioChangeSizeView.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/22.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEAudioChangeSizeView : UIView

@property (copy, nonatomic) void (^clickBtnBlock)(BOOL ifSucceed, CGFloat oldSize, CGFloat videoSize);
@property (copy, nonatomic) void (^clickSelectBtnBlock)(NSInteger btnTag);
@property (copy, nonatomic) void (^clickDeleteAudioBlock)(void);        //点击删除按钮

@property (strong, nonatomic) UIButton *sureBtn;
@property (strong, nonatomic) UIButton *cancleBtn;
@property (strong, nonatomic) UILabel *titleLab;

@property (strong, nonatomic) UIImageView *audioLogo;
@property (strong, nonatomic) UILabel *audioTitle;
@property (strong, nonatomic) UIButton *audioDelete;
@property (strong, nonatomic) UILabel *lab1;
@property (strong, nonatomic) UILabel *lab2;
@property (strong, nonatomic) UISlider *slider1;
@property (strong, nonatomic) UISlider *slider2;
@property (strong, nonatomic) UIButton *selectAudioBtn;
@property (strong, nonatomic) UIButton *selectAudioBtn2;

- (void)setOldSize:(CGFloat)oldSize newSize:(CGFloat)newSize;
+ (CGFloat)viewHeightIfAll:(BOOL)ifAll;

//是否显示顶部配乐音量
- (void)changeHeadIfShow:(BOOL)ifShow;
@end

NS_ASSUME_NONNULL_END
