//
//  GraphLine.m
//  mworkingHaier
//
//  Created by Saborka on 26/12/2016.
//  https://github.com/sensejump/CustomGraphView
//

#import "GraphLine.h"
#import "GraphConstants.h"

@interface GraphLine ()

/**
 *  存储折线上每个点,方便后续处理
 */
@property (strong, nonatomic) CAShapeLayer *shapeLayer;

@end

@implementation GraphLine

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)reloadDataWithAnimation:(BOOL)animation
{
    [self drawLine];
    [self drawGradient];
}

/**
 *  画折线图
 */
- (void)drawLine
{
    self.pointArray = [NSMutableArray array];
    UIBezierPath *linePath = [[UIBezierPath alloc] init];
    for (int i = 0; i < self.valueArray.count; i++) {
        CGFloat pointX = self.xScaleLength * i;
        CGFloat value = [self.valueArray[i] floatValue];
        CGFloat percent = value / self.maxValue;
        CGFloat pointY = (1 - percent) * GraphTotalHeight;
        CGPoint point = CGPointMake(pointX, pointY);
        [self.pointArray addObject:[NSValue valueWithCGPoint:point]];
        
        if (i == 0) {
            [linePath moveToPoint:point];
        } else {
            [linePath addLineToPoint:point];
        }
    }
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.zPosition = 0.0f;
    _shapeLayer.strokeColor = _lineColor.CGColor;
    _shapeLayer.lineWidth = _lineWidth;
    _shapeLayer.lineCap = kCALineCapRound;
    _shapeLayer.lineJoin = kCALineJoinRound;
    _shapeLayer.frame = self.frame;
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    _shapeLayer.path = linePath.CGPath;
    [self.layer addSublayer:_shapeLayer];
    
}

- (void)drawGradient
{
    /**
     *  添加渐变色
     */
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = @[(__bridge id)_lineAlphaColor.CGColor,(__bridge id)[UIColor colorWithWhite:1 alpha:0.1].CGColor];
    
    gradientLayer.locations= @[@0.0,@1.0];
    gradientLayer.startPoint = CGPointMake(0.0,0.0);
    gradientLayer.endPoint = CGPointMake(0.0,1);
    
    UIBezierPath *gradientPath = [[UIBezierPath alloc] init];
    //渐变面积的第一个点和最后一个点都是对应折线点最下面的点,中间的点与折线上的点相同
    [gradientPath moveToPoint:CGPointMake(0, GraphTotalHeight)];
    
    for (int i = 0; i < self.pointArray.count; i ++) {
        [gradientPath addLineToPoint:[self.pointArray[i] CGPointValue]];
    }
    
    CGPoint endPoint = [[self.pointArray lastObject] CGPointValue];
    endPoint = CGPointMake(endPoint.x, GraphTotalHeight);
    [gradientPath addLineToPoint:endPoint];
    CAShapeLayer *arc = [CAShapeLayer layer];
    arc.path = gradientPath.CGPath;
    gradientLayer.mask = arc;
    [self.layer addSublayer:gradientLayer];
}

@end
