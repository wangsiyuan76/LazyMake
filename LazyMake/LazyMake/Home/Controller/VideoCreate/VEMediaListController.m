//
//  VEMediaListController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/21.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEMediaListController.h"
#import <AVFoundation/AVFoundation.h>
#import <LanSongFFmpegFramework/LSOMediaInfo.h>
#import "VENoneView.h"
#import "VEAudioCropViewController.h"
#import "VEAudioCropView.h"
#import <LanSongFFmpegFramework/LanSongFFmpeg.h>

#define BTN_ALPHA 0.7f

@interface VEMediaListController () <UITableViewDelegate, UITableViewDataSource,AVAudioPlayerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *listArr;
@property (strong, nonatomic) AVAudioPlayer *player;
@property (strong, nonatomic) VENoneView *noneView;

//当前页面裁剪音乐相关
@property (strong, nonatomic) VEAudioCropView *audioCropView;           //配乐裁剪view
@property (assign, nonatomic) BOOL showSelectF;                         //是否弹出
@property (strong, nonatomic) UIButton *shadowBtn;                      //背景遮罩btn
@property (strong, nonatomic) UIButton *shadowNavBtn;                   //背景遮罩btn
@property (nonatomic, assign) double endTime;
@property (assign, nonatomic) double audioDur;                          //音频时长
@property (nonatomic, strong) NSString *cropUrl;                        //音频裁剪后的地址
@property (strong, nonatomic) NSString *audioPath;                      //音频地址
@property (strong, nonatomic) NSString *temporaryAudioPath;              //临时音频地址
@property (strong, nonatomic) LMMediaModel *selectModel;                //裁剪时选中的音频

@end

@implementation VEMediaListController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.player stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_BLACK_COLOR;
    self.title = @"本地音乐";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.noneView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self showNoneView];
    if (self.ifShowCropView) {
        [self.navigationController.navigationBar addSubview:self.shadowNavBtn];
        [self.view addSubview:self.shadowBtn];
        [self.view addSubview:self.audioCropView];
    }

    if (MPMediaLibrary.authorizationStatus == MPMediaLibraryAuthorizationStatusAuthorized) {
         self.listArr = [NSMutableArray arrayWithArray:[self findArtistList]];
         [self loadData];
     }else if (MPMediaLibrary.authorizationStatus == MPMediaLibraryAuthorizationStatusDenied || MPMediaLibrary.authorizationStatus == MPMediaLibraryAuthorizationStatusRestricted){
         [self showAlert];
         return;
     }else{
         [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
             if (status == MPMediaLibraryAuthorizationStatusAuthorized){//允许
                 dispatch_async(dispatch_get_main_queue(), ^{
                     self.listArr = [NSMutableArray arrayWithArray:[self findArtistList]];
                     [self loadData];
                 });
             }else{//拒绝
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [MBProgressHUD showError:@"用户已拒绝"];
                     self.listArr = [[NSMutableArray alloc]init];
                     [self loadData];
                 });

             }
         }];
     }
    // Do any additional setup after loading the view.
}

