//
//  VEAEVideoEditViewController.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/20.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VEHomeTemplateModel.h"
#import "VECreateBottomFeaturesView.h"
#import "VEMediaListController.h"
#import "VEChangeImageVideoView.h"
#import "VEAudioChangeSizeView.h"
#import "VEChangeTextView.h"
#import "VEAudioModel.h"
#import "VEAudioCropView.h"
#import "VEVideoSucceedViewController.h"
#import "VECreateHUD.h"
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

#define BOTTOM_VIEW_H 120
#define BTN_ALPHA 0.5f

@interface VEAEVideoEditViewController : UIViewController <AVAudioPlayerDelegate>

@property (strong, nonatomic) VEHomeTemplateModel *showModel;

@property (strong, nonatomic) VEAudioChangeSizeView  *audioSizeView;        //调整声音大小的view
@property (strong, nonatomic) VEChangeTextView *textView;                   //替换文字的view
@property (strong, nonatomic) VEChangeImageVideoView *changeView;         //选择图片，视频的view
@property (strong, nonatomic) VEAudioCropView *audioCropView;           //配乐裁剪view

@property (strong, nonatomic) VEAudioModel *audioModel;                 //配乐相关model
@property (assign, nonatomic) BOOL playAudio;                           //是否播放音乐
@property (assign, nonatomic) CGSize playSize;                          //播放器的size
@property (strong, nonatomic) NSArray *mediaArr;
@property (strong, nonatomic) NSString *videoUrl;                         //生成视频的url
@property (assign, nonatomic) BOOL showSelectF;                          //是否有弹出view
@property (strong, nonatomic) NSMutableArray *textArr;                   //改变文字的数组

@property (strong, nonatomic) UIButton *shadowBtn;                      //背景遮罩btn
@property (strong, nonatomic) UIButton *shadowNavBtn;                   //背景遮罩btn
@property (strong, nonatomic) UIButton *doneBtn;                        //完成按钮
@property (assign, nonatomic) BOOL hasStop;                               
@property (strong, nonatomic) UIImageView *stopImageV;          
@property (assign, nonatomic) BOOL hasSelelctMedia;                     //是否有选中素材

/// 生成预览
-(void)startAEPreview;

/// 停止预览
-(void)stopAeExecute;

-(void)stopAePreview;

//点击完成按钮
- (void)clickDoneBtn;

@end

NS_ASSUME_NONNULL_END
