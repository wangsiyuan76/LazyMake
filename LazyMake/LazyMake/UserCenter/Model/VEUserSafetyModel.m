//
//  VEUserSafetyModel.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/15.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEUserSafetyModel.h"

@implementation VEUserSafetyModel

- (void)setContentStr:(NSString *)contentStr{
    _contentStr = contentStr;
    
    CGFloat textH = [VETool getTextHeightWithStr:contentStr withWidth:kScreenWidth - 30  - 20 withLineSpacing:4 withFont:15];
    self.cellH = textH + 50;
}
@end
