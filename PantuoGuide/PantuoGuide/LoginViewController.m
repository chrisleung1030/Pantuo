//
//  LoginViewController.m
//  PantuoGuide
//
//  Created by Christopher Leung on 8/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "LoginViewController.h"
#import "SplashViewController.h"
#import "TutorialViewController.h"
#import "ForgetPasswordViewController.h"
#import "RegistrationViewController.h"
#import "LandingViewController.h"
#import "AboutUsViewController.h"
#import "MyInfoViewController.h"
#import "AppDelegate.h"
#import <TencentOpenAPI/QQApiInterface.h>

@interface LoginViewController () <UIGestureRecognizerDelegate, UITextFieldDelegate, SplashViewControllerDelegate, TutorialViewControllerDelegate, QQApiInterfaceDelegate>

@property (nonatomic, retain) SplashViewController *splashViewController;
@property (nonatomic, retain) TutorialViewController *tutorialViewController;

@property (nonatomic, retain) IBOutlet UIImageView *bgImageView;
@property (nonatomic, retain) IBOutlet UITextField *mobileTextField;
@property (nonatomic, retain) IBOutlet UITextField *passwordTextField;
@property (nonatomic, retain) IBOutlet UILabel *errorLabel;
@property (nonatomic, retain) IBOutlet UIButton *forgetPasswordButton;
@property (nonatomic, retain) IBOutlet UIButton *loginButton;
@property (nonatomic, retain) IBOutlet UILabel *socialMediaLabel;
@property (nonatomic, retain) IBOutlet UIButton *registrationButton;
@property (nonatomic, assign) BOOL canLogin;
@property (nonatomic, assign) BOOL isSocialLogin;
@property (nonatomic, retain) NSDictionary *socialDict;

- (IBAction)forgetPassword:(id)sender;
- (IBAction)login:(id)sender;
- (IBAction)qq:(id)sender;
- (IBAction)weChat:(id)sender;
- (IBAction)weibo:(id)sender;
- (IBAction)registration:(id)sender;

@end

@implementation LoginViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.canLogin = YES;
    [self.errorLabel setAdjustsFontSizeToFitWidth:YES];
    
    [self.mobileTextField setPlaceholder:GetStringWithKey(@"mobile_num")];
    [self.passwordTextField setPlaceholder:GetStringWithKey(@"login_password")];
    [self.loginButton setTitle:GetStringWithKey(@"login") forState:UIControlStateNormal];
    [self.socialMediaLabel setText:GetStringWithKey(@"login_using_social_media")];
    [self.registrationButton setTitle:GetStringWithKey(@"register_now") forState:UIControlStateNormal];
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.alignment                = NSTextAlignmentCenter;
    
    NSDictionary *dict = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),
                            NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                            NSForegroundColorAttributeName:[UIColor whiteColor],
                           NSParagraphStyleAttributeName:paragraphStyle};
    
    NSMutableAttributedString *tempAttString = [[NSMutableAttributedString alloc] init];
    [tempAttString appendAttributedString:[[NSAttributedString alloc] initWithString:GetStringWithKey(@"login_forget_pwd") attributes:dict]];
    [self.forgetPasswordButton setAttributedTitle:tempAttString forState:UIControlStateNormal];
    
    self.splashViewController = [SplashViewController new];
    self.splashViewController.delegate = self;
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window addSubview:self.splashViewController.view];
    self.splashViewController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

}

- (void) setBackgroundImage:(UIImage *)aImage{
    [self.bgImageView setImage:aImage];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    NSString *mobile = [self getUserDefault:KEY_SAVED_MOBILE];
    if (mobile && mobile.length > 0) {
        [self.mobileTextField setText:mobile];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}


- (void) socialLoginWithInfo:(NSDictionary *)aDict{
    self.isSocialLogin = YES;
    self.socialDict = aDict;
    [self callPantuoAPIWithLink:API_LOGIN WithParameter:aDict];
}

- (IBAction)forgetPassword:(id)sender{
    [self.navigationController pushViewController:[ForgetPasswordViewController new] animated:YES];
}

- (IBAction)login:(id)sender{
    [self logEventWithId:GetStringWithKey(@"Tracking_login_phone_login_id") WithLabel:GetStringWithKey(@"Tracking_login_phone_login")];
    [self hideKeyboard:NO];
    [self checkLogin];
}

- (IBAction)qq:(id)sender{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate tencentLogin];
}

- (IBAction)weChat:(id)sender{
    [self loginWeChat];
}

- (IBAction)weibo:(id)sender{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = WEIBO_REDIRECT_URL;
    request.scope = WEIBO_SCOPE;
    [WeiboSDK sendRequest:request];
}

- (IBAction)registration:(id)sender{
    [self logEventWithId:GetStringWithKey(@"Tracking_login_go_to_registration_id") WithLabel:GetStringWithKey(@"Tracking_login_go_to_registration")];
    [self.navigationController pushViewController:[RegistrationViewController new] animated:YES];
}

- (void) goLoginWithMobile:(NSString *)aMobile WithPassword:(NSString *)aPassword{
    self.isSocialLogin = NO;
    NSString *ePw = [aPassword AES256EncryptWithKey:KEY];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:
                          ROLE,@"role",
                          aMobile,@"mobile",
                          GetUserID(),@"device_id",
                          ePw,@"password",
                          nil];
    [self callPantuoAPIWithLink:API_LOGIN WithParameter:para];
}

