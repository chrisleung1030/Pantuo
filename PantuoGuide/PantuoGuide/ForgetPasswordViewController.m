//
//  ForgetPasswordViewController.m
//  PantuoGuide
//
//  Created by Christopher Leung on 8/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "ForgetPasswordViewController.h"

@interface ForgetPasswordViewController () <UITextFieldDelegate>


@property (nonatomic, retain) IBOutlet UIImageView *bgImageView;
@property (nonatomic, retain) IBOutlet UITextField *mobileTextField;
@property (nonatomic, retain) IBOutlet UITextField *codeTextField;
@property (nonatomic, retain) IBOutlet UITextField *pwTextField;
@property (nonatomic, retain) IBOutlet UITextField *repwTextField;

@property (nonatomic, retain) IBOutlet UILabel *mobileErrorLabel;
@property (nonatomic, retain) IBOutlet UILabel *codeErrorLabel;
@property (nonatomic, retain) IBOutlet UILabel *pwErrorLabel;

@property (nonatomic, retain) IBOutlet UIButton *codeButton;
@property (nonatomic, retain) IBOutlet UIButton *doneButton;

@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, assign) int second;

- (IBAction)code:(id)sender;
- (IBAction)done:(id)sender;

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addTopBarView];
    
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
    [tempAttString appendAttributedString:[[NSAttributedString alloc] initWithString:GetStringWithKey(@"new_password")
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
    [self setBackgroundImage];
}

- (NSString *) getTopBarTitle{
    return GetStringWithKey(@"forget_pwd");
}

- (void) setBackgroundImage{
    NSArray *tempArray = [self getUserDefault:KEY_REGISTRATION_BG];
    int index = (int)(random() % [tempArray count]);
    NSString *imageLink = [tempArray objectAtIndex:index];
    
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:imageLink]];
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
        if (mobile.length == 0) {
            mobileMessage = GetStringWithKey(@"login_no_mobile_num");
        }else if (!IsCorrectMobileNumber(mobile)){
            mobileMessage = GetStringWithKey(@"reg_mobile_error");
        }
        [self.mobileErrorLabel setText:mobileMessage];
        
        if (mobileMessage.length == 0) {
            NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  mobile,@"mobile",
                                  @"0",@"for_registration",
                                  nil];
            if (DEBUG_SMS) {
                [para setObject:@"1" forKey:@"debug"];
            }
            [self callPantuoAPIWithLink:API_SEND_SMS WithParameter:para];
        }
    }
}

- (IBAction)done:(id)sender{
    NSString *mobile = self.mobileTextField.text;
    NSString *code = self.codeTextField.text;
    NSString *pw = self.pwTextField.text;
    NSString *repw = self.repwTextField.text;
    
    NSString *mobileMessage = [NSString string];
//    if (mobile.length == 0) {
//        mobileMessage = GetStringWithKey(@"login_no_mobile_num");
    if (!IsCorrectMobileNumber(mobile)){
        mobileMessage = GetStringWithKey(@"reg_mobile_error");
    }
    [self.mobileErrorLabel setText:mobileMessage];
    
    NSString *codeMessage = [NSString string];
    if (code.length == 0) {
        codeMessage = GetStringWithKey(@"please_sms_code");
    }
    [self.codeErrorLabel setText:codeMessage];
    
    NSString *pwMessage = [NSString string];
    if (pw.length == 0) {
        pwMessage = GetStringWithKey(@"login_no_pwd");
    }else if (repw.length == 0) {
        pwMessage = GetStringWithKey(@"please_re_input_pwd");
    }else if (!IsCorrectPassword(pw)){
        pwMessage = GetStringWithKey(@"reg_pwd_combination");
    }else if (![pw isEqualToString:repw]){
        pwMessage = GetStringWithKey(@"two_password_not_match");
    }
    [self.pwErrorLabel setText:pwMessage];
    
    if (mobileMessage.length == 0 && codeMessage.length == 0 && pwMessage.length == 0) {
        NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:
                              mobile,@"mobile",
                              GetUserID(),@"device_id",
                              [pw AES256EncryptWithKey:KEY],@"password",
                              code,@"mobile_code",
                              nil];
        [self callPantuoAPIWithLink:API_FORGET_PASSWORD WithParameter:para];
    }
}

- (void) handleResponse:(id)response WithLink:(NSString *)aLink WithRequest:(NSDictionary *)aRequest{
    if ([aLink isEqualToString:API_FORGET_PASSWORD]) {
        NSString *result = [self getStatusResult:response];
        if ([result length] > 1) {
            UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:result delegate:nil cancelButtonTitle:GetStringWithKey(@"confirm") otherButtonTitles:nil];
            [tempAlertView show];
        }else if ([result isEqualToString:@"1"]){
            UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:GetStringWithKey(@"forget_pwd")
                                                                    message:GetStringWithKey(@"reset_pwd_success_msg") delegate:self cancelButtonTitle:GetStringWithKey(@"confirm") otherButtonTitles:nil];
            [tempAlertView setTag:1];
            [tempAlertView show];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView tag] == 1) {
        [self stopTimer];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([self.mobileTextField isFirstResponder]){
        [self.mobileTextField resignFirstResponder];
    }else if ([self.codeTextField isFirstResponder]){
        [self.codeTextField resignFirstResponder];
    }else if ([self.pwTextField isFirstResponder]){
        [self.pwTextField resignFirstResponder];
    }else if ([self.repwTextField isFirstResponder]){
        [self.repwTextField resignFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if ([textField isEqual:self.pwTextField]) {
        [self.repwTextField becomeFirstResponder];
    }else if ([textField isEqual:self.repwTextField]) {
        [self done:nil];
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
