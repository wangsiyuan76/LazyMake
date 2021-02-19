//
//  VEAEVideoEditViewController+CreateView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/26.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEAEVideoEditViewController+CreateView.h"

@implementation VEAEVideoEditViewController (CreateView)

//顶部完成按钮
-(void)createHeadView{
    self.doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 26)];
     [self.doneBtn setTitle:@"完成" forState:UIControlStateNormal];
     UIImage *image = [VETool colorGradientWithStartColor:[UIColor colorWithHexString:@"#6156FC"] endColor:[UIColor colorWithHexString:@"#1DABFD"] ifVertical:NO imageSize:CGSizeMake(60, 26)];
     [self.doneBtn setBackgroundImage:image forState:UIControlStateNormal];
     [self.doneBtn addTarget:self action:@selector(clickDoneBtn) forControlEvents:UIControlEventTouchUpInside];
     self.doneBtn.layer.masksToBounds = YES;
     self.doneBtn.layer.cornerRadius = 13;
     self.doneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
     UIBarButtonItem *searchBtnBar = [[UIBarButtonItem alloc]initWithCustomView:self.doneBtn];
     self.navigationItem.rightBarButtonItem = searchBtnBar;
    [self createBottomView];
}

/// 底部菜单按钮
- (void)createBottomView{
    VECreateBottomFeaturesView *subV = [[VECreateBottomFeaturesView alloc]initWithFrame:CGRectMake(0, kScreenHeight - Height_SafeAreaBottom - BOTTOM_VIEW_H , self.view.width, BOTTOM_VIEW_H) titleArr:self.showModel.customObj.aeTitleArr imageArr:self.showModel.customObj.aeImageArr];
    subV.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:subV];
    @weakify(self);
    subV.clickBtnBlock = ^(NSInteger btnTag) {
        @strongify(self);
        if (self.showModel.customObj.aeTitleArr.count > btnTag) {
            [self stopAeExecute];
            [self stopAePreview];
            NSString *str = self.showModel.customObj.aeTitleArr[btnTag];
            if ([str containsString:@"文字"]) {
                [self createChangeTextView];
            }else if ([str containsString:@"图层"] || [str containsString:@"视频"]) {
                [self createChangeImageVideoView];
            }else if ([str containsString:@"配乐"]){
                [self createChangeAudioSizeView];
            }
        }
    };
}

//创建改变图片，视频view的model数组
- (NSArray *)createImageVideoArr{
    NSMutableArray *arr = [NSMutableArray new];
    if (self.showModel.customObj.images.count > 0) {
        for (int x = 0; x < self.showModel.customObj.images.count; x++) {
            LMChangeImageVideoItemModel *model = [[LMChangeImageVideoItemModel alloc]init];
            model.titleStr = [NSString stringWithFormat:@"%d",x+1];
            model.coverImage = [UIImage imageNamed:@"vm_add_picture_video"];
            if (self.showModel.customObj.aeType == LMAEVideoType_AllVideo || self.showModel.customObj.aeType == LMAEVideoType_TextVideo) {
                model.coverImage = [UIImage imageNamed:@"vm_add_video_"];
            }else if (self.showModel.customObj.aeType == LMAEVideoType_AllPic || self.showModel.customObj.aeType == LMAEVideoType_TextPic){
                model.coverImage = [UIImage imageNamed:@"vm_add_picture_"];
            }
            [arr addObject:model];
        }
    }
    return arr;
}

//创建改变图片，视频view选择图片的大小
- (CGSize)setImageSize{
    if (self.showModel.customObj.images.count > 0) {
          LMHomeTemplateAEImageModel *imageModel = self.showModel.customObj.images[0];
          CGFloat bili = imageModel.width.floatValue/imageModel.height.floatValue;
          CGFloat h = kScreenWidth/bili;
          return CGSizeMake(kScreenWidth, h);
    }
    return CGSizeMake(kScreenWidth, kScreenWidth);
}

