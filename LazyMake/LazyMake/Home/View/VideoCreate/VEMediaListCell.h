//
//  VEMediaListCell.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/21.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

static NSString *VEMediaListCellStr = @"VEMediaListCell";

NS_ASSUME_NONNULL_BEGIN

@interface LMMediaModel : NSObject

@property (strong, nonatomic) UIImage *coverImage;
@property (strong, nonatomic) NSString *nameStr;        //歌曲名
@property (strong, nonatomic) NSString *artistStr;      //作者名
@property (strong, nonatomic) NSString *url;            //地址
@property (assign, nonatomic) NSInteger timeLong;  //时长
@property (strong, nonatomic) MPMediaItem *mediaItem;   
@property (strong, nonatomic) NSString *timeStr;
@property (assign, nonatomic) BOOL isPlay;
@property (assign, nonatomic) BOOL isAddFile;       //是否需要添加file://
/**
 * 多媒体文件中的音频总时长
 */
@property(nonatomic,assign) double aDuration;
@end

@interface VEMediaListCell : UITableViewCell

@property (copy, nonatomic) void (^playBtnBlock)(NSInteger index);
@property (copy, nonatomic) void (^choseBtnBlock)(NSInteger index);

@property (strong, nonatomic) LMMediaModel *model;
@property (assign, nonatomic) NSInteger index;

+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
