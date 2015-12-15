//
//  AppDelegate.m
//  PantuoGuide
//
//  Created by Christopher Leung on 8/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "SplashViewController.h"
#import "Config.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "BaiduMobStat.h"
#import "MyInfoDetailViewController.h"
#import "PreviewViewController.h"
#import "LandingViewController.h"
#import "ZBarSDK.h"
#import "BPush.h"

@interface AppDelegate () <UIAlertViewDelegate, WXApiDelegate, WeiboSDKDelegate, TencentSessionDelegate>

@property (nonatomic, strong) UINavigationController *nvc;
@property (nonatomic, retain) UIAlertView *versionAlertView;
@property (nonatomic, retain) TencentOAuth *tencentOAuth;
@property (nonatomic, retain) NSArray *tencentShareInfoArray;

@property (nonatomic, retain) NSString *activityID;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    for (NSString *aString in [[NSBundle mainBundle] preferredLocalizations]) {
//        NSLog(@"Localization:%@",aString);
//    }
//    for (NSString *aString in [NSLocale preferredLanguages]) {
//        NSLog(@"NSLocale:%@",aString);
//    }
    
    NSDictionary *tempDict = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (tempDict) {
        NSString *tempID = [tempDict objectForKey:@"activity_id"];
        if (tempID && tempID.length > 0) {
            self.activityID = tempID;
        }
    }
    
    SetLanguage(kLanguageSimplifiedChinese);
    srandom((unsigned)floor([NSDate timeIntervalSinceReferenceDate]));
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [WXApi registerApp:WECHAT_APP_KEY];
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:WEIBO_APP_KEY];
    self.wbtoken = [NSString string];
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQ_APP_KEY andDelegate:self];
    NSUserDefaults *tempDefault = [NSUserDefaults standardUserDefaults];
    if (![tempDefault objectForKey:KEY_CALENDAR]) {
        [tempDefault setObject:[NSNumber numberWithBool:YES] forKey:KEY_CALENDAR];
        [tempDefault synchronize];
    }
    if (![tempDefault objectForKey:KEY_ADD_TO_CALENDAR]) {
        [tempDefault setObject:[NSMutableDictionary dictionary] forKey:KEY_ADD_TO_CALENDAR];
        [tempDefault synchronize];
    }
    [ZBarReaderView class];
    
    [self registerPushNote];
    [BPush registerChannel:launchOptions apiKey:BAIDU_PUSH_API_KEY pushMode:BPushModeProduction withFirstAction:nil withSecondAction:nil withCategory:nil isDebug:NO];
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        [BPush handleNotification:userInfo];
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    statTracker.enableExceptionLog = YES; // 是否允许截获并发送崩溃信息，请设置YES或者NO
//    statTracker.channelId = @"ReplaceMeWithYourChannel";//设置您的app的发布渠道
    statTracker.logStrategy = BaiduMobStatLogStrategyAppLaunch;//根据开发者设定的发送策略,发送日志
    statTracker.logSendInterval = 1;  //为1时表示发送日志的时间间隔为1小时,当logStrategy设置为BaiduMobStatLogStrategyCustom时生效
    statTracker.logSendWifiOnly = NO; //是否仅在WIfi情况下发送日志数据
    statTracker.sessionResumeInterval = 10;//设置应用进入后台再回到前台为同一次session的间隔时间[0~600s],超过600s则设为600s，默认为30s
    statTracker.shortAppVersion  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    statTracker.enableDebugOn = NO; //调试的时候打开，会有log打印，发布时候关闭
    [statTracker startWithAppId:BAIDU_KEY];//设置您在mtj网站上添加的app的appkey,此处AppId即为应用的appKey
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.nvc = [[UINavigationController alloc] initWithRootViewController:[LoginViewController new]];
    [self.nvc.view setBackgroundColor:[UIColor clearColor]];
    [self.nvc.view sendSubviewToBack:self.nvc.navigationBar];
    self.window.rootViewController = self.nvc;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationSignificantTimeChange:(UIApplication *)application{
    if ([self.nvc.viewControllers count] > 1){
        LandingViewController *vc = (LandingViewController *)[self.nvc.viewControllers objectAtIndex:1];
        if ([self.nvc.visibleViewController isKindOfClass:[LandingViewController class]]) {
            [vc updateOnTimeChange];
        }else{
            vc.refreshView = YES;
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert |UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound)];
    }
    
    [self downloadBgImagesJSON];
    [self checkVersionWithShowAlreadyUpdateAlert:NO];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self] ||
            [TencentOAuth HandleOpenURL:url] ||
            [WeiboSDK handleOpenURL:url delegate:self] ||
            [QQApiInterface handleOpenURL:url delegate:[self.nvc.viewControllers objectAtIndex:0]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [WXApi handleOpenURL:url delegate:self] ||
            [TencentOAuth HandleOpenURL:url] ||
            [WeiboSDK handleOpenURL:url delegate:self] ||
            [QQApiInterface handleOpenURL:url delegate:[self.nvc.viewControllers objectAtIndex:0]];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Push note
- (void) registerPushNote{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
}

// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
//    NSLog(@"%s%@",__FUNCTION__,[deviceToken description]);
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
//        NSLog(@"result:%@",[result description]);
        NSString *channelID = [NSString string];
        if ([result isKindOfClass:[NSDictionary class]] && [result objectForKey:@"channel_id"]) {
            channelID = [result objectForKey:@"channel_id"];
        }
        
//        NSString *dt = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"&lt;&gt;"]];
//        dt = [dt stringByReplacingOccurrencesOfString:@" " withString:@""];
//        NSRange range;
//        range.location = 1;
//        range.length = [dt length] - 2;
//        NSString *token = [dt substringWithRange:range];
        NSString *udid = GetUserID();
        
//        NSLog(@"channelID:%@",channelID);
        NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     channelID,@"push_token",
                                     udid,@"device_id",
                                     PLATFORM_ID,@"platform_id",
                                     nil];
        
        NSUserDefaults *tempDefaults = [NSUserDefaults standardUserDefaults];
        id object = [tempDefaults objectForKey:KEY_GUIDE_INFO];
        if (object) {
            GuideInfo *tempInfo = [NSKeyedUnarchiver unarchiveObjectWithData:object];
            [para setObject:tempInfo.guide_id forKey:@"guide_id"];
        }
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:API_PUSH_NOTE
           parameters:[NSDictionary dictionaryWithDictionary:para]
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              }
         ];
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"%s%@",__FUNCTION__,[error description]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // App 收到推送的通知
    [BPush handleNotification:userInfo];
    if ([application applicationState] == UIApplicationStateActive) {
        [self doPushAlert:userInfo WithDelegate:YES];
        NSString *tempID = [userInfo objectForKey:@"activity_id"];
        if (tempID && tempID.length > 0) {
            self.activityID = tempID;
        }
    }else{
        if ([userInfo objectForKey:@"activity_id"]){
            NSString *activityID = [userInfo objectForKey:@"activity_id"];
            [self doActivityPushNote:activityID];
        }
    }
}

