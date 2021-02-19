//
//  VEVideoSpliceChangeView.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/5/21.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *LMVideoSpliceChangeCellStr = @"LMVideoSpliceChangeCell";

@interface LMVideoSpliceChangeCell : UICollectionViewCell

@property (copy, nonatomic) void (^clickSubBtnBlock)(NSInteger index);
@property (strong, nonatomic) UIImageView *mainImage;
@property (strong, nonatomic) UIView *shadowView;
@property (strong, nonatomic) UIView *selectView;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UIButton *subBtn;
@property (assign, nonatomic) NSInteger index;
@end


@interface VEVideoSpliceChangeView : UIView <UICollectionViewDelegate,UICollectionViewDataSource>

@property (copy, nonatomic) void (^clickCellItemBlock)(NSInteger index);
@property (copy, nonatomic) void (^clickPlayBtnBlock)(BOOL ifPlay);
@property (copy, nonatomic) void (^clickCropBtnBlock)(NSInteger index);
@property (copy, nonatomic) void (^moveCellBlock)(UIGestureRecognizerState moveState);
@property (copy, nonatomic) void (^changeDataArrNumberBlock)(NSArray *dataChangeArr);

@property (strong, nonatomic) UIButton *playBtn;
@property (strong, nonatomic) UILabel *playTimeLab;
@property (strong, nonatomic) UILabel *allTimeLab;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UILabel *bottomLab;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (assign, nonatomic) NSInteger secondAll;

//改变播放时间进度
- (void)changePlayTimeSchedule:(NSInteger)schedule;

- (void)changeSelectIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
