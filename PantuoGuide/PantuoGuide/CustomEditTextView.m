//
//  CustomEditTextView.m
//  PantuoGuide
//
//  Created by Christopher Leung on 9/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "CustomEditTextView.h"
#import "Config.h"
#import "LanguageManager.h"

@interface CustomEditTextView () <AddressPickerDataSourceDelegate>

@end

@implementation CustomEditTextView
@synthesize delegate;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) awakeFromNib{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter]  addObserver:self
                                              selector:@selector(handleTextChange:)
                                                  name:UITextFieldTextDidChangeNotification
                                                object:self.mTextField];
    
    self.leftRightSelection = 0;
    if ([self isAddress]) {
        [self.inlandAddressView.layer setCornerRadius:5.0];
        [self.inlandAddressView.layer setBorderWidth:1.0];
        [self.inlandAddressView.layer setBorderColor:[UIColor colorWithRed:158/255.0 green:157/255.0 blue:157/255.0 alpha:1.0].CGColor];
        
        self.provinceDataSource = [AddressPickerDataSource new];
        [self.provinceDataSource setPickerWithAdressPickerPlace:AddressPickerProvince];
        self.provinceDataSource.delegate = self;
        self.provincePickerView = [[UIPickerView alloc] init];
        self.provincePickerView.dataSource = self.provinceDataSource;
        self.provincePickerView.delegate = self.provinceDataSource;
        self.provinceTextView.inputView = self.provincePickerView;
        [self addToolBarToTextField:self.provinceTextView WithSelector:@selector(provinceDone)];
        
        self.cityDataSource = [AddressPickerDataSource new];
        [self.cityDataSource setPickerWithAdressPickerPlace:AddressPickerCity];
        self.cityDataSource.delegate = self;
        self.cityPickerView = [[UIPickerView alloc] init];
        self.cityPickerView.dataSource = self.cityDataSource;
        self.cityPickerView.delegate = self.cityDataSource;
        self.cityTextView.inputView = self.cityPickerView;
        [self addToolBarToTextField:self.cityTextView WithSelector:@selector(cityDone)];
        
        self.areaDataSource = [AddressPickerDataSource new];
        [self.areaDataSource setPickerWithAdressPickerPlace:AddressPickerArea];
        self.areaDataSource.delegate = self;
        self.areaPickerView = [[UIPickerView alloc] init];
        self.areaPickerView.dataSource = self.areaDataSource;
        self.areaPickerView.delegate = self.areaDataSource;
        self.areaTextView.inputView = self.areaPickerView;
        [self addToolBarToTextField:self.areaTextView WithSelector:@selector(areaDone)];
        
        self.leftRightSelection = 1;
        [self.leftImageView setImage:[UIImage imageNamed:@"btn_tick_green.png"]];
        [self.rightImageView setImage:[UIImage imageNamed:@"btn_tick_grey.png"]];
        [self.leftLabel setTextColor:ColorWithHexString(@"4CAF50")];
        [self.rightLabel setTextColor:ColorWithHexString(@"BABBBC")];
        [self.leftLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [self.rightLabel setFont:[UIFont systemFontOfSize:16]];
        
        if ([self isAddress]) {
            [self.mTextField setHidden:YES];
            [self.mTextField setPlaceholder:GetStringWithKey(@"profile_address_hint")];
            [self.inlandAddressView setHidden:NO];
        }
    }
}

- (BOOL) isAddress{
    return self.inlandAddressView != nil;
}

- (void) addToolBarToTextField:(UITextView *)aTextView WithSelector:(SEL)aSelector{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:GetStringWithKey(@"done")
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:aSelector];
    [toolbar setItems:[NSArray arrayWithObjects:flex,rightButton,nil]];
    aTextView.inputAccessoryView = toolbar;
}


- (IBAction)left:(id)sender{
    if (self.leftRightSelection != 1) {
        self.leftRightSelection = 1;
        [self.leftImageView setImage:[UIImage imageNamed:@"btn_tick_green.png"]];
        [self.rightImageView setImage:[UIImage imageNamed:@"btn_tick_grey.png"]];
        [self.leftLabel setTextColor:ColorWithHexString(@"4CAF50")];
        [self.rightLabel setTextColor:ColorWithHexString(@"BABBBC")];
        [self.leftLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [self.rightLabel setFont:[UIFont systemFontOfSize:16]];
        
        if ([self isAddress]) {
            [self.mTextField setHidden:YES];
            [self.inlandAddressView setHidden:NO];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(CustomEditTextViewDidSelectOption:)]) {
            [self.delegate CustomEditTextViewDidSelectOption:YES];
        }
    }
}

