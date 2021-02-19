//
//  VEVipFeaturesListCell.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/7.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEVipFeaturesListCell.h"
#import "VEVipFeaturesListSubCell.h"
#import "VEVIPMoneyModel.h"

#define LINE_NUMBER 3               //每行显示cell的数量


@interface VEVipFeaturesListCell () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UILabel *titleLab;                    //标题
@property (strong, nonatomic) UICollectionView *collectionView;     //中间的数据
@property (strong, nonatomic) UIButton *serviceBtn;                 //联系客服按钮
@property (strong, nonatomic) NSMutableArray *enumArr;

@end

@implementation VEVipFeaturesListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.collectionView];
        [self.contentView addSubview:self.serviceBtn];
        [self setAllViewLayout];
        [self createData];
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
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(14);
        make.bottom.mas_offset(-10);
    }];
    
    [self.serviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.mas_equalTo(self.titleLab.mas_centerY);
        make.right.mas_equalTo(-14);
    }];
}

- (void)createData{
    self.enumArr = [NSMutableArray new];
    NSArray *titleArr = @[@"定制模板",@"视频编辑",@"去水印",@"去广告",@"更换音乐",@"提取音频",@"区域剪裁",@"视频加封面",@"镜像视频",@"视频倒放",@"视频加减速",@"视频加滤镜",@"视频生成GIF",@"会员标识",@"专属客服"];
    NSArray *imageArr = @[@"vm_vip_custom",@"vm_vip_video_add",@"vm_vip_watermark",@"vm_vip_ad",@"vm_vip_music",@"vm_vip_music_",@"vm_vip_tailoring",@"vm_vip_cover",@"vm_vip_mirror",@"vm_vip_back",@"vm_vip_speed",@"vm_vip_filter",@"vm_vip_gif",@"vm_vip_vip",@"vm_vilp_qq"];
    NSArray *contentArr = @[@"解锁所有VIP模板",@"生成无水印视频",@"无限次数使用",@"去除所有广告",@"生成无水印视频",@"无限次数使用",@"生成无水印视频",@"生成无水印视频",@"生成无水印视频",@"生成无水印视频",@"生成无水印视频",@"生成无水印视频",@"生成无水印视频",@"享有会员专属身份",@"优先接入服务"];
    for (int x = 0; x < titleArr.count; x++) {
        VEVIPMoneyModel *model = [VEVIPMoneyModel new];
        model.iconName = imageArr[x];
        model.titleStr = titleArr[x];
        model.contentStr = contentArr[x];
        [self.enumArr addObject:model];
    }
    [self.collectionView reloadData];
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:18];
        _titleLab.textColor = [UIColor colorWithHexString:@"ffffff"];
        _titleLab.text = @"会员特权";
    }
    return _titleLab;
}

- (UIButton *)serviceBtn{
    if (!_serviceBtn) {
        _serviceBtn = [UIButton new];
        [_serviceBtn setTitle:@"联系客服" forState:UIControlStateNormal];
        [_serviceBtn setTitleColor:[UIColor colorWithHexString:@"A1A7B2"] forState:UIControlStateNormal];
        _serviceBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_serviceBtn setImage:[UIImage imageNamed:@"vm_member_qq"] forState:UIControlStateNormal];
        [_serviceBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [_serviceBtn addTarget:self action:@selector(serviceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _serviceBtn;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
        [fl setScrollDirection:UICollectionViewScrollDirectionVertical];
        fl.minimumLineSpacing = 10;
        fl.minimumInteritemSpacing = 10;
        fl.itemSize = CGSizeMake((kScreenWidth - 10 - 20- ((LINE_NUMBER - 1) * 10))/LINE_NUMBER, [VEVipFeaturesListSubCell cellHeight]);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:fl];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[VEVipFeaturesListSubCell class] forCellWithReuseIdentifier:VEVipFeaturesListSubCellStr];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.enumArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VEVipFeaturesListSubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VEVipFeaturesListSubCellStr forIndexPath:indexPath];
    if (self.enumArr.count > indexPath.row) {
        cell.model = self.enumArr[indexPath.row];
    }
    return cell;
}

+ (CGFloat)cellHeight{
    return 60 + [VEVipFeaturesListSubCell cellHeight] * 5 + 10 * 5;
}

- (void)serviceBtnClick{
    NSString *numStr = [[NSUserDefaults standardUserDefaults]objectForKey:QQCustomerService];
    NSString *qq_number = numStr?:@"24136853";
    NSString *qq=[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",qq_number];
    NSURL *url = [NSURL URLWithString:qq];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {}];
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
