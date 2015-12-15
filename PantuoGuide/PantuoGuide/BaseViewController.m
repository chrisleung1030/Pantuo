//
//  BaseViewController.m
//  PantuoGuide
//
//  Created by Christopher Leung on 8/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isCallingAPI = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) logEventWithId:(NSString *)aId WithLabel:(NSString *)aLabel{
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    [statTracker logEvent:aId eventLabel:aLabel];
}

#pragma mark - weChat
- (void) loginWeChat{
    SendAuthReq* req =[[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo";
    req.state = @"pantuo_request" ;
    if ([WXApi isWXAppInstalled]) {
        [WXApi sendReq:req];
    }else{
        [WXApi sendAuthReq:req viewController:self delegate:APP_DELEGATE];
    }
}

#pragma mark - API
- (AFHTTPRequestOperationManager *) getPantuoAPIManager{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:HTTP_HEADER_CONSUMER_VALUE forHTTPHeaderField:HTTP_HEADER_CONSUMER_KEY];
    [manager.requestSerializer setValue:HTTP_HEADER_TOKEN_VALUE forHTTPHeaderField:HTTP_HEADER_TOKEN_KEY];
    
    return manager;
}

- (AFHTTPRequestOperationManager *) getIPOSCSLManager{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    return manager;
}

- (void) callPantuoAPIWithLink:(NSString *)aLink WithParameter:(NSDictionary *)aPara{
    if (!self.isCallingAPI) {
        self.isCallingAPI = YES;
        [self startActivityIndicator];
        AFHTTPRequestOperationManager *manager = [self getPantuoAPIManager];
        
        [manager POST:aLink
           parameters:aPara
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {}
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  self.isCallingAPI = NO;
                  [self stopActivityIndicator];
                  if (DEBUG_API) {
                      NSLog(@"response:%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                  }
                  
                  id response = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                  if ([response isKindOfClass:[NSDictionary class]] && [response objectForKey:@"error"]) {
                      if (DEBUG_SMS && [aLink isEqualToString:API_SEND_SMS] && [response objectForKey:@"countdown"]) {
                          [self handleResponse:response WithLink:aLink WithRequest:aPara];
                      }else{
                          [self handleError:[response objectForKey:@"error"] WithLink:aLink];
                      }
                      
                  }else{
                      [self handleResponse:response WithLink:aLink WithRequest:aPara];
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  self.isCallingAPI = NO;
                  [self stopActivityIndicator];
                  if (SHOW_API_ERROR_POP_UP) {
                      UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:GetStringWithKey(@"alert_api_fail") delegate:nil cancelButtonTitle:GetStringWithKey(@"confirm") otherButtonTitles:nil];
                      [tempAlertView show];
                  }
              }
        ];
    }
}

- (void) callIPOSCSLAPIWithLink:(NSString *)aLink WithParameter:(NSDictionary *)aPara WithGet:(BOOL)aGet{
    if (!self.isCallingAPI) {
        self.isCallingAPI = YES;
        [self startActivityIndicator];
        AFHTTPRequestOperationManager *manager = [self getIPOSCSLManager];
        
        void (^aSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject) {
            self.isCallingAPI = NO;
            [self stopActivityIndicator];
            if (DEBUG_API) {
                NSLog(@"response:%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
            }
            
            id response = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            if ([response isKindOfClass:[NSDictionary class]] && [response objectForKey:@"error"]) {
                [self handleError:[response objectForKey:@"error"] WithLink:aLink];
            }else{
                [self handleResponse:response WithLink:aLink WithRequest:aPara];
            }
        };
        
        void (^aFailBlock)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error) {
            self.isCallingAPI = NO;
            [self stopActivityIndicator];
            if (SHOW_API_ERROR_POP_UP) {
                UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:GetStringWithKey(@"alert_api_fail") delegate:nil cancelButtonTitle:GetStringWithKey(@"confirm") otherButtonTitles:nil];
                [tempAlertView show];
            }
        };
        
        if (aGet) {
            [manager GET:aLink parameters:aPara success:aSuccessBlock failure:aFailBlock];
        }else{
            [manager POST:aLink parameters:aPara constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            } success:aSuccessBlock failure:aFailBlock];
        }
    }
}

- (void) handleError:(NSString *)aError WithLink:(NSString *)aLink{
    UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:aError delegate:nil cancelButtonTitle:GetStringWithKey(@"confirm") otherButtonTitles:nil];
    [tempAlertView show];
}


- (void) handleResponse:(id)response WithLink:(NSString *)aLink WithRequest:(NSDictionary *)aRequest{
}

- (NSString *) getStatusResult:(NSDictionary *)aDict{
    id resultObject = [aDict objectForKey:@"success"];
    NSString *result = @"1";
    if (!resultObject || [resultObject intValue] == 0) {
        result = [aDict objectForKey:@"error"];
        if (!result) {
            result = [NSString string];
        }
    }
    return result;
}

#pragma mark - TopBarView
- (void) addTopBarView{
    self.topBarView = [[[NSBundle mainBundle] loadNibNamed:@"TopBarView" owner:self options:nil] objectAtIndex:0];
    [self.view addSubview:self.topBarView];
    [self.topBarView.backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.topBarView.titleLabel setText:[self getTopBarTitle]];
}

