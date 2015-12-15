//
//  InputTypeViewController.m
//  PantuoGuide
//
//  Created by Christopher Leung on 1/5/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "InputTypeViewController.h"

@interface InputTypeViewController () <UITextFieldDelegate>

@property (nonatomic, retain) UIScrollView *mScrollView;
@property (nonatomic, retain) NSMutableArray *buttonArray;
@property (nonatomic, retain) NSMutableArray *colorArray;

@property (nonatomic, retain) UIButton *otherButton;
@property (nonatomic, retain) UITextField *otherTextField;
@property (nonatomic, retain) UIView *otherView;

@end

@implementation InputTypeViewController

- (NSString *) getTopBarTitle{
    return GetStringWithKey(@"custom_color_activity");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addTopBarView];
    [self.topBarView.saveButton setHidden:NO];
    [self.topBarView.saveButton setTitle:GetStringWithKey(@"save") forState:UIControlStateNormal];
    [self.topBarView.saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-120, SCREEN_WIDTH, 120)];
    [colorView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:colorView];
    
    self.colorArray = [NSMutableArray array];
    int interval = (SCREEN_WIDTH-180)/4;
    for (int i = 0; i < [ACTIVITY_COLOR count]; i++) {
        UIButton *tempButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [tempButton setBackgroundColor:ColorWithHexString([ACTIVITY_COLOR objectAtIndex:i])];
        [tempButton setFrame:CGRectMake(interval*(i+1)+60*i, 30, 60, 60)];
        [tempButton.layer setCornerRadius:30];
        [tempButton.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [tempButton.layer setBorderWidth:0];
        [tempButton setTag:i+101];
        [tempButton addTarget:self action:@selector(color:) forControlEvents:UIControlEventTouchUpInside];
        [colorView addSubview:tempButton];
        [self.colorArray addObject:tempButton];
    }
    
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, SCREEN_HEIGHT-138, SCREEN_WIDTH-16, 18)];
    [tempLabel setText:GetStringWithKey(@"custom_color")];
    [tempLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.view addSubview:tempLabel];
    
    self.mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT-198)];
    [self.view addSubview:self.mScrollView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    [self.mScrollView addGestureRecognizer:tap];
    
    tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, SCREEN_WIDTH-16, 18)];
    [tempLabel setText:GetStringWithKey(@"select_content")];
    [tempLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.mScrollView addSubview:tempLabel];
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, tempLabel.frame.origin.y + tempLabel.frame.size.height, SCREEN_WIDTH, 0)];
    [tempView setBackgroundColor:[UIColor whiteColor]];
    [self.mScrollView addSubview:tempView];
    
    self.buttonArray = [NSMutableArray array];
    interval = (SCREEN_WIDTH - 240)/5;
    int row = 0;
    int totalType = 25;
    int y = 8;
    for (int i = 0 ; i < totalType; i ++) {
        int column = i%4;
        UIButton *tempButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [tempButton setFrame:CGRectMake(60*column+interval*(row+1), y, 60, 60)];
        [tempButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"icn_off_%02d.png",i+1]] forState:UIControlStateNormal];
        [tempButton addTarget:self action:@selector(type:) forControlEvents:UIControlEventTouchUpInside];
        [tempButton setTag:i+1];
        [tempView addSubview:tempButton];
        [self.buttonArray addObject:tempButton];
        row ++;
        if (row == 4) {
            row = 0;
            if (i + 1 != totalType) {
                y += 68;
            }
        }
    }
    y += 94;
    
    self.otherView = [[UIView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, 70)];
    [self.mScrollView addSubview:self.otherView];
    
    self.otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.otherButton setFrame:CGRectMake(interval, 0, 60, 60)];
    [self.otherButton addTarget:self action:@selector(other:) forControlEvents:UIControlEventTouchUpInside];
    [self.otherButton setBackgroundImage:[UIImage imageNamed:@"icn_event_26.png"] forState:UIControlStateNormal];
    [self.otherView addSubview:self.otherButton];
    
//    UILabel *otherTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(interval*2+60, 0, 200, 25)];
//    [otherTitleLabel setText:];
//    [otherTitleLabel setFont:[UIFont systemFontOfSize:14]];
//    [self.otherView addSubview:otherTitleLabel];
    
    self.otherTextField = [[UITextField alloc] initWithFrame:CGRectMake(interval*2+60, 15, 200, 30)];
    [self.otherTextField setText:self.otherType];
    [self.otherTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.otherTextField setPlaceholder:GetStringWithKey(@"hint_word_limit_4")];
    self.otherTextField.delegate = self;
    [self.otherView addSubview:self.otherTextField];
    
    y+= self.otherView.frame.size.height;
    
    CGRect tempFrame = tempView.frame;
    tempFrame.size.height = y;
    [tempView setFrame:tempFrame];
    [self.mScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, y)];
    
    if (self.selectedColor > 0) {
        UIButton *tempButton = (UIButton *)[self.colorArray objectAtIndex:self.selectedColor-1];
        [tempButton.layer setBorderWidth:3];
    }
    if (self.selectedType > 0) {
        UIButton *tempButton = (UIButton *)[self.buttonArray objectAtIndex:self.selectedType-1];
        [tempButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"icn_on_%02d.png",self.selectedType]] forState:UIControlStateNormal];
    }
    self.otherTextField.text = self.otherType;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self tapped];
}