#pragma mark - Push handle
- (void) checkActivityPushNote{
    if (self.activityID && self.activityID.length > 0) {
        [self performSelectorOnMainThread:@selector(doActivityPushNote:) withObject:self.activityID waitUntilDone:NO];
        self.activityID = [NSString string];
    }
}

- (void) doActivityPushNote:(NSString *)aActivityID{
    if ([self.nvc.viewControllers count] > 2){
        UIViewController *tempController = [self.nvc.viewControllers objectAtIndex:1];
        [self.nvc popToViewController:tempController animated:NO];
    }
    LandingViewController *tempController = (LandingViewController *)[self.nvc.viewControllers objectAtIndex:1];
    [tempController goToAttendanceWithActivityID:aActivityID];
}

- (void) doPushAlert:(NSDictionary *)aDict WithDelegate:(BOOL)aDelegate{
    NSDictionary *tempDict = [aDict objectForKey:@"aps"];
    if (tempDict && [tempDict objectForKey:@"alert"]) {
        NSString *message = [tempDict objectForKey:@"alert"];
        if ([message length] > 0) {
            if (aDelegate) {
                UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:GetStringWithKey(@"close") otherButtonTitles:GetStringWithKey(@"view"),nil];
                [tempAlertView setTag:1];
                [tempAlertView show];
            }else{
                UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:GetStringWithKey(@"confirm") otherButtonTitles:nil];
                [tempAlertView show];
            }
            
        }
    }
}

