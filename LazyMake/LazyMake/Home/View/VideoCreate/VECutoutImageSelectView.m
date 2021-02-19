//
//  VECutoutImageSelectView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/6/2.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VECutoutImageSelectView.h"
#import "TZImagePickerController.h"

@interface VECutoutImageSelectView () <TZImagePickerControllerDelegate>

@end

@implementation VECutoutImageSelectView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backgroundImage];
        [self addSubview:self.mainImage];
        [self addSubview:self.addImage];
        [self addSubview:self.subLab];
        [self addSubview:self.mainBtn];
        [self setAllViewLayout];
    }
    return self;
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.mainImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.addImage mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.subLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.addImage.mas_bottom).mas_offset(10);
    }];
    
    [self.mainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (UIImageView *)backgroundImage{
    if (!_backgroundImage) {
        _backgroundImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vm_show_image_bg"]];
        _backgroundImage.backgroundColor = [UIColor clearColor];
        _backgroundImage.hidden = YES;
    }
    return _backgroundImage;
}

- (UIImageView *)mainImage{
    if (!_mainImage) {
        _mainImage = [UIImageView new];
        _mainImage.backgroundColor = [UIColor colorWithHexString:@"#A1A7B2"];
        _mainImage.contentMode = UIViewContentModeScaleAspectFit;
        _mainImage.clipsToBounds = YES;
        _mainImage.userInteractionEnabled = YES;
    }
    return _mainImage;
}

- (UIButton *)mainBtn{
    if (!_mainBtn) {
        _mainBtn = [UIButton new];
        [_mainBtn addTarget:self action:@selector(clickMainBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mainBtn;
}

- (UILabel *)subLab{
    if (!_subLab) {
        _subLab = [UILabel new];
        _subLab.font = [UIFont systemFontOfSize:15];
        _subLab.textColor = [UIColor colorWithHexString:@"ffffff"];
        _subLab.textAlignment = NSTextAlignmentCenter;
        _subLab.text = @"添加一张人像图片";
    }
    return _subLab;
}

- (UIImageView *)addImage{
    if (!_addImage) {
        _addImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"vm_detail_cutout_add"]];
    }
    return _addImage;
}
- (void)clickMainBtn{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.sortAscendingByModificationDate = NO;
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.maxImagesCount = 1;
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.ifUsedTZCrop = NO;
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [currViewController() presentViewController:imagePickerVc animated:YES completion:nil];
    @weakify(self);
    imagePickerVc.noTZCropBlock = ^(UIImage *cropImage) {
        @strongify(self);
        if (cropImage) {
            [self.mainImage setImage:cropImage];
            self.addImage.hidden = YES;
            self.subLab.hidden = YES;
            self.backgroundImage.hidden = NO;
            self.mainImage.backgroundColor = [UIColor clearColor];
            if (self.changeSelectImageBlock) {
                self.changeSelectImageBlock(cropImage);
            }
        }
    };
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
