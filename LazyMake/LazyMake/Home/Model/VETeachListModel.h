//
//  VETeachListModel.h
//  LazyMake
//
//  Created by xunruiIOS on 2020/6/2.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VETeachListModel : VEBaseModel

@property (strong, nonatomic) NSString *tID;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *thumb;
@property (strong, nonatomic) NSString *vedio;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *views;
@property (strong, nonatomic) NSString *upStr;                  //up
@property (strong, nonatomic) NSString *downStr;                //down
//0:无;1:编辑;2:弹幕;3:多格;4:换音乐;5:抠图;6:加封面;7:裁剪;8:取音频;9:镜像;10:生成GIF;11:去水印;12:加减速;13:加滤镜;14:模板制作
@property (strong, nonatomic) NSString *type;

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *is_hot;
@property (strong, nonatomic) NSString *inputtime;

@end

NS_ASSUME_NONNULL_END
