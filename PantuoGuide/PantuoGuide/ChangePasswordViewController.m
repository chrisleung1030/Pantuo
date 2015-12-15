//
//  ChangePasswordViewController.m
//  PantuoGuide
//
//  Created by Christopher Leung on 9/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "CustomEditTextView.h"

@interface ChangePasswordViewController () <CustomEditTextViewDelegate>

@property (nonatomic, retain) IBOutlet UIButton *updateButton;
@property (nonatomic, retain) IBOutlet UILabel *errorLabel;
@property (nonatomic, retain) CustomEditTextView *oldPwCustomEditTextView;
@property (nonatomic, retain) CustomEditTextView *updatePwCustomEditTextView;
@property (nonatomic, retain) CustomEditTextView *confirmPwCustomEditTextView;

@end

@implementation ChangePasswordViewController

- (NSString *) getTopBarTitle{
    return GetStringWithKey(@"profile_update_password");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addTopBarTitleView];
    [self.updateButton setTitle:GetStringWithKey(@"profile_update_2") forState:UIControlStateNormal];
    
    
    self.oldPwCustomEditTextView = [[[NSBundle mainBundle] loadNibNamed:@"CustomEditTextView" owner:self options:nil] objectAtIndex:0];
    self.oldPwCustomEditTextView.delegate = self;
    [self.view addSubview:self.oldPwCustomEditTextView];
    
    self.updatePwCustomEditTextView = [[[NSBundle mainBundle] loadNibNamed:@"CustomEditTextView" owner:self options:nil] objectAtIndex:0];
    self.updatePwCustomEditTextView.delegate = self;
    [self.view addSubview:self.updatePwCustomEditTextView];
    
    self.confirmPwCustomEditTextView = [[[NSBundle mainBundle] loadNibNamed:@"CustomEditTextView" owner:self options:nil] objectAtIndex:0];
    self.confirmPwCustomEditTextView.delegate = self;
    [self.view addSubview:self.confirmPwCustomEditTextView];
    
    CGRect tempFrame = self.oldPwCustomEditTextView.frame;
    tempFrame.origin.y = 90;
    [self.oldPwCustomEditTextView setFrame:tempFrame];
    
    int y = tempFrame.origin.y + tempFrame.size.height;
    
    tempFrame = self.updatePwCustomEditTextView.frame;
    tempFrame.origin.y = y;
    [self.updatePwCustomEditTextView setFrame:tempFrame];
    y += tempFrame.size.height;
    
    tempFrame = self.confirmPwCustomEditTextView.frame;
    tempFrame.origin.y = y;
    [self.confirmPwCustomEditTextView setFrame:tempFrame];
    
    [self.oldPwCustomEditTextView setPlaceHolder:GetStringWithKey(@"profile_old_pw") WithStar:YES];
    [self.oldPwCustomEditTextView setTitle:GetStringWithKey(@"profile_old_pw") WithStar:YES];
    
    [self.updatePwCustomEditTextView setPlaceHolder:GetStringWithKey(@"profile_new_pw") WithStar:YES];
    [self.updatePwCustomEditTextView setTitle:GetStringWithKey(@"profile_new_pw") WithStar:YES];
    
    [self.confirmPwCustomEditTextView setPlaceHolder:GetStringWithKey(@"profile_confirm_new_pw") WithStar:YES];
    [self.confirmPwCustomEditTextView setTitle:GetStringWithKey(@"profile_confirm_new_pw") WithStar:YES];
    
    [self.oldPwCustomEditTextView.mTextField setSecureTextEntry:YES];
    [self.oldPwCustomEditTextView.mTextField setReturnKeyType:UIReturnKeyNext];
    
    [self.updatePwCustomEditTextView.mTextField setSecureTextEntry:YES];
    [self.updatePwCustomEditTextView.mTextField setReturnKeyType:UIReturnKeyNext];
    
    [self.confirmPwCustomEditTextView.mTextField setSecureTextEntry:YES];
    [self.confirmPwCustomEditTextView.mTextField setReturnKeyType:UIReturnKeyDone];
}

