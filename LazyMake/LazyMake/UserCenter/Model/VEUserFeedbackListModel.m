//
//  VEUserFeedbackListModel.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/8.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEUserFeedbackListModel.h"

@implementation VEUserFeedbackListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"backID" : @"id",
             @"isReply" : @"is_reply",
             @"content" : @"content",
             @"replyContent" : @"reply_content",
             @"replyTime" : @"reply_time",
             };
}


- (void)setContent:(NSString *)content{
    _content = content;
    if (content.length > SHRINK_NUMBER) {
        NSString *subStr = [content substringWithRange:NSMakeRange(0, SHRINK_NUMBER)];
        self.height = [VETool getTextHeightWithStr:subStr withWidth:kScreenWidth - 110 withLineSpacing:self.lineSep withFont:FONT_SIZE] + 52;
        self.openHeight = [VETool getTextHeightWithStr:content withWidth:kScreenWidth - 110 withLineSpacing:self.lineSep withFont:FONT_SIZE] + 52;
    }else{
        self.height = [VETool getTextHeightWithStr:content withWidth:kScreenWidth - 110 withLineSpacing:self.lineSep withFont:FONT_SIZE] + 52;
        self.openHeight = self.height;
    }
}

- (void)setReplyContent:(NSString *)replyContent{
    _replyContent = replyContent;
    if ([replyContent isNotBlank]) {
        self.replayHeight = [VETool getTextHeightWithStr:replyContent withWidth:kScreenWidth - 76 withLineSpacing:self.lineSep withFont:FONT_SIZE] + 56;
    }else{
        self.replayHeight = CGFLOAT_MIN;
    }
}

- (NSInteger)lineSep{
    return 4;
}

@end
