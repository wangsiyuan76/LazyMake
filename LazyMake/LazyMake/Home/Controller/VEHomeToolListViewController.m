//
//  VEHomeToolListViewController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/1.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEHomeToolListViewController.h"
#import "VEHomeToolSubCell.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "NetworkManage.h"
#import "VESelectVideoController.h"
#import "VEHomeApi.h"
#import "VEHomeToolTeachCell.h"
#import "VEHomeTeachListViewController.h"
#import "VETeachDetailViewController.h"
#import "VESelectMoreGridSelectController.h"
#import "VECutoutImageController.h"

@interface VEHomeToolListViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *hotArr;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) NSMutableArray *guideArr;

@end

@implementation VEHomeToolListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_NAV_COLOR;
    self.title = @"工具箱";
    [self loadData];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    // Do any additional setup after loading the view.
}

- (void)loadTeachData{
    [MBProgressHUD showMessage:@"加载中..."];
    [[VEHomeApi sharedApi]ve_loadTeachDataWithPageSize:@"6" Completion:^(VEBaseModel *  _Nonnull result) {
        [MBProgressHUD hideHUD];
        if (result.state.intValue == 1) {
            self.guideArr = [NSMutableArray new];
            [self.guideArr addObjectsFromArray:result.resultArr];
            [self.collectionView reloadData];
        }else{
            [MBProgressHUD showError:result.errorMsg];
        }
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:VENETERROR];
    }];
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewLeftAlignedLayout *fl = [[UICollectionViewLeftAlignedLayout alloc]init];
        [fl setScrollDirection:UICollectionViewScrollDirectionVertical];
        fl.headerReferenceSize = CGSizeMake(kScreenWidth, 60);
        fl.footerReferenceSize = CGSizeMake(kScreenWidth, 10);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:fl];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = YES;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = MAIN_NAV_COLOR;
        [_collectionView registerClass:[VEHomeToolSubCell class] forCellWithReuseIdentifier:VEHomeToolSubCellStr];
        [_collectionView registerClass:[VEHomeToolTeachCell class] forCellWithReuseIdentifier:VEHomeToolTeachCellStr];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];

    }
    return _collectionView;
}

