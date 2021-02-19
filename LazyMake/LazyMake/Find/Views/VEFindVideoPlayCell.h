//
//  VEFindVideoPlayCell.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/5/20.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VEHomeTemplateModel.h"
#import "VEFindHomeListModel.h"
#import "ZFDownloadManager.h"
#import "VECreateHUD.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *VEFindVideoPlayCellStr = @"VEFindVideoPlayCell";

@interface VEFindVideoPlayCell : UICollectionViewCell  <ZFDownloadDelegate>

@property (strong, nonatomic) UIImageView *mainImage;
@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) UIButton *againBtn;
@property (strong, nonatomic) UILabel *userNamaLab;
@property (strong, nonatomic) UIImageView *userIconBtn;

@property (strong, nonatomic) VEHomeTemplateModel *showModel;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) VEFindHomeListModel *model;
@property (nonatomic, strong) VECreateHUD *hud;
@property (strong, nonatomic) UIImageView *shadowImage;

+ (CGFloat)cellHieght;


@end

NS_ASSUME_NONNULL_END
