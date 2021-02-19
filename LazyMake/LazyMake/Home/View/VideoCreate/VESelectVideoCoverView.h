//
//  VESelectVideoCoverView.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/23.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VESelectVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VESelectVideoCoverView : UIView
@property (copy, nonatomic) void (^clickSubBtnBlock)(NSInteger btnTag, UIImage *selcectImage);
@property (copy, nonatomic) void (^clickSubImageBlock)(UIImage *selcectImage);
@property (copy, nonatomic) void (^loadAllImageBlock)(NSArray *allImage);
@property (copy, nonatomic) void (^clickAddImageBlock)(void);

@property (strong, nonatomic) NSString *videoUrl;
@property (strong, nonatomic) NSMutableArray *imageList;
@property (strong, nonatomic) NSArray *allImageArr;
@property (strong, nonatomic) VESelectVideoModel *videoModel;


@end

NS_ASSUME_NONNULL_END
