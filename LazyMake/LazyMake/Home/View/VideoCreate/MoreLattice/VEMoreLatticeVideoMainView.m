//
//  VEMoreLatticeVideoMainView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/6/8.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEMoreLatticeVideoMainView.h"
#import "VESelectVideoController.h"
#import "VEVideoEditViewController.h"

@implementation LMMoreLatticeVideoSubView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.playScrollView];
        [self addSubview:self.addBtn];
        [self addSubview:self.addLab];
        [self addSubview:self.changeView];
        [self addSubview:self.changeBtn];
        [self addSubview:self.cropView];
        [self addSubview:self.cropBtn];
        [self setAllViewLayout];
    }
    return self;
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.addLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(self.mas_centerY).mas_offset(30);
    }];
    
    [self.changeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(6);
        make.top.mas_equalTo(6);
        make.width.mas_equalTo(54);
        make.height.mas_equalTo(20);
    }];
    
    [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.changeView.mas_left);
        make.top.mas_equalTo(self.changeView.mas_top);
        make.width.mas_equalTo(self.changeView.mas_width);
        make.height.mas_equalTo(self.changeView.mas_height);
    }];
    
    [self.cropView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.changeView.mas_left);
        make.top.mas_equalTo(self.changeView.mas_bottom).mas_offset(4);
        make.width.mas_equalTo(self.changeView.mas_width);
        make.height.mas_equalTo(self.changeView.mas_height);
    }];
    
    [self.cropBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.cropView.mas_left);
        make.top.mas_equalTo(self.cropView.mas_top);
        make.width.mas_equalTo(self.cropView.mas_width);
        make.height.mas_equalTo(self.cropView.mas_height);
    }];
    
    [self.playScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (UIView *)cropView{
    if (!_cropView) {
        _cropView = [UIView new];
        _cropView.backgroundColor = [UIColor blackColor];
        _cropView.alpha = 0.3f;
        _cropView.layer.masksToBounds = YES;
        _cropView.layer.cornerRadius = 10;
    }
    return _cropView;
}

- (UIView *)changeView{
    if (!_changeView) {
        _changeView = [UIView new];
        _changeView.backgroundColor = [UIColor blackColor];
        _changeView.alpha = 0.3f;
        _changeView.layer.masksToBounds = YES;
        _changeView.layer.cornerRadius = 10;
    }
    return _changeView;
}

- (UIButton *)cropBtn{
    if (!_cropBtn) {
        _cropBtn = [UIButton new];
        [_cropBtn setImage:[UIImage imageNamed:@"vm_detail_editor_tailoring"] forState:UIControlStateNormal];
        [_cropBtn setTitle:@"裁剪" forState:UIControlStateNormal];
        [_cropBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
        [_cropBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        _cropBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_cropBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [_cropBtn addTarget:self action:@selector(clickCropBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cropBtn;
}

- (UIButton *)changeBtn{
    if (!_changeBtn) {
        _changeBtn = [UIButton new];
        [_changeBtn setImage:[UIImage imageNamed:@"vm_detail_editor_replace"] forState:UIControlStateNormal];
        [_changeBtn setTitle:@"替换" forState:UIControlStateNormal];
        [_changeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
        [_changeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        _changeBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_changeBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [_changeBtn addTarget:self action:@selector(clickChangeBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeBtn;
}

- (UIScrollView *)playScrollView{
    if (!_playScrollView) {
        _playScrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        _playScrollView.bounces = NO;
        _playScrollView.showsVerticalScrollIndicator = NO;
        _playScrollView.showsHorizontalScrollIndicator = NO;
        _playScrollView.delegate = self;
    }
    return _playScrollView;
}

- (UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [UIButton new];
        [_addBtn setBackgroundColor:[UIColor colorWithHexString:@"#A1A7B2"]];
        [_addBtn addTarget:self action:@selector(clickChangeBtn) forControlEvents:UIControlEventTouchUpInside];
        [_addBtn setImage:[UIImage imageNamed:@"vm_detail_cutout_add"] forState:UIControlStateNormal];
        [_addBtn setImageEdgeInsets:UIEdgeInsetsMake(-10, 0, 0, 0)];
        _addBtn.hidden = YES;
    }
    return _addBtn;
}

- (UILabel *)addLab{
    if (!_addLab) {
        _addLab = [UILabel new];
        _addLab.textAlignment = NSTextAlignmentCenter;
        _addLab.text = @"添加视频";
        _addLab.font = [UIFont systemFontOfSize:14];
        _addLab.textColor = [UIColor colorWithHexString:@"ffffff"];
        _addLab.hidden = YES;
    }
    return _addLab;
}

//裁剪视频
- (void)clickCropBtn{
    VEVideoEditViewController *VC = [[VEVideoEditViewController alloc]init];
    VC.videoModel = self.videoModel;
    VC.videoType = LMEditVideoTypeSelect;
    VC.ifHiddenCrop = YES;
    [currViewController().navigationController pushViewController:VC animated:YES];
    @weakify(self);
    VC.dismissSelectBlock = ^(VESelectVideoModel * _Nonnull videoModel, NSString * _Nonnull videoPath) {
        @strongify(self);
        LMLog(@"asdfasfadsfadsf=====%@",videoModel);
        LSOVideoAsset *lsoAsset = [[LSOVideoAsset alloc] initWithPath:videoPath];
        self.videoModel.showImage = lsoAsset.firstFrameImage;
        if (!lsoAsset.firstFrameImage) {
            self.videoModel.showImage = [VETool thumbnailImageRequestWithVideoUrl:[NSURL URLWithString:[NSString stringWithFormat:@"file://%@",videoPath]] andTimeDur:0];
        }
        self.videoModel.second = lsoAsset.duration;
        self.videoModel.videoUrl = [NSString stringWithFormat:@"file://%@",videoPath];
        self.videoModel.videoAss = lsoAsset;
        self.videoModel = self.videoModel;
        if (self.clickCropBlock) {
            self.clickCropBlock(self.index,self.videoModel);
        }
    };
}

//替换视频
- (void)clickChangeBtn{
    VESelectVideoController *vc = [[VESelectVideoController alloc]init];
    vc.videoType = LMEditVideoTypeSelectNo;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [currViewController() presentViewController:nav animated:YES completion:nil];
    @weakify(self);
    vc.dismissSelectBlock = ^(VESelectVideoModel * _Nonnull videoModel, NSString * _Nonnull videoPath) {
        @strongify(self);
        [self changeShowStyleIfPlay:YES];
        self.videoModel = videoModel;
        if (self.clickChangeBlock) {
            self.clickChangeBlock(self.index,self.videoModel);
        }
    };
}

- (void)setVideoModel:(VESelectVideoModel *)videoModel{
    _videoModel = videoModel;
    CGRect newRect = [self createPlayViewSize];
    self.playScrollView.contentSize = CGSizeMake(newRect.size.width, newRect.size.height);

    if (self.avPlayer) {
        [self stopPlayer];
    }
    NSURL *mediaURL = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@",self.videoModel.videoUrl]];
    self.playItem = [AVPlayerItem playerItemWithURL:mediaURL];
    self.avPlayer = [AVPlayer playerWithPlayerItem:self.playItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    self.playerLayer.frame = newRect;
    self.playerLayer.backgroundColor = [UIColor grayColor].CGColor;
    [self.playScrollView.layer addSublayer:self.playerLayer];
    [self.avPlayer pause];
    //监听播放进度
    @weakify(self);
     [self.avPlayer addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, NSEC_PER_SEC) queue:NULL usingBlock:^(CMTime time) {
         @strongify(self);
         //进度 当前时间/总时间
         CGFloat progress = CMTimeGetSeconds(self.avPlayer.currentItem.currentTime) / CMTimeGetSeconds(self.avPlayer.currentItem.duration);
         //在这里截取播放进度并处理
         if (progress == 1.0f) {
             LMLog(@"======currentTime==%.2f,=========%.2f ====%zd========%.2f",CMTimeGetSeconds(self.avPlayer.currentItem.currentTime),CMTimeGetSeconds(self.avPlayer.currentItem.duration),self.index,self.videoModel.videoAss.duration);

             //播放百分比为1表示已经播放完毕
             if (self.playSucceedBlock) {
                 self.playSucceedBlock(self.index);
             }
         }
     }];
}

//改变播放器的大小
- (void)changePlayViewSize{
    CGRect newRect = [self createPlayViewSize];
    self.playerLayer.frame = newRect;
    self.playScrollView.contentSize = CGSizeMake(newRect.size.width, newRect.size.height);
}

//计算播放view的大小
- (CGRect)createPlayViewSize{
    if (self.videoModel) {
        CGFloat bili = self.videoModel.videoSize.width/self.videoModel.videoSize.height;
        CGFloat w = 0;
        CGFloat h = 0;
        //    CGFloat top = 0;
        if (self.width >= self.height) {
            w = self.width;
            h = w/bili;
    
        }else{
            h = self.height;
            w = h*bili;
            if (w < self.width) {
                w = self.width;
                h = w/bili;
            }
        }
        return CGRectMake(0, 0, w, h);
    }
    return CGRectZero;
}

//停止，销毁播放器
- (void)stopPlayer{
    [self.avPlayer pause];
    [self.avPlayer.currentItem cancelPendingSeeks];
    [self.avPlayer.currentItem.asset cancelLoading];
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer=nil;
    self.avPlayer = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

// 改变展示样式
// @param ifPlay 是否有视频
- (void)changeShowStyleIfPlay:(BOOL)ifPlay{
    if (ifPlay) {
        self.addBtn.hidden = YES;
        self.addLab.hidden = YES;
        self.changeBtn.hidden = NO;
        self.changeView.hidden = NO;
        self.cropBtn.hidden = NO;
        self.cropView.hidden = NO;
    }else{
        self.addBtn.hidden = NO;
        self.addLab.hidden = NO;
        self.changeBtn.hidden = YES;
        self.changeView.hidden = YES;
        self.cropBtn.hidden = YES;
        self.cropView.hidden = YES;
    }
}
@end

@implementation VEMoreLatticeVideoMainView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {    }
    return self;
}

- (void)setModel:(VEMoreGridVideoModel *)model{
    _model = model;
    [self.subViewArr removeAllObjects];
    self.subViewArr = [NSMutableArray new];
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[LMMoreLatticeVideoSubView class]]) {
            LMMoreLatticeVideoSubView *videoV = (LMMoreLatticeVideoSubView *)subView;
            [videoV stopPlayer];
        }
        [subView removeFromSuperview];
    }
    
    if (model.selectId.intValue == 0) {         //上下分屏两个
        [self createTwoHorizontal];
    }else if (model.selectId.intValue == 1){    //左右分屏两个
        [self createTwoVertical];
    }else if (model.selectId.intValue == 2){    //上下分屏三个
        [self createThreeHorizontal];
    }else if (model.selectId.intValue == 3){    //分屏四个
        [self createForeHorizontal];
    }
}

//上下分屏两个
- (void)createTwoHorizontal{
    int maxNum = 2;
    CGFloat h = self.height/2;
    for (int x = 0; x < maxNum; x++) {
        [self createAllSubViewWithFrame:CGRectMake(0, x*h, self.width, h) index:x];
    }
}

//左右分屏两个
- (void)createTwoVertical{
    int maxNum = 2;
    CGFloat w = self.width/2;
    for (int x = 0; x < maxNum; x++) {
        [self createAllSubViewWithFrame:CGRectMake(x*w, 0, w, self.height) index:x];
    }
}

//上下分屏三个
- (void)createThreeHorizontal{
    int maxNum = 3;
    CGFloat h = self.height/3;
    for (int x = 0; x < maxNum; x++) {
        [self createAllSubViewWithFrame:CGRectMake(0, x*h, self.width, h) index:x];
    }
}

//分屏四个
- (void)createForeHorizontal{
    int maxNum = 4;
    CGFloat h = self.height/2;
    CGFloat w = self.width/2;

    for (int x = 0; x < maxNum; x++) {
        NSInteger yushu = x%2;
        NSInteger chuShu = x/2;
        [self createAllSubViewWithFrame:CGRectMake(yushu*w, chuShu*h, w, h) index:x];
    }
}

//创建视频播放的view
- (void)createAllSubViewWithFrame:(CGRect)subFrame index:(NSInteger)x{
    LMMoreLatticeVideoSubView *subV = [[LMMoreLatticeVideoSubView alloc]initWithFrame:subFrame];
    subV.index = x;
    if (self.videoArr.count > x) {
        [subV changeShowStyleIfPlay:YES];
        subV.videoModel = self.videoArr[x];
        if (self.playStyle == 0) {   //同时播放
            [subV.avPlayer play];
        }else{                      //顺序播放
            if (x == 0) {
                [subV.avPlayer play];
            }
        }
    }else{
        [subV changeShowStyleIfPlay:NO];
    }

    @weakify(self);
    //改变，添加视频的回调
    subV.clickChangeBlock = ^(NSInteger selectIndex, VESelectVideoModel * _Nonnull changeModel) {
        @strongify(self);
        if (self.videoArr.count > selectIndex) {
            [self.videoArr replaceObjectAtIndex:selectIndex withObject:changeModel];
        }else{
            [self.videoArr addObject:changeModel];
        }
        if (self.changeVideoArrBlock) {
            self.changeVideoArrBlock(self.videoArr);
        }
        //所有视频从头开始播放
        if (self.playStyle == 0) {
            for (LMMoreLatticeVideoSubView *subV in self.subViewArr) {
                [subV.playItem seekToTime:kCMTimeZero completionHandler:nil];
                [subV.avPlayer play];
            }
        }else{
            for (LMMoreLatticeVideoSubView *subV in self.subViewArr) {
                [subV.playItem seekToTime:kCMTimeZero completionHandler:nil];
                [subV.avPlayer pause];
            }
            LMMoreLatticeVideoSubView *subV = self.subViewArr[0];
            [subV.avPlayer play];
        }

    };
    
    //裁剪视频的回调
    subV.clickCropBlock = ^(NSInteger selectIndex, VESelectVideoModel * _Nonnull changeModel) {
        @strongify(self);
        if (self.videoArr.count > selectIndex) {
            [self.videoArr replaceObjectAtIndex:selectIndex withObject:changeModel];
        }
        if (self.changeVideoArrBlock) {
            self.changeVideoArrBlock(self.videoArr);
        }
        //所有视频从头开始播放
        if (self.playStyle == 0) {
            for (LMMoreLatticeVideoSubView *subV in self.subViewArr) {
                [subV.playItem seekToTime:kCMTimeZero completionHandler:nil];
                [subV.avPlayer play];
            }
        }else{
            for (LMMoreLatticeVideoSubView *subV in self.subViewArr) {
                [subV.playItem seekToTime:kCMTimeZero completionHandler:nil];
                [subV.avPlayer pause];
            }
            LMMoreLatticeVideoSubView *subV = self.subViewArr[0];
            [subV.avPlayer play];
        }
    };
    
    //播放完成回调
    subV.playSucceedBlock = ^(NSInteger selectIndex) {
        @strongify(self);
        if (self.playStyle == 0) {      //同时播放
            if (self.subViewArr.count > selectIndex) {
                LMMoreLatticeVideoSubView *subStopV = self.subViewArr[selectIndex];
                //获取所有视频中最长的那个
                NSMutableArray *arr = [NSMutableArray new];
                for (LMMoreLatticeVideoSubView *subV in self.subViewArr) {
                    NSNumber *num = [NSNumber numberWithFloat:subV.videoModel.videoAss.duration];
                    [arr addObject:num];
                }
                float maxValue = [[arr valueForKeyPath:@"@max.floatValue"] floatValue];
                NSString *maxValueStr = [NSString stringWithFormat:@"%.2f",maxValue];
                NSString *videoValueStr = [NSString stringWithFormat:@"%.2f",subStopV.videoModel.videoAss.duration];

                //判断这个视频是不是所有视频中时长最长的那个
                if ([videoValueStr isEqualToString:maxValueStr]) {
                    if (self.playSucceedBlock) {
                        self.playSucceedBlock();
                    }
                    //如果最长的那个播放完成，则全部开始重新播放
                    for (LMMoreLatticeVideoSubView *subV in self.subViewArr) {
                        [subV.playItem seekToTime:kCMTimeZero completionHandler:nil];
                        [subV.avPlayer play];
                    }
                }
            }
        }else if (self.playStyle == 1){     //顺序播放
            self.playIndex = selectIndex+1;
            for (LMMoreLatticeVideoSubView *subV in self.subViewArr) {//其他的先全部暂停
                [subV.avPlayer pause];
            }
            if (self.subViewArr.count > selectIndex+1) {
                LMMoreLatticeVideoSubView *nextV = self.subViewArr[selectIndex+1];
                [nextV.playItem seekToTime:kCMTimeZero completionHandler:nil];
                [nextV.avPlayer play];
            }else{
                LMMoreLatticeVideoSubView *subV = self.subViewArr[0];
                [subV.playItem seekToTime:kCMTimeZero completionHandler:nil];
                [subV.avPlayer play];
                if (self.playSucceedBlock) {
                    self.playSucceedBlock();
                }
            }
        }
    };
    [self addSubview:subV];
    [self.subViewArr addObject:subV];
}

/// 改变播放方式
/// @param playStyle 0同时播放 1顺序播放
- (void)changePlayStyle:(NSInteger)playStyle andVideoArr:(NSMutableArray *)videoArr{
    self.playStyle = playStyle;
    self.videoArr = videoArr;
    for (int x = 0; x < self.subViewArr.count; x++) {
        LMMoreLatticeVideoSubView *subV = self.subViewArr[x];
        subV.index = x;
        if (videoArr.count > x) {
            subV.videoModel = videoArr[x];
        }
        if (playStyle == 0) {
            [subV.playItem seekToTime:kCMTimeZero completionHandler:nil];
            [subV.avPlayer play];
        }else{
            self.playIndex = 0;
            if (x == 0) {
                [subV.playItem seekToTime:kCMTimeZero completionHandler:nil];
                [subV.avPlayer play];
            }
        }
    }
}

//改变布局大小
- (void)changeAllSubViewFrame{
    if (self.model.selectId.intValue == 0) {         //上下分屏两个
        for (UIView *subView in self.subviews) {
            if ([subView isKindOfClass:[LMMoreLatticeVideoSubView class]]) {
                LMMoreLatticeVideoSubView *videoView = (LMMoreLatticeVideoSubView *)subView;
                videoView.frame = CGRectMake(subView.frame.origin.x, videoView.index*(self.height/2), self.width, self.height/2);
                [videoView changePlayViewSize];
            }
        }
    }else if (self.model.selectId.intValue == 1){    //左右分屏两个
        for (UIView *subView in self.subviews) {
            if ([subView isKindOfClass:[LMMoreLatticeVideoSubView class]]) {
                LMMoreLatticeVideoSubView *videoView = (LMMoreLatticeVideoSubView *)subView;
                videoView.frame = CGRectMake(videoView.index*(self.width/2), subView.frame.origin.y, self.width/2, self.height);
                [videoView changePlayViewSize];
            }
        }
    }else if (self.model.selectId.intValue == 2){    //上下分屏三个
        for (UIView *subView in self.subviews) {
            if ([subView isKindOfClass:[LMMoreLatticeVideoSubView class]]) {
                LMMoreLatticeVideoSubView *videoView = (LMMoreLatticeVideoSubView *)subView;
                videoView.frame = CGRectMake(subView.frame.origin.x, videoView.index*(self.height/3), self.width, self.height/3);
                [videoView changePlayViewSize];
            }
        }
    }else if (self.model.selectId.intValue == 3){    //四个
        for (UIView *subView in self.subviews) {
            if ([subView isKindOfClass:[LMMoreLatticeVideoSubView class]]) {
                LMMoreLatticeVideoSubView *videoView = (LMMoreLatticeVideoSubView *)subView;
                NSInteger yushu = videoView.index%2;
                NSInteger chuShu = videoView.index/2;
                videoView.frame = CGRectMake(yushu*(self.width/2), chuShu*(self.height/2), self.width/2, self.height/2);
                [videoView changePlayViewSize];
            }
        }
    }
}

- (void)stopAllVideo{
    if (self.playStyle == 0) {
        for (LMMoreLatticeVideoSubView *subV in self.subviews) {
            [subV.avPlayer pause];
        }
    }else{
        if (self.subViewArr.count > self.playIndex) {
            LMMoreLatticeVideoSubView *subV = self.subViewArr[self.playIndex];
            [subV.avPlayer pause];
        }
    }
}

- (void)playAllVideo{
    if (self.playStyle == 0) {
        for (LMMoreLatticeVideoSubView *subV in self.subviews) {
            [subV.avPlayer play];
        }
    }else{
        if (self.subViewArr.count > self.playIndex) {
            LMMoreLatticeVideoSubView *subV = self.subViewArr[self.playIndex];
            [subV.avPlayer play];
        }
    }
}

//改变音量
- (void)changeAllVolume:(CGFloat)volume{
    for (LMMoreLatticeVideoSubView *subV in self.subviews) {
        subV.avPlayer.volume = volume;
    }
}

//释放所有播放器
- (void)releaseAllPlayer{
    for (LMMoreLatticeVideoSubView *subV in self.subviews) {
        [subV stopPlayer];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
