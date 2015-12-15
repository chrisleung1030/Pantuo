//
//  PreviewViewController.m
//  PantuoGuide
//
//  Created by Christopher Leung on 4/5/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "PreviewViewController.h"
#import "AppDelegate.h"
#import "WebViewController.h"
#import "AddActivityViewController.h"
#import "LandingViewController.h"
#import "MyInfoDetailViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface PreviewViewController () <UIWebViewDelegate>

@property (nonatomic, retain) UIWebView *mWebView;

@end

@implementation PreviewViewController

- (NSString *) getTopBarTitle{
    if (self.useMyActivityTitle) {
        return GetStringWithKey(@"my_activities");
    }else{
        return GetStringWithKey(@"preview_activity");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTopBarTitleView];
    // Do any additional setup after loading the view from its nib.
    
    if (!self.activityImage) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:self.activityImageLink]
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                 // progression tracking code
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                if (image) {
                                    self.activityImage = image;
                                }
                            }];
    }
    
    self.mWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, SCREEN_HEIGHT-90)];
    self.mWebView.delegate = self;
    [self.view addSubview:self.mWebView];
    if (self.showEdit) {
        [self.topBarTitleView.editButton setHidden:NO];
        [self.topBarTitleView.editButton setTitle:GetStringWithKey(@"edit") forState:UIControlStateNormal];
        [self.topBarTitleView.editButton addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self loadWebViewWithShare:NO];
}

- (void) loadWebViewWithShare:(BOOL)aShare{
    NSString *link = self.previewLink;
    if (aShare) {
        link = [link stringByAppendingString:@"&share=1"];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:link] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:3.0];
    [self.mWebView loadRequest:request];
}

- (void) edit{
    [self logEventWithId:GetStringWithKey(@"Tracking_preview_edit_edit_id") WithLabel:GetStringWithKey(@"Tracking_preview_edit_edit")];
    [self stopMusic];
    AddActivityViewController *vc = [AddActivityViewController new];
    vc.activityDict = self.activityDict;
    vc.isFromPreview = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) refreshWebView{
    ((LandingViewController *)[self.navigationController.viewControllers objectAtIndex:1]).refreshView = YES;
    [self loadWebViewWithShare:YES];
}

- (void) setCalendarDict{
    NSString *startDateString = [self.activityDict objectForKey:@"start_date"];
    NSString *startTimeString = [self.activityDict objectForKey:@"start_time"];
    NSString *endDateString = [self.activityDict objectForKey:@"end_date"];
    NSDateFormatter *tempFormatter = [NSDateFormatter new];
    [tempFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *startDate = [tempFormatter dateFromString:[NSString stringWithFormat:@"%@ %@",startDateString,startTimeString]];
    NSDate *endDate = [tempFormatter dateFromString:[NSString stringWithFormat:@"%@ 23:59",endDateString]];
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  startDate,@"start_date",
                                  endDate,@"end_date",
                                  [self.activityDict objectForKey:@"title"],@"title",
                                  self.activityId,@"activity_id",nil];
    
    NSUserDefaults *tempDefaults = [NSUserDefaults standardUserDefaults];
    [tempDefaults setObject:mDict forKey:KEY_PREPARE_CALENDAR_ACTIVITY];
    [tempDefaults synchronize];
}

- (void) shareToQQ{
    if ([[self getGuideInfo] isGuideProfileCompleted]){
        AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        NSData *tempData = UIImageJPEGRepresentation(self.activityImage, 1.0);
        NSArray *tempArray = [NSArray arrayWithObjects:self.activityTitle,self.activityLink,tempData, nil];
        [myDelegate tencentShareWithInfoArray:tempArray];
    }else{
        UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:GetStringWithKey(@"error_activity_incomplete_info") delegate:self cancelButtonTitle:GetStringWithKey(@"update_later") otherButtonTitles:GetStringWithKey(@"complete_info"), nil];
        [tempAlertView setTag:3];
        [tempAlertView show];
    }
}

