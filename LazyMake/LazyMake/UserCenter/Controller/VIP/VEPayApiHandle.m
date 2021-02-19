//
//  VEPayApiHandle.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/27.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEPayApiHandle.h"
#import "VEUserApi.h"

@implementation VEPayApiHandle
+ (instancetype)sharedHPPHandle{
    static VEPayApiHandle *sharedHPPHandle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHPPHandle = [[VEPayApiHandle alloc] init];
    });
    return sharedHPPHandle;
}

- (void)refreshReceiptData{
    SKReceiptRefreshRequest *request = [[SKReceiptRefreshRequest alloc] init];
    request.delegate = self;
    [request start];
}

- (void)buyAppProduct:(NSString *)productId orderNum:(NSString *)oerderNum{
    self.payProductId = productId;
    [MBProgressHUD showMessage:@"支付中..."];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    NSLog(@"transactions,count:%zd",[SKPaymentQueue defaultQueue].transactions.count);
    if ([SKPaymentQueue canMakePayments]) {
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
        NSArray *arr = [NSArray arrayWithObject:productId];
        self.orderNum = oerderNum;
        NSSet *set = [NSSet setWithArray:arr];
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
        request.delegate = self;
        [request start];
        NSLog(@"允许程序内付费购买");
    }else{
        [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    }
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSArray *myProduct = response.products;
    SKProduct *payProduct;
    if (myProduct.count == 0) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"购买失败"];
        return;
    }
    for(SKProduct *product in myProduct){
        NSLog(@"product info");
        NSLog(@"SKProduct 描述信息%@", [product description]);
        NSLog(@"产品标题 %@" , product.localizedTitle);
        NSLog(@"产品描述信息: %@" , product.localizedDescription);
        NSLog(@"价格: %@" , product.price);
        NSLog(@"Product id: %@" , product.productIdentifier);
        if ([product.productIdentifier isEqualToString:self.payProductId]) {
            payProduct = product;
        }
    }
    if (payProduct) {
        SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:payProduct];
        payment.applicationUsername = [LMUserManager sharedManger].userInfo.userid;  //用于回调用
        NSLog(@"payOrderId:%@",payment.applicationUsername);
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}


//查询失败后的回调
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    //菊花消失
    NSLog(@"请求苹果服务器失败%@",[error localizedDescription]);
}


//沙盒测试环境验证
#define SANDBOX @"https://sandbox.itunes.apple.com/verifyReceipt"
//正式环境验证
#define AppStore @"https://buy.itunes.apple.com/verifyReceipt"
/**
 *  验证购买，避免越狱软件模拟苹果请求达到非法购买问题
 */
-(void)verifyPurchaseWithPaymentTransaction{
    //从沙盒中获取交易凭证并且拼接成请求体数据
    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    NSString *receiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//转化为base64字符串
    [self verifyReceipt:YES data:receiptString];
}

- (void)verifyReceipt:(BOOL)isProduction data:(NSString *)data{
//    NSString *bodyString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", data];//拼接请求数据

    NSString *bodyString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\",\"password\" : \"%@\"}", data,PAY_PASSWORD];
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *urlStr;
    if (isProduction) {
        urlStr = AppStore;
    }else{
        urlStr = SANDBOX;
    }
    //创建请求到苹果官方进行购买验证/Users/xunruiios/Downloads/PayDemo-master/xxx.txt
    NSURL *url=[NSURL URLWithString:urlStr];
    NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:url];
    requestM.HTTPBody = bodyData;
    requestM.HTTPMethod = @"POST";
    //创建连接并发送同步请求
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:requestM returningResponse:nil error:&error];
    if (error) {
        NSLog(@"验证购买过程中发生错误，错误信息：%@",error.localizedDescription);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"发送错误，购买失败"];
        return;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"recepit：%@",dic);
    
    int statusCode = [dic[@"status"] intValue];
    if(statusCode == 0){
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"支付成功"];
    }else{
        if (statusCode == 21007) {
            //需要在sandbox环境测
            [self verifyReceipt:NO data:data];
        }
        else{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"支付失败"];
        }
    }
}


//apple内购支付订单补交
- (void)doIAPOrdercomplementCheck{
    NSArray* transactions = [SKPaymentQueue defaultQueue].transactions;
    for (SKPaymentTransaction *transaction in transactions) {
        [self updatedTransaction:transaction bj:YES];
    }
}

//支付结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
//    for (SKPaymentTransaction *transaction in transactions) {
//        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//    }
    [MBProgressHUD hideHUD];
    [MBProgressHUD showMessage:@"支付中..."];
    NSLog(@"顶顶顶顶所付大多count:%zd",transactions.count);
    for (SKPaymentTransaction *transaction in transactions) {
        LMLog(@"顶顶顶顶所付大多========%zd",transaction.transactionState);
        [self updatedTransaction:transaction bj:NO];
    }
}
        
- (void)updatedTransaction:(SKPaymentTransaction *)transaction bj:(BOOL)bj{
    switch (transaction.transactionState) {
        case SKPaymentTransactionStatePurchased: {
            //当前订单状态为已经购买
            //本地验证改为服务端验证
//            [MBProgressHUD showMessage:@"验证中..."];
//            [self verifyPurchaseWithPaymentTransaction];
            [MBProgressHUD hideHUD];
            [self verifyLoadApp];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kSKPaymentTransactionStatePurchasedNot" object:nil];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];      //关闭交易
        }
            break;
        case SKPaymentTransactionStateFailed: {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"购买失败"];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        }
            break;
        case SKPaymentTransactionStateRestored: {
//            [MBProgressHUD hideHUD];
//            [MBProgressHUD showError:@"已经购买过该商品"];
            [MBProgressHUD showError:@"交易恢复"];
            //恢复购买  当前无此情况
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        }
            break;
        case SKPaymentTransactionStatePurchasing: {
            NSLog(@"商品添加进列表");
        }
            break;
        default: {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"这是什么情况啊？"];
            NSLog(@"这是什么情况啊？");
        }
            break;
    }
}


- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    NSLog(@"%s",__func__);
    NSLog(@"%@",error);
    [MBProgressHUD showError:error.localizedDescription];
}


- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    NSLog(@"%s",__func__);
}

- (void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

-(void)verifyLoadApp{
    //从沙盒中获取交易凭证并且拼接成请求体数据
    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    NSString *receiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//转化为base64字符串

    [MBProgressHUD showMessage:@"验证中..."];
    [VEUserApi paySucceecBackReceipt:receiptString tradeNo:self.orderNum Completion:^(VEBaseModel *  _Nonnull result) {
        [MBProgressHUD hideHUD];
        [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
        if (result.state.intValue == 1) {
            [MBProgressHUD showSuccess:@"支付成功"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"APPPaySucceed" object:nil];
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"APPPayFailure" object:nil];
            [MBProgressHUD showError:result.errorMsg];
        }
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:VENETERROR];
        [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    }];

}

@end
