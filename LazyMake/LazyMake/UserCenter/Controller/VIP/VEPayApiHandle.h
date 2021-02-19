//
//  VEPayApiHandle.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/27.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEPayApiHandle : NSObject<SKProductsRequestDelegate,SKPaymentTransactionObserver>

+ (instancetype)sharedHPPHandle;

@property (assign, nonatomic) BOOL isShowPassword;           //是否添加自动续订的password
@property (strong, nonatomic) NSString *orderNum;

- (void)buyAppProduct:(NSString *)productId orderNum:(NSString *)oerderNum;

//apple内购支付订单补交
- (void)doIAPOrdercomplementCheck;

@property (strong, nonatomic) NSString *payProductId;


@end

NS_ASSUME_NONNULL_END
