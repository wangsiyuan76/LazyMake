//
//  GraphView.h
//  mworkingHaier
//
//  Created by Saborka on 26/12/2016.
//  https://github.com/sensejump/CustomGraphView
//

#import <UIKit/UIKit.h>

@interface GraphView : UIView

/**
 *  X轴 坐标数据
 */
@property (strong, nonatomic) NSArray *xTitleArray;

/**
 *  Y轴 坐标数据
 */
@property (strong, nonatomic) NSArray *yTitleArray;

/**
 *  目标,实际折线图数据,bar数据
 */
@property (strong, nonatomic) NSArray *targetValues;
@property (strong, nonatomic) NSArray *actualValues;
@property (strong, nonatomic) NSArray *targetBarValues;
@property (strong, nonatomic) NSArray *actualBarValues;

/**
 *  有木有柱状图
 */
@property (assign, nonatomic) BOOL needBar;

/**
 *  是成交还是回款,折线图颜色不同
 */
@property (assign, nonatomic) BOOL isDeal;

/**
 *  X轴 单位长度
 */
@property (assign, nonatomic) CGFloat xScaleLength;

/**
 *  Y轴 最大值
 */
@property (assign, nonatomic) CGFloat yMaxValue;

/**
 *  画图
 */
- (void)drawGraph;

/**
 *  刷数据
 */
- (void)reloadData;

@end