- (void) getHasCreatedActivity:(GuideInfo *)aGuideInfo{
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:
                          aGuideInfo.token,@"token",
                          aGuideInfo.guide_id,@"guide_id",
                          nil];
    [self callIPOSCSLAPIWithLink:API_HAS_CREATED_ACTIVITY WithParameter:para WithGet:YES];
}

- (void) handleError:(NSString *)aError WithLink:(NSString *)aLink{
    if ([aLink isEqualToString:API_LOGIN] && self.isSocialLogin) {
        RegistrationViewController *vc = [RegistrationViewController new];
        vc.socialMediaDict = self.socialDict;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [super handleError:aError WithLink:aLink];
    }
}

- (void) handleResponse:(id)response WithLink:(NSString *)aLink WithRequest:(NSDictionary *)aRequest{
    if ([aLink isEqualToString:API_LOGIN]) {
        GuideInfo *guideInfo = [GuideInfo new];
        [guideInfo setUpGuideInfo:response];
        NSData *guideInfoEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:guideInfo];
        [self setUserDefaultWithKey:KEY_GUIDE_INFO WithValue:guideInfoEncodedObject];
        [self setUserDefaultWithKey:KEY_SAVED_MOBILE WithValue:self.mobileTextField.text];
        
        [self getHasCreatedActivity:guideInfo];
    }else if ([aLink isEqualToString:API_HAS_CREATED_ACTIVITY]) {
        [self.mobileTextField setText:[NSString string]];
        [self.passwordTextField setText:[NSString string]];
        BOOL hasCreatedActivity = [[response objectForKey:@"has_created_activity"] isEqualToString:@"1"];
        LandingViewController *vc = [LandingViewController new];
        vc.hasCreatedActivity = hasCreatedActivity;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self hideKeyboard:NO];
}

- (void) checkLogin{
    NSString *mobile = self.mobileTextField.text;
    NSString *password = self.passwordTextField.text;
    
    NSString *message = [NSString string];
    if (mobile.length == 0) {
        message = GetStringWithKey(@"login_no_mobile_num");
    }else if (password.length == 0){
        message = GetStringWithKey(@"login_no_pwd");
    }else if (!IsCorrectMobileNumber(mobile)){
        message = GetStringWithKey(@"mobile_num_error");
    }else if(!IsCorrectPassword(password)){
        message = GetStringWithKey(@"login_incorrect_pwd");
    }
    
    [self.errorLabel setText:message];
    if (message.length == 0) {
        [self hideKeyboard:NO];
        [self goLoginWithMobile:mobile WithPassword:password];
    }
}

- (void) hideKeyboard:(BOOL)aLogin{
    if ([self.mobileTextField isFirstResponder]){
        [self.mobileTextField resignFirstResponder];
    }else if ([self.passwordTextField isFirstResponder]){
        [self.passwordTextField resignFirstResponder];
        if (aLogin) {
            [self checkLogin];
        }
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self hideKeyboard:YES];
    return YES;
}


#pragma mark - SplashViewControllerDelegate
- (void) SplashViewControllerDidFinishedWithGoToMainPage:(BOOL)aGoToMainPage WithHasCreatedActivity:(BOOL)aHasCreatedActivity WithAnimation:(BOOL)aAnimation{
    if (aGoToMainPage) {
        LandingViewController *vc = [LandingViewController new];
        vc.hasCreatedActivity = aHasCreatedActivity;
        [self.navigationController pushViewController:vc animated:NO];
    }
    if (aAnimation) {
        [UIView animateWithDuration:1.5 animations:^{
            [self.splashViewController.view setAlpha:0];
        } completion:^(BOOL finished) {
            [self.splashViewController.view removeFromSuperview];
            self.splashViewController.delegate = nil;
            self.splashViewController = nil;
        }];
    }else{
        [self.splashViewController.view removeFromSuperview];
        self.splashViewController.delegate = nil;
        self.splashViewController = nil;
    }
}

- (void) SplashViewControllerDidFinishedWithGoToTutorial{
    self.tutorialViewController = [TutorialViewController new];
    self.tutorialViewController.delegate = self;
    [self.view addSubview:self.tutorialViewController.view];
    self.tutorialViewController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

#pragma mark - TutorialViewControllerDelegate
- (void) TutorialViewControllerDidAnimated{
    [self.splashViewController.view removeFromSuperview];
    self.splashViewController.delegate = nil;
    self.splashViewController = nil;
}

- (void) TutorialViewControllerDidFinish{
    [UIView animateWithDuration:1.5 animations:^{
        [self.tutorialViewController.view setAlpha:0];
    } completion:^(BOOL finished) {
        [self.tutorialViewController.view removeFromSuperview];
        self.tutorialViewController.delegate = nil;
        self.tutorialViewController = nil;
    }];
}

#pragma mark - QQApiInterfaceDelegate
- (void)onReq:(QQBaseReq *)req{
}

- (void)onResp:(QQBaseResp *)resp{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate handleQQAPIInterfaceResp:resp];
}

- (void)isOnlineResponse:(NSDictionary *)response{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
