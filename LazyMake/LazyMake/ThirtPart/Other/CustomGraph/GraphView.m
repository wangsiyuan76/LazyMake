
//
//  GraphView.m
//  mworkingHaier
//
//  Created by Saborka on 26/12/2016.
//  Copyright © 2016 CaiGaoBaDou. All rights reserved.
//  https://github.com/sensejump/CustomGraphView

#import "GraphView.h"
#import "GraphLine.h"
#import "GraphConstants.h"
#import "GraphBar.h"
#import "GraphDot.h"
#import "GraphPopView.h"
#import <math.h>
#import "DashesLineView.h"

@interface GraphView () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
/**
 *  目标 折线
 */
@property (strong, nonatomic) GraphLine *targetLine;

/**
 *  实际折线
 */
@property (strong, nonatomic) GraphLine *actualLine;

//X轴底部view
@property (strong, nonatomic) UIView *bottomView;

@property (assign, nonatomic) NSInteger lastSelectIndex;

@end

@implementation GraphView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lastSelectIndex = -1;
    }
    return self;
}

- (void)drawGraph
{
    self.width = SCREEN_WIDTH;
    self.height = GraphTotalHeight;
    [self addSubview:self.scrollView];
    [self drawGrid];
    [self drawLine];
    if (_needBar) {
        [self drawBar];
    }
    [self createTappedCovers];
}

/**
 *  先画格子
 */

- (void)drawGrid
{
    [self drawXAxis];
    [self drawYAxis];
}

/**
 *  画x坐标
 */

- (void)drawXAxis
{
    //底部
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - GraphXBottomHeight, SCREEN_WIDTH, GraphXBottomHeight)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    
    //分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"0xf5f5f5"];
    [self.bottomView addSubview:lineView];
    
    [self.scrollView addSubview:self.bottomView];
    
    for (int i = 0; i < _xTitleArray.count; i++) {
        UILabel *axisLabel = [self createAxisLabelIsXaxis:YES];
        axisLabel.tag = BaseXAxisTag + i;
        axisLabel.text = [_xTitleArray objectAtIndex:i];
        axisLabel.left = _xScaleLength * i;
        [self.bottomView addSubview:axisLabel];
    }
}

/**
 *  画y坐标
 */

- (void)drawYAxis
{
    for (int i = 0; i < _yTitleArray.count; i++) {
        //水平辅助线
        DashesLineView *line = [[DashesLineView alloc] initWithFrame:CGRectMake(0, GraphTotalHeight / _yTitleArray.count * i, SCREEN_WIDTH, 1)];
        [self addSubview:line];
        [self sendSubviewToBack:line];
        
        //字
        if (i > 0) {
            UILabel *numLabel = [self createAxisLabelIsXaxis:NO];
            numLabel.bottom = line.top;
            numLabel.text = [_yTitleArray objectAtIndex:i];
            [self addSubview:numLabel];
            [self sendSubviewToBack:numLabel];
        }
    }
}

- (UILabel *)createAxisLabelIsXaxis:(BOOL)xAxis
{
    
    CGFloat left = xAxis ? 0 : 50;
    CGFloat width = xAxis ? _xScaleLength : SCREEN_WIDTH - 50 - 10;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(left, 0, width, GraphXBottomHeight)];
    label.textColor = xAxis ? GraphXAxisFontColor : GraphYAxisFontColor;
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:GraphFontSize];
    label.textAlignment = xAxis ? NSTextAlignmentCenter : NSTextAlignmentRight;
    return label;
}

- (void)reloadData
{
    
}

/**
 *  画折线
 */

- (void)drawLine
{
    self.targetLine = [self createLineIsTarget:YES];
    self.actualLine = [self createLineIsTarget:NO];
    [self.scrollView addSubview:self.targetLine];
    [self.scrollView addSubview:self.actualLine];
    [self.targetLine reloadDataWithAnimation:YES];
    [self.actualLine reloadDataWithAnimation:YES];
}

- (GraphLine *)createLineIsTarget:(BOOL)isTarget
{
    GraphLine *line = [[GraphLine alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height - GraphXBottomHeight)];
    //    line.delegate = self;
    line.xScaleLength = self.xScaleLength;
    line.lineWidth = 2;
    line.maxValue = self.yMaxValue;
    if (isTarget) {
        line.lineColor = LineBlueColor;
        line.lineAlphaColor = LineBlueAlphaColor;
        line.valueArray = self.targetValues;
    } else {
        line.lineColor = self.isDeal ? LinePurpleColor : LineOrangeColor;
        line.lineAlphaColor = self.isDeal ? LinePurpleAlphaColor : LineOrangeAlphaColor;
        line.valueArray = self.actualValues;
    }
    return line;
}

/**
 *  画柱状图
 */
