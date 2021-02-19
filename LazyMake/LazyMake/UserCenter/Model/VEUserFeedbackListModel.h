//
//  VEUserFeedbackListModel.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/8.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEBaseModel.h"

#define SHRINK_NUMBER 22                        //收起时最大字数限制
#define FONT_SIZE 15

NS_ASSUME_NONNULL_BEGIN

@interface VEUserFeedbackListModel : VEBaseModel

@property (strong, nonatomic) NSString *backID;             //反馈id
@property (strong, nonatomic) NSString *content;            //反馈内容
@property (strong, nonatomic) NSString *time;               //反馈时间
@property (strong, nonatomic) NSString *isReply;            //是否有回复
@property (strong, nonatomic) NSString *replyContent;       //回复内容
@property (strong, nonatomic) NSString *replyTime;          //回复时间

@property (assign, nonatomic) BOOL isOpen;                  //是否展开
@property (assign, nonatomic) CGFloat height;               //回收的高度
@property (assign, nonatomic) CGFloat openHeight;           //展开的高度
@property (assign, nonatomic) CGFloat replayHeight;         //回复的高度
@property (assign, nonatomic) NSInteger lineSep;            //行间距

@end

NS_ASSUME_NONNULL_END
