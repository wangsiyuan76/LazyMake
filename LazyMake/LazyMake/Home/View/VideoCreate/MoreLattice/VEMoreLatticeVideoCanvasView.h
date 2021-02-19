//
//  VEMoreLatticeVideoCanvasView.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/6/8.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMMoreLatticeVideoSubCanvasView : UIView

@property (copy, nonatomic) void (^clickMainBtnBlock)(NSInteger tag);
@property (strong, nonatomic) UIView *borderView;
@property (strong, nonatomic) UIView *mainView;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UIButton *mainBtn;

- (void)setSelect:(BOOL)ifSelect;

@end

@interface VEMoreLatticeVideoCanvasView : UIView

@property (copy, nonatomic) void (^clickSubChangeBlock)(BOOL ifSucceed, NSInteger index, CGSize selectSize);

@property (strong, nonatomic) UIButton *sureBtn;
@property (strong, nonatomic) UIButton *cancleBtn;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UIScrollView *scroolView;
@property (strong, nonatomic) NSMutableArray *subArr;
@property (strong, nonatomic) NSMutableArray *sizeArr;
@property (assign, nonatomic) NSInteger selectIndex;

- (void)changeSelectWithIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