- (UIButton *)shadowNavBtn{
    if (!_shadowNavBtn) {
        _shadowNavBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, -Height_StatusBar, kScreenWidth, Height_NavBar)];
        _shadowNavBtn.backgroundColor = [UIColor blackColor];
        _shadowNavBtn.alpha = 0.f;
        [_shadowNavBtn addTarget:self action:@selector(clickShadowBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shadowNavBtn;
}

- (UIButton *)shadowBtn{
    if (!_shadowBtn) {
        _shadowBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _shadowBtn.backgroundColor = [UIColor blackColor];
        _shadowBtn.alpha = 0.f;
        [_shadowBtn addTarget:self action:@selector(clickShadowBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shadowBtn;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[VEMediaListCell class] forCellReuseIdentifier:VEMediaListCellStr];
    }
    return _tableView;
}

//音乐裁剪的view
- (VEAudioCropView *)audioCropView{
    if (!_audioCropView) {
        CGFloat top = kScreenHeight + 20;
        _audioCropView = [[VEAudioCropView alloc]initWithFrame:CGRectMake(0,top , kScreenWidth, [VEAudioCropView viewHeight])];
        _audioCropView.backgroundColor = self.view.backgroundColor;
        _audioCropView.titleLab.font = [UIFont systemFontOfSize:16];
        _audioCropView.titleLab.text = [NSString stringWithFormat:@"建议裁剪时长大于%zds",self.minS];
        @weakify(self);
        _audioCropView.changeSelectTimeBlock = ^(NSInteger beginTime, NSInteger endTime, NSInteger continuedTime, BOOL ifLeft) {
            @strongify(self);
            if ((endTime - beginTime) > self.minS) {
                self.audioCropView.titleLab.text = [NSString stringWithFormat:@"建议裁剪时长小于%zds",self.maxS];
            }else{
                self.audioCropView.titleLab.text = [NSString stringWithFormat:@"建议裁剪时长大于%zds",self.minS];
            }
            if (!ifLeft) {
                self.endTime = endTime;
            }
            //防止音乐时长有小数，造成裁剪不全的情况
            if (self.endTime > self.audioDur) {
                self.endTime = self.audioDur;
            }else{
                int dur = self.audioDur;
                if (self.endTime == dur) {
                    self.endTime = self.audioDur;
                }
            }
            NSString *str =  [LSOVideoEditor executeAudioCutOut:self.audioPath startS:beginTime duration:self.endTime-beginTime];
            self.temporaryAudioPath = str;
            [self playAudioWithUrl:str];
        };
        
        _audioCropView.clickDoneBtnBlock = ^(BOOL ifSucceed) {
            @strongify(self);
            self.showSelectF = NO;
            [self cropAudioSizeView];
            [self.player stop];
            if (ifSucceed) {
                self.cropUrl = self.temporaryAudioPath;
                if (self.cropAudioBlock) {
                    [self.navigationController popViewControllerAnimated:YES];
                    self.cropAudioBlock(self.cropUrl, self.selectModel.isAddFile, self.selectModel.nameStr);
                }
            }
        };
    }
    return _audioCropView;
}


- (void)showAlert{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"请在“设置”中为APP打开权限"
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                        handler:^(UIAlertAction * action) {
                        self.listArr = [[NSMutableArray alloc]init];
                        [self loadData];
    }];
    UIAlertAction* nanAct = [UIAlertAction actionWithTitle:@"去打开" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                                            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {}];
                                                             }];

    [alert addAction:nanAct];
    [alert addAction:cancelAction];
    [currViewController() presentViewController:alert animated:YES completion:nil];
}

- (void)loadData{
    //获取本app从视频提取的音乐数据
    [VETool createEmoticonFolderBlock:^(BOOL ifSucceed, NSString * _Nonnull fileUrl, NSError * _Nonnull error) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSArray *fileList= [[NSArray alloc] init];
            fileList= [fileManager contentsOfDirectoryAtPath:fileUrl error:&error];
            if (fileList.count > 0) {
                NSInteger y = 0;
                for (int x = 0; x < fileList.count; x++) {
                    NSString *file = fileList[x];
                    NSString *path = [fileUrl stringByAppendingPathComponent:file];
                    LMLog(@"======%@",[NSData dataWithContentsOfFile:path]);
                    LSOMediaInfo *medf = [[LSOMediaInfo alloc]initWithPath:path];
                    [medf prepare];
                    LMLog(@"==medf===%.2f",medf.aDuration);

                    LMMediaModel *model = [LMMediaModel new];
                    model.isAddFile = YES;
                    model.timeLong = medf.aDuration;
                    model.nameStr = file;
                    model.aDuration = medf.aDuration;
                    //防止有中文导致无法播放，使用urf8编码
                    model.url =  [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                    NSInteger adInt = (NSInteger)medf.aDuration;
                    model.timeStr = [NSString stringWithFormat:@"%.2zd:%.2zd",adInt/60,adInt%60];
                    if (medf.aDuration > 3) {
                        [self.listArr insertObject:model atIndex:0];
                    }
                    y++;
                }
                if (y == fileList.count-1) {
                    [self.tableView reloadData];
                }
            }
        }];
    [self showNoneView];
    [self.tableView reloadData];
}

-(NSArray*) findArtistList {
        NSMutableArray *artistList = [[NSMutableArray alloc]init];
        MPMediaQuery *listQuery = [MPMediaQuery songsQuery];//播放列表
      // 读取条件
//        MPMediaPropertyPredicate *albumNamePredicate = [MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithInt:MPMediaTypeMusic ] forProperty: MPMediaItemPropertyMediaType];
//        [listQuery addFilterPredicate:albumNamePredicate];
        NSArray *playlist = [listQuery collections];//播放列表数组
        for (MPMediaPlaylist * list in playlist) {
            NSArray *songs = [list items];//歌曲数组
            for (MPMediaItem *song in songs) {
                //歌曲名
                NSString *title =[song valueForProperty:MPMediaItemPropertyTitle];
                //封面
                MPMediaItemArtwork  *imageArt =[song valueForProperty:MPMediaItemPropertyArtwork];
                UIImage *artworkImage = [imageArt imageWithSize:CGSizeMake(100, 100)];
                //歌手名
                NSString *artist =[[song valueForProperty:MPMediaItemPropertyArtist] uppercaseString];
                //链接    注意: 如果后面不调用 absoluteString ,播放会崩溃
                NSString *url = [[song valueForProperty: MPMediaItemPropertyAssetURL] absoluteString];
                LMLog(@"song.assetURL=====%@",song.assetURL);
                //时长
                NSNumber *timeNum = [song valueForProperty: MPMediaItemPropertyPlaybackDuration];
                
                NSInteger timeInte = timeNum.integerValue;
                if (timeInte > 3) {
                    LMMediaModel *model = [LMMediaModel new];
                    model.isAddFile = NO;
                    model.aDuration = timeNum.doubleValue;
                    model.mediaItem = song;
                    model.timeLong = timeInte;
                    model.nameStr = title;
                    model.coverImage = artworkImage;
                    model.artistStr = artist;
                    model.url = url;
                    model.timeStr = [NSString stringWithFormat:@"%.2zd:%.2zd",timeInte/60,timeInte%60];
                    [artistList addObject: model];
                }
            }
        }

    return artistList;
}