- (void) shareToWeChat{
    if ([[self getGuideInfo] isGuideProfileCompleted]){
//        floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_8_3
        if ([WXApi isWXAppInstalled]) {
            WXMediaMessage *message = [WXMediaMessage message];
            message.title = self.activityTitle;
            
            UIGraphicsBeginImageContext(CGSizeMake(50, 50));
            [self.activityImage drawInRect:CGRectMake(0,0,50,50)];
            UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            [message setThumbImage:newImage];
            
            WXWebpageObject *ext = [WXWebpageObject object];
            ext.webpageUrl = self.activityLink;
            
            message.mediaObject = ext;
            
            SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneTimeline;
            
            [WXApi sendReq:req];
        }else{
            UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:GetStringWithKey(@"alert_no_wechat") delegate:nil cancelButtonTitle:GetStringWithKey(@"confirm") otherButtonTitles:nil];
            [tempAlertView show];
        }
    }else{
        UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:GetStringWithKey(@"error_activity_incomplete_info") delegate:self cancelButtonTitle:GetStringWithKey(@"update_later") otherButtonTitles:GetStringWithKey(@"complete_info"), nil];
        [tempAlertView setTag:3];
        [tempAlertView show];
    }
}

- (void) shareToWeibo{
    if ([[self getGuideInfo] isGuideProfileCompleted]){
        AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        if ([myDelegate.wbtoken length] == 0) {
            WBAuthorizeRequest *request = [WBAuthorizeRequest request];
            request.redirectURI = WEIBO_REDIRECT_URL;
            request.scope = WEIBO_SCOPE;
            [WeiboSDK sendRequest:request];
        }else{
            WBMessageObject *message = [WBMessageObject message];
            message.text = [NSString stringWithFormat:@"%@ %@",self.activityTitle,self.activityLink];
            
            WBImageObject *image = [WBImageObject object];
            image.imageData = UIImageJPEGRepresentation(self.activityImage, 1.0);
            message.imageObject = image;
            
            WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
            authRequest.redirectURI = WEIBO_REDIRECT_URL;
            authRequest.scope = WEIBO_SCOPE;
            
            WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:myDelegate.wbtoken];
            [WeiboSDK sendRequest:request];
        }
    }else{
        UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:GetStringWithKey(@"error_activity_incomplete_info") delegate:self cancelButtonTitle:GetStringWithKey(@"update_later") otherButtonTitles:GetStringWithKey(@"complete_info"), nil];
        [tempAlertView setTag:3];
        [tempAlertView show];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView tag] == 3) {
        if (buttonIndex == 1) {
            [self stopMusic];
            [self.navigationController pushViewController:[MyInfoDetailViewController new] animated:YES];
        }
    }
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    BOOL load = NO;
    NSString *link = request.URL.absoluteString;
    
    if ([link hasPrefix:@"qq://"]){
        [self setCalendarDict];
        [self shareToQQ];
    }else if ([link hasPrefix:@"wechat://"]){
        [self setCalendarDict];
        [self shareToWeChat];
    }else if ([link hasPrefix:@"weibo://"]){
        [self setCalendarDict];
        [self shareToWeibo];
    }else if ([link rangeOfString:self.previewLink].location != NSNotFound) {
        load = YES;
    }else if ([link hasPrefix:@"http://"]){
        if (self.activityDict) {
            [self logEventWithId:GetStringWithKey(@"Tracking_preview_edit_risk_id") WithLabel:GetStringWithKey(@"Tracking_preview_edit_risk")];
        }else{
            [self logEventWithId:GetStringWithKey(@"Tracking_preview_risk_id") WithLabel:GetStringWithKey(@"Tracking_preview_risk")];
        }
        [self stopMusic];
        WebViewController *vc = [WebViewController new];
        vc.link = link;
        [self.navigationController pushViewController:vc animated:YES];
    }
    return load;
}

- (void) stopMusic{
    [self.mWebView stringByEvaluatingJavaScriptFromString:@"bgm_off();"];
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
