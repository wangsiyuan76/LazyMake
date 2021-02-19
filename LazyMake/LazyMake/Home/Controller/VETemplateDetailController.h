//
//  VETemplateDetailController.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/8.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VETemplateDetailController : UIViewController

@property (strong, nonatomic) NSMutableArray *listData;         //全部数据的数组
@property (assign, nonatomic) NSInteger selectIndex;            //当前展示的数据
@property (assign, nonatomic) NSInteger page;                   //分页
@property (assign, nonatomic) BOOL hasMore;                     //是否还能加载更多
@property (strong, nonatomic) NSString *loadUrl;                //加载更多数据的请求地址
@property (strong, nonatomic) NSDictionary *parDic;             //加载更多数据的参数（如首页的分类id，搜索页时的关键字 等）

- (void)setAllParWithArr:(NSArray *)arr selectIndex:(NSInteger)selectIndex page:(NSInteger)page hasMore:(BOOL)hasMore laodUrl:(NSString *)loadUrl otherDic:(NSDictionary *)parDic;

@end

NS_ASSUME_NONNULL_END
