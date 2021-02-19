//
//  VEChangeImageVideoView.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/22.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VEHomeTemplateModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface LMChangeImageVideoItemModel : NSObject

@property (strong, nonatomic) UIImage *coverImage;
@property (strong, nonatomic) NSString *titleStr;
@property (assign, nonatomic) BOOL ifSelect;

//视频相关
@property (strong, nonatomic) NSString *videoUrl;
@property (assign, nonatomic) BOOL ifVideo;
@property (assign, nonatomic) CGFloat startTime;
@property (assign, nonatomic) CGFloat endTime;

@end

@interface VEChangeImageVideoView : UIView

@property (copy, nonatomic) void (^clickBtnBlock)(BOOL ifSucceed, NSArray *mediaArr);
@property (copy, nonatomic) void (^stopVidepBlock)(BOOL ifStop);

@property (assign, nonatomic) CGSize imageSize;
@property (assign, nonatomic) BOOL hasVideo;
@property (strong, nonatomic) NSArray *listArr;
@property (assign, nonatomic) LMAEVideoType aeType;
@property (strong, nonatomic) VEHomeTemplateModel *showModel;
@property (weak, nonatomic) UIViewController *superVC;
@end

NS_ASSUME_NONNULL_END
