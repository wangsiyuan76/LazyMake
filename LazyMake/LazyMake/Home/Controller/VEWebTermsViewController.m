//
//  VEWebTermsViewController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/4/7.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEWebTermsViewController.h"

@interface VEWebTermsViewController () <WKUIDelegate,WKNavigationDelegate>

@end

@implementation VEWebTermsViewController

- (void)dealloc{
    LMLog(@"VEWebTermsViewController 页面释放");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_BLACK_COLOR;
    //self.navigationController.navigationBar.topItem.title = @"";
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.loadUrl]];
    [self.webView loadRequest:request];
    [self remeveLongPan];
}


/// 去掉webview的长按手势
- (void)remeveLongPan{
     //禁止长按弹出 UIMenuController 相关
      //禁止选择 css 配置相关
      NSString*css = @"body{-webkit-user-select:none;-webkit-user-drag:none;}";
      //css 选中样式取消
      NSMutableString*javascript = [NSMutableString string];
      [javascript appendString:@"var style = document.createElement('style');"];
      [javascript appendString:@"style.type = 'text/css';"];
      [javascript appendFormat:@"var cssContent = document.createTextNode('%@');", css];
      [javascript appendString:@"style.appendChild(cssContent);"];
      [javascript appendString:@"document.body.appendChild(style);"];
      [javascript appendString:@"document.documentElement.style.webkitUserSelect='none';"];//禁止选择
      [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];//禁止长按

      //javascript 注入
      WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript
      injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
      forMainFrameOnly:YES];
      WKUserContentController*userContentController = [[WKUserContentController alloc] init];
      [userContentController addUserScript:noneSelectScript];
      WKWebViewConfiguration*configuration = [[WKWebViewConfiguration alloc] init];
      configuration.userContentController = userContentController;
      //控件加载
      [self.webView.configuration.userContentController addUserScript:noneSelectScript];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.backBlock) {
        self.backBlock();
    }
}

- (WKWebView *)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:[WKWebViewConfiguration new]];
        _webView.backgroundColor = self.view.backgroundColor;
        _webView.allowsBackForwardNavigationGestures = NO;
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
    }
    return _webView;
}

#pragma mark 网页加载完成 延时0.2秒展示网页，，此时夜间模式的颜色已经修改完毕，，不会看到闪白了

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    self.webView.hidden = YES;
    [MBProgressHUD showMessage:@"加载中"];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    /// 延时0.2s 显示网页
    [self performSelector:@selector(showWebView) withObject:self afterDelay:0.2];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [MBProgressHUD hideHUD];
    self.webView.hidden = NO;
    [MBProgressHUD showError:@"加载失败"];
}


- (void)showWebView{
    self.webView.hidden = NO;
    [MBProgressHUD hideHUD];
    
    for (UIView* subview in self.webView.subviews) {
        for (UIGestureRecognizer* longPress in subview.gestureRecognizers) {
            if ([longPress isKindOfClass:UILongPressGestureRecognizer.class]) {
                [subview removeGestureRecognizer:longPress];
            }
        }
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