- (void) addTopBarTitleView{
    self.topBarTitleView = [[[NSBundle mainBundle] loadNibNamed:@"TopBarTitleView" owner:self options:nil] objectAtIndex:0];
    [self.view addSubview:self.topBarTitleView];
    [self.topBarTitleView.backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.topBarTitleView.titleLabel setText:[self getTopBarTitle]];
    [self.topBarTitleView updateTitleAndUnderlineView];
}

- (void) addTopBarLandingTitleView{
    self.topBarTitleView = [[[NSBundle mainBundle] loadNibNamed:@"TopBarTitleView" owner:self options:nil] objectAtIndex:0];
    [self.view addSubview:self.topBarTitleView];
    [self.topBarTitleView setUpAsMainTopBar];
    [self.topBarTitleView.infoButton addTarget:self action:@selector(info:) forControlEvents:UIControlEventTouchUpInside];
    [self.topBarTitleView.aboutButton addTarget:self action:@selector(about:) forControlEvents:UIControlEventTouchUpInside];
    [self.topBarTitleView.eventButton addTarget:self action:@selector(qrcode:) forControlEvents:UIControlEventTouchUpInside];
    [self.topBarTitleView.eventButton setBackgroundImage:[UIImage imageNamed:@"icon_scanner.png"] forState:UIControlStateNormal];
    [self.topBarTitleView.titleLabel setText:[self getTopBarTitle]];
    [self.topBarTitleView updateTitleAndUnderlineView];
}

- (NSString *) getTopBarTitle{
    return [NSString string];
}

#pragma mark - Button action
- (void) back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) info:(id)sender{
}

- (void) about:(id)sender{
}

- (void) event:(id)sender{
}

- (void) qrcode:(id)sender{
}


#pragma mark - Common function
- (ActivityStatus) getActivityStatus:(NSDictionary *)aDict{
    ActivityStatus status;
    
    NSDateComponents *tempCompo = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
    NSString *today = [NSString stringWithFormat:@"%d-%02d-%02d",(int)tempCompo.year,(int)tempCompo.month,(int)tempCompo.day];
    if ([today compare:[aDict objectForKey:@"end_date"]] == NSOrderedDescending) {
        status = ActivityStatusEnded;
    }else if ([[aDict objectForKey:@"action"] isEqualToString:@"published"]) {
        status = ActivityStatusOnGoing;
    }else{
        status = ActivityStatusIncomplete;
    }
    return status;
}

#pragma mark - User Defaults
- (GuideInfo *) getGuideInfo{
    id object = [self getUserDefault:KEY_GUIDE_INFO];
    if (object) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:object];
    }
    return NULL;
}

- (id) getUserDefault:(NSString *)aKey{
    return [[NSUserDefaults standardUserDefaults] objectForKey:aKey];
}

- (void) setUserDefaultWithKey:(NSString *)aKey WithValue:(id)aValue{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    [standardDefaults setObject:aValue forKey:aKey];
    [standardDefaults synchronize];
}

#pragma mark - UIActivityIndicatorView
- (void) startActivityIndicator{
    [self stopActivityIndicator];
    
    self.mbProgressHUD = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.mbProgressHUD show:YES];
    [self.view addSubview:self.mbProgressHUD];
}

- (void) stopActivityIndicator{
    if (self.mbProgressHUD) {
        [self.mbProgressHUD removeFromSuperview];
        self.mbProgressHUD = nil;
    }
}

#pragma mark - Choose Image
- (void) showChooseImageActionSheet{
    UIActionSheet *tempSheet = [[UIActionSheet alloc] initWithTitle:GetStringWithKey(@"profile_get_image") delegate:self cancelButtonTitle:GetStringWithKey(@"date_picker_neg") destructiveButtonTitle:nil otherButtonTitles:GetStringWithKey(@"photo_library"),GetStringWithKey(@"camera"), nil];
    [tempSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        if (status == ALAuthorizationStatusAuthorized) {
            [self showPhotoLibrary];
        }else if (status == ALAuthorizationStatusNotDetermined){
            [self showPhotoLibrary];
        }else{
            [self showPhotoLibraryAlert];
        }
    }else if (buttonIndex == 1) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(authStatus == AVAuthorizationStatusAuthorized){
            [self showCamera];
        }
        else if(authStatus == AVAuthorizationStatusNotDetermined)
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
             {
                 if(granted){
                     [self showCamera];
                 }else{
                     [self showCameraAlert];
                 }
             }];
        }else{
            [self showCameraAlert];
        }
    }
}

- (void) showPhotoLibrary{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void) showCamera{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void) showPhotoLibraryAlert{
    UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:GetStringWithKey(@"alert_access_photo") delegate:nil cancelButtonTitle:GetStringWithKey(@"confirm") otherButtonTitles:nil];
    [tempAlertView show];
}


- (void) showCameraAlert{
    UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:GetStringWithKey(@"alert_access_camera") delegate:nil cancelButtonTitle:GetStringWithKey(@"confirm") otherButtonTitles:nil];
    [tempAlertView show];
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