- (void)drawBar
{
    CGFloat targetX = (self.xScaleLength - 3*GraphBarWidthAndGap) / 2;
    CGFloat actualX = targetX + GraphBarWidthAndGap * 2;
    for (int i = 0; i < self.targetBarValues.count; i++) {
        GraphBar *targetBar = [[GraphBar alloc] initWithFrame:CGRectMake(targetX + self.xScaleLength * i, 0, GraphBarWidthAndGap, self.height - GraphXBottomHeight-1)];
        targetBar.barColor = BarBlueColor;
        CGFloat targetValue = [[self.targetBarValues objectAtIndex:i] floatValue] / self.yMaxValue;
        targetBar.barValue = targetValue;
        [_scrollView addSubview:targetBar];
        [_scrollView sendSubviewToBack:targetBar];
    }
    
    for (int i = 0; i < self.actualBarValues.count; i++) {
        GraphBar *actualBar = [[GraphBar alloc] initWithFrame:CGRectMake(actualX+ self.xScaleLength * i, 0, GraphBarWidthAndGap, self.height - GraphXBottomHeight-1)];
        actualBar.barColor = BarYellowColor;
        CGFloat actualValue = [[self.actualBarValues objectAtIndex:i] floatValue] / self.yMaxValue;
        actualBar.barValue = actualValue;
        [_scrollView addSubview:actualBar];
        [_scrollView sendSubviewToBack:actualBar];
    }
}

/**
 *  分散一个个的可点击区域
 */
- (void)createTappedCovers
{
    for (int i = 0; i < self.xTitleArray.count; i++) {
        UIView *cover = [[UIView alloc] init];
        cover.tag = BaseCoverTag + i;
        
        if (i == 0) { //第一个点
            cover.frame = CGRectMake(0, 0, self.xScaleLength / 2, GraphTotalHeight);
            [_scrollView addSubview:cover];
        } else if (i == self.xTitleArray.count - 1) { //最后一个点
            cover.frame = CGRectMake(self.scrollView.contentSize.width - self.xScaleLength / 2, 0, self.xScaleLength / 2, GraphTotalHeight);
            [_scrollView addSubview:cover];
        } else { //中间的点
            cover.frame = CGRectMake(self.xScaleLength * i, 0, self.xScaleLength, GraphTotalHeight);
            [_scrollView addSubview:cover];
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverTapped:)];
        [cover addGestureRecognizer:tap];
    }
}

- (void)coverTapped:(UITapGestureRecognizer *)tap
{
    NSInteger index = tap.view.tag - BaseCoverTag;
    
    [self highlightCurrentXTitleWithIndex:index];
    
    CGPoint targetPoint = [[self.targetLine.pointArray objectAtIndex:index] CGPointValue];
    CGPoint actualPoint = [[self.actualLine.pointArray objectAtIndex:index] CGPointValue];
    
    /**
     *  圆环及浮层
     */
    
    if (self.lastSelectIndex != -1) { //已经显示了的
        GraphDot *dot = (GraphDot *)[_scrollView viewWithTag:BaseDotTag + self.lastSelectIndex];
        [dot removeFromSuperview];
        GraphPopView *pop = (GraphPopView *)[_scrollView viewWithTag:BasePopTag + self.lastSelectIndex];
        [pop removeFromSuperview];
    }
    
    CGPoint currentPoint = [tap locationInView:tap.view];
    
    //分别计算出当前点跟目标折线，实际折线差值的绝对值，哪个小，就在哪个上面画
    CGFloat targetAbs = fabs(currentPoint.y - targetPoint.y);
    CGFloat actualAbs = fabs(currentPoint.y - actualPoint.y);
    
    if (targetAbs < actualAbs || targetAbs == actualAbs) { //如果重合的话 也画在目标折线
        [self createDotPopComparePopWithIndex:index point:targetPoint color:LineBlueColor string:[self.targetValues objectAtIndex:index] lineView:self.targetLine];
    } else {
        UIColor *color = _isDeal ? LinePurpleColor : LineOrangeColor;
        [self createDotPopComparePopWithIndex:index point:actualPoint color:color string:[self.actualValues objectAtIndex:index] lineView:self.actualLine];
    }
    self.lastSelectIndex = index;
}

- (void)createDotPopComparePopWithIndex:(NSInteger)index
                                  point:(CGPoint)point
                                  color:(UIColor *)color
                                 string:(NSString *)string
                               lineView:(GraphLine *)lineView
{
    GraphDot *dot = [[GraphDot alloc] initWithCenter:point radius:DotRadius borderColor:color];
    dot.tag = BaseDotTag + index;
    dot.dotBorderWidth = 1.5;
    [_scrollView addSubview:dot];
    [dot performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1];
    
    GraphPopView *pop = [[GraphPopView alloc] initWithFrame:CGRectZero bgColor:color string:string];
    pop.center = point;
    
    CGFloat popY = point.y + GapBetweenDotAndPop;
    if (popY + pop.height > GraphTotalHeight - GraphXBottomHeight) { //如果pop底端超过x坐标 就把popview放在dot上面
        popY = popY - 3 * GapBetweenDotAndPop;
    }
    pop.top = popY;
    pop.tag = index + BasePopTag;
    [_scrollView addSubview:pop];
    [pop performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1];
}

//高亮当前的x轴
- (void)highlightCurrentXTitleWithIndex:(NSInteger)index
{
    for (int i = 0; i < self.xTitleArray.count; i++) {
        UILabel *label = (UILabel *)[self.bottomView viewWithTag:i + BaseXAxisTag];
        if (i == index) {
            [label setTextColor:GraphXAxisHighlightFontColor];
        } else {
            [label setTextColor:GraphXAxisFontColor];
        }
    }
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.minimumZoomScale = 0.5;
        _scrollView.maximumZoomScale = 2;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(_xScaleLength * _xTitleArray.count, self.height);
    }
    return _scrollView;
}

@end