- (IBAction)right:(id)sender{
    if (self.leftRightSelection != 2) {
        self.leftRightSelection = 2;
        [self.leftImageView setImage:[UIImage imageNamed:@"btn_tick_grey.png"]];
        [self.rightImageView setImage:[UIImage imageNamed:@"btn_tick_green.png"]];
        [self.leftLabel setTextColor:ColorWithHexString(@"BABBBC")];
        [self.rightLabel setTextColor:ColorWithHexString(@"4CAF50")];
        [self.leftLabel setFont:[UIFont systemFontOfSize:16]];
        [self.rightLabel setFont:[UIFont boldSystemFontOfSize:16]];
        
        if ([self isAddress]) {
            [self.mTextField setHidden:NO];
            [self.inlandAddressView setHidden:YES];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(CustomEditTextViewDidSelectOption:)]) {
            [self.delegate CustomEditTextViewDidSelectOption:NO];
        }
    }
}

- (IBAction)image1:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(CustomEditTextViewDidSelectImage:)]) {
        [self.delegate CustomEditTextViewDidSelectImage:YES];
    }
}

- (IBAction)image2:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(CustomEditTextViewDidSelectImage:)]) {
        [self.delegate CustomEditTextViewDidSelectImage:NO];
    }
}

- (IBAction)qq:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(CustomEditTextViewDidSelectSocial:)]) {
        [self.delegate CustomEditTextViewDidSelectSocial:SOCIAL_MEDIA_TYPE_QQ];
    }
}

- (IBAction)wechat:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(CustomEditTextViewDidSelectSocial:)]) {
        [self.delegate CustomEditTextViewDidSelectSocial:SOCIAL_MEDIA_TYPE_WECHAT];
    }
}

- (IBAction)weibo:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(CustomEditTextViewDidSelectSocial:)]) {
        [self.delegate CustomEditTextViewDidSelectSocial:SOCIAL_MEDIA_TYPE_WEIBO];
    }
}

- (IBAction) fullpage:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(CustomEditTextViewDidSelectFullpage:)]) {
        [self.delegate CustomEditTextViewDidSelectFullpage:self];
    }
}

-(void) handleTextChange:(NSNotification *)notification {
    if (notification.object == self.mTextField) {
        [self.titleLabel setHidden:self.mTextField.text.length == 0];
    }
}

- (void) setTitle:(NSString *)aString WithStar:(BOOL)aStar{
    NSMutableAttributedString *tempAttString;
    
    tempAttString = [[NSMutableAttributedString alloc] init];
    [tempAttString appendAttributedString:[[NSAttributedString alloc] initWithString:aString
                                                                          attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}]];
    if (aStar) {
        [tempAttString appendAttributedString:[[NSAttributedString alloc] initWithString:@"*"
                                                                              attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}]];
    }
    [self.titleLabel setAttributedText:tempAttString];
}

- (void) setTitle2:(NSString *)aString WithStar:(BOOL)aStar{
    NSMutableAttributedString *tempAttString;
    
    tempAttString = [[NSMutableAttributedString alloc] init];
    [tempAttString appendAttributedString:[[NSAttributedString alloc] initWithString:aString
                                                                          attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}]];
    if (aStar) {
        [tempAttString appendAttributedString:[[NSAttributedString alloc] initWithString:@"*"
                                                                              attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}]];
    }
    [self.title2Label setAttributedText:tempAttString];
}

- (void) setPlaceHolder:(NSString *)aString  WithStar:(BOOL)aStar{
    NSMutableAttributedString *tempAttString;
    
    tempAttString = [[NSMutableAttributedString alloc] init];
    [tempAttString appendAttributedString:[[NSAttributedString alloc] initWithString:aString
                                                                          attributes:@{NSForegroundColorAttributeName:[[UIColor grayColor] colorWithAlphaComponent:0.5]}]];
    if (aStar) {
        [tempAttString appendAttributedString:[[NSAttributedString alloc] initWithString:@"*"
                                                                              attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}]];
    }
    if (self.mTextField) {
        [self.mTextField setAttributedPlaceholder:tempAttString];
    }else{
        [self.contentLabel setAttributedText:tempAttString];
    }
}

- (void) setLeft:(NSString *)aString{
    [self.leftLabel setText:aString];
}

- (void) setRight:(NSString *)aString{
    [self.rightLabel setText:aString];
}

