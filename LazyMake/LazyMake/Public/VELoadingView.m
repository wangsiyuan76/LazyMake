//
//  VELoadingView.m
//  DemoProgressView
//
//  Created by xunruiIOS on 2020/6/12.
//  Copyright © 2020 zhangshaoyu. All rights reserved.
//

#import "VELoadingView.h"

@implementation VELoadingView
- (instancetype)initWithSubSize:(CGSize)subSize{
    self = [super init];
    if (self) {
        CGFloat lineW = 4;          //线宽
        
        UIWindow *win = [UIApplication sharedApplication].keyWindow;
        self.bigView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, win.frame.size.width, win.frame.size.height)];
        [win addSubview:self.bigView];

        self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, subSize.width, subSize.height)];
        self.mainView.center = CGPointMake(win.frame.size.width/2, win.frame.size.height/2-20);
        [win addSubview:self.mainView];
        
        //半透明背景view
        self.backgrongdV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, subSize.width/2, subSize.height/2)];
        self.backgrongdV.center = CGPointMake(self.mainView.frame.size.width/2, self.mainView.frame.size.height/2-10);
        self.backgrongdV.backgroundColor = [UIColor whiteColor];
        self.backgrongdV.alpha = 0.8f;
        self.backgrongdV.layer.masksToBounds = YES;
        self.backgrongdV.layer.cornerRadius = self.backgrongdV.frame.size.height/2;
        [self.mainView addSubview:self.backgrongdV];

        //进度view
        self.proView = [[SYRingProgressView alloc] initWithFrame:CGRectMake(0, 0, subSize.width/2, subSize.height/2)];
        self.proView.center = CGPointMake(self.mainView.frame.size.width/2, self.mainView.frame.size.height/2-10);
        self.proView.lineColor = [UIColor colorWithRed:0.11 green:0.67 blue:0.99 alpha:0.4];
        self.proView.lineWidth = lineW;
        self.proView.progressColor = [UIColor colorWithHexString:@"#1DABFD"];
        self.proView.defaultColor = [UIColor yellowColor];
        self.proView.label.textColor = [UIColor colorWithHexString:@"#1DABFD"];
        self.proView.label.hidden = NO;
        self.proView.label.font = [UIFont systemFontOfSize:16];
        [self.proView initializeProgress];
        [self.mainView addSubview:self.proView];
        
        //文字lab
        self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, self.proView.frame.origin.y+self.proView.frame.size.height+10, subSize.width, 15)];
        self.titleLab.font = [UIFont systemFontOfSize:16];
        self.titleLab.textColor = [UIColor whiteColor];
        self.titleLab.text = @"合成中...";
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        [self.mainView addSubview:self.titleLab];
    }
    return self;
}

- (void)setProgress:(CGFloat)prog{
    self.proView.progress = prog;
}

- (void)hiden{
    [self.bigView removeFromSuperview];
    [self.mainView removeFromSuperview];
    self.bigView = nil;
    self.mainView = nil;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
