//
//  RegistrationViewController.m
//  PantuoGuide
//
//  Created by Christopher Leung on 8/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "RegistrationViewController.h"
#import "WebViewController.h"
#import "LandingViewController.h"

@interface RegistrationViewController () <UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UITextField *mobileTextField;
@property (nonatomic, retain) IBOutlet UITextField *codeTextField;
@property (nonatomic, retain) IBOutlet UITextField *pwTextField;
@property (nonatomic, retain) IBOutlet UITextField *repwTextField;
@property (nonatomic, retain) IBOutlet UITextField *suggestTextField;

@property (nonatomic, retain) IBOutlet UILabel *mobileErrorLabel;
@property (nonatomic, retain) IBOutlet UILabel *codeErrorLabel;
@property (nonatomic, retain) IBOutlet UILabel *tncErrorLabel;

@property (nonatomic, retain) IBOutlet UIButton *codeButton;
@property (nonatomic, retain) IBOutlet UIButton *checkedButton;
@property (nonatomic, retain) IBOutlet UIButton *tandcButton;
@property (nonatomic, retain) IBOutlet UIButton *doneButton;

@property (nonatomic, retain) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic, retain) IBOutlet UIImageView *bgImageView;
@property (nonatomic, retain) IBOutlet UIImageView *checkedImageView;

@property (nonatomic, assign) BOOL isChecked;

@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, assign) int second;

@end

@implementation RegistrationViewController
@synthesize socialMediaDict;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setBackgroundImage];
    [self addTopBarView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    [self.mainScrollView addGestureRecognizer:tap];
    
    self.isChecked = NO;
    [self.codeButton setTitle:GetStringWithKey(@"reg_send_sms") forState:UIControlStateNormal];
    [self.doneButton setTitle:GetStringWithKey(@"done") forState:UIControlStateNormal];
    
    NSMutableAttributedString *tempAttString = [[NSMutableAttributedString alloc] init];
    [tempAttString appendAttributedString:[[NSAttributedString alloc] initWithString:GetStringWithKey(@"mobile_num")
                                                                          attributes:@{NSForegroundColorAttributeName:[[UIColor grayColor] colorWithAlphaComponent:0.5]}]];
    
    
    [tempAttString appendAttributedString:[[NSAttributedString alloc] initWithString:@"*"
                                                                          attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}]];
    [self.mobileTextField setAttributedPlaceholder:tempAttString];
    
    tempAttString = [[NSMutableAttributedString alloc] init];
    [tempAttString appendAttributedString:[[NSAttributedString alloc] initWithString:GetStringWithKey(@"verification_code")
                                                                          attributes:@{NSForegroundColorAttributeName:[[UIColor grayColor] colorWithAlphaComponent:0.5]}]];
    [tempAttString appendAttributedString:[[NSAttributedString alloc] initWithString:@"*"
                                                                          attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}]];
    [self.codeTextField setAttributedPlaceholder:tempAttString];
    
    tempAttString = [[NSMutableAttributedString alloc] init];
    [tempAttString appendAttributedString:[[NSAttributedString alloc] initWithString:GetStringWithKey(@"login_password")
                                                                          attributes:@{NSForegroundColorAttributeName:[[UIColor grayColor] colorWithAlphaComponent:0.5]}]];
    [tempAttString appendAttributedString:[[NSAttributedString alloc] initWithString:@"*"
                                                                          attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}]];
    [self.pwTextField setAttributedPlaceholder:tempAttString];
    
    tempAttString = [[NSMutableAttributedString alloc] init];
    [tempAttString appendAttributedString:[[NSAttributedString alloc] initWithString:GetStringWithKey(@"login_password_confirm")
                                                                          attributes:@{NSForegroundColorAttributeName:[[UIColor grayColor] colorWithAlphaComponent:0.5]}]];
    [tempAttString appendAttributedString:[[NSAttributedString alloc] initWithString:@"*"
                                                                          attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}]];
    [self.repwTextField setAttributedPlaceholder:tempAttString];
    
    
    NSDictionary *dict1 = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone),
                            NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                            NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    NSDictionary *dict2 = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),
                           NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                           NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    tempAttString = [[NSMutableAttributedString alloc] init];
    [tempAttString appendAttributedString:[[NSAttributedString alloc] initWithString:GetStringWithKey(@"agree") attributes:dict1]];
    [tempAttString appendAttributedString:[[NSAttributedString alloc] initWithString:GetStringWithKey(@"tnc") attributes:dict2]];
    [self.tandcButton setAttributedTitle:tempAttString forState:UIControlStateNormal];
    
    [self.suggestTextField setPlaceholder:GetStringWithKey(@"rec_mobile_num")];
    
    if (self.socialMediaDict) {
        [self.pwTextField setHidden:YES];
        [self.repwTextField setHidden:YES];
        
        int interval = self.mobileErrorLabel.frame.origin.y - self.pwTextField.frame.origin.y;
        CGRect tempFrame = self.mobileErrorLabel.frame;
        tempFrame.origin.y -= interval;
        [self.mobileErrorLabel setFrame:tempFrame];
        
        tempFrame = self.codeTextField.frame;
        tempFrame.origin.y -= interval;
        [self.codeTextField setFrame:tempFrame];
        
        tempFrame = self.codeButton.frame;
        tempFrame.origin.y -= interval;
        [self.codeButton setFrame:tempFrame];
        
        tempFrame = self.codeErrorLabel.frame;
        tempFrame.origin.y -= interval;
        [self.codeErrorLabel setFrame:tempFrame];
        
        tempFrame = self.suggestTextField.frame;
        tempFrame.origin.y -= interval;
        [self.suggestTextField setFrame:tempFrame];
    }
}