#pragma mark - 各个弹出操作框的回调方法
//音乐裁剪view点击完成的回调
- (void)audioCropViewClick:(BOOL)ifSucceed{
    if (ifSucceed) {
        self.playAudio = NO;
        self.audioModel.beginTime = self.audioModel.previewBeginTime;
        self.audioModel.endTime = self.audioModel.previewEndTime;
        [self createChangeAudioSizeView];
        [self stopAeExecute];
        [self stopAePreview];
    }else{
        self.playAudio = NO;
        self.audioModel.previewOldSize = 1;
        [self startAEPreview];
        self.shadowBtn.alpha = 0;
        self.shadowNavBtn.alpha = 0;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.audioCropView.frame = CGRectMake(0, kScreenHeight+20, kScreenWidth, [VEAudioCropView viewHeight]);
    }completion:^(BOOL finished) {
        self.audioCropView.hidden = YES;
    }];
}

//音乐调整音量view点击完成的回调
- (void)audioSizeViewClick:(BOOL)ifSucceed oldSize:(CGFloat)oldSize videoSize:(CGFloat)videoSize{
    self.showSelectF = YES;
    if (ifSucceed) {
        self.audioModel.oldSize = oldSize;
        self.audioModel.soundtrackSize = videoSize;
        self.audioModel.previewOldSize = oldSize;
    }
    [self startAEPreview];
    [UIView animateWithDuration:0.3 animations:^{
        self.audioSizeView.frame = CGRectMake(0, kScreenHeight+20, kScreenWidth, [VEAudioChangeSizeView viewHeightIfAll:self.audioModel.audioUrl?YES:NO]);
        self.shadowBtn.alpha = 0;
        self.shadowNavBtn.alpha = 0;
    }completion:^(BOOL finished) {
        self.audioSizeView.hidden = YES;
    }];
}

//改变图片和视频view的回调
- (void)imageVideoChangeViewClick:(BOOL)ifSucceed mediaArr:(NSArray *__nullable)mediaArr{
    if (ifSucceed) {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.mediaArr];
        for (int x = 0; x < mediaArr.count; x++) {
            LMChangeImageVideoItemModel *subModel = mediaArr[x];
            if (subModel.ifSelect) {
                if (arr.count > x) {
                    self.hasSelelctMedia = YES;
                    [arr replaceObjectAtIndex:x withObject:subModel];
                }
            }
        }
        self.mediaArr = arr;
    }
    self.showSelectF = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.changeView.frame = CGRectMake(0, kScreenHeight+70, kScreenWidth, 145);
        self.shadowBtn.alpha = 0;
        self.shadowNavBtn.alpha = 0;
    }completion:^(BOOL finished) {
        self.changeView.hidden = YES;
    }];
    [self startAEPreview];
}

//改变文字view的回调
- (void)textViewChangeClick:(BOOL)ifSucceed selectIndex:(NSInteger)selectIndex changeArr:(NSArray * _Nonnull)changeArr{
    self.showSelectF = YES;
    [self startAEPreview];
    [UIView animateWithDuration:0.3 animations:^{
        self.textView.frame = CGRectMake(0, kScreenHeight+20, kScreenWidth, [VEChangeTextView viewHeighCount:self.showModel.customObj.texts.count]);
        self.shadowBtn.alpha = 0;
        self.shadowNavBtn.alpha = 0;
    }completion:^(BOOL finished) {
        self.textView.hidden = YES;
    }];
    if (ifSucceed) {
        self.textArr = [NSMutableArray arrayWithArray:changeArr];
        [self startAEPreview];
    }
}

#pragma mark - view的弹出，回收
//调整配乐音量的view
- (void)createChangeAudioSizeView{
    [self.audioSizeView changeHeadIfShow:self.audioModel.audioUrl?YES:NO];
    if (self.showSelectF) {
        [self.audioSizeView setOldSize:self.audioModel.oldSize newSize:self.audioModel.soundtrackSize];
        self.audioSizeView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.audioSizeView.frame = CGRectMake(0, kScreenHeight - Height_SafeAreaBottom-[VEAudioChangeSizeView viewHeightIfAll:self.audioModel.audioUrl?YES:NO], kScreenWidth, [VEAudioChangeSizeView viewHeightIfAll:self.audioModel.audioUrl?YES:NO]);
            self.shadowBtn.alpha = BTN_ALPHA;
            self.shadowNavBtn.alpha = BTN_ALPHA;
        }];
    }else{
        [self startAEPreview];
        [UIView animateWithDuration:0.3 animations:^{
            self.audioSizeView.frame = CGRectMake(0, kScreenHeight+20, kScreenWidth, [VEAudioChangeSizeView viewHeightIfAll:self.audioModel.audioUrl?YES:NO]);
            self.shadowBtn.alpha = 0;
            self.shadowNavBtn.alpha = 0;
        }completion:^(BOOL finished) {
            self.audioSizeView.hidden = YES;
             [self startAEPreview];
        }];
    }
}

