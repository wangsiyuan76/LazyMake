//
//  VEChangeTextView.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/22.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEChangeTextView.h"

static NSString *LMChangeTextCellStr = @"LMChangeTextCell";

@interface LMChangeTextCell : UITableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) UILabel *lab;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UITextField *textF;

@end

@implementation LMChangeTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.lab];
        [self.contentView addSubview:self.textF];
        [self.contentView addSubview:self.lineView];
        [self.lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        [self.textF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (UILabel *)lab{
    if (!_lab) {
        _lab = [UILabel new];
        _lab.font = [UIFont systemFontOfSize:15];
        _lab.textColor = [UIColor colorWithHexString:@"#A1A7B2"];
        _lab.textAlignment = NSTextAlignmentCenter;
        _lab.hidden = YES;
    }
    return _lab;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = MAIN_NAV_COLOR;
    }
    return _lineView;
}

- (UITextField *)textF{
    if (!_textF) {
        _textF = [[UITextField alloc]init];
        _textF.font = [UIFont systemFontOfSize:15];
        _textF.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _textF.textAlignment = NSTextAlignmentCenter;
        _textF.delegate = self;
    }
    return _textF;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end

@implementation VEChangeTextView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.cancleBtn];
        [self addSubview:self.sureBtn];
        [self addSubview:self.titleLab];
        [self addSubview:self.tableView];
        [self setAllViewLayout];
    }
    return self;
}

- (void)setAllViewLayout{
    @weakify(self);
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.cancleBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.mas_equalTo(self.sureBtn.mas_centerY);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton new];
        [_sureBtn setImage:[UIImage imageNamed:@"vm_icon_popover_complete"] forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (UIButton *)cancleBtn{
    if (!_cancleBtn) {
        _cancleBtn = [UIButton new];
        [_cancleBtn setImage:[UIImage imageNamed:@"vm_icon_popover_close"] forState:UIControlStateNormal];
        [_cancleBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont boldSystemFontOfSize:18];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = @"点击替换文字";
        _titleLab.textColor = [UIColor colorWithHexString:@"ffffff"];
    }
    return _titleLab;
}

-  (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = self.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView registerClass:[LMChangeTextCell class] forCellReuseIdentifier:LMChangeTextCellStr];
    }
    return _tableView;
}

- (void)setListArr:(NSArray *)listArr{
    _listArr = listArr;
    [self.tableView reloadData];
}

- (void)clickSureBtn{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.listArr];
    for (int x = 0; x < self.tableView.visibleCells.count; x++) {
        LMChangeTextCell *subCell = self.tableView.visibleCells[x];
        [subCell.textF resignFirstResponder];
        [arr replaceObjectAtIndex:x withObject:subCell.textF.text];
    }
    if (self.clickDoneBtnBlock) {
        self.clickDoneBtnBlock(YES,self.selectIndex,arr);
    }
}

- (void)clickCancelBtn{
    for (int x = 0; x < self.tableView.visibleCells.count; x++) {
        LMChangeTextCell *subCell = self.tableView.visibleCells[x];
        [subCell.textF resignFirstResponder];
    }
    if (self.clickDoneBtnBlock) {
        self.clickDoneBtnBlock(NO,self.selectIndex,@[]);
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LMChangeTextCell *cell = [tableView dequeueReusableCellWithIdentifier:LMChangeTextCellStr];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[LMChangeTextCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LMChangeTextCellStr];
    }
    if (self.listArr.count > indexPath.row) {
        cell.lab.text = self.listArr[indexPath.row];
        cell.textF.text = self.listArr[indexPath.row];
    }
//    if (self.selectIndex == indexPath.row) {
//        cell.lab.textColor = [UIColor colorWithHexString:@"ffffff"];
//    }else{
//        cell.lab.textColor = [UIColor colorWithHexString:@"A1A7B2"];
//    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = self.backgroundColor;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectIndex = indexPath.row;
    [self.tableView reloadData];
}


+ (CGFloat)viewHeighCount:(NSInteger)count{
    return 45*count+60;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
