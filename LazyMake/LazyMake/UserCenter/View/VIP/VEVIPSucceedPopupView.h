//
//  VEVIPSucceedPopupView.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/7.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEVIPSucceedPopupView : UIView

@property (strong, nonatomic) UIImageView *topImage;        //顶部的钻石图片
@property (strong, nonatomic) UILabel *titleLab;            //标题
@property (strong, nonatomic) UILabel *contentLab;          //中间内容
@property (strong, nonatomic) UILabel *endTimeLab;          //结束时间
@property (strong, nonatomic) UIButton *knowBtn;            //我知道了的按钮

@end

NS_ASSUME_NONNULL_END