- (void)loadData{
    [self loadTeachData];
    self.hotArr = [NSMutableArray new];
    NSArray *hotImageArr = @[@"vm_tool_video",@"vm_tool_video_add",@"vm_tool_cutout",@"vm_tool_music",@"vm_tool_watermark",@"vm_tool_audio"];
    NSArray *hotTitleArr = @[@"多格视频",@"视频拼接",@"人像抠图",@"更换音乐",@"去水印",@"提取音频"];
    for (int x = 0; x < hotImageArr.count; x++) {
        VEHomeToolModel *model = [VEHomeToolModel new];
        model.imageName = hotImageArr[x];
        model.name = hotTitleArr[x];
        [self.hotArr addObject:model];
    }
    
    self.dataArr = [NSMutableArray new];
    NSArray *imageArr = @[@"vm_tool_tailoring",@"vm_tool_cover",@"vm_tool_mirror",@"vm_tool_back",@"vm_tool_speed",@"vm_tool_filter",@"vm_tool_gif"];
    NSArray *titleArr = @[@"区域剪裁",@"加封面",@"镜像视频",@"视频倒放",@"加减速",@"加滤镜",@"生成GIF"];
    for (int x = 0; x < imageArr.count; x++) {
        VEHomeToolModel *model = [VEHomeToolModel new];
        model.imageName = imageArr[x];
        model.name = titleArr[x];
        [self.dataArr addObject:model];
    }
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        if (self.hotArr.count % 4 > 0) {
            return self.hotArr.count + (self.hotArr.count % 4);
        }
        return self.hotArr.count;
    }else if (section == 1){
        if (self.dataArr.count % 4 > 0) {
            return self.dataArr.count + (4-(self.dataArr.count % 4));
        }
    }
    return self.guideArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        CGFloat w = (kScreenWidth-6)/3;
        if (indexPath.row % 3 == 0) {
            w += 6;
        }else if (indexPath.row % 3 == 1) {
            w -= 6;
        }
        return CGSizeMake(w, (kScreenWidth-36)/3);
    }
    return CGSizeMake((kScreenWidth)/4, 80);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 2) {
        return 3;
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor colorWithHexString:@"0B0E22"];
        for (UIView *subV in headerView.subviews) {
            [subV removeFromSuperview];
        }
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(14, 20, 100, 30)];
        lab.textColor = [UIColor colorWithHexString:@"1DABFD"];
        lab.font = [UIFont systemFontOfSize:18];
        
        UIButton *moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth -  100, 0, 100, 60)];
        [moreBtn setTitle:@"查看全部" forState:UIControlStateNormal];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [moreBtn setTitleColor:[UIColor colorWithHexString:@"#A1A7B2"] forState:UIControlStateNormal];
        [moreBtn setImage:[UIImage imageNamed:@"vm_icon_next"] forState:UIControlStateNormal];
        [VETool changeBtnStyleWithType:LMBtnImageTitleType_ImagRight distance:4 andBtn:moreBtn];
        moreBtn.hidden = YES;
        [moreBtn addTarget:self action:@selector(clickMoreBtn) forControlEvents:UIControlEventTouchUpInside];

        if (indexPath.section == 0) {
            lab.text = @"热门工具";
        }else if (indexPath.section == 1) {
            lab.text = @"其他工具";
        }else if (indexPath.section == 2) {
            lab.text = @"新手教程";
            moreBtn.hidden = NO;
        }
        [headerView addSubview:lab];
        [headerView addSubview:moreBtn];
        return headerView;
    }else{
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        footerView.backgroundColor = MAIN_NAV_COLOR;
        if (indexPath.section == 2) {
            footerView.backgroundColor = [UIColor colorWithHexString:@"0B0E22"];
        }
        return footerView;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        VEHomeToolTeachCell *teaCell = [collectionView dequeueReusableCellWithReuseIdentifier:VEHomeToolTeachCellStr forIndexPath:indexPath];
        teaCell.contentView.backgroundColor = [UIColor colorWithHexString:@"0B0E22"];
        if (self.guideArr.count > indexPath.row) {
            [teaCell setModel:self.guideArr[indexPath.row] andIndex:indexPath.row lineNum:3];
        }
        return teaCell;
    }
    VEHomeToolSubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VEHomeToolSubCellStr forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithHexString:@"0B0E22"];
    if (indexPath.section == 0) {
        if (self.hotArr.count > indexPath.row) {
            cell.model = self.hotArr[indexPath.row];
        }else{
            [cell hiddenAll];
        }
    }else{
        if (self.dataArr.count > indexPath.row) {
            cell.model = self.dataArr[indexPath.row];
        }else{
            [cell hiddenAll];
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        [self clickTeachItemWithIndex:indexPath.row];
        return;
    }
    LMEditVideoType type = LMEditVideoTypeCrop;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            type = LMEditVideoTypeVideoLattice;
        }else if(indexPath.row == 1){
            type = LMEditVideoTypeVideoSplice;
        }else if(indexPath.row == 2){
            type = LMEditVideoTypeVideoCatout;
        }else if(indexPath.row == 3){
            type = LMEditVideoTypeWatermark;
        }else if(indexPath.row == 4){
            type = LMEditVideoTypeChangeAudio;
        }else if(indexPath.row == 5){
            type = LMEditVideoTypeOutAudio;
        }
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            type = LMEditVideoTypeCrop;
        }else if (indexPath.row == 1) {
            type = LMEditVideoTypeCover;
        }else if (indexPath.row == 2) {
            type = LMEditVideoTypeMirror;
        }else if (indexPath.row == 3) {
            type = LMEditVideoTypeBack;
        }else if (indexPath.row == 4) {
            type = LMEditVideoTypeSpeed;
        }else if (indexPath.row == 5) {
            type = LMEditVideoTypeFilter;
        }else if (indexPath.row == 6) {
            type = LMEditVideoTypeGIF;
        }else{
            return;
        }
    }
    if (type == LMEditVideoTypeVideoLattice) {
        VESelectMoreGridSelectController *vc = [[VESelectMoreGridSelectController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(type == LMEditVideoTypeVideoCatout){
        VECutoutImageController *vc = [[VECutoutImageController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        VESelectVideoController *vc = [[VESelectVideoController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.videoType = type;
        [currViewController().navigationController pushViewController:vc animated:YES];
    }
}

- (void)clickMoreBtn{
    VEHomeTeachListViewController *vc = [[VEHomeTeachListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickTeachItemWithIndex:(NSInteger)index{
    if (self.guideArr.count > index) {
        VETeachListModel *model = self.guideArr[index];
        VETeachDetailViewController *vc = [[VETeachDetailViewController alloc]init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
