//
//  VEHomeTemplateModel.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/9.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEHomeTemplateModel.h"

@implementation VEHomeTemplateModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"tID" : @"id",
             @"descriptionStr" : @"description",
             @"isHot" : @"is_hot",
             @"isHot" : @"is_hot",
             @"isFree" : @"is_free",
             @"downloadNum" : @"download_num",
             @"collectNum" : @"collect_num",
             @"isAcross" : @"is_across",
             @"oneCutout" : @"one_cutout",
             @"customObj" : @"custom_arr",
             @"statusStr":@"status",
             };
}


@end

@implementation LMHomeTemplateAEModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"desKey" : @"des_key",
             @"desIv" : @"des_iv",
             @"textToImage" : @"text_to_image",
             @"videoPreview" : @"video_preview",
             @"zipfileSize" : @"zipfile_size",
             @"oneCutout" : @"one_cutout",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"images" : [LMHomeTemplateAEImageModel class],
             @"texts" : [LMHomeTemplateAETextModel class],
    };
}

- (LMAEVideoType)aeType{
    if (!_aeType) {
        if ([self.type isEqualToString:@"all_text"]) {
            _aeType = LMAEVideoType_AllText;
        }
        if ([self.type isEqualToString:@"all_pic"]) {
            _aeType = LMAEVideoType_AllPic;
        }
        if ([self.type isEqualToString:@"all_video"]) {
            _aeType = LMAEVideoType_AllVideo;
        }
        if ([self.type isEqualToString:@"text_pic"]) {
            _aeType = LMAEVideoType_TextPic;
        }
        if ([self.type isEqualToString:@"text_video"]) {
            _aeType = LMAEVideoType_TextVideo;
        }
        if ([self.type isEqualToString:@"pic_video"]) {
            _aeType = LMAEVideoType_PicVideo;
        }
        if ([self.type isEqualToString:@"text_pic_video"]) {
            _aeType = LMAEVideoType_TextPicVideo;
        }
    }
    return _aeType;
}

- (NSArray *)aeTitleArr{
    if (!_aeTitleArr) {
        if (self.aeType == LMAEVideoType_AllText) {
            _aeTitleArr = @[@"文字",@"配乐"];
        }
        if (self.aeType == LMAEVideoType_AllPic) {
            _aeTitleArr = @[@"图层",@"配乐"];
        }
        if (self.aeType == LMAEVideoType_AllVideo) {
            _aeTitleArr = @[@"视频",@"配乐"];
        }
        if (self.aeType == LMAEVideoType_TextPic) {
            _aeTitleArr = @[@"文字",@"图层",@"配乐"];
        }
        if (self.aeType == LMAEVideoType_TextVideo) {
            _aeTitleArr = @[@"文字",@"视频",@"配乐"];
        }
        if (self.aeType == LMAEVideoType_PicVideo) {
            _aeTitleArr = @[@"图层",@"配乐"];
        }
        if (self.aeType == LMAEVideoType_TextPicVideo) {
            _aeTitleArr = @[@"文字",@"图层",@"配乐"];
        }
        if (self.aeType == LMAEVideoType_Audio) {
            _aeTitleArr = @[@"配乐"];
        }
    }
    return _aeTitleArr;
}

- (NSArray *)aeImageArr{
    if (!_aeImageArr) {
        if (self.aeType == LMAEVideoType_AllText) {
            _aeImageArr = @[@"vm_detail_material_text",@"vm_detail_material_music"];
        }
        if (self.aeType == LMAEVideoType_AllPic) {
            _aeImageArr = @[@"vm_detail_material_layer",@"vm_detail_material_music"];
        }
        if (self.aeType == LMAEVideoType_AllVideo) {
            _aeImageArr = @[@"vm_detail_material_layer",@"vm_detail_material_music"];
        }
        if (self.aeType == LMAEVideoType_TextPic) {
            _aeImageArr = @[@"vm_detail_material_text",@"vm_detail_material_layer",@"vm_detail_material_music"];
        }
        if (self.aeType == LMAEVideoType_TextVideo) {
            _aeImageArr = @[@"vm_detail_material_text",@"vm_detail_material_layer",@"vm_detail_material_music"];
        }
        if (self.aeType == LMAEVideoType_PicVideo) {
            _aeImageArr = @[@"vm_detail_material_layer",@"vm_detail_material_music"];
        }
        if (self.aeType == LMAEVideoType_TextPicVideo) {
            _aeImageArr = @[@"vm_detail_material_text",@"vm_detail_material_layer",@"vm_detail_material_music"];
        }
        if (self.aeType == LMAEVideoType_Audio) {
            _aeImageArr = @[@"vm_detail_material_music"];
        }
    }
    return _aeImageArr;
}

@end

@implementation LMHomeTemplateAEImageModel



@end

@implementation LMHomeTemplateAETextModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"fontText" : @"font_text",
             @"fontUrl" : @"font_url",
             @"fontSize" : @"font_size",
             };
}

@end
