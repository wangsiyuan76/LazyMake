//
//  VEAETemplateCutoutController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/6/3.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEAETemplateCutoutController.h"
#import "HYHAddImageView.h"
#import "VEMainGuideView.h"
#import "VEVideoSucceedViewController.h"
#import "AppDelegate.h"

@interface VEAETemplateCutoutController ()

@property (strong, nonatomic) UIImageView *coverImage;              //背景图
@property (strong, nonatomic) HYHAddImageView *cropImage;           //可以拉伸缩放的view
@property (strong, nonatomic) UIButton *doneBtn;                    //完成按钮
@property (strong, nonatomic) UIButton *cutoutBtn;                  //一键抠图按钮
@property (strong, nonatomic) VEMainGuideView *guideV;              //引导view
@property (assign, nonatomic) NSInteger guideIndex;                 //引导view的index

@property (assign, nonatomic) CGSize imageSize;                     //原始图片大小
@property (assign, nonatomic) CGSize cropSize;                      //替换图片大小
@property (assign, nonatomic) CGSize showImageSize;                     //原始图片大小

@property (strong, nonatomic) UIImage *cropShowImage;                   //裁剪抠图后的图片
@property (assign, nonatomic) BOOL hasNextBDAi;                   //是否是第二次点击

@end

@implementation VEAETemplateCutoutController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_BLACK_COLOR;
    [self createHeadView];
    [self showGuideView];
    self.imageSize = [self setImageSize];
    self.cropSize = [self setCropSize];
    self.showImageSize = [self setShowImageSize];
    [self.view addSubview:self.cropImage];
    [self.view addSubview:self.coverImage];
    // Do any additional setup after loading the view.
}

