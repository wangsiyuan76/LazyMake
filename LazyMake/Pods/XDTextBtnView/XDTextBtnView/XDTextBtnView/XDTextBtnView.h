//
//  XDTextBtnView.h
//  文字按钮
//
//  Created by XD on 2019/6/10.
//  Copyright © 2019 XDTextBtnView. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDTextBtnView;

NS_ASSUME_NONNULL_BEGIN

@protocol XDTextBtnViewDelegate <NSObject>

@optional
//isSingle = YES
- (void)XDTextBtnViewClickIndex:(NSInteger)index lastClickIndex:(NSInteger)lastClickIndex view:(XDTextBtnView *)view;
//isSingle = NO
- (void)XDTextBtnViewSelectIndexes:(NSArray *)indexes view:(XDTextBtnView *)view;

@end

@interface XDTextBtnView : UIView

/**
 *  是否单选 默认单选
 *  如果单选 XDTextBtnViewClickIndex:lastClickIndex:
 *  如果多选 XDTextBtnViewSelectIndexes:
 */
@property (nonatomic, assign) BOOL isSingle;

@property (nonatomic, assign) CGFloat textFontSize;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, strong) UIColor *selectTextColor;

@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, strong) UIColor *selectBackgroundColor;

@property (nonatomic, strong) UIImage *backgroundImage;

@property (nonatomic, strong) UIImage *selectBackgroundImage;

@property (nonatomic, assign) CGFloat cornerRadius;

@property (nonatomic, assign) CGFloat borderWidth;

@property (nonatomic, strong) UIColor *borderColor;

@property (nonatomic, strong) UIColor *selectBorderColor;

@property (nonatomic, assign) CGFloat allBtnMaxWidth;

//按钮文字到按钮左右边的间距
@property (nonatomic, assign) CGFloat marginX;

//按钮的间距
@property (nonatomic, assign) CGFloat btnMarginX;

@property (nonatomic, assign) CGFloat marginY;

@property (nonatomic, assign) CGFloat btnWidth;

@property (nonatomic, assign) CGFloat btnHeight;

@property (nonatomic, assign) NSInteger viewTag;

/**
 *  需要设置完全部样式后设置数据
 */
@property (nonatomic, strong) NSArray <NSString *> *textArr;

/**
 *  需要设置完数据后设置默认数据
 */
@property (nonatomic, strong) NSArray <NSString *> *defultIndexArr;

@property (nonatomic, weak) id <XDTextBtnViewDelegate> delegate;

/**
 * 总高度(第一行无上marginY 最后一行无下marginY)
 */
@property (nonatomic, readonly, assign) CGFloat maxY;



- (void)unSelectAll;

@end

NS_ASSUME_NONNULL_END
