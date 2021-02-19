//
//  VEAddCoverMainView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/23.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEAddCoverMainView.h"
#import "TZImagePickerController.h"

@interface VEAddCoverMainView ()<TZImagePickerControllerDelegate>

@end
@implementation VEAddCoverMainView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.mainImage];
        [self addSubview:self.changeBtn];
        
        [self.mainImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return self;
}

- (UIImageView *)mainImage{
    if (!_mainImage) {
        _mainImage = [[UIImageView alloc]init];
        _mainImage.contentMode = UIViewContentModeScaleAspectFill;
        _mainImage.clipsToBounds = YES;
    }
    return _mainImage;
}

- (UIButton *)changeBtn{
    if (!_changeBtn) {
        _changeBtn = [UIButton new];
        [_changeBtn addTarget:self action:@selector(changeImage) forControlEvents:UIControlEventTouchUpInside];
        [_changeBtn setTitle:@"添加图片" forState:UIControlStateNormal];
        _changeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_changeBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    }
    return _changeBtn;
}

- (void)changeImage{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.sortAscendingByModificationDate = NO;
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.maxImagesCount = 1;
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowCrop = YES;
    imagePickerVc.scaleAspectFillCrop = NO;
    imagePickerVc.ifUsedTZCrop = YES;
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    imagePickerVc.customAspectRatio = CGSizeMake(self.imageSize.width, self.imageSize.height);
    [currViewController() presentViewController:imagePickerVc animated:YES completion:nil];
    @weakify(self);
    imagePickerVc.noTZCropBlock = ^(UIImage *cropImage) {
        @strongify(self);
        self.image = cropImage;
        [self.mainImage setImage:cropImage];
        [self.changeBtn setTitle:@"" forState:UIControlStateNormal];
        if (self.changeImageBlock) {
            self.changeImageBlock(cropImage);
        }
    };
    
}

//- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
//    if (photos.count > 0) {
//        UIImage *image = photos[0];
//        self.image = image;
//        [self.mainImage setImage:image];
//        [self.changeBtn setTitle:@"" forState:UIControlStateNormal];
//        if (self.changeImageBlock) {
//            self.changeImageBlock(image);
//        }
//    }
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
