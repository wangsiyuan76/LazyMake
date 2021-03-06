//
//  UIImage+ScallGif.h
//  iShow
//
//  Created by ydd on 2018/8/22.
//

#import <UIKit/UIKit.h>

@interface UIImage (ScallGif)


+ (NSData *)scallGIFWithData:(NSData *)data scallSize:(CGSize)scallSize scallPath:(NSString *)scallPath;
+ (NSData *)scallGIFWithData:(NSData *)data scallSize:(CGSize)scallSize succeedBlock:(void (^)(NSData * resultData))completion;
@end
