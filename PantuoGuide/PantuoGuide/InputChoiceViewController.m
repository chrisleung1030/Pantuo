//
//  InputChoiceViewController.m
//  PantuoGuide
//
//  Created by Christopher Leung on 27/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "InputChoiceViewController.h"
#import "ClickableNameView.h"

@interface InputChoiceViewController () <UITextViewDelegate>

@property (nonatomic, retain) UIScrollView *mScrollView;
@property (nonatomic, retain) UILabel *countLabel;
@property (nonatomic, retain) UITextView *mTextView;

@property (nonatomic, retain) UILabel *placeholderLabel;

@end

@implementation InputChoiceViewController

- (NSString *) getTopBarTitle{
    return self.titleText;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addTopBarView];
    [self.topBarView.saveButton setHidden:NO];
    [self.topBarView.saveButton setTitle:GetStringWithKey(@"save") forState:UIControlStateNormal];
    [self.topBarView.saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
    self.mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT-60)];
    [self.view addSubview:self.mScrollView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    [self.mScrollView addGestureRecognizer:tap];
    
    self.choiceArray = [NSMutableArray array];
    [self callIPOSCSLAPIWithLink:self.apiForChoice WithParameter:nil WithGet:YES];
}

- (void) handleResponse:(id)response WithLink:(NSString *)aLink WithRequest:(NSDictionary *)aRequest{
    
    if ([self.apiForChoice isEqualToString:API_GET_SLOGAN]) {
        [self.choiceArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                     response,@"options",
                                     [NSString string],@"name",nil]];
    }else{
        self.choiceArray = response;
    }
    int y = 0;
    UILabel *tempLabel;
    NSArray *selectedChoiceArray = [NSArray array];
    if (self.selectedChoice.length > 0) {
        selectedChoiceArray = [self.selectedChoice componentsSeparatedByString:GetStringWithKey(@"activity_text_seperator")];
    }
    if ([self.choiceArray count] == 1) {
        tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH-16, 25)];
        [tempLabel setText:GetStringWithKey(@"select_content")];
        [tempLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [self.mScrollView addSubview:tempLabel];
        
        y = tempLabel.frame.origin.y + tempLabel.frame.size.height;
    }
    
    BOOL addUpBorder = YES;
    for (NSDictionary *tempDict in self.choiceArray) {
        NSString *title = [tempDict objectForKey:@"name"];
        if (addUpBorder && [self.choiceArray count] > 1) {
            title = [GetStringWithKey(@"select_content") stringByAppendingString:title];
        }
        ClickableNameView *tempClickableNameView = [[[NSBundle mainBundle] loadNibNamed:@"ClickableNameView" owner:self options:nil] objectAtIndex:0];
        [tempClickableNameView setFrame:CGRectMake(0, y, SCREEN_WIDTH, tempClickableNameView.frame.size.height)];
        [self.mScrollView addSubview:tempClickableNameView];
        [tempClickableNameView initViewWithTitle:title
                                       WithStart:NO
                                   WithNameArray:[NSMutableArray arrayWithArray:[tempDict objectForKey:@"options"]]
                            WithClickedNameArray:selectedChoiceArray];
        [tempClickableNameView addBorder:addUpBorder];
        if (addUpBorder) {
            addUpBorder = NO;
        }
        y += tempClickableNameView.frame.size.height;
    }
    
    tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, y, SCREEN_WIDTH-16, 25)];
    [tempLabel setText:GetStringWithKey(@"other")];
    [tempLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.mScrollView addSubview:tempLabel];
    
    self.currentCount = (int)self.otherChoice.length;
    self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, y, SCREEN_WIDTH-16, 25)];
    [self.countLabel setText:[NSString stringWithFormat:@"%d / %d",self.currentCount,self.maxCount]];
    [self.countLabel setTextAlignment:NSTextAlignmentRight];
    [self.countLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.mScrollView addSubview:self.countLabel];
    
    y += tempLabel.frame.size.height;
    
    self.mTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, 200)];
    self.mTextView.delegate = self;
    [self.mScrollView addSubview:self.mTextView];
    [self.mTextView setFont:[UIFont systemFontOfSize:14]];
    [self.mTextView.layer setBorderWidth:1];
    [self.mTextView.layer setBorderColor:ColorWithHexString(@"BABBBC").CGColor];
    self.mTextView.text = self.otherChoice;
    
    self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, y+6, 320, 21)];
    [self.placeholderLabel setTextColor:[UIColor lightGrayColor]];
    [self.placeholderLabel setUserInteractionEnabled:NO];
    [self.placeholderLabel setFont:[UIFont systemFontOfSize:14]];
    [self.placeholderLabel setText:[NSString stringWithFormat:@"%@%@",GetStringWithKey(@"please_allow"),self.titleText]];
    [self.mScrollView addSubview:self.placeholderLabel];
    
    [self.placeholderLabel setHidden:self.mTextView.text.length > 0];
    
    y += self.mTextView.frame.size.height + 10;
    
    [self.mScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, y)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self tapped];
}

- (void) tapped{
    if ([self.mTextView isFirstResponder]){
        [self.mTextView resignFirstResponder];
    }
}

- (void) save{
    NSMutableString *allNames = [NSMutableString string];
    for (UIView *tempView in self.mScrollView.subviews) {
        if ([tempView isKindOfClass:[ClickableNameView class]]) {
            ClickableNameView *clickableNameView =(ClickableNameView *)tempView;
            NSString *names = [clickableNameView getClickedNames];
            if ([names length] > 0) {
                if ([allNames length] > 0) {
                    [allNames appendString:GetStringWithKey(@"activity_text_seperator")];
                }
                [allNames appendString:names];
            }
        }
    }
    if (self.delegate) {
        [self.delegate InputChoiceViewControllerDidFinishWithText:allNames WithOtherText:self.mTextView.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self.mScrollView setContentOffset:CGPointMake(0, self.mTextView.frame.origin.y - 18) animated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    int y;
    if (self.mScrollView.contentSize.height < self.mScrollView.frame.size.height) {
        y = 0;
    }else{
        y = self.mScrollView.contentSize.height - self.mScrollView.frame.size.height;
    }
    [self.mScrollView setContentOffset:CGPointMake(0, y) animated:YES];
}

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
