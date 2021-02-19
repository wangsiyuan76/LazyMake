//
//  VEHomeToolTeachCell.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/6/2.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEHomeToolTeachCell.h"

@implementation VEHomeToolTeachCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.mainImage];
        [self.contentView addSubview:self.mainLab];
        
    }
    return self;
}

- (UIImageView *)mainImage{
    if (!_mainImage) {
        _mainImage = [[UIImageView alloc]initWithFrame:CGRectMake(3, 0, (kScreenWidth-36)/3, (kScreenWidth-36)/3)];
        _mainImage.contentMode = UIViewContentModeScaleAspectFill;
        _mainImage.clipsToBounds = YES;
        _mainImage.layer.masksToBounds = YES;
        _mainImage.layer.cornerRadius = 7;
    }
    return _mainImage;
}

- (void)setModel:(VETeachListModel *)model andIndex:(NSInteger)index lineNum:(NSInteger)lineNum{
    [self.mainImage sd_setImageWithURL:[NSURL URLWithString:model.thumb]];
    if (index % lineNum == 0) {
        self.mainImage.frame = CGRectMake(15, 0, (kScreenWidth-36)/lineNum, (kScreenWidth-36)/lineNum);
    }else{
        self.mainImage.frame = CGRectMake(3, 0, (kScreenWidth-36)/lineNum, (kScreenWidth-36)/lineNum);
    }
}


@end