-(void)createHeadView{
    self.doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 26)];
    [self.doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    UIImage *image = [VETool colorGradientWithStartColor:[UIColor colorWithHexString:@"#6156FC"] endColor:[UIColor colorWithHexString:@"#1DABFD"] ifVertical:NO imageSize:CGSizeMake(60, 26)];
    self.doneBtn.tag = 1;
    [self.doneBtn setBackgroundImage:image forState:UIControlStateNormal];
    [self.doneBtn addTarget:self action:@selector(clickDoneBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.doneBtn.layer.masksToBounds = YES;
    self.doneBtn.layer.cornerRadius = 13;
    self.doneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    self.cutoutBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 26)];
    self.cutoutBtn.tag = 2;
    [self.cutoutBtn setTitle:@"一键抠图" forState:UIControlStateNormal];
    UIImage *image2 = [VETool colorGradientWithStartColor:[UIColor colorWithHexString:@"#6156FC"] endColor:[UIColor colorWithHexString:@"#1DABFD"] ifVertical:NO imageSize:CGSizeMake(60, 26)];
    [self.cutoutBtn setBackgroundImage:image2 forState:UIControlStateNormal];
    [self.cutoutBtn addTarget:self action:@selector(clickDoneBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.cutoutBtn.layer.masksToBounds = YES;
    self.cutoutBtn.layer.cornerRadius = 13;
    self.cutoutBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    UIBarButtonItem *searchBtnBar = [[UIBarButtonItem alloc]initWithCustomView:self.doneBtn];
    UIBarButtonItem *searchBtnBar2 = [[UIBarButtonItem alloc]initWithCustomView:self.cutoutBtn];
    self.navigationItem.rightBarButtonItems = @[searchBtnBar,searchBtnBar2];
}

//显示引导的view
- (void)showGuideView{
    NSNumber *num = [[NSUserDefaults standardUserDefaults]objectForKey:@"AEEMPLATECUTOUTGUIDE"];
    if (num.boolValue == NO) {
        UIWindow *win = [UIApplication sharedApplication].keyWindow;
        self.guideV = [[VEMainGuideView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [self.guideV.subImage setImage:[UIImage imageNamed:@"vm_guide_zoom"]];
        self.guideV.subImage.frame = CGRectMake((kScreenWidth - 232)/2, (kScreenHeight - 154)/2, 232, 154);
        [win addSubview:self.guideV];
        [self.guideV showAll];
        self.guideIndex = 1;
        @weakify(self);
        self.guideV.clickMainBtnBlock = ^{
            @strongify(self);
            if (self.guideIndex == 1) {
                [self.guideV.subImage setImage:[UIImage imageNamed:@"vm_guide_cutout"]];
                self.guideV.subImage.frame = CGRectMake((kScreenWidth - 185 - 88), Height_NavBar + 10, 185, 80);
                self.guideIndex ++;

            }else{
                self.guideIndex ++;
                [self.guideV hiddenAll];
            }
        };
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"AEEMPLATECUTOUTGUIDE"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

- (void)clickDoneBtn:(UIButton *)btn{
    self.doneBtn.userInteractionEnabled = NO;
    self.cutoutBtn.userInteractionEnabled = NO;
    [self createNewImage:btn.tag==1?NO:YES];
}

- (HYHAddImageView *)cropImage{
    if (!_cropImage) {
        _cropImage = [[HYHAddImageView alloc]initWithFrame:CGRectMake(0, Height_NavBar, self.showImageSize.width, self.showImageSize.height)];
        _cropImage.addImage = self.selectImage;
        _cropImage.isEditing = YES;
        _cropImage.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
        _cropImage.backgroundColor = [UIColor clearColor];
        @weakify(self);
        _cropImage.ChangeImageBlock = ^(UIGestureRecognizerState type) {
            @strongify(self);
            if (type == UIGestureRecognizerStateBegan) {
                self.coverImage.alpha = 0.5f;
            }else if (type == UIGestureRecognizerStateEnded) {
                self.coverImage.alpha = 1;
            }
        };
    }
    return _cropImage;
}

- (UIImageView *)coverImage{
    if (!_coverImage) {
        _coverImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, Height_NavBar, self.imageSize.width, self.imageSize.height)];
        _coverImage.image = [self showCoverImage];
    }
    return _coverImage;
}

- (CGSize)setImageSize{
    CGSize imageSize = CGSizeMake(540, 960);
    CGFloat bili = imageSize.width/imageSize.height;
    CGFloat h = kScreenWidth/bili;
    return CGSizeMake(kScreenWidth, h);
}

- (CGSize)setShowImageSize{
    CGSize imageSize = self.selectImage.size;
    CGFloat bili = imageSize.width/imageSize.height;
    CGFloat newW = imageSize.width;
    CGFloat newH = imageSize.height;
    if (imageSize.width >= imageSize.height) {
        if (imageSize.width > kScreenWidth) {
            newW = kScreenWidth;
        }
        newH = newW/bili;
    }else{
        if (imageSize.height > kScreenHeight) {
            newH = kScreenHeight;
        }
        newW = newH*bili;
    }
    return CGSizeMake(newW, newH);
    
}

- (CGSize)setCropSize{
    if (self.showModel.customObj.images.count > 0) {
        LMHomeTemplateAEImageModel *imageModel = self.showModel.customObj.images[0];
        return CGSizeMake(imageModel.width.floatValue, imageModel.height.floatValue);
    }
  return [self setImageSize];
}

- (UIImage *)showCoverImage{
    NSError *error = [NSError new];
    NSFileManager *fileManager= [NSFileManager defaultManager];
    NSArray *fileList= [[NSArray alloc] init];
    fileList= [fileManager contentsOfDirectoryAtPath:self.showModel.unZipPath error:&error];
    for (NSString *file in fileList) {
        NSString *path = [self.showModel.unZipPath stringByAppendingPathComponent:file];
        if ([file containsString:@"cover"]) {
            NSString *coverPath = [NSString stringWithFormat:@"%@/cover_0",path];
            UIImage *image = [UIImage imageWithContentsOfFile:coverPath];
            return image;
        }
    }
    return nil;
}

//图片放大缩小旋转后生成的新图片
- (void)createNewImage:(BOOL)ifCutout {
//    self.cropShowImage = [self createNewImage];
    self.cropShowImage = [self screenImageWithSize:self.imageSize];
    UIImage *showImage = [self composeImg];

    if (ifCutout || self.hasNextBDAi == YES) {
        NSString *str = nil;
        if (self.hasNextBDAi) {
            str = @"图片合成中...";
        }
        [VETool baiduCutoutImageWithImage:showImage loadingStr:str Completion:^(UIImage * _Nonnull image) {
            self.doneBtn.userInteractionEnabled = YES;
            self.cutoutBtn.userInteractionEnabled = YES;
            if (!self.hasNextBDAi) {
                self.cropShowImage = image;
                self.cropImage.addImage = image;
                self.hasNextBDAi = YES;
            }else{
                if (self.selectBlock) {
                    self.selectBlock(image, YES);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSString * _Nonnull errorStr) {
            [MBProgressHUD showError:errorStr];
            self.doneBtn.userInteractionEnabled = YES;
            self.cutoutBtn.userInteractionEnabled = YES;
        }];
    }else{
        self.doneBtn.userInteractionEnabled = YES;
        self.cutoutBtn.userInteractionEnabled = YES;
        if (self.selectBlock) {
            self.selectBlock(showImage, YES);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//将纯色图片和放大缩小后的图片合成一张图片
- (UIImage *)composeImg {
    UIImage *img = self.cropShowImage;
    //以1.png的图大小为底图
    UIImage *img1 = [self buttonImageFromColor];
    CGImageRef imgRef1 = img1.CGImage;
    CGFloat w1 = CGImageGetWidth(imgRef1);
    CGFloat h1 = CGImageGetHeight(imgRef1);

 /*
  //目前只是屏幕截图，不需要计算坐标和大小，如果后期需要改动，则放开
  CGImageRef imgRef = img.CGImage;
  CGFloat w = CGImageGetWidth(imgRef);
  CGFloat h = CGImageGetHeight(imgRef);
  CGFloat oldw = CGImageGetWidth(self.selectImage.CGImage);
  CGFloat oldh = CGImageGetHeight(self.selectImage.CGImage);
  
  CGFloat biliW = oldw/w;
  CGFloat biliH = oldh/h;
  CGFloat biliImage = self.selectImage.size.width/self.selectImage.size.height;
  
  //生成的图片宽度
    CGFloat newW = w1/biliW;
    CGFloat newH = newW/biliImage;
    if (newW > w1 || newH > h1) {
        if (newW > w1 && newH > h1) {
            newW = w1;
            newH = h1;
        }else if(newW > w1 && newH < h1){
            newW = w1;
            newH = newW/biliImage;
        }else if(newW < w1 && newH > h1){
            newH = h1;
            newW = newH*biliImage;
        }

        LMLog(@"============%.2f ===========%.2f =======%@ =======%@",self.cropShowImage.scale,self.selectImage.scale,NSStringFromCGSize(self.cropShowImage.size),NSStringFromCGSize(self.selectImage.size));
        CGFloat subBili = self.cropShowImage.size.width/self.selectImage.size.width;
//        img = [self ct_imageFromImage:self.cropShowImage inRect:CGRectMake((fabs(self.cropImage.frame.origin.x)*subBili), fabs(self.cropImage.frame.origin.y)*subBili+Height_NavBar, w1*subBili, h1*subBili)];
//        img = [self getSubImage:CGRectMake((fabs(self.cropImage.frame.origin.x)*subBili), fabs(self.cropImage.frame.origin.y)*subBili+Height_NavBar, w1*subBili, h1*subBili)];
//        img =  [self screenImageWithSize:CGSizeMake(self.imageSize.width, self.imageSize.height)];
    }

    //计算坐标
    float oldX = self.cropImage.origin.x;
    float oldY = self.cropImage.origin.y-Height_NavBar;
    CGFloat biliX = oldX/self.imageSize.width;
    CGFloat biliY = oldY/self.imageSize.height;
    float newX = w1*biliX;
    float newY = h1*biliY;
    if (newX < 0) {
        newX = 0;
    }
    if (newY < 0) {
        newY = 0;
    }
    */

    //以1.png的图大小为画布创建上下文
    UIGraphicsBeginImageContext(CGSizeMake(w1, h1));
    [img1 drawInRect:CGRectMake(0, 0, w1, h1)];//先把1.png 画到上下文中
//    [img drawInRect:CGRectMake(newX, newY, newW, newH)];//再把小图放在上下文中
    [img drawInRect:CGRectMake(0, 0, w1, h1)];//先把1.png 画到上下文中

    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();//从当前上下文中获得最终图片
    UIGraphicsEndImageContext();//关闭上下文
//        UIImageWriteToSavedPhotosAlbum(resultImg, nil, nil, nil);
    return resultImg;
}

//通过颜色来生成一个纯色图片
- (UIImage *)buttonImageFromColor{
    CGRect rect = CGRectMake(0, 0, self.cropSize.width, self.cropSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

//截图
-(UIImage *)screenImageWithSize:(CGSize )imgSize{
    //调整样式，成适合截图的样式
    self.coverImage.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    self.cropImage.frame = CGRectMake(self.cropImage.frame.origin.x, self.cropImage.frame.origin.y-Height_NavBar, self.cropImage.frame.size.width, self.cropImage.frame.size.height+Height_NavBar);
    
    UIGraphicsBeginImageContext(imgSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate; //获取app的appdelegate，便于取到当前的window用来截屏
    [app.window.layer renderInContext:context];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
    
    //将样式改回来
    self.coverImage.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
    self.cropImage.frame = CGRectMake(self.cropImage.frame.origin.x, self.cropImage.frame.origin.y+Height_NavBar, self.cropImage.frame.size.width, self.cropImage.frame.size.height-Height_NavBar);
    
    //如果位置发生偏移则更改
//    CGFloat x = 0;
//    CGFloat y = 0;
//    if (self.cropImage.frame.origin.y > 0 || self.cropImage.frame.origin.x > 0 ) {
//        if (self.cropImage.frame.origin.x > 0) {
//            x = self.cropImage.frame.origin.x;
//        }
//        if (self.cropImage.frame.origin.y-Height_NavBar > 0) {
//             y = self.cropImage.frame.origin.y-Height_NavBar;
//        }
//        CGFloat w = imgSize.width - x;
//        CGFloat h = imgSize.height - y;
//        return [self ct_imageFromImage:img inRect:CGRectMake(x, y, w, h)];
//    }
    return img;
}

#pragma mrk - 目前用不到如果后期出现问题再使用
//图片放大， 缩小。旋转后生成新的图片
- (UIImage *)createNewImage{
    //旋转角度
    double rotationZ = [[self.cropImage.layer valueForKeyPath:@"transform.rotation.z"] doubleValue];
        
    rotationZ = 0;
    CGFloat biliW = self.showImageSize.width/self.cropImage.size.width;
    CGFloat biliH = self.showImageSize.height/self.cropImage.size.height;
    CGFloat imageW = self.selectImage.size.width/biliW;
    CGFloat imageH = self.selectImage.size.height/biliH;
    CGFloat biliImage = self.selectImage.size.width/self.selectImage.size.height;
    imageH = imageW/biliImage;
        
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,imageW, imageH)];
    CGAffineTransform t = CGAffineTransformMakeRotation(rotationZ);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    UIGraphicsBeginImageContextWithOptions(rotatedSize, NO, self.selectImage.scale);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap,rotationZ);
    CGContextScaleCTM(bitmap, 1, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-imageW / 2, -imageH / 2, imageW, imageH), [self.selectImage CGImage]);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //    LMLog(@"--asdfasdfasdf=-----%@========%@ ====%.2f ===== %@",NSStringFromCGSize(self.cropImage.size),NSStringFromCGSize(self.selectImage.size),rotationZ,NSStringFromCGSize(newImage.size));
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 *  从图片中按指定的位置大小截取图片的一部分
 */
- (UIImage *)ct_imageFromImage:(UIImage *)image inRect:(CGRect)rect{
    //把像 素rect 转化为 点rect（如无转化则按原图像素取部分图片）
//    CGFloat scale = [UIScreen mainScreen].scale;
//    CGFloat x= rect.origin.x*scale,y=rect.origin.y*scale,w=rect.size.width*scale,h=rect.size.height*scale;
//    CGRect dianRect = CGRectMake(x, y, w, h);
   CGRect dianRect = rect;

    //截取部分图片并生成新图片
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, dianRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil);
    return newImage;
}

-(UIImage *)getSubImage:(CGRect)squareFrame{
    CGFloat scaleRatio = self.cropImage.size.width / self.showImageSize.width;
    CGFloat x = (squareFrame.origin.x - self.cropImage.origin.x) / scaleRatio;
    CGFloat y = (squareFrame.origin.y - self.cropImage.origin.y) / scaleRatio;
    CGFloat w = squareFrame.size.width / scaleRatio;
    CGFloat h = squareFrame.size.height / scaleRatio;
    if (self.cropImage.size.width < squareFrame.size.width) {
        CGFloat newW = self.showImageSize.width;
        CGFloat newH = newW * (squareFrame.size.height / squareFrame.size.width);
        x = 0; y = y + (h - newH) / 2;
        w = newH; h = newH;
    }
    if (self.cropImage.size.height < squareFrame.size.height) {
        CGFloat newH = self.showImageSize.height;
        CGFloat newW = newH * (squareFrame.size.width / squareFrame.size.height);
        x = x + (w - newW) / 2; y = 0;
        w = newH; h = newH;
    }
    CGRect myImageRect = CGRectMake(x, y, w, h);
    CGImageRef imageRef = self.selectImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    CGSize size;
    size.width = myImageRect.size.width;
    size.height = myImageRect.size.height;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(subImageRef);
      UIImageWriteToSavedPhotosAlbum(smallImage, nil, nil, nil);
    return smallImage;
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
