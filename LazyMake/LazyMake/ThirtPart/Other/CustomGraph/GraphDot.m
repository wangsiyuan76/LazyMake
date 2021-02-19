//
//  GraphDot.m
//  mworkingHaier
//
//  Created by Saborka on 26/12/2016.
//  https://github.com/sensejump/CustomGraphView
//

#import "GraphDot.h"

@interface GraphDot ()

@end

@implementation GraphDot

- (instancetype)initWithCenter:(CGPoint)center
                        radius:(CGFloat)radius
                   borderColor:(UIColor *)borderColor
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(center.x - radius, center.y - radius, radius * 2.0, radius * 2.0);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = radius;
        self.layer.borderColor = borderColor.CGColor;
    }
    return self;
}

- (void)setDotBorderWidth:(CGFloat)dotBorderWidth
{
    _dotBorderWidth = dotBorderWidth;
    self.layer.borderWidth = dotBorderWidth;
}

@end
