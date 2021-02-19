//
//  VEVideoSelectSpliceView.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/5/21.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VESelectVideoModel.h"
#import "VEMoreGridVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VEVideoSelectSpliceView : UIView <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (copy, nonatomic) void (^deleteAllBlock)(void);
@property (strong, nonatomic) UIView *titleView;
@property (strong, nonatomic) UILabel *titleLab;

@property (strong, nonatomic) UIView *mainView;
@property (strong, nonatomic) UILabel *numLab;
@property (strong, nonatomic) UIButton *nextBtn;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (assign, nonatomic) LMEditVideoType videoType;

//多格视频用到的
@property (strong, nonatomic) VEMoreGridVideoModel *model;                  //当前展示的样式
@property (strong, nonatomic) NSArray *modelArr;                            //所有样式的分组
@property (assign, nonatomic) NSInteger selectModelIndex;                   //当前展示的样式的index

-(void)inseartObj:(VESelectVideoModel *)obj maxNumber:(NSInteger)maxNumber;

+ (CGFloat)viewHeight;

@end

NS_ASSUME_NONNULL_END
