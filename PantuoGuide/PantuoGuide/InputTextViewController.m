//
//  InputTextViewController.m
//  PantuoGuide
//
//  Created by Christopher Leung on 16/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "InputTextViewController.h"

@interface InputTextViewController () <UITextViewDelegate>

@property (nonatomic, retain) IBOutlet UITextView *mTextView;
@property (nonatomic, retain) IBOutlet UILabel *placeholderLabel;
@property (nonatomic, retain) IBOutlet UILabel *countLabel;

@end

@implementation InputTextViewController

- (NSString *) getTopBarTitle{
    return self.titleText;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addTopBarView];
    [self.topBarView.saveButton setHidden:NO];
    [self.topBarView.saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
    self.currentCount = 0;
    [self.countLabel setText:[NSString stringWithFormat:@"%d / %d",self.currentCount,self.maxCount]];
    if (self.presetText.length > 0) {
        [self.mTextView setText:self.presetText];
        [self textViewDidChange:self.mTextView];
    }
    if (self.isSendSMS) {
        [self.placeholderLabel setText:GetStringWithKey(@"attendance_placeholer")];
        [self.topBarView.saveButton setTitle:GetStringWithKey(@"attendance_send") forState:UIControlStateNormal];
    }else {
        [self.topBarView.saveButton setTitle:GetStringWithKey(@"save") forState:UIControlStateNormal];
        [self.placeholderLabel setText:[NSString stringWithFormat:@"%@%@",GetStringWithKey(@"please_allow"),self.titleText]];
    }
    [self.mTextView.layer setBorderColor:ColorWithHexString(@"BABBBC").CGColor];
    [self.mTextView.layer setBorderWidth:1];
    [self.mTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self hideKeyboard];
}

- (void) hideKeyboard{
    if ([self.mTextView isFirstResponder]){
        [self.mTextView resignFirstResponder];
    }
}

- (void) save{
    if (self.isSendSMS) {
        [self logEventWithId:GetStringWithKey(@"Tracking_send_message_send_id") WithLabel:GetStringWithKey(@"Tracking_send_message_send")];
        if (self.mTextView.text.length > 0) {
            [self hideKeyboard];
            GuideInfo *tempInfo = [self getGuideInfo];
            NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:
                                  tempInfo.token,@"token",
                                  tempInfo.guide_id,@"guide_id",
                                  self.mTextView.text,@"content",
                                  self.activityId,@"activity_id", nil];
            [self callIPOSCSLAPIWithLink:API_SEND_ACTIVITY_SMS WithParameter:para WithGet:YES];
        }
    }else{
        if (self.delegate) {
            [self.delegate InputTextViewControllerDidFinish:self WithText:self.mTextView.text];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) handleResponse:(id)response WithLink:(NSString *)aLink WithRequest:(NSDictionary *)aRequest{
    UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:GetStringWithKey(@"attendance_finish_send_sms") delegate:self cancelButtonTitle:GetStringWithKey(@"confirm") otherButtonTitles:nil];
    [tempAlertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    if (textView == self.mTextView) {
        if (!self.mTextView.markedTextRange) {
            if (textView.text.length > self.maxCount) {
                [textView setText:[textView.text substringToIndex:self.maxCount]];
            }
            self.currentCount = (int)self.mTextView.text.length;
            [self.countLabel setText:[NSString stringWithFormat:@"%d / %d",self.currentCount,self.maxCount]];
        }
        [self.placeholderLabel setHidden:textView.text.length > 0];
    }
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
