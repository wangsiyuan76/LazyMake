//
//  VEFindHomeListCell.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/5/19.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VEFindHomeListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VEFindHomeListCellVideoView : UIView

@property (copy, nonatomic) void (^clickMainBtnBlock)(void);
@property (strong, nonatomic) UIImageView *mainImage;
@property (strong, nonatomic) UIButton *mainBtn;

@end

static NSString *VEFindHomeListCellStr = @"VEFindHomeListCell";

@interface VEFindHomeListCell : UITableViewCell

@property (copy, nonatomic) void (^clickPlayBtnBlock)(BOOL ifPlay, BOOL ifPushDetail, NSInteger index);
@property (strong, nonatomic) VEFindHomeListModel *model;
@property (strong, nonatomic) VEFindHomeListCellVideoView *mainVideoView;
@property (nonatomic, strong) UIButton *playStopBtn;
@property (nonatomic, strong) UIButton *mainPlayBtn;
@property (nonatomic, assign) NSInteger index;

@end

NS_ASSUME_NONNULL_END
