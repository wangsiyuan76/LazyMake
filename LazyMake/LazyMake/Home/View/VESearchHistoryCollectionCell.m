//
//  VESearchHistoryCollectionCell.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/2.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VESearchHistoryCollectionCell.h"

@interface VESearchHistoryCollectionCell ()

@property (strong, nonatomic) NSMutableArray *hicArr;

@end

@implementation VESearchHistoryCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.labelSelect = [[JYLabelsSelect alloc] initWith:CGPointMake(0, 0) width:SCREEN_WIDTH - 30];
        self.labelSelect.dataSource = @[];
        self.labelSelect.minRowSpace = 8;
        self.labelSelect.minMarginSpace = UIEdgeInsetsMake(5, 5, 10, 5);
        self.labelSelect.hidden = YES;
  
        _labelSelect.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_labelSelect];
    }return self;
}

- (CGFloat)createCellHeightWithTagArr:(NSArray *)tagArr{
    if (tagArr.count < 1) {
        self.labelSelect.hidden = YES;
        self.cellHeight = CGFLOAT_MIN;
        return self.cellHeight;
    }
    self.labelSelect.hidden = NO;
    [_labelSelect removeAllLabs];

    NSMutableArray *hicArr = [NSMutableArray new];
    for (NSString *tagStr in tagArr) {
        UILabel *menuLabel = [UILabel new];
        menuLabel.textAlignment = NSTextAlignmentCenter;
        menuLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        menuLabel.text = tagStr;
        menuLabel.font = [UIFont systemFontOfSize:13];
        CGFloat width = [menuLabel widthOfSizeToFit];
        menuLabel.frame = CGRectMake(0, 0, width + 15 + 15, 26);
        menuLabel.layer.cornerRadius = 13.0;
        menuLabel.clipsToBounds = YES;
        menuLabel.backgroundColor = MAIN_NAV_COLOR;
        [hicArr addObject:menuLabel];
    }
    [self.labelSelect addLabels:hicArr];
    self.cellHeight = self.labelSelect.frame.size.height;
    return self.cellHeight;
}

@end
