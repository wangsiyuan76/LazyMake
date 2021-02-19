//
//  VEVipPackageCell.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/3.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEVipPackageCell.h"
#import "VEVipPackageSubCell.h"
#import <Masonry.h>
#import "VEWebTermsViewController.h"

#define BTNSIZE CGSizeMake(296, 38)
@interface VEVipPackageCell () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UILabel *titleLab;                    //标题
@property (strong, nonatomic) UICollectionView *collectionView;     //中间的数据
@property (strong, nonatomic) UIButton *sureBtn;                    //开通按钮
@property (strong, nonatomic) YYLabel *protocolText;             //协议文字
@property (strong, nonatomic) UILabel *freeTypeLab;             //免费使用三天

@end

@implementation VEVipPackageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.collectionView];
        [self.contentView addSubview:self.freeTypeLab];
        [self.contentView addSubview:self.sureBtn];
        [self.contentView addSubview:self.protocolText];
        [self setAllViewLayout];
//        if ([LMUserManager sharedManger].userInfo.vipState.intValue == 0) {
//            self.freeTypeLab.hidden = NO;
//        }else{
//            self.freeTypeLab.hidden = YES;
//        }
    }
    return self;
}

- (void)setAllViewLayout{
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.top.mas_equalTo(15);
    }];
    
    @weakify(self);
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(14);
        make.right.mas_equalTo(-14);
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(14);
        make.height.mas_offset([VEVipPackageSubCell celHeight] + 10);
    }];
    
    [self.freeTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.collectionView.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.collectionView.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(BTNSIZE);
    }];
    
    [self.protocolText mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.sureBtn.mas_bottom).mas_offset(8);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.mas_equalTo(25);
    }];
    
//    if ([LMUserManager sharedManger].userInfo.vipState.intValue > 0) {
//        [self.sureBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.collectionView.mas_bottom).mas_offset(10);
//        }];
//    }
}

- (UILabel *)freeTypeLab{
    if (!_freeTypeLab) {
        _freeTypeLab = [UILabel new];
        _freeTypeLab.font = [UIFont systemFontOfSize:12];
        _freeTypeLab.textColor = [UIColor colorWithHexString:@"ff9853"];
        _freeTypeLab.text = @"首次开通VIP，可免费使用3天";
        _freeTypeLab.textAlignment = NSTextAlignmentCenter;
        _freeTypeLab.hidden = YES;
    }
    return _freeTypeLab;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:18];
        _titleLab.textColor = [UIColor colorWithHexString:@"ffffff"];
        _titleLab.text = @"会员套餐";
    }
    return _titleLab;
}

- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton new];
        [_sureBtn setTitle:@"立即开通" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        UIImage *bgImage = [VETool colorGradientWithStartColor:[UIColor colorWithHexString:@"6156FC"] endColor:[UIColor colorWithHexString:@"1DABFD"] ifVertical:NO imageSize:BTNSIZE];
        [_sureBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
        _sureBtn.layer.masksToBounds = YES;
        _sureBtn.layer.cornerRadius = BTNSIZE.height/2;
        [_sureBtn addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (YYLabel *)protocolText{
    if (!_protocolText) {
        _protocolText = [YYLabel new];
        _protocolText.textAlignment = NSTextAlignmentCenter;
        UIColor *color = [UIColor colorWithHexString:@"ffffff"];
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:12], NSForegroundColorAttributeName: color};
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"充值即代表同意懒人视频《VIP会员服务协议》" attributes:attributes];
        [text setTextHighlightRange:[[text string] rangeOfString:@"《VIP会员服务协议》"] color:[UIColor colorWithHexString:@"#528DF0"] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            VEWebTermsViewController *webVC = [VEWebTermsViewController new];
            webVC.hidesBottomBarWhenPushed = YES;
            webVC.loadUrl = WEB_VIP_URL;
            webVC.title = @"VIP会员服务协议";
            [currViewController().navigationController pushViewController:webVC animated:YES];
        }];
        _protocolText.attributedText = text;
    }
    return _protocolText;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
        [fl setScrollDirection:UICollectionViewScrollDirectionVertical];
        fl.minimumLineSpacing = 4;
        fl.minimumInteritemSpacing = 4;
        fl.itemSize = CGSizeMake((kScreenWidth - 14 - 14- 20)/3, [VEVipPackageSubCell celHeight]);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:fl];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[VEVipPackageSubCell class] forCellWithReuseIdentifier:VEVipPackageSubCellStr];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.moneyArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger num = self.moneyArr.count;
    if (num < 1) {
        num = 3;
    }
    return CGSizeMake((kScreenWidth - 28 - ((num - 1) * 8))/num, [VEVipPackageSubCell celHeight]);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VEVipPackageSubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VEVipPackageSubCellStr forIndexPath:indexPath];
    if (self.moneyArr.count > indexPath.row) {
        cell.model = self.moneyArr[indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    for (VEVIPMoneyModel *subModel in self.moneyArr) {
        subModel.ifSelect = NO;
    }
    if (self.moneyArr.count > indexPath.row) {
        VEVIPMoneyModel *model = self.moneyArr[indexPath.row];
        model.ifSelect = YES;
    }
    [self.collectionView reloadData];

}

+ (CGFloat)cellHeight{
//    if ([LMUserManager sharedManger].userInfo.vipState.intValue == 0) {
//        return [VEVipPackageSubCell celHeight] + 44 + 10 + BTNSIZE.height + 70 + 30;
//    }else{
        return [VEVipPackageSubCell celHeight] + 44 + 10 + BTNSIZE.height + 70;
//    }
}
- (void)setMoneyArr:(NSArray *)moneyArr{
    _moneyArr = moneyArr;
    [self.collectionView reloadData];
}

- (void)clickSureBtn{
    //取到当前选中的model
    VEVIPMoneyModel *model;
    for (VEVIPMoneyModel *subModel in self.moneyArr) {
        if (subModel.ifSelect) {
            model = subModel;
            break;
        }
    }
    
    if (model) {
        if (self.clickSureBtnBlock) {
            self.clickSureBtnBlock(model);
        }
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
