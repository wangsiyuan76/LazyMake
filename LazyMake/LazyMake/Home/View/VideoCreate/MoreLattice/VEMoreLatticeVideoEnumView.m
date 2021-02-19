//
//  VEMoreLatticeVideoEnumView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/6/8.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEMoreLatticeVideoEnumView.h"

@implementation VEMoreLatticeVideoEnumView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.biliView];
        [self addSubview:self.btnView];
        
        @weakify(self);
        [self.biliView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(30);
            make.height.mas_equalTo(50);
        }];
        
        [self.btnView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(self.biliView.mas_bottom).mas_offset(30);
            make.bottom.mas_equalTo(0);
        }];
    }
    return self;
}

- (UIView *)biliView{
    if (!_biliView) {
        _biliView = [UIView new];
        self.biliArr = [NSMutableArray new];
        NSArray *selectArr = @[@"vm_detail_editor_1_p",@"vm_detail_editor_2_p",@"vm_detail_editor_3_p",@"vm_detail_editor_5_p"];
        NSArray *imageArr = @[@"vm_detail_editor_1_n",@"vm_detail_editor_2_n",@"vm_detail_editor_3_n",@"vm_detail_editor_5_n"];
        CGFloat btnW = 45;
        CGFloat btnH = 45;
        CGFloat distance = (self.width-(btnW*selectArr.count))/(selectArr.count-1);

        for (int x = 0; x < selectArr.count; x++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x*(distance+btnW), 0, btnW, btnH)];
            [btn setBackgroundImage:[UIImage imageNamed:imageArr[x]] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:selectArr[x]] forState:UIControlStateSelected];
            btn.tag = x;
            [btn addTarget:self action:@selector(clickBiliBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.biliArr addObject:btn];
            [_biliView addSubview:btn];
        }

    }
    return _biliView;
}

- (UIView *)btnView{
    if (!_btnView) {
        _btnView = [UIView new];
        NSArray *titleArr = @[@"排序",@"画布",@"配乐"];
        NSArray *imageArr = @[@"vm_detail_editor_sort_small",@"vm_detail_editor_canvas_small",@"vm_detail_editor_music_small"];
        CGFloat btnW = 100;
        CGFloat btnH = 38;
        CGFloat distance = (self.width-(btnW*titleArr.count))/(titleArr.count-1);
        for (int x = 0; x<titleArr.count; x++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x*(distance+btnW), 0, btnW, btnH)];
            [btn setImage:[UIImage imageNamed:imageArr[x]] forState:UIControlStateNormal];
            [btn setTitle:titleArr[x] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:17];
            [btn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
            btn.tag = x;
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 19;
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = [UIColor colorWithHexString:@"ffffff"].CGColor;
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
            [btn addTarget:self action:@selector(clickSubBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_btnView addSubview:btn];
        }
    }
    return _btnView;
}

- (void)clickBiliBtn:(UIButton *)btn{
    btn.selected = YES;
    for (UIButton *subBtn in self.biliArr) {
        if (subBtn.tag != btn.tag) {
            subBtn.selected = NO;
        }
    }
    if (self.clickBiliBlock) {
        self.clickBiliBlock(btn.tag);
    }
}

- (void)clickSubBtn:(UIButton *)btn{
    if (self.clickSubBtnBlock) {
        self.clickSubBtnBlock(btn.tag);
    }
}

- (void)setVideoStyleIndex:(NSInteger)videoStyleIndex{
    if (self.biliArr.count > videoStyleIndex) {
        UIButton *btn = self.biliArr[videoStyleIndex];
        btn.selected = YES;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