//提取音乐库中的音乐到本地
- (void)convertToM4A:(MPMediaItem *)song lmSubModel:(LMMediaModel *)lmMediaModel{
    NSURL *url = [song valueForProperty:MPMediaItemPropertyAssetURL];
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [dirs objectAtIndex:0];
    NSLog(@"%@", documentsDirectoryPath);
    NSLog (@"compatible presets for songAsset: %@",[AVAssetExportSession exportPresetsCompatibleWithAsset:songAsset]);
    
    NSArray *ar = [AVAssetExportSession exportPresetsCompatibleWithAsset: songAsset];
    NSLog(@"%@", ar);
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc]
                                      initWithAsset: songAsset
                                      presetName: AVAssetExportPresetAppleM4A];
    
    NSLog (@"created exporter. supportedFileTypes: %@", exporter.supportedFileTypes);
    
    exporter.outputFileType = @"com.apple.m4a-audio";
    
    NSString *exportFile = [documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a",[song valueForProperty:MPMediaItemPropertyTitle]]];
    
    NSError *error1;
    
    if([fileManager fileExistsAtPath:exportFile])
    {
        [fileManager removeItemAtPath:exportFile error:&error1];
    }
    
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager]enumeratorAtPath:documentsDirectoryPath];
    for (NSString *fileName in enumerator)
    {
        NSLog(@"------%@", fileName);
    }
    
    NSURL* exportURL = [NSURL fileURLWithPath:exportFile];
    exporter.outputURL = exportURL;
    
    // do the export
    [exporter exportAsynchronouslyWithCompletionHandler:^{

//         double size = (long)data1.length / 1024. / 1024.;
//         NSString *title = song.title;
//         if ([[title stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
//             title = @"无名称音频";
//         }
//         title = [title stringByAppendingString:[NSString stringWithFormat:@"       %.2fM", size]];
//         dispatch_async(dispatch_get_main_queue(), ^{
//
////             self.audiolb.text = title;
//         });
//         NSLog(@"==================data1:%@",data1);
         
        AVAssetExportSessionStatus exportStatus = exporter.status;
        if (exportStatus == AVAssetExportSessionStatusCompleted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                lmMediaModel.isAddFile = YES;
                lmMediaModel.url = [NSString stringWithFormat:@"%@",exportFile];
                [self pushVideoCropVCWithUrl:[NSString stringWithFormat:@"%@",exportFile] subModel:lmMediaModel];
            }) ;
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"提取失败，请重试"];
            });
        }
     }];
}

- (VENoneView *)noneView{
    if (!_noneView) {
        _noneView = [[VENoneView alloc]initWithFrame:CGRectMake(0, Height_NavBar, kScreenWidth, kScreenHeight-Height_NavBar)];
        _noneView.backgroundColor = self.view.backgroundColor;
        [_noneView setLogoImage:@"vm_loading_empty" andTitle:@"暂时没有音乐"];
        _noneView.hidden = YES;
    }
    return _noneView;
}

