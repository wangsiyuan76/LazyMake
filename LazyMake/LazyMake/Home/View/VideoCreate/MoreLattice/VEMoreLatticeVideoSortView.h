//
//  VEMoreLatticeVideoSortView.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/6/8.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEMoreLatticeVideoSortView : UIView <UICollectionViewDelegate,UICollectionViewDataSource>

@property (copy, nonatomic) void (^clickSureBtnBlock)(BOOL ifSucceed,NSInteger playStyle,NSMutableArray *changeArr);

@property (strong, nonatomic) UIButton *sureBtn;
@property (strong, nonatomic) UIButton *cancleBtn;
@property (strong, nonatomic) UILabel *titleLab;

@property (strong, nonatomic) UILabel *title1;
@property (strong, nonatomic) UILabel *title2;
@property (strong, nonatomic) UIButton *togetherBtn;                  //同时播放按钮
@property (strong, nonatomic) UIButton *orderBtn;                     //顺序播放按钮
@property (strong, nonatomic) UICollectionView *collectionView;       //排序collection
@property (strong, nonatomic) UILabel *bottomLab;                     //底部文字

@property (assign, nonatomic) NSInteger playStyle;                    //0同时播放 1顺序播放
@property (strong, nonatomic) NSMutableArray *dataArr;

- (void)createDataArr:(NSArray *)dataArr;

- (void)createPlayStyle:(NSInteger)playStyle;

@end

NS_ASSUME_NONNULL_END
