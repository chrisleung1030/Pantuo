//
//  ViewController.m
//  PantuoGuide
//
//  Created by Christopher Leung on 8/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "SplashViewController.h"
#import "LoginViewController.h"
#import "LandingViewController.h"

@interface SplashViewController ()

@property (nonatomic, retain) UIImageView *logoImageView;

@end

@implementation SplashViewController
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:GREEN_PANTUO];
    self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.logoImageView setImage:[UIImage imageNamed:@"logo_splash.png"]];
    [self.logoImageView setFrame:CGRectMake((SCREEN_WIDTH-135)/2, (SCREEN_HEIGHT-135)/2, 135, 135)];
    [self.view addSubview:self.logoImageView];

    [self animateLogo];
}

- (void) animateLogo{
    [UIView animateWithDuration:2.0
                          delay:2.5
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
                            [self.logoImageView setAlpha:0];
                        } completion:^(BOOL finished) {
                            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                            [[UIApplication sharedApplication] setStatusBarHidden:NO];
                            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                            
                            id object = [self getUserDefault:KEY_SKIP_TUTORIAL];
                            if (object && [object boolValue]) {
                                GuideInfo *tempInfo = [self getGuideInfo];
                                if (tempInfo) {
                                    [self downloadGuideInfo];
                                }else{
                                    [self goToLoginPageWithAnimation:YES];
                                }
                                
                            }else{
                                [self.delegate SplashViewControllerDidFinishedWithGoToTutorial];
                            }
                        }];
}

- (void) goToLoginPageWithAnimation:(BOOL)aAnimation{
    [self setUserDefaultWithKey:KEY_GUIDE_INFO WithValue:NULL];
    [self.delegate SplashViewControllerDidFinishedWithGoToMainPage:NO WithHasCreatedActivity:NO WithAnimation:aAnimation];
}

- (void) downloadGuideInfo{
    AFHTTPRequestOperationManager *manager = [self getPantuoAPIManager];
    
    GuideInfo *tempInfo = [self getGuideInfo];
    [self startActivityIndicator];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:tempInfo.token,@"token",tempInfo.guide_id,@"guide_id",nil];
    [manager POST:API_GET_GUIDE_INFO parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (DEBUG_API) {
            NSLog(@"response:%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        }
        
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];

        [self stopActivityIndicator];
        
        if ([response objectForKey:@"error"]) {
            [self goToLoginPageWithAnimation:YES];
        }else{
            GuideInfo *guideInfo = [GuideInfo new];
            [guideInfo setUpGuideInfo:response];
            NSData *guideInfoEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:guideInfo];
            [self setUserDefaultWithKey:KEY_GUIDE_INFO WithValue:guideInfoEncodedObject];
            
            [self getHasCreatedActivity:guideInfo];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self goToLoginPageWithAnimation:YES];
    }];
}

- (void) getHasCreatedActivity:(GuideInfo *)aGuideInfo{
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:
                          aGuideInfo.token,@"token",
                          aGuideInfo.guide_id,@"guide_id",
                          nil];
    [self callIPOSCSLAPIWithLink:API_HAS_CREATED_ACTIVITY WithParameter:para WithGet:YES];
}

- (void) handleResponse:(id)response WithLink:(NSString *)aLink WithRequest:(NSDictionary *)aRequest{
    if ([aLink isEqualToString:API_HAS_CREATED_ACTIVITY]) {
        BOOL hasCreatedActivity = [[response objectForKey:@"has_created_activity"] isEqualToString:@"1"];
        [self.delegate SplashViewControllerDidFinishedWithGoToMainPage:YES WithHasCreatedActivity:hasCreatedActivity WithAnimation:YES];
    }
}

- (void) handleError:(NSString *)aError WithLink:(NSString *)aLink{
    [self goToLoginPageWithAnimation:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