//裁剪配乐的view
- (void)cropAudioSizeView{
    if (self.showSelectF) {
        self.audioCropView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.audioCropView.frame = CGRectMake(0, kScreenHeight - Height_SafeAreaBottom-[VEAudioCropView viewHeight], kScreenWidth, [VEAudioCropView viewHeight]);
            self.shadowBtn.alpha = BTN_ALPHA;
            self.shadowNavBtn.alpha = BTN_ALPHA;
        }];
    }else{
        [self startAEPreview];
        [UIView animateWithDuration:0.3 animations:^{
            self.audioCropView.frame = CGRectMake(0, kScreenHeight+20, kScreenWidth, [VEAudioCropView viewHeight]);
            self.shadowBtn.alpha = 0;
            self.shadowNavBtn.alpha = 0;
        }completion:^(BOOL finished) {
            self.audioCropView.hidden = YES;
             [self startAEPreview];
        }];
    }
}

//更换文字的view
- (void)createChangeTextView{
    if (self.showSelectF) {
        self.textView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.textView.frame = CGRectMake(0, kScreenHeight - Height_SafeAreaBottom-[VEChangeTextView viewHeighCount:self.showModel.customObj.texts.count], kScreenWidth, [VEChangeTextView viewHeighCount:self.showModel.customObj.texts.count]);
            self.shadowBtn.alpha = BTN_ALPHA;
            self.shadowNavBtn.alpha = BTN_ALPHA;
        }];
    }else{
        [self startAEPreview];
        [UIView animateWithDuration:0.3 animations:^{
            self.textView.frame = CGRectMake(0, kScreenHeight+20, kScreenWidth, [VEChangeTextView viewHeighCount:self.showModel.customObj.texts.count]);
            self.shadowBtn.alpha = 0;
            self.shadowNavBtn.alpha = 0;
        }completion:^(BOOL finished) {
            self.textView.hidden = YES;
            [self startAEPreview];
        }];
    }
}

///选择图片、视频的view
- (void)createChangeImageVideoView{
    if (self.showSelectF) {
        self.changeView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.changeView.frame = CGRectMake(0, kScreenHeight - Height_SafeAreaBottom-145, kScreenWidth, 145);
            self.shadowBtn.alpha = BTN_ALPHA;
            self.shadowNavBtn.alpha = BTN_ALPHA;
        }];
    }else{
        [self startAEPreview];
        [UIView animateWithDuration:0.3 animations:^{
            self.changeView.frame = CGRectMake(0, kScreenHeight+70, kScreenWidth, 145);
            self.shadowBtn.alpha = 0;
            self.shadowNavBtn.alpha = 0;
        }completion:^(BOOL finished) {
            self.changeView.hidden = YES;
             [self startAEPreview];
        }];
    }
}

#pragma mark - 音乐播放器
/// 跳转选择音乐页面
- (void)pushSelectAudioVC{
    VEMediaListController *vc = [VEMediaListController new];
    vc.videoUrl = self.showModel.customObj.videoPreview;
    vc.videoFrame = self.stopImageV.frame;
    self.hasStop = YES;
    [self.navigationController pushViewController:vc animated:YES];
    @weakify(self);
    vc.cropAudioBlock = ^(NSString * _Nonnull audioPath, BOOL ifAddFile, NSString * _Nonnull audioName) {
        @strongify(self);
        self.audioSizeView.audioTitle.text = audioName;
        self.audioModel.audioUrl = audioPath;
        self.audioModel.isAddFile = ifAddFile;
        [self createChangeAudioSizeView];
    };
}

/// 开始生成预览
- (void)previewStartAEView{
    [self startAEPreview];

}

@end
