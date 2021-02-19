//
//  VETemplateBottomView.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/8.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VEHomeTemplateModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VETemplateBottomView : UIView
@property (copy, nonatomic) void (^doneLoadSucceedBlock)(VEHomeTemplateModel *model);

@property (copy, nonatomic) void (^clickTagBlock)(id selectedObject, NSInteger index);
@property (copy, nonatomic) void (^clickUserBlock)(void);
@property (copy, nonatomic) void (^clickMakeBlock)(void);

@property (strong, nonatomic) VEHomeTemplateModel *showModel;

- (void)createTagArr:(NSArray *)tagArr;

/// 暂停下载
- (void)stopDonloading;

//删除，撤销当前下载的内容
- (void)deleteDonlondingData;

- (void)updateBtnType;
@end

NS_ASSUME_NONNULL_END
