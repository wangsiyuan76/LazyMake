//
//  VEHomeHeadFeaturesView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/2.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEHomeHeadFeaturesView.h"
#import "VEHomeHeadEffectCell.h"
#import "VEHomeToolEnumCell.h"
@interface VEHomeHeadFeaturesView () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation VEHomeHeadFeaturesView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return self;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[VEHomeHeadEffectCell class] forCellReuseIdentifier:VEHomeHeadEffectCellStr];
        [_tableView registerClass:[VEHomeToolEnumCell class] forCellReuseIdentifier:VEHomeToolEnumCellStr];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellID"];
    }
    return _tableView;
}

- (void)setToolList:(NSArray *)toolList{
    _toolList = toolList;
    [self.tableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return [VEHomeHeadEffectCell cellHeight];
    }else if (indexPath.row == 1){
        return [VEHomeToolEnumCell cellHeight];
    }else{
        return 10;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        VEHomeHeadEffectCell *cell = [tableView dequeueReusableCellWithIdentifier:VEHomeHeadEffectCellStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[VEHomeHeadEffectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VEHomeHeadEffectCellStr];
        }
        return cell;
    }else if (indexPath.row == 1){
        VEHomeToolEnumCell *cell = [tableView dequeueReusableCellWithIdentifier:VEHomeToolEnumCellStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[VEHomeToolEnumCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VEHomeToolEnumCellStr];
        }
        cell.toolList = self.toolList;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == 2) {
        cell.backgroundColor = MAIN_NAV_COLOR;
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
