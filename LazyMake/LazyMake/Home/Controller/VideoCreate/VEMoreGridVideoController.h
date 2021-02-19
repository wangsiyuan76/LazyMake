//
//  VEMoreGridVideoController.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/6/5.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VEMoreLatticeVideoMainView.h"
#import "VEMoreLatticeVideoEnumView.h"
#import "VEMoreGridVideoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface VEMoreGridVideoController : UIViewController

@property (strong, nonatomic) VEMoreLatticeVideoMainView *mainView;         //顶部展示的view
@property (strong, nonatomic) VEMoreLatticeVideoEnumView *enumView;         //底部菜单选项的view
@property (strong, nonatomic) NSMutableArray *videoArr;                     //选择的视频数组
@property (strong, nonatomic) VEMoreGridVideoModel *model;                  //当前展示的样式
@property (strong, nonatomic) NSArray *modelArr;                            //所有样式的分组
@property (assign, nonatomic) NSInteger selectModelIndex;                   //当前展示的样式的index

@end

NS_ASSUME_NONNULL_END
