//
//  VECreateHUD.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/24.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VECreateHUD.h"
#import "MBProgressHUD.h"

@interface VECreateHUD ()
{
    MBProgressHUD *demoHintHUD;
    BOOL isShowing;
}
@end

@implementation VECreateHUD
-(id) init
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
//    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
//    demoHintHUD = [[MBProgressHUD alloc] initWithView:window];
////    demoHintHUD.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
//    [window addSubview:demoHintHUD];
//    isShowing=NO;
    
    return self;
}
-(void)showProgress:(NSString *)text par:(double)par
{
//    if (demoHintHUD!=nil) {
//        if(isShowing==NO){
//            [demoHintHUD showAnimated:YES];
//            demoHintHUD.label.text=text;
//            demoHintHUD.mode=MBProgressHUDModeDeterminateHorizontalBar;
//            isShowing=YES;
//        }else{
//            demoHintHUD.progress = par;
//            demoHintHUD.label.text=text;
//        }
//    }
    
    if (!self.loadHUD) {
        self.loadHUD = [[VELoadingView alloc]initWithSubSize:CGSizeMake(140, 140)];
        if ([text containsString:@"中"]) {
            NSRange range = [text rangeOfString:@"中"];
            NSString *str = [text substringWithRange:NSMakeRange(0, range.location+range.length)];
            if (str.length > 2) {
                self.loadHUD.titleLab.text = [NSString stringWithFormat:@"%@...",str];
            }
        }
    }
    [self.loadHUD setProgress:par];

}
-(void)hide
{
//    if(isShowing && demoHintHUD!=nil){
//        [demoHintHUD hideAnimated:YES];
//        isShowing=NO;
//    }
    [self.loadHUD hiden];
}
-(void)dealloc
{
    isShowing=NO;
    demoHintHUD=nil;
    self.loadHUD = nil;
}
@end
