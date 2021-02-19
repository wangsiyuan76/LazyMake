//
//  VEFilterSelectModel.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/20.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LanSongEditorFramework/LanSongEditor.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEFilterSelectModel : NSObject
@property (strong, nonatomic) NSString *imageStr;
@property (strong, nonatomic) NSString *titleStr;
@property (assign, nonatomic) BOOL ifSelect;
@property LanSongOutput <LanSongInput> *selectedFilter;

+ (NSArray *)createFilterDataArr;

@end

NS_ASSUME_NONNULL_END