#pragma mark - Get image methods
- (void) downloadBgImagesJSON{
    
    NSUserDefaults *sd = [NSUserDefaults standardUserDefaults];
    NSArray *imagesArray = [sd objectForKey:KEY_REGISTRATION_BG];
    NSNumber *hvImage = [sd objectForKey:KEY_ALREADY_HV_IMAGE];
    if (imagesArray && hvImage && [hvImage boolValue]) {
        // random an image
        [self performSelectorInBackground:@selector(setImageForLandingInBg:) withObject:imagesArray];
    }else{
        // use default image
        LoginViewController *vc = (LoginViewController *)[self.nvc.viewControllers objectAtIndex:0];
        [vc setBackgroundImage:[UIImage imageNamed:@"bg_01.jpg"]];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:API_GET_BACKGROUNDS parameters:NULL success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        NSArray *regBG = [response objectForKey:@"registration"];
        NSDictionary *calBG = [response objectForKey:@"calendar"];
        
        if (regBG && [regBG isKindOfClass:[NSArray class]]) {
            NSUserDefaults *sd = [NSUserDefaults standardUserDefaults];
            [sd setObject:regBG forKey:KEY_REGISTRATION_BG];
            [sd setObject:[NSNumber numberWithBool:NO] forKey:KEY_ALREADY_HV_IMAGE];
            [sd synchronize];
            
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            for (int i = 0 ; i < [regBG count]; i++) {
                NSString *imageURL  = [regBG objectAtIndex:i];
                [manager downloadImageWithURL:[NSURL URLWithString:imageURL]
                                      options:0
                                     progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                         // progression tracking code
                                     }
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                        NSUserDefaults *tempNSUserDefaults = [NSUserDefaults standardUserDefaults];
                                        id object = [tempNSUserDefaults objectForKey:KEY_ALREADY_HV_IMAGE];
                                        if (!(object && [object boolValue])) {
                                            [tempNSUserDefaults setObject:[NSNumber numberWithBool:YES] forKey:KEY_ALREADY_HV_IMAGE];
                                            [tempNSUserDefaults synchronize];
                                        }
                                    }];
            }
        }
        
        if (calBG && [calBG isKindOfClass:[NSDictionary class]]) {
            NSUserDefaults *sd = [NSUserDefaults standardUserDefaults];
            [sd setObject:calBG forKey:KEY_CALENDAR_BG];
            [sd synchronize];
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            for (NSString *key in calBG) {
                [manager downloadImageWithURL:[NSURL URLWithString:[calBG objectForKey:key]]
                                      options:0
                                     progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                         // progression tracking code
                                     }
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                        if (image) {
                                            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CALENDAR_UPDATED object:nil];
                                        }
                                    }];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void) setImageForLandingInBg:(NSArray *)aImageArray{
    @autoreleasepool {
        int index = (int)(random() % [aImageArray count]);
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        BOOL contain = [manager cachedImageExistsForURL:[NSURL URLWithString:[aImageArray objectAtIndex:index]]];
        while (!contain) {
            index = (int)(random() % [aImageArray count]);
            contain = [manager cachedImageExistsForURL:[NSURL URLWithString:[aImageArray objectAtIndex:index]]];
        }
        NSString *imageURL  = [aImageArray objectAtIndex:index];
        [manager downloadImageWithURL:[NSURL URLWithString:imageURL]
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                 // progression tracking code
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                LoginViewController *vc = (LoginViewController *)[self.nvc.viewControllers objectAtIndex:0];
                                [vc setBackgroundImage:image];
                            }];
    }
}

- (void) checkVersionWithShowAlreadyUpdateAlert:(BOOL)aShow{
    if (!self.versionAlertView) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:majorVersion,@"version",PLATFORM_ID,@"platform",nil];
        
        [manager POST:API_CHECK_VERSION parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            
            NSString *show = [response objectForKey:@"show_alert"];
            NSString *message = [response objectForKey:@"message"];
            
            if ([show isEqualToString:@"1"]) {
                self.versionAlertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:GetStringWithKey(@"update_later") otherButtonTitles:GetStringWithKey(@"update_now"),nil];
                [self.versionAlertView show];
            }else if (aShow){
                UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:GetStringWithKey(@"no_update") delegate:nil cancelButtonTitle:GetStringWithKey(@"confirm") otherButtonTitles:nil];
                [tempAlertView show];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == self.versionAlertView) {
        self.versionAlertView = nil;
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:API_APP_UPDATE]];
        }
    }else if (alertView.tag == 1){
        if (buttonIndex == 1) {
            [self checkActivityPushNote];
        }
    }
}

