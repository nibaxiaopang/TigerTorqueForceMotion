//
//  TigerTorquePrivacyVC.m
//  TigerTorqueForceMotion
//
//  Created by Tiger Torque ForceMotion on 2024/10/25.
//

#import "TigerTorquePrivacyVC.h"
#import <WebKit/WebKit.h>
#import <Photos/Photos.h>
#import "TigerTorqueUUDInstance.h"
#import "UIViewController+Extentsion.h"

@interface TigerTorquePrivacyVC ()<WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate, WKDownloadDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *idcView;
@property (weak, nonatomic) IBOutlet WKWebView *wbView;
@property (weak, nonatomic) IBOutlet UIButton *BackBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCos;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomCos;

@property (nonatomic, strong) NSURL *donFiUR;
@property (nonatomic, copy) void(^backAction)(void);
@property (nonatomic, copy) NSString *extUrlstring;

@property (nonatomic, strong) NSDictionary *confData;
@property (nonatomic, assign) BOOL bju;
@end

@implementation TigerTorquePrivacyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.confData = [NSUserDefaults.standardUserDefaults objectForKey:@"TigerTorqueDegData"];
    self.bju = [[self.confData objectForKey:@"bju"] boolValue];
    [self TorquePrivacyInitSubViews];
    [self TorqueInitConfigNav];
    [self TorqueInitWebViewConfig];
    [self TorqueInitWebData];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (self.confData) {
        NSInteger top = [[self.confData objectForKey:@"top"] integerValue];
        NSInteger bottom = [[self.confData objectForKey:@"bottom"] integerValue];
        if (top>0) {
            self.topCos.constant = self.view.safeAreaInsets.top;
        }
        
        if (bottom>0) {
            self.bottomCos.constant = self.view.safeAreaInsets.bottom;
        }
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape;
}

#pragma mark Event
- (IBAction)popAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backClick
{
    if (self.backAction) {
        self.backAction();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark INIT
- (void)TorquePrivacyInitSubViews
{
    self.wbView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.view.backgroundColor = UIColor.blackColor;
    self.wbView.backgroundColor = [UIColor blackColor];
    self.wbView.opaque = NO;
    self.wbView.scrollView.backgroundColor = [UIColor blackColor];
    self.idcView.hidesWhenStopped = YES;
}

- (void)TorqueInitConfigNav
{
    self.BackBtn.hidden = self.navigationController == nil;
    if (!self.url.length) {
        self.wbView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        return;
    }
    
    self.BackBtn.hidden = YES;
    self.navigationController.navigationBar.tintColor = [UIColor systemBlueColor];
    UIImage *image = [UIImage systemImageNamed:@"xmark"];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)TorqueInitWebViewConfig
{
    if (self.confData) {
        NSInteger type = [[self.confData objectForKey:@"type"] integerValue];
        WKUserContentController *userContentC = self.wbView.configuration.userContentController;
        // w
        if (type == 1) {
            NSString *trackStr = @"window.jsBridge = {\n    postMessage: function(name, data) {\n        window.webkit.messageHandlers.RatFindMSGHandle.postMessage({name, data})\n    }\n};\n";
            WKUserScript *trackScript = [[WKUserScript alloc] initWithSource:trackStr injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
            [userContentC addUserScript:trackScript];
            
            NSString *version = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
            if (!version) {
                version = @"";
            }
            NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
            if (!bundleId) {
                bundleId = @"";
            }
            NSString *inPPStr = [NSString stringWithFormat:@"window.WgPackage = {name: '%@', version: '%@'}", bundleId, version];
            WKUserScript *inPPScript = [[WKUserScript alloc] initWithSource:inPPStr injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
            [userContentC addUserScript:inPPScript];
            [userContentC addScriptMessageHandler:self name:@"RatFindMSGHandle"];
        }
        
        // afu
        else {
            [userContentC addScriptMessageHandler:self name:@"jsBridge"];
        }
    }
    
    self.wbView.navigationDelegate = self;
    self.wbView.UIDelegate = self;
}

- (void)TorqueInitWebData
{
    if (self.url.length) {
        NSURL *url = [NSURL URLWithString:self.url];
        if (url == nil) {
            return;
        }
        [self.idcView startAnimating];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.wbView loadRequest:request];
    } else {
        NSURL *url = [NSURL URLWithString:self.TorqueMainPrivacyUrl];
        if (url == nil) {
            return;
        }
        [self.idcView startAnimating];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.wbView loadRequest:request];
    }
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSString *name = message.name;
    if ([name isEqualToString:@"RatFindMSGHandle"]) {
        NSDictionary *trackMessage = (NSDictionary *)message.body;
        NSString *tName = trackMessage[@"name"] ?: @"";
        NSString *tData = trackMessage[@"data"] ?: @"";
        NSData *data = [tData dataUsingEncoding:NSUTF8StringEncoding];
        
        if (data) {
            NSError *error;
            id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (!error && [jsonObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = jsonObject;
                if (![tName isEqualToString:@"openWindow"]) {
                    [self TorqueSendEvent:tName values:dic];
                    return;
                }
                if ([tName isEqualToString:@"rechargeClick"]) {
                    return;
                }
                NSString *adId = dic[@"url"] ?: @"";
                if (adId.length > 0) {
                    [self TorqueReloadWbViewData:adId];
                }
            }
        } else {
            [self TorqueSendEvent:tName values:@{tName: data}];
        }
    }  else if ([message.name isEqualToString:@"jsBridge"] && [message.body isKindOfClass:[NSString class]]) {
        NSDictionary *dic = [self TorqueJsonToDicWithJsonString:(NSString *)message.body];
        NSString *evName = dic[@"funcName"] ?: @"";
        NSString *evParams = dic[@"params"] ?: @"";
        if ([evName isEqualToString:@"openAppBrowser"]) {
            NSDictionary *uDic = [self TorqueJsonToDicWithJsonString:evParams];
            NSString *urlStr = uDic[@"url"] ?: @"";
            NSURL *url = [NSURL URLWithString:urlStr];
            if (url && [[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            }
        } else if ([evName isEqualToString:@"appsFlyerEvent"]) {
            [self TorqueSendEventsWithParams:evParams];
        }
    }
}

- (void)TorqueReloadWbViewData:(NSString *)adurl
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.extUrlstring isEqualToString:adurl] && self.bju) {
            return;
        }
        
        TigerTorquePrivacyVC *adView = [self.storyboard instantiateViewControllerWithIdentifier:@"TigerTorquePrivacyVC"];
        adView.url = adurl;
        __weak typeof(self) weakSelf = self;
        adView.backAction = ^{
            NSString *close = @"window.closeGame();";
            [weakSelf.wbView evaluateJavaScript:close completionHandler:nil];
        };
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:adView];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:nav animated:YES completion:nil];
    });
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.idcView stopAnimating];
    });
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.idcView stopAnimating];
    });
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction preferences:(WKWebpagePreferences *)preferences decisionHandler:(void (^)(WKNavigationActionPolicy, WKWebpagePreferences *))decisionHandler {
    if (@available(iOS 14.5, *)) {
        if (navigationAction.shouldPerformDownload) {
            decisionHandler(WKNavigationActionPolicyDownload, preferences);
            NSLog(@"%@", navigationAction.request);
            [webView startDownloadUsingRequest:navigationAction.request completionHandler:^(WKDownload *down) {
                down.delegate = self;
            }];
        } else {
            decisionHandler(WKNavigationActionPolicyAllow, preferences);
        }
    } else {
        decisionHandler(WKNavigationActionPolicyAllow, preferences);
    }
}

