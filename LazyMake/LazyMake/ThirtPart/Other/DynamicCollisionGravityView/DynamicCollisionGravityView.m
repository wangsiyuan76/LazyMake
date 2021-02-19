//
//  DynamicCollisionGravityView.m
//  自由落体弹力
//
//  Created by Z.Irving on 2017/8/9.
//  Copyright © 2017年 ZWL. All rights reserved.
//

#import "DynamicCollisionGravityView.h"

@interface DynamicCollisionGravityView()
//实现的动画
@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
//动画行为
@property (nonatomic, strong) UIDynamicItemBehavior *dynamicItemBehavior;
//碰撞行为
@property (nonatomic, strong) UICollisionBehavior *collisionBehavior;
//重力行为
@property (nonatomic, strong) UIGravityBehavior * gravityBehavior;

@end
@implementation DynamicCollisionGravityView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initViewsInSelf];
    }
    return self;
}
- (void)initViewsInSelf
{
    _dynamicAnimator = [[UIDynamicAnimator alloc]initWithReferenceView:self];
    
    _dynamicItemBehavior = [[UIDynamicItemBehavior alloc]init];
    
    _dynamicItemBehavior.elasticity = 1;
    //碰撞
    _collisionBehavior = [[UICollisionBehavior alloc]init];
    
    _collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    _gravityBehavior = [[UIGravityBehavior alloc]init];
    
    //行为放入动画
    [_dynamicAnimator addBehavior:_dynamicItemBehavior];
    
    [_dynamicAnimator addBehavior:_collisionBehavior];
    
    [_dynamicAnimator addBehavior:_gravityBehavior];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    int x = arc4random() % (int)self.bounds.size.width;
    
    int size = arc4random() % 50 +20;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, 10, size, size)];
    
    imageView.image = [UIImage imageNamed:@"篮球.png"];
    
    [self addSubview:imageView];
    
    //添加行为
    [_dynamicItemBehavior addItem:imageView];
    
    [_gravityBehavior addItem:imageView];
    
    [_collisionBehavior addItem:imageView];
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