#pragma mark - Calendar
- (void) addToCalendar:(NSString *)aType{
    NSUserDefaults *tempDefault = [NSUserDefaults standardUserDefaults];
    id object = [tempDefault objectForKey:KEY_CALENDAR];
    if (object && [[tempDefault objectForKey:KEY_CALENDAR] boolValue]) {
        EKEventStore *eventStore = [EKEventStore new];
        
        EKAuthorizationStatus authorizationStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
        BOOL needsToRequestAccessToEventStore = ([EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent] == EKAuthorizationStatusNotDetermined);
        
        if (needsToRequestAccessToEventStore) {
            [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self doAddToCalendarWithEKEventStore:eventStore];
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (error) {
                            [self showErrorAlert:[error description]];
                        }
                    });
                }
            }];
        } else if (authorizationStatus == EKAuthorizationStatusAuthorized) {
            [self doAddToCalendarWithEKEventStore:eventStore];
        }else{
//            [self showErrorAlert:[error description]];
        }
    }
}

- (void) showErrorAlert:(NSString *)aMessage{
    UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:aMessage delegate:nil cancelButtonTitle:GetStringWithKey(@"confirm") otherButtonTitles:nil];
    [tempAlertView show];
}

- (void) doAddToCalendarWithEKEventStore:(EKEventStore *)eventStore{
    NSUserDefaults *tempDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:[tempDefaults objectForKey:KEY_ADD_TO_CALENDAR]];
    
    NSMutableDictionary *mDict = [tempDefaults objectForKey:KEY_PREPARE_CALENDAR_ACTIVITY];

    EKEvent *event;
    NSString *tempEventId = [tempDict objectForKey:[mDict objectForKey:@"activity_id"]];
    if (tempEventId && [tempEventId length] > 0) {
        event = [eventStore eventWithIdentifier:tempEventId];
        if (!event) {
            event = [EKEvent eventWithEventStore:eventStore];
        }
    }else{
        event = [EKEvent eventWithEventStore:eventStore];
    }
    
    event.title = [mDict objectForKey:@"title"];
    event.startDate = [mDict objectForKey:@"start_date"];
    event.endDate = [mDict objectForKey:@"end_date"];
    event.allDay = YES;
    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
    NSError *error;
    [eventStore saveEvent:event span:EKSpanThisEvent error:&error];
    if (error) {
        UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:[error description] delegate:nil cancelButtonTitle:GetStringWithKey(@"confirm") otherButtonTitles:nil];
        [tempAlertView show];
    }else{
        [tempDict setObject:event.eventIdentifier forKey:[mDict objectForKey:@"activity_id"]];
        [tempDefaults setObject:[NSDictionary dictionaryWithDictionary:tempDict] forKey:KEY_ADD_TO_CALENDAR];
        [tempDefaults synchronize];
    }
}

- (void) updateShareTo:(NSString *)aType{
    NSUserDefaults *tempDefaults = [NSUserDefaults standardUserDefaults];
    id object = [tempDefaults objectForKey:KEY_GUIDE_INFO];
    NSMutableDictionary *mDict = [tempDefaults objectForKey:KEY_PREPARE_CALENDAR_ACTIVITY];
    NSString * activityId = [mDict objectForKey:@"activity_id"];
    if (object) {
        GuideInfo *tempInfo = [NSKeyedUnarchiver unarchiveObjectWithData:object];
        if ([activityId length] > 0) {
            NSDictionary *aPara = [NSDictionary dictionaryWithObjectsAndKeys:
                                   tempInfo.token,@"token",
                                   tempInfo.guide_id,@"guide_id",
                                   activityId,@"activity_id",
                                   aType,@"social_type",nil];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager GET:API_ACTIVITY_SHARED parameters:aPara success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (DEBUG_API) {
                    NSLog(@"response:%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                }
                id response = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                if ([response isKindOfClass:[NSDictionary class]] && [response objectForKey:@"error"]) {
                    // error
                }else{
                    // success
                    if ([self.nvc.visibleViewController isKindOfClass:[PreviewViewController class]]) {
                        PreviewViewController *previewVC = (PreviewViewController *)self.nvc.visibleViewController;
                        [previewVC refreshWebView];
                    }
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                // error
            }];
        }
    }
    [self addToCalendar:aType];
}

#pragma mark - Tencent
- (void) tencentLogin{
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_PIC_T,
                            nil];
    [self.tencentOAuth authorize:permissions inSafari:NO];
}

