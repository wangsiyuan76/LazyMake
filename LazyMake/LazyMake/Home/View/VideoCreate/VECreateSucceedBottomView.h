//
//  VECreateSucceedBottomView.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/17.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VECreateSucceedBottomView : UIView <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (copy, nonatomic) void (^clickSubBtnBlock)(NSInteger btnTag);

@property (strong, nonatomic) UIButton *vipBtn;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *shareTitleArr;
@property (strong, nonatomic) NSArray *shareImageArr;

@property (assign, nonatomic) BOOL ifAe;                //来源是否是模板
@property (assign, nonatomic) BOOL ifHiddenWearerBtn;       //是否隐藏去水印按钮

@property (strong, nonatomic) UIButton *doneBtn;            //保存本地按钮
@property (strong, nonatomic) UIButton *pushBtn;            //上传服务端按钮
@property (strong, nonatomic) NSString *videoPath;            
@property (strong, nonatomic) NSString *photoId;
@property (assign, nonatomic) BOOL ifImage;                //是否是图片
@property (assign, nonatomic) CGSize imageSize;
@property (strong, nonatomic) UIImage *showImage;

@end

NS_ASSUME_NONNULL_END
