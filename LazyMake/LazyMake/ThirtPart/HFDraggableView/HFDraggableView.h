//
//  HFDraggableView.h
//  HFDraggableView
//
//  Created by Henry on 08/11/2017.
//  Copyright © 2017 Henry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HFDraggableView : UIView
@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) CGSize biliSize;

+ (void)setActiveView:(HFDraggableView *)view;
@end