- (void) startTimer:(int)second{
    [self stopTimer];
    self.second = second;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCodeCountDown) userInfo:nil repeats:YES];
}

- (void) stopTimer{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void) updateCodeCountDown{
    if (self.second == 0) {
        [self stopTimer];
        [self.codeButton setTitle:GetStringWithKey(@"reg_send_sms") forState:UIControlStateNormal];
    }else{
        NSString *text = [NSString stringWithFormat:@"%02d : %02d",self.second/60,self.second%60];
        [self.codeButton setTitle:text forState:UIControlStateNormal];
    }
    self.second --;
}

- (IBAction)code:(id)sender{
    if (!self.timer) {
        NSString *mobile = self.mobileTextField.text;
        
        NSString *mobileMessage = [NSString string];
        //    if (mobile.length == 0) {
        //        mobileMessage = GetStringWithKey(@"login_no_mobile_num");
        if (!IsCorrectMobileNumber(mobile)){
            mobileMessage = GetStringWithKey(@"reg_mobile_error");
        }
        [self.mobileErrorLabel setText:mobileMessage];
        
        if (mobileMessage.length == 0) {
            NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  mobile,@"mobile",
                                  @"1",@"for_registration",
                                  nil];
            if (DEBUG_SMS) {
                [para setObject:@"1" forKey:@"debug"];
            }
            [self callPantuoAPIWithLink:API_SEND_SMS WithParameter:para];
            [self.codeTextField becomeFirstResponder];
        }
    }
}

- (IBAction)check:(id)sender{
    self.isChecked = !self.isChecked;
    if (self.isChecked) {
        [self.checkedImageView setImage:[UIImage imageNamed:@"tnc_chceked.png"]];
    }else{
        [self.checkedImageView setImage:[UIImage imageNamed:@"tnc_uncheck.png"]];
    }
}

