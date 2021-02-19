//
//  VEFilterSelectModel.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/20.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEFilterSelectModel.h"

@implementation VEFilterSelectModel

+ (NSArray *)createFilterDataArr{
    NSMutableArray *arr = [NSMutableArray new];
      for (int x = 0; x < 14; x++) {
          VEFilterSelectModel *model = [VEFilterSelectModel new];
          model.ifSelect = NO;
          switch (x) {
              case 0:               //无
              {
                  model.ifSelect = YES;
                  model.selectedFilter = nil;
                  model.imageStr = @"vm_detail_filter_p";
                  model.titleStr = @"无";
              }
                  break;
             case 1:                //
             {
                 model.imageStr = @"vm_detail_filter_meiyan";
                 model.titleStr = @"美颜";
                 model.selectedFilter = [[LanSongBeautyFilter alloc] init];
             }
                 break;
             case 2:
             {
                 model.imageStr = @"vm_detail_filter_baixi";
                 model.titleStr = @"白皙";
                 model.selectedFilter = [[LanSongIFAmaroFilter alloc] init];
             }
                 break;
            case 3:
            {
                model.titleStr = @"甜美";
                model.imageStr = @"vm_detail_filter_tianmei";
                model.selectedFilter = [[LanSongIFHudsonFilter alloc] init];
            }
                break;
            case 4:
            {
                model.titleStr = @"轻颜";
                model.imageStr = @"vm_detail_filter_qingyan";
                model.selectedFilter = [[LanSongIFXproIIFilter alloc] init];
            }
                break;
            case 5:
            {
                model.titleStr = @"奶油";
                model.imageStr = @"vm_detail_filter_naiyou";
                model.selectedFilter = [[LanSongIFEarlybirdFilter alloc] init];
            }
                break;
            case 6:
            {
                model.titleStr = @"素肌";
                model.imageStr = @"vm_detail_filter_suji";
                model.selectedFilter = [[LanSongIFSutroFilter alloc] init];
            }
                break;
            case 7:
            {
                model.titleStr = @"温暖";
                model.imageStr = @"vm_detail_filter_wennuan";
                model.selectedFilter = [[LanSongIFToasterFilter alloc] init];
            }
                break;
           case 8:
           {
               model.titleStr = @"黑白";
               model.imageStr = @"vm_detail_filter_heibai";
               model.selectedFilter = [[LanSongIFInkwellFilter alloc] init];
           }
               break;
           case 9:
           {
               model.titleStr = @"元气";
               model.imageStr = @"vm_detail_filter_yuanqi";
               model.selectedFilter = [[LanSongIFValenciaFilter alloc] init];
           }
               break;
            case 10:
            {
                model.titleStr = @"复古";
                model.imageStr = @"vm_detail_filter_fugu";
                model.selectedFilter = [[LanSongSepiaFilter alloc] init];
            }
                break;
            case 11:
            {
                model.titleStr = @"冷淡";
                model.imageStr = @"vm_detail_filter_lengdan";
                model.selectedFilter = [[LanSongMonochromeFilter alloc] init];
                [(LanSongMonochromeFilter *)model.selectedFilter setColor:(LanSongVector4){0.0f, 0.0f, 1.0f, 1.f}];
            }
                break;
                  
            case 12:
            {
                model.titleStr = @"冷玉";
                model.imageStr = @"vm_detail_filter_lengyu";
                model.selectedFilter = [[LanSongHueFilter alloc] init];
            }
                break;
                  
            case 13:
            {
                model.titleStr = @"霏颜";
                model.imageStr = @"vm_detail_filter_feiyan";
                model.selectedFilter = [[LanSongGammaFilter alloc] init];
            }
                break;
              default:
                  break;
          }
          [arr addObject:model];
      }
    return arr;
}

@end
