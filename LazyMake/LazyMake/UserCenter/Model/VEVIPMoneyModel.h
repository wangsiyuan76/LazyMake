//
//  VEVIPMoneyModel.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/3.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface LMVIPMoneyPushModel : VEBaseModel

@property (strong, nonatomic) NSString *userid;
@property (strong, nonatomic) NSString *tariffid;
@property (strong, nonatomic) NSString *goodsname;
@property (strong, nonatomic) NSString *goodsid;
@property (strong, nonatomic) NSString *goodsdesc;
@property (strong, nonatomic) NSString *amount;
@property (strong, nonatomic) NSString *paytype;
@property (strong, nonatomic) NSString *datetime;
@property (strong, nonatomic) NSString *member_desc;
@property (strong, nonatomic) NSString *pay_mouth;
@property (strong, nonatomic) NSString *trade_no;

@end
@interface LMVIPMoneyIconModel : VEBaseModel
@property (strong, nonatomic) NSArray *tariff;              //时间
@property (strong, nonatomic) NSString *isAppleAay;         //是否使用苹果内购

@end

@interface VEVIPMoneyModel : VEBaseModel

@property (strong, nonatomic) NSString *timeStr;            //时间
@property (strong, nonatomic) NSString *moneyStr;           //现价
@property (strong, nonatomic) NSString *oldMoneyStr;        //原价
@property (strong, nonatomic) NSString *moneyID;            //ID
@property (assign, nonatomic) BOOL ifSelect;                //是否选中
@property (strong, nonatomic) NSString *appleTariff;        //购买id

@property (strong, nonatomic) NSString *dayNum;            //天数
@property (strong, nonatomic) NSString *monthNum;          //月数
@property (strong, nonatomic) NSString *giving;            //赠送天数
@property (strong, nonatomic) NSString *convertday;        //平均每天多少钱
@property (strong, nonatomic) NSString *textDesc;          //限时特惠
@property (strong, nonatomic) NSString *endNum;            //结束日期

//VIP会员底部的菜单数据
@property (strong, nonatomic) NSString *iconName;
@property (strong, nonatomic) NSString *titleStr;
@property (strong, nonatomic) NSString *contentStr;

@end

NS_ASSUME_NONNULL_END