- (void) tencentShareWithInfoArray:(NSArray *)aArray{
    self.tencentShareInfoArray = aArray;
    
    if (self.tencentOAuth.accessToken && 0 != [self.tencentOAuth.accessToken length]){
        [self tencentShare];
    }else{
        [self tencentLogin];
    }
}

- (void) tencentShare{
    NSURL *url = [NSURL URLWithString:[self.tencentShareInfoArray objectAtIndex:1]];
    QQApiNewsObject* img = [QQApiNewsObject objectWithURL:url
                                                    title:[self.tencentShareInfoArray objectAtIndex:0]
                                              description:@""
                                         previewImageData:[self.tencentShareInfoArray objectAtIndex:2]];
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    NSLog(@"sent:%d",sent);
    self.tencentShareInfoArray = nil;
}

#pragma mark - TencentSessionDelegate
- (void)tencentDidLogin{
    NSLog(@"%s",__FUNCTION__);
    if (self.tencentOAuth.accessToken && 0 != [self.tencentOAuth.accessToken length])
    {
        //  记录登录用户的OpenID、Token以及过期时间
        if (self.tencentShareInfoArray) {
            [self performSelector:@selector(tencentShare) withObject:nil afterDelay:1.0];
//            [self tencentShare];
        }else{
            NSString *accessToken = self.tencentOAuth.accessToken;
            NSString *openId = self.tencentOAuth.openId;
            NSDate *expirationDate = self.tencentOAuth.expirationDate;
            NSTimeInterval seconds = [expirationDate timeIntervalSinceDate:[NSDate date]];
            
            [self.tencentOAuth getUserInfo];
            
            NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:
                                  SOCIAL_MEDIA_TYPE_QQ,@"social_type",
                                  openId,@"social_id",
                                  KEY,@"api_password",
                                  GetUserID(),@"device_id",
                                  accessToken,@"access_token",
                                  [NSString stringWithFormat:@"%f",seconds],@"expire_in",
                                  ROLE,@"role",nil];
            
            if ([self.nvc.visibleViewController isKindOfClass:[LoginViewController class]]) {
                LoginViewController *loginVC = (LoginViewController *)self.nvc.visibleViewController;
                [loginVC socialLoginWithInfo:para];
            }else if ([self.nvc.visibleViewController isKindOfClass:[MyInfoDetailViewController class]]){
                MyInfoDetailViewController *infoDetailVC = (MyInfoDetailViewController *)self.nvc.visibleViewController;
                [infoDetailVC updateSocialInfo:para];
            }
        }
    }
    else
    {
        UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"登录不成功 没有获取accesstoken" delegate:nil cancelButtonTitle:GetStringWithKey(@"confirm") otherButtonTitles:nil];
        [tempAlertView show];
    }
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled{
    if (cancelled)
    {
        UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"用户取消登录" delegate:nil cancelButtonTitle:GetStringWithKey(@"confirm") otherButtonTitles:nil];
        [tempAlertView show];
    }
    else
    {
        UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"登录失败" delegate:nil cancelButtonTitle:GetStringWithKey(@"confirm") otherButtonTitles:nil];
        [tempAlertView show];
    }
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork{
    UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"无网络连接，请设置网络" delegate:nil cancelButtonTitle:GetStringWithKey(@"confirm") otherButtonTitles:nil];
    [tempAlertView show];
}

- (BOOL)tencentNeedPerformIncrAuth:(TencentOAuth *)tencentOAuth withPermissions:(NSArray *)permissions
{
    return YES;
}

- (BOOL)tencentNeedPerformReAuth:(TencentOAuth *)tencentOAuth
{
    return YES;
}

#pragma mark - QQApiInterfaceDelegate
- (void) handleQQAPIInterfaceResp:(QQBaseResp *)resp{
    if ([resp.result isEqualToString:@"0"]) {
        [self performSelector:@selector(updateShareTo:) withObject:@"qq" afterDelay:1.0];
    }else{
        UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:resp.errorDescription delegate:nil cancelButtonTitle:GetStringWithKey(@"confirm") otherButtonTitles:nil];
        [tempAlertView show];
    }
}

#pragma mark - WXApi
-(void) onReq:(BaseReq*)req{
}

