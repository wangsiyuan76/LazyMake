//
//  GraphBar.m
//  mworkingHaier
//
//  Created by Saborka on 27/12/2016.
//  https://github.com/sensejump/CustomGraphView
//

#import "GraphBar.h"

@interface GraphBar ()

@property (strong, nonatomic) CAShapeLayer *shapeLayer;

@end

@implementation GraphBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.lineCap      = kCALineCapButt;
        _shapeLayer.fillColor    = [[UIColor whiteColor] CGColor];
        _shapeLayer.lineWidth    = self.frame.size.width;
        _shapeLayer.strokeEnd    = 0.0;
        self.clipsToBounds = YES;
        [self.layer addSublayer:_shapeLayer];
    }
    return self;
}

- (void)setBarColor:(UIColor *)barColor
{
    _barColor = barColor;
    _shapeLayer.strokeColor = barColor.CGColor;
}

- (void)setBarValue:(CGFloat)barValue
{
    _barValue = barValue;
    
    UIBezierPath *barLine = [UIBezierPath bezierPath];
    [barLine moveToPoint:CGPointMake(self.width/2.0, self.height)];
    [barLine addLineToPoint:CGPointMake(self.width/2.0, (1 - barValue) * self.height)];
    
    [barLine setLineWidth:1.0];
    [barLine setLineCapStyle:kCGLineCapSquare];
    _shapeLayer.path = barLine.CGPath;
    if (_barColor) {
        _shapeLayer.strokeColor = [_barColor CGColor];
    }
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.0;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [_shapeLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
    _shapeLayer.strokeEnd = 1.0;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillRect(context, rect);
}

@end