- (void)showNoneView{
    if (self.listArr.count > 0) {
        self.noneView.hidden = YES;
        self.tableView.hidden = NO;
    }else{
        self.noneView.hidden = NO;
        self.tableView.hidden = YES;
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [VEMediaListCell cellHeight];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VEMediaListCell *cell = [tableView dequeueReusableCellWithIdentifier:VEMediaListCellStr];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.index = indexPath.row;
    if (!cell) {
        cell = [[VEMediaListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VEMediaListCellStr];
    }
    if (self.listArr.count > indexPath.row) {
        cell.model = self.listArr[indexPath.row];
    }
    
    @weakify(self);
    cell.playBtnBlock = ^(NSInteger index) {
        @strongify(self);
        [self playVideoWithIndex:index];
    };
    cell.choseBtnBlock = ^(NSInteger index) {
        @strongify(self);
        if (self.listArr.count > index) {
            LMMediaModel *subModel = self.listArr[index];
//            if (self.selectMusicBlock) {
//                self.selectMusicBlock(self.listArr[index]);
//                [self.navigationController popViewControllerAnimated:YES];
//            }
            if (subModel.isAddFile) {
                [self pushVideoCropVCWithUrl:@"" subModel:subModel];
            }else{
                [MBProgressHUD showMessage:@"音乐提取中"];
                [self convertToM4A:subModel.mediaItem lmSubModel:subModel];
            }
        }
    };
    return cell;
}

- (void)pushVideoCropVCWithUrl:(NSString *)url subModel:(LMMediaModel *)subModel{
    if (self.ifShowCropView) {
        [MBProgressHUD showMessage:@"音乐提取中"];
        self.showSelectF = YES;
        self.audioCropView.allTime = subModel.aDuration;
        self.audioDur = subModel.aDuration;
        self.endTime = subModel.aDuration;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *str =  [LSOVideoEditor executeAudioCutOut:url.length>0?url:subModel.url startS:0 duration:subModel.aDuration];
            self.audioPath = str;
            self.cropUrl = str;
            self.temporaryAudioPath = str;
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                [self cropAudioSizeView];
                self.selectModel = subModel;
                [self playAudioWithUrl:str];
            });
        });
        return;
    }
    VEAudioCropViewController *cropVC = [[VEAudioCropViewController alloc]init];
    cropVC.videoPath = self.videoUrl;
    cropVC.videoFrame = self.videoFrame;
    cropVC.audioPath = url.length>0?url:subModel.url;
    cropVC.audioDur = subModel.aDuration;
    cropVC.ifAddF = subModel.isAddFile;
    [self.navigationController pushViewController:cropVC animated:YES];
    
    cropVC.cropAudioBlock = ^(NSString * _Nonnull audioPath, BOOL ifAddFile) {
        if (self.cropAudioBlock) {
            self.cropAudioBlock(audioPath,ifAddFile,subModel.nameStr);
        }
    };
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    cell.backgroundColor = self.view.backgroundColor;
}

- (void)playVideoWithIndex:(NSInteger)index{
    if (self.listArr.count > index) {
        LMMediaModel *model = self.listArr[index];
        //取消其他cell的播放状态
        for (LMMediaModel *subModel in self.listArr) {
            if (![subModel.url isEqualToString:model.url]) {
                subModel.isPlay = NO;
            }
        }
        model.isPlay = !model.isPlay;
        if (model.isPlay) {
            [self.player stop];
            self.player = nil;
            LMLog(@"=====model.url======%@",model.url);
            self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:model.url] error:nil];
            // 设置循环次数，-1为一直循环
            self.player.numberOfLoops = -1;
            // 准备播放
            [self.player prepareToPlay];
            // 设置播放音量
//            self.player.volume = 50;
            // 当前播放位置，即从currentTime处开始播放，相关于android里面的seekTo方法
//            player.currentTime = 15;
            // 设置代理
            self.player.delegate = self;
            [self.player play];
        }else{
            [self.player stop];
        }
    }
    [self.tableView reloadData];
}

- (void)playAudioWithUrl:(NSString *)audioUrl{
    [self.player stop];
    self.player = nil;
    if (![audioUrl containsString:@"file://"]) {
        audioUrl = [NSString stringWithFormat:@"file://%@",audioUrl];
    }
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:audioUrl] error:nil];
    self.player.numberOfLoops = -1;
    self.player.volume = 1;
    self.player.delegate = self;

    [self.player prepareToPlay];
    [self.player play];
    [MBProgressHUD hideHUD];
}

/* 音频播放器完成播放：成功：当声音播放完毕时调用。如果播放器因中断而停止，则不调用此方法。 */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
}


/* 如果在解码时发生错误，将报告给委托 */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error{}

- (void)dealloc{
    [self.player stop];
    self.player = nil;
}

- (void)clickShadowBtn{}

//裁剪配乐的view
- (void)cropAudioSizeView{
    if (self.showSelectF) {
        self.audioCropView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.shadowBtn.alpha = BTN_ALPHA;
            self.shadowNavBtn.alpha = BTN_ALPHA;
            self.audioCropView.frame = CGRectMake(0, kScreenHeight - Height_SafeAreaBottom-[VEAudioCropView viewHeight], kScreenWidth, [VEAudioCropView viewHeight]+Height_SafeAreaBottom);
        }];
    }else{
        
        [self.player stop];
        [UIView animateWithDuration:0.3 animations:^{
            self.shadowBtn.alpha = 0;
            self.shadowNavBtn.alpha = 0;
            self.audioCropView.frame = CGRectMake(0, kScreenHeight+20, kScreenWidth, [VEAudioCropView viewHeight]+Height_SafeAreaBottom);
        }completion:^(BOOL finished) {
            self.audioCropView.hidden = YES;
            [self.audioCropView removeFromSuperview];
            self.audioCropView = nil;
            [self.view addSubview:self.audioCropView];
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
