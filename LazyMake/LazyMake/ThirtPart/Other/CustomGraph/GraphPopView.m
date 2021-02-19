
//
//  GraphPopView.m
//  mworkingHaier
//
//  Created by Saborka on 26/12/2016.
//  https://github.com/sensejump/CustomGraphView
//

#import "GraphPopView.h"

static CGFloat const popHeight = 25;

@interface GraphPopView ()

@property (strong, nonatomic) UIColor *bgColor;
@property (strong, nonatomic) NSString *numberString;
@property (strong, nonatomic) UILabel *numberLabel;

@end

@implementation GraphPopView

- (instancetype)initWithFrame:(CGRect)frame
                      bgColor:(UIColor *)bgColor
                       string:(NSString *)string
{
    self = [super initWithFrame:frame];
    if (self) {
        _numberString = string;
        _bgColor = bgColor;
        [self uiConfig];
    }
    return self;
}

- (void)uiConfig
{
    self.backgroundColor = _bgColor;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = popHeight / 2;
    
    CGFloat width = [self getWidthWithString:_numberString withSize:CGSizeMake(SCREEN_WIDTH , popHeight) font:[UIFont fontWithName:@"PingFangSC-Regular" size:12]];
    self.width = width + 20;
    self.height = popHeight;
    [self addSubview:self.numberLabel];
}

//获得label宽度
- (CGFloat)getWidthWithString:(NSString *)string withSize:(CGSize)size font:(UIFont *)font
{
    if (!string.length) {
        return 0;
    }
    
    float width = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.width;
    width = ceilf(width);
    return width;
}

- (UILabel *)numberLabel
{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.width - 20, popHeight)];
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _numberLabel.text = _numberString;
        _numberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numberLabel;
}

@end
