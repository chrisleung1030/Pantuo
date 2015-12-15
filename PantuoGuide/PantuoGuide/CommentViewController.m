//
//  CommentViewController.m
//  PantuoGuide
//
//  Created by Christopher Leung on 9/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "CommentViewController.h"

@interface CommentViewController () <UITextViewDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) IBOutlet UITextView *commentTextView;
@property (nonatomic, retain) IBOutlet UILabel *subTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *countLabel;
@property (nonatomic, retain) IBOutlet UIButton *submitButton;

@property (nonatomic, assign) int maxCount;
@property (nonatomic, assign) int currentCount;

@end

@implementation CommentViewController

- (NSString *) getTopBarTitle{
    return GetStringWithKey(@"write_comment_title");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addTopBarView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    
    self.currentCount = 0;
    self.maxCount = 500;
    
    [self.subTitleLabel setText:GetStringWithKey(@"write_your_comment")];
    [self.submitButton setTitle:GetStringWithKey(@"comment_submit") forState:UIControlStateNormal];
    [self.countLabel setText:[NSString stringWithFormat:@"%d / %d",self.currentCount,self.maxCount]];
    
    [self.commentTextView becomeFirstResponder];
}

- (void) back:(id)sender{
    if ([self.commentTextView.text length] == 0) {
        [super back:nil];
    }else{
        UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:GetStringWithKey(@"alert_comment")
                                                               delegate:self
                                                      cancelButtonTitle:GetStringWithKey(@"quit_app_neg")
                                                      otherButtonTitles:GetStringWithKey(@"quit_app_pos"), nil];
        [tempAlertView setTag:2];
        [tempAlertView show];
    }
}

- (IBAction)submit:(id)sender{
    NSString *text = self.commentTextView.text;
    if (text.length == 0) {
        UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:GetStringWithKey(@"please_input_comment") delegate:nil cancelButtonTitle:GetStringWithKey(@"confirm") otherButtonTitles:nil];
        [tempAlertView show];
    }else{
        NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:
                              PLATFORM_ID,@"platform",
                              GetUserID(),@"device_id",
                              text,@"comment",nil];
        [self callIPOSCSLAPIWithLink:API_WRITE_COMMENT WithParameter:para WithGet:YES];
    }
}

- (void) handleResponse:(id)response WithLink:(NSString *)aLink WithRequest:(NSDictionary *)aRequest{
    UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:GetStringWithKey(@"comment_submit_success") delegate:self cancelButtonTitle:GetStringWithKey(@"confirm") otherButtonTitles:nil];
    [tempAlertView setTag:1];
    [tempAlertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView tag] == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        if (buttonIndex == 0) {
            [super back:nil];
        }else{
            [self submit:nil];
        }
    }
}

#pragma mark - UITextViewDelegate
- (void)keyboardDidShow:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    NSLog(@"%s %f",__FUNCTION__,keyboardFrameBeginRect.size.height);
    
    CGRect tempFrame = self.commentTextView.frame;
    tempFrame.size.height = SCREEN_HEIGHT - tempFrame.origin.y - keyboardFrameBeginRect.size.height - 35;
    [self.commentTextView setFrame:tempFrame];
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([self.commentTextView isFirstResponder]) {
        [self.commentTextView resignFirstResponder];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    CGRect tempFrame = self.commentTextView.frame;
    tempFrame.size.height = SCREEN_HEIGHT - tempFrame.origin.y - self.submitButton.frame.size.height - 16;
    [self.commentTextView setFrame:tempFrame];
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView == self.commentTextView) {
        if (!self.commentTextView.markedTextRange) {
            if (textView.text.length > self.maxCount) {
                [textView setText:[textView.text substringToIndex:self.maxCount]];
            }
            self.currentCount = (int)self.commentTextView.text.length;
            [self.countLabel setText:[NSString stringWithFormat:@"%d / %d",self.currentCount,self.maxCount]];
        }
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
