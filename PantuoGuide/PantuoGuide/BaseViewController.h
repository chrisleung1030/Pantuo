//
//  BaseViewController.h
//  PantuoGuide
//
//  Created by Christopher Leung on 8/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"
#import "MBProgressHUD.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "Config.h"
#import "LanguageManager.h"
#import "AFNetworking.h"
#import "TopBarView.h"
#import "TopBarTitleView.h"
#import "Nsstring+AESCrypt.h"
#import "Base64.h"
#import "GuideInfo.h"
#import "WXApi.h"
#import "TBXML.h"
#import "BaiduMobStat.h"

@interface BaseViewController : UIViewController <UIAlertViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MBProgressHUDDelegate>

@property (nonatomic, retain) TopBarView *topBarView;
@property (nonatomic, retain) TopBarTitleView *topBarTitleView;
@property (nonatomic, retain) MBProgressHUD *mbProgressHUD;
@property (nonatomic, assign) BOOL isCallingAPI;

- (AFHTTPRequestOperationManager *) getPantuoAPIManager;
- (AFHTTPRequestOperationManager *) getIPOSCSLManager;

- (void) callPantuoAPIWithLink:(NSString *)aLink WithParameter:(NSDictionary *)aPara;
- (void) callIPOSCSLAPIWithLink:(NSString *)aLink WithParameter:(NSDictionary *)aPara WithGet:(BOOL)aGet;

- (NSString *) getStatusResult:(NSDictionary *)aDict;

- (void) handleError:(NSString *)aError WithLink:(NSString *)aLink;
- (void) handleResponse:(id)response WithLink:(NSString *)aLink WithRequest:(NSDictionary *)aRequest;

- (void) startActivityIndicator;
- (void) stopActivityIndicator;

- (void) addTopBarView;
- (void) addTopBarTitleView;
- (void) addTopBarLandingTitleView;
- (NSString *) getTopBarTitle;
- (void) back:(id)sender;
- (void) info:(id)sender;
- (void) about:(id)sender;
- (void) event:(id)sender;

- (ActivityStatus) getActivityStatus:(NSDictionary *)aDict;

- (GuideInfo *) getGuideInfo;
- (id) getUserDefault:(NSString *)aKey;
- (void) setUserDefaultWithKey:(NSString *)aKey WithValue:(id)aValue;

- (void) showChooseImageActionSheet;

- (void) logEventWithId:(NSString *)aId WithLabel:(NSString *)aLabel;

- (void) loginWeChat;

@end