- (void) setLongContent:(NSString *)aContent{
    if ([aContent length] == 0) {
        [self.titleLabel setHidden:YES];
        CGRect tempFrame = self.contentLabel.frame;
        tempFrame.size.width = SCREEN_WIDTH;
        [self.contentLabel setFrame:tempFrame];
        [self.contentLabel setText:self.titleLabel.attributedText.string];
        [self.contentLabel setTextColor:[UIColor lightGrayColor]];
    }else{
        [self.titleLabel setHidden:NO];

        CGRect tempFrame = self.contentLabel.frame;
        tempFrame.size.width = SCREEN_WIDTH - tempFrame.origin.x*2 - 17;
        tempFrame.size.height = 100000;
        [self.contentLabel setFrame:tempFrame];
        [self.contentLabel setText:aContent];
        [self.contentLabel sizeToFit];
        [self.contentLabel setTextColor:[UIColor blackColor]];
        
        tempFrame = self.frame;
        if (aContent.length == 0) {
            tempFrame.size.height = 50;
        }else{
            tempFrame.size.height = self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height + 10;
        }
        [self setFrame:tempFrame];
    }
}

- (NSString *) getContent{
    if (self.leftRightSelection == 1) {
        if ([self isAddress]){
            return @"0";
        }else{
            return @"M";
        }
    }else if (self.leftRightSelection == 2) {
        if ([self isAddress]){
            return @"1";
        }else{
            return @"F";
        }
    }else{
        return self.mTextField.text;
    }
}

- (void) setContent:(NSString *)aString{
    self.mTextField.text = aString;
    [self.titleLabel setHidden:self.mTextField.text.length == 0];
}

- (void) provinceDone{
    int row = (int)[self.provincePickerView selectedRowInComponent:0];
    [self AddressPickerDataSource:self.provinceDataSource
                        SelectRow:row
                         WithText:[self.provinceDataSource.infoArray objectAtIndex:row]];
    [self.provinceTextView resignFirstResponder];
}

- (void) cityDone{
    int row = (int)[self.cityPickerView selectedRowInComponent:0];
    [self AddressPickerDataSource:self.cityDataSource
                        SelectRow:row
                         WithText:[self.cityDataSource.infoArray objectAtIndex:row]];
    [self.cityTextView resignFirstResponder];
}

- (void) areaDone{
    int row = (int)[self.areaPickerView selectedRowInComponent:0];
    [self AddressPickerDataSource:self.areaDataSource
                        SelectRow:row
                         WithText:[self.areaDataSource.infoArray objectAtIndex:row]];
    [self.areaTextView resignFirstResponder];
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    BOOL shouldBegin = YES;
    if (textView == self.cityTextView) {
        [self.cityDataSource updateWithProvince:self.provinceDataSource.currentRow WithCity:-1 WithArea:-1];
        [self.cityPickerView reloadComponent:0];
        shouldBegin = [self.cityDataSource.infoArray count] > 0;
    }else if (textView == self.areaTextView){
        if (self.cityDataSource.currentRow == -1 && [self.cityDataSource.infoArray count] > 0) {
            shouldBegin = NO;
        }else{
            [self.areaDataSource updateWithProvince:self.provinceDataSource.currentRow WithCity:self.cityDataSource.currentRow WithArea:-1];
            [self.areaPickerView reloadComponent:0];
            shouldBegin = [self.areaDataSource.infoArray count] > 0;
        }
    }
    return shouldBegin;
}


- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(CustomEditTextViewDidBegin:)]) {
        [self.delegate CustomEditTextViewDidBegin:self];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(CustomEditTextViewDidEnd:)]) {
        [self.delegate CustomEditTextViewDidEnd:self];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.delegate && [self.delegate respondsToSelector:@selector(CustomEditTextViewDidBegin:)]) {
        [self.delegate CustomEditTextViewDidBegin:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.delegate && [self.delegate respondsToSelector:@selector(CustomEditTextViewDidEnd:)]) {
        [self.delegate CustomEditTextViewDidEnd:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.delegate CustomEditTextViewDidReturn:self];
    return YES;
}

#pragma mark - AddressPickerDataSourceDelegate
- (void) AddressPickerDataSource:(id)aSelf SelectRow:(int)aRow WithText:(NSString *)aText{
    if (aSelf == self.provinceDataSource) {
        [self.provinceTextView setText:aText];
        
        self.provinceDataSource.currentRow = aRow;
        self.cityDataSource.currentRow = -1;
        [self.cityTextView setText:GetStringWithKey(@"city")];
        
        self.areaDataSource.currentRow = -1;
        [self.areaTextView setText:GetStringWithKey(@"district")];
    }else if (aSelf == self.cityDataSource){
        [self.cityTextView setText:aText];
        
        self.cityDataSource.currentRow = aRow;
        self.areaDataSource.currentRow = -1;
        [self.areaTextView setText:GetStringWithKey(@"district")];
    }else if (aSelf == self.areaDataSource){
        self.areaDataSource.currentRow = aRow;
        [self.areaTextView setText:aText];
    }
}

- (void) dealloc{
    [[NSNotificationCenter defaultCenter]  removeObserver:self name:UITextFieldTextDidChangeNotification object:self.mTextField];
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    NSLog(@"string:%@",string);
//    return YES;
//}

@end
