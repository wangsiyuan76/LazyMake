//
//  GraphLine.h
//  mworkingHaier
//
//  Created by Saborka on 26/12/2016.
//  https://github.com/sensejump/CustomGraphView
//

#import <UIKit/UIKit.h>

@interface GraphLine : UIView

@property (strong, nonatomic) UIColor *lineColor;
@property (strong, nonatomic) UIColor *lineAlphaColor;
@property (assign, nonatomic) CGFloat lineWidth;
@property (strong, nonatomic) NSArray *valueArray;
@property (assign, nonatomic) CGFloat xScaleLength;
@property (assign, nonatomic) CGFloat maxValue;
@property (strong, nonatomic) NSMutableArray *pointArray;

- (void)reloadDataWithAnimation:(BOOL)animation;

@end
