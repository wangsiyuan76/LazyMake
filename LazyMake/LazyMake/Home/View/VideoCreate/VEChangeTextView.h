//
//  VEChangeTextView.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/22.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEChangeTextView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (copy, nonatomic) void (^clickDoneBtnBlock)(BOOL ifSucceed, NSInteger selectIndex, NSArray *changeArr);

@property (strong, nonatomic) UIButton *sureBtn;
@property (strong, nonatomic) UIButton *cancleBtn;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *listArr;
@property (assign, nonatomic) NSInteger selectIndex;

+ (CGFloat)viewHeighCount:(NSInteger)count;

@end

NS_ASSUME_NONNULL_END
