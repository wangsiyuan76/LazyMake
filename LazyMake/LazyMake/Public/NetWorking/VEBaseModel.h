//
//  VEBaseModel.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/3/31.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEBaseModel : NSObject

@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,assign) BOOL hasMore;              //是否可以加载更多
@property (nonatomic,assign) NSInteger recordCount;

@property (nonnull,strong) NSString *state;
@property (nonnull,strong) NSString *msg;
@property (nonnull,strong) NSArray *resultArr;          //result直接为数组时调用

@property (assign, nonatomic) BOOL isSuccess;
@property (assign, nonatomic) BOOL isLoading;
@property (assign, nonatomic) double loadingSchedule;

@property (strong, nonatomic) NSString *errorMsg;

@end

NS_ASSUME_NONNULL_END