- (IBAction)update:(id)sender{
    NSString *oldPw = [self.oldPwCustomEditTextView getContent];
    NSString *updatePw = [self.updatePwCustomEditTextView getContent];
    NSString *confirmPw = [self.confirmPwCustomEditTextView getContent];
    
    NSString *message = [NSString string];
    if ([oldPw length] == 0) {
        message = GetStringWithKey(@"profile_no_old_pw");
    }else if ([updatePw length] == 0) {
        message = GetStringWithKey(@"profile_no_new_pw");
    }else if ([confirmPw length] == 0) {
        message = GetStringWithKey(@"profile_no_new_confirm_pw");
    }else if (![confirmPw isEqualToString:updatePw]) {
        message = GetStringWithKey(@"profile_no_and_confirm_not_the_same");
    }else if (!IsCorrectPassword(updatePw)) {
        message = GetStringWithKey(@"profile_new_pw_wrong_format");
    }
    
    CGRect tempFrame = self.errorLabel.frame;
    tempFrame.size.width = SCREEN_WIDTH - 20;
    tempFrame.size.height = 100;
    [self.errorLabel setFrame:tempFrame];
    [self.errorLabel setText:message];
    [self.errorLabel sizeToFit];
    
    if ([message length] == 0) {
        GuideInfo *tempInfo = [self getGuideInfo];
        NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:
                              tempInfo.token,@"token",
                              tempInfo.guide_id,@"guide_id",
                              ROLE,@"role",
                              [oldPw AES256EncryptWithKey:KEY], @"old_password",
                              [updatePw AES256EncryptWithKey:KEY],@"new_password", nil];
        [self callPantuoAPIWithLink:API_UPDATE_PASSWORD WithParameter:para];
    }
}

- (void) handleError:(NSString *)aError WithLink:(NSString *)aLink{
    if ([aLink isEqualToString:API_LOGOUT]) {
        [self setUserDefaultWithKey:KEY_GUIDE_INFO WithValue:NULL];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [super handleError:aError WithLink:aLink];
    }
}

- (void) handleResponse:(id)response WithLink:(NSString *)aLink WithRequest:(NSDictionary *)aRequest{
    if ([aLink isEqualToString:API_LOGOUT]) {
        [self setUserDefaultWithKey:KEY_GUIDE_INFO WithValue:NULL];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if ([aLink isEqualToString:API_UPDATE_PASSWORD]) {
        GuideInfo *tempInfo = [self getGuideInfo];
        NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:tempInfo.token,@"token",ROLE,@"role",nil];
        [self callPantuoAPIWithLink:API_LOGOUT WithParameter:para];
        
        UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:GetStringWithKey(@"profile_update_password")
                                                                message:GetStringWithKey(@"profile_update_password_success") delegate:self
                                                      cancelButtonTitle:GetStringWithKey(@"reset_pwd_pos") otherButtonTitles:nil];
        [tempAlertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([self.oldPwCustomEditTextView.mTextField isFirstResponder]){
        [self.oldPwCustomEditTextView.mTextField resignFirstResponder];
    }else if ([self.updatePwCustomEditTextView.mTextField isFirstResponder]){
        [self.updatePwCustomEditTextView.mTextField resignFirstResponder];
    }else if ([self.confirmPwCustomEditTextView.mTextField isFirstResponder]){
        [self.confirmPwCustomEditTextView.mTextField resignFirstResponder];
    }
}

- (void) CustomEditTextViewDidReturn:(id)aSelf{
    if (aSelf == self.oldPwCustomEditTextView){
        [self.updatePwCustomEditTextView.mTextField becomeFirstResponder];
    }else if (aSelf == self.updatePwCustomEditTextView){
        [self.confirmPwCustomEditTextView.mTextField becomeFirstResponder];
    }else if (aSelf == self.confirmPwCustomEditTextView){
        [self.confirmPwCustomEditTextView.mTextField resignFirstResponder];
    }
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