#pragma mark - WKUIDelegate
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (navigationAction.targetFrame == nil) {
        NSURL *url = navigationAction.request.URL;
        if (url) {
            self.extUrlstring = url.absoluteString;
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    }
    return nil;
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    
    NSString *authenticationMethod = challenge.protectionSpace.authenticationMethod;
    if ([authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *credential = nil;
        if (challenge.protectionSpace.serverTrust) {
            credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        }
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
    }
}

#pragma mark - WKDownloadDelegate
- (void)download:(WKDownload *)download decideDestinationUsingResponse:(NSURLResponse *)response suggestedFilename:(NSString *)suggestedFilename completionHandler:(void (^)(NSURL *))completionHandler API_AVAILABLE(ios(14.5)){
    NSString *tempDir = NSTemporaryDirectory();
    NSURL *tempDirURL = [NSURL fileURLWithPath:tempDir isDirectory:YES];
    NSURL *destinationURL = [tempDirURL URLByAppendingPathComponent:suggestedFilename];
    self.donFiUR = destinationURL;
    if ([[NSFileManager defaultManager] fileExistsAtPath:destinationURL.path]) {
        [self saveDownloadedFileToPhotoAlbum:self.donFiUR];
    }
    completionHandler(destinationURL);
}

- (void)download:(WKDownload *)download didFailWithError:(NSError *)error API_AVAILABLE(ios(14.5)){
    NSLog(@"Download failed: %@", error.localizedDescription);
}

- (void)downloadDidFinish:(WKDownload *)download API_AVAILABLE(ios(14.5)){
    NSLog(@"Download finished successfully.");
    [self saveDownloadedFileToPhotoAlbum:self.donFiUR];
}

- (void)saveDownloadedFileToPhotoAlbum:(NSURL *)fileURL API_AVAILABLE(ios(14.5)){
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                [PHAssetCreationRequest creationRequestForAssetFromImageAtFileURL:fileURL];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (success) {
                        [self TorqueShowAlertWithTitle:@"sucesso" message:@"A imagem foi salva no álbum."];
                    } else {
                        [self TorqueShowAlertWithTitle:@"erro" message:[NSString stringWithFormat:@"Falha ao salvar a imagem: %@", error.localizedDescription]];
                    }
                });
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self TorqueShowAlertWithTitle:@"Photo album access denied." message:@"Please enable album access in settings."];
            });
            NSLog(@"Photo album access denied.");
        }
    }];
}

@end
