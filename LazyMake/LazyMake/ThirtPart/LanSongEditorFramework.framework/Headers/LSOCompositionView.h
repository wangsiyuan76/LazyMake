//
//  LSOCompositionView.h
//  LanSongEditorFramework
//
//  Created by sno on 2020/3/14.
//  Copyright © 2020 sno. All rights reserved.
//


#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import "LanSongContext.h"



@class LSOLayer;


@interface LSOCompositionView : UIView <LanSongInput>



//*****************一下为内部使用, 外界不要使用*****************
//LSDEMO_DELETE

/**
 预览进度;
 */
@property(nonatomic, copy) void(^ _Nullable previewProgressBlock)(CGFloat progess);

@property(nonatomic, copy) void(^ _Nullable previewCompletedBlock)();


@property(nonatomic, copy) void(^ _Nullable userSelectedLayerBlock)(LSOLayer * _Nullable layer);


/// 当前选中的图层;
@property (nonatomic, readwrite)LSOLayer * _Nullable currentTransformLayer;


- (void)setBackgroundColorRed:(GLfloat)redComponent green:(GLfloat)greenComponent blue:(GLfloat)blueComponent alpha:(GLfloat)alphaComponent;
- (void)setCurrentlyReceivingMonochromeInput:(BOOL)newValue;
-(void)setPenArray:(NSMutableArray *_Nullable)array;
-(void)setPenArray2:(NSMutableArray * _Nullable)array;
-(void)setPenArray3:(NSMutableArray *_Nullable)array;
-(void)setBGLayer:(LSOLayer * _Nullable)layer;

-(void)resetDriver;

@property (nonatomic, assign) BOOL disableTouchEvent;


@property (nonatomic)BOOL forceUpdate;
//**********, 外界不要使用 LSDEMO_DELETE END*****************






@end