- (IBAction)tandc:(id)sender{
    WebViewController *vc = [WebViewController new];
    vc.title = GetStringWithKey(@"tnc");
    vc.link = API_GET_TNC;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)done:(id)sender{
    [self logEventWithId:GetStringWithKey(@"Tracking_registration_finish_id") WithLabel:GetStringWithKey(@"Tracking_registration_finish")];
    NSString *mobile = self.mobileTextField.text;
    NSString *code = self.codeTextField.text;
    NSString *pw = self.pwTextField.text;
    NSString *repw = self.repwTextField.text;
    
    NSString *mobileMessage = [NSString string];
    if (mobile.length == 0) {
        mobileMessage = GetStringWithKey(@"login_no_mobile_num");
    }else if (!self.socialMediaDict){
        if (pw.length == 0) {
            mobileMessage = GetStringWithKey(@"login_no_pwd");
        }else if (repw.length == 0) {
            mobileMessage = GetStringWithKey(@"please_re_input_pwd");
        }else if (!IsCorrectMobileNumber(mobile)){
            mobileMessage = GetStringWithKey(@"reg_mobile_error");
        }else if (!IsCorrectPassword(pw)){
            mobileMessage = GetStringWithKey(@"reg_pwd_combination");
        }else if (![pw isEqualToString:repw]){
            mobileMessage = GetStringWithKey(@"two_password_not_match");
        }
    }else if (!IsCorrectMobileNumber(mobile)){
        mobileMessage = GetStringWithKey(@"reg_mobile_error");
    }
    
    [self.mobileErrorLabel setText:mobileMessage];
    
    NSString *codeMessage = [NSString string];
    if (code.length == 0) {
        codeMessage = GetStringWithKey(@"input_sms_verification_code");
    }
    [self.codeErrorLabel setText:codeMessage];
    
    NSString *tncMessage = [NSString string];
    if (!self.isChecked) {
        tncMessage = GetStringWithKey(@"tnc_not_checked_error");
    }
    [self.tncErrorLabel setText:tncMessage];
    
    if (mobileMessage.length == 0 && codeMessage.length == 0 && tncMessage.length == 0) {
        NSMutableDictionary *para;
        if (self.socialMediaDict) {
            para = [NSMutableDictionary dictionaryWithDictionary:self.socialMediaDict];
            [para setObject:mobile forKey:@"mobile"];
            [para setObject:GetUserID() forKey:@"device_id"];
            [para setObject:code forKey:@"mobile_code"];
            [para setObject:ROLE forKey:@"role"];            
        }else{
            para = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                    mobile,@"mobile",
                    GetUserID(),@"device_id",
                    [pw AES256EncryptWithKey:KEY],@"password",
                    code,@"mobile_code",
                    ROLE,@"role",
                    nil];
            if (self.suggestTextField.text.length > 0) {
                [para setObject:self.suggestTextField.text forKey:@"refer_mobile"];
            }
        }
        [self callPantuoAPIWithLink:API_REGISTRATION WithParameter:para];
    }
}

- (void) handleResponse:(id)response WithLink:(NSString *)aLink WithRequest:(NSDictionary *)aRequest{
    if ([aLink isEqualToString:API_REGISTRATION]) {
        NSString *result = [self getStatusResult:response];
        if ([result length] > 1) {
            UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:result delegate:nil cancelButtonTitle:GetStringWithKey(@"confirm") otherButtonTitles:nil];
            [tempAlertView show];
        }else{
            GuideInfo *guideInfo = [GuideInfo new];
            [guideInfo setUpGuideInfo:response];
            NSData *guideInfoEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:guideInfo];
            [self setUserDefaultWithKey:KEY_GUIDE_INFO WithValue:guideInfoEncodedObject];
            [self setUserDefaultWithKey:KEY_SAVED_MOBILE WithValue:self.mobileTextField.text];
            
            LandingViewController *vc = [LandingViewController new];
            vc.hasCreatedActivity = NO;
            
            UINavigationController *nvc =  self.navigationController;
            [nvc popViewControllerAnimated:NO];
            [nvc pushViewController:vc animated:YES];
        }
    }else if ([aLink isEqualToString:API_SEND_SMS]){
        if ([response objectForKey:@"error"]) {
            UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:[NSString string]
                                                                    message:[response objectForKey:@"error"]
                                                                   delegate:nil
                                                          cancelButtonTitle:GetStringWithKey(@"confirm") otherButtonTitles:nil];
            [tempAlertView show];
        }
        id object = [response objectForKey:@"countdown"];
        if (object){
            [self startTimer:[object intValue]*60];
        }else{
            [self startTimer:180];
        }
    }
}

- (void) setBackgroundImage{
    NSArray *tempArray = [self getUserDefault:KEY_REGISTRATION_BG];
    int index = (int)(random() % [tempArray count]);
    NSString *imageLink = [tempArray objectAtIndex:index];

    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:imageLink]];
}


- (NSString *) getTopBarTitle{
    return GetStringWithKey(@"registration");
}

- (void) tapped{
    if ([self.mobileTextField isFirstResponder]){
        [self.mobileTextField resignFirstResponder];
    }else if ([self.codeTextField isFirstResponder]){
        [self.codeTextField resignFirstResponder];
    }else if ([self.pwTextField isFirstResponder]){
        [self.pwTextField resignFirstResponder];
    }else if ([self.repwTextField isFirstResponder]){
        [self.repwTextField resignFirstResponder];
    }else if ([self.suggestTextField isFirstResponder]){
        [self.suggestTextField resignFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if ([textField isEqual:self.pwTextField]) {
        [self.repwTextField becomeFirstResponder];
    }else if ([textField isEqual:self.repwTextField]){
        [self.codeTextField becomeFirstResponder];
    }
    return YES;
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
