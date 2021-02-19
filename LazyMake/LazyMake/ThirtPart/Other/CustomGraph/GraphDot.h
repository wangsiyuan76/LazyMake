//
//  GraphDot.h
//  mworkingHaier
//
//  Created by Saborka on 26/12/2016.
//  https://github.com/sensejump/CustomGraphView
//

#import <UIKit/UIKit.h>

@interface GraphDot : UIView

- (instancetype)initWithCenter:(CGPoint)center
                        radius:(CGFloat)radius
                   borderColor:(UIColor *)borderColor;

@property (assign, nonatomic) CGFloat dotBorderWidth;

@end
