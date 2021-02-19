//
//  VEVideoSucceedViewController.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/17.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEVideoSucceedViewController : UIViewController

@property (assign, nonatomic) BOOL ifHiddenWearerBtn;       //是否隐藏去水印按钮
@property (assign, nonatomic) BOOL ifImage;                  //是否是gif图片
@property (strong, nonatomic) UIImage *showImage;

@property (strong, nonatomic) NSString *videoPath;
@property (assign, nonatomic) CGSize videoSize;
@property (strong, nonatomic) NSString *customId;           //模板id

@end

NS_ASSUME_NONNULL_END