-(void) onResp:(BaseResp*)resp{
//    NSLog(@"resp:%@ %d",resp,resp.errCode);
    if (resp.errCode == 0) {
        if ([resp isKindOfClass:[SendAuthResp class]]) {
            NSString *weChatCode = ((SendAuthResp *)resp).code;
            NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:
                                  WECHAT_APP_KEY,@"appid",
                                  WECHAT_APP_SECRET,@"secret",
                                  weChatCode,@"code",
                                  @"authorization_code",@"grant_type",nil];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager POST:API_GET_WECHAT_TOKEN parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                
                NSString *accessToken = [response objectForKey:@"access_token"];
                NSString *refreshToken = [response objectForKey:@"refresh_token"];
                NSString *expires_in = [response objectForKey:@"expires_in"];
                NSString *openid = [response objectForKey:@"unionid"];
                if ([openid length] == 0) {
                    openid = [response objectForKey:@"openid"];
                }
                
                NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:
                                      SOCIAL_MEDIA_TYPE_WECHAT,@"social_type",
                                      KEY,@"api_password",
                                      GetUserID(),@"device_id",
                                      accessToken,@"access_token",
                                      expires_in,@"expire_in",
                                      refreshToken,@"refresh_token",
                                      ROLE,@"role",
                                      openid,@"social_id",nil];
                
                NSArray *tempArray = [self.nvc viewControllers];
                UIViewController *tempController = [tempArray objectAtIndex:[tempArray count]-1];
                if ([tempController isKindOfClass:[MyInfoDetailViewController class]]) {
                    MyInfoDetailViewController *detailVC = (MyInfoDetailViewController *)tempController;
                    [detailVC updateSocialInfo:para];
                }else if ([tempController isKindOfClass:[LoginViewController class]]) {
                    LoginViewController *loginVC = (LoginViewController *)tempController;
                    [loginVC socialLoginWithInfo:para];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }else if ([resp isKindOfClass:[SendMessageToWXResp class]]){
            [self performSelector:@selector(updateShareTo:) withObject:@"weixin" afterDelay:1.0];
        }
    }else if (resp.errStr.length > 0){
        UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:resp.errStr delegate:self cancelButtonTitle:GetStringWithKey(@"confirm") otherButtonTitles:nil];
        [tempAlertView show];
    }
}

#pragma mark - Weibo
/**
 收到一个来自微博客户端程序的请求
 
 收到微博的请求后，第三方应用应该按照请求类型进行处理，处理完后必须通过 [WeiboSDK sendResponse:] 将结果回传给微博
 @param request 具体的请求对象
 */
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
}

/**
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 @param response 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
//    NSLog(@"response.statusCode %ld",(long)response.statusCode);
    if ([response isKindOfClass:[WBAuthorizeResponse class]] && response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
        WBAuthorizeResponse *authorizeResponse = (WBAuthorizeResponse *)response;
        NSTimeInterval seconds = [authorizeResponse.expirationDate timeIntervalSinceDate:[NSDate date]];
        self.wbtoken = authorizeResponse.accessToken;
        NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:
                              SOCIAL_MEDIA_TYPE_WEIBO,@"social_type",
                              authorizeResponse.userID,@"social_id",
                              KEY,@"api_password",
                              GetUserID(),@"device_id",
                              authorizeResponse.accessToken,@"access_token",
                              [NSString stringWithFormat:@"%f",seconds],@"expire_in",
                              authorizeResponse.refreshToken,@"refresh_token",
                              ROLE,@"role",nil];
        
        if ([self.nvc.visibleViewController isKindOfClass:[MyInfoDetailViewController class]]) {
            MyInfoDetailViewController *detailVC = (MyInfoDetailViewController *)self.nvc.visibleViewController;
            [detailVC updateSocialInfo:para];
        }else if ([self.nvc.visibleViewController isKindOfClass:[LoginViewController class]]) {
            LoginViewController *loginVC = (LoginViewController *)self.nvc.visibleViewController;
            [loginVC socialLoginWithInfo:para];
        }else if ([self.nvc.visibleViewController isKindOfClass:[PreviewViewController class]]) {
            [self performSelector:@selector(shareToWeibo) withObject:nil afterDelay:0.5];
            
        }
    }else if ([response isKindOfClass:[WBSendMessageToWeiboResponse class]]  && response.statusCode == WeiboSDKResponseStatusCodeSuccess){
        [self performSelector:@selector(updateShareTo:) withObject:@"weibo" afterDelay:1.0];
    }
}

- (void) shareToWeibo{
    PreviewViewController *previewVC = (PreviewViewController *)self.nvc.visibleViewController;
    [previewVC shareToWeibo];
}

@end