- (void) tapped{
    if ([self.otherTextField isFirstResponder]){
        [self.otherTextField resignFirstResponder];
    }
}

- (void) type:(UIButton *)sender{
    if (self.selectedType > 0) {
        UIButton *tempButton = (UIButton *)[self.buttonArray objectAtIndex:self.selectedType-1];
        [tempButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"icn_off_%02d.png",self.selectedType]] forState:UIControlStateNormal];
    }
    if (self.selectedType == (int)[sender tag]) {
        self.selectedType = 0;
        if (self.otherTextField.text.length > 0) {
            [self.otherButton setBackgroundImage:[UIImage imageNamed:@"icn_event_green_26.png"] forState:UIControlStateNormal];
        }else{
            [self.otherButton setBackgroundImage:[UIImage imageNamed:@"icn_event_26.png"] forState:UIControlStateNormal];
        }
    }else{
        self.selectedType = (int)[sender tag];
        UIButton *tempButton = (UIButton *)[self.buttonArray objectAtIndex:self.selectedType-1];
        [tempButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"icn_on_%02d.png",self.selectedType]] forState:UIControlStateNormal];
        [self.otherButton setBackgroundImage:[UIImage imageNamed:@"icn_event_26.png"] forState:UIControlStateNormal];
    }
    [self.otherTextField resignFirstResponder];
}

- (void) other:(id)sender{
    if (![self.otherTextField isFirstResponder]) {
        [self.otherTextField becomeFirstResponder];
    }
}

- (void) color:(UIButton *)sender{
    if (self.selectedColor > 0) {
        UIButton *tempButton = (UIButton *)[self.colorArray objectAtIndex:self.selectedColor-1];
        [tempButton.layer setBorderWidth:0];
    }
    self.selectedColor = (int)[sender tag] - 100;
    UIButton *tempButton = (UIButton *)[self.colorArray objectAtIndex:self.selectedColor-1];
    [tempButton.layer setBorderWidth:3];
    
}

- (void) save{
    NSString *message = [NSString string];
    if (self.selectedColor <= 0 || (self.selectedType <= 0 && self.otherTextField.text.length == 0)) {
        message = GetStringWithKey(@"error_activity_type");
    }
    
    if (message.length == 0) {
        if (self.delegate) {
            [self.delegate InputTypeViewControllerDidFinishWithType:self.selectedType
                                                          WithColor:[ACTIVITY_COLOR objectAtIndex:self.selectedColor-1]
                                                      WithOtherType:self.otherTextField.text];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:GetStringWithKey(@"confirm") otherButtonTitles:nil];
        [tempAlertView show];
    }
}

-(void)keyboardWillShow:(NSNotification*)notification
{
    if (self.selectedType > 0) {
        UIButton *tempButton = (UIButton *)[self.buttonArray objectAtIndex:self.selectedType-1];
        [tempButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"icn_off_%02d.png",self.selectedType]] forState:UIControlStateNormal];
        self.selectedType = 0;
    }
    [self.otherButton setBackgroundImage:[UIImage imageNamed:@"icn_event_green_26.png"] forState:UIControlStateNormal];
    
    CGFloat height = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGRect tempFrame = self.mScrollView.frame;
    tempFrame.size.height = SCREEN_HEIGHT - tempFrame.origin.y -height;
    [self.mScrollView setFrame:tempFrame];
    
    [self.mScrollView setContentOffset:CGPointMake(0, self.mScrollView.contentSize.height -tempFrame.size.height+ 10) animated:YES];
    
}

-(void)keyboardWillHide:(NSNotification*)notification{
    CGRect tempFrame = self.mScrollView.frame;
    tempFrame.size.height = SCREEN_HEIGHT-198;
    [self.mScrollView setFrame:tempFrame];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self tapped];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (self.otherTextField.markedTextRange) {
        return YES;
    }else{
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        
        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
        return newLength <= 4 || returnKey;
    }
}

- (void) textDidChange:(NSNotification*)notification{
    if (!self.otherTextField.markedTextRange) {
        if (self.otherTextField.text.length > 4) {
            [self.otherTextField setText:[self.otherTextField.text substringToIndex:4]];
        }
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

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}


@end
