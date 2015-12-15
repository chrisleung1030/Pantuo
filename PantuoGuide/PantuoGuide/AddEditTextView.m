//
//  AddEditTextView.m
//  PantuoGuide
//
//  Created by Christopher Leung on 23/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "AddEditTextView.h"
#import "LanguageManager.h"

@interface AddEditTextView () <AddressPickerDataSourceDelegate, NumberPickerDataSourceDelegate>

@end

@implementation AddEditTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) awakeFromNib{
    [super awakeFromNib];
    self.updateImage1 = NO;
    self.updateImage2 = NO;
    self.updateImage3 = NO;
    
    if (self.removeTripButton) {
        self.planId = [NSString string];
        
        [self.removeTripButton.layer setCornerRadius:5];
        [self.startHolderView.layer setCornerRadius:5];
        [self.endHolderView.layer setCornerRadius:5];
        
        [self.startHolderView.layer setBorderWidth:1.0];
        [self.startHolderView.layer setBorderColor:[UIColor colorWithRed:158/255.0 green:157/255.0 blue:157/255.0 alpha:1.0].CGColor];
        
        [self.endHolderView.layer setBorderWidth:1.0];
        [self.endHolderView.layer setBorderColor:[UIColor colorWithRed:158/255.0 green:157/255.0 blue:157/255.0 alpha:1.0].CGColor];
        
        UIPickerView *tempPickerView = [UIPickerView new];
        self.startDatePickerDataSource = [NumberPickerDataSource new];
        self.startDatePickerDataSource.startDay = 1;
        self.startDatePickerDataSource.endDay = 100;
        self.startDatePickerDataSource.delegate = self;
        tempPickerView.dataSource = self.startDatePickerDataSource;
        tempPickerView.delegate = self.startDatePickerDataSource;
        self.startTextField.inputView = tempPickerView;
        
        tempPickerView = [UIPickerView new];
        self.endDatePickerDataSource = [NumberPickerDataSource new];
        self.endDatePickerDataSource.startDay = 1;
        self.endDatePickerDataSource.endDay = 100;
        self.endDatePickerDataSource.delegate = self;
        tempPickerView.dataSource = self.endDatePickerDataSource;
        tempPickerView.delegate = self.endDatePickerDataSource;
        self.endTextField.inputView = tempPickerView;
        [self addToolBarToTextField:self.endTextField WithSelector:@selector(endDone)];
    }
    if (self.typeButton) {
        [self.typeButton.layer setCornerRadius:30];
        [self.typeButton.titleLabel setNumberOfLines:2];
        [self.typeButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        self.type = 0;
        self.color = [NSString string];
        self.otherType = [NSString string];
    }
    
    self.selectedChoice = [NSString string];
    self.otherChoice = [NSString string];
    
    if (self.dateView) {
        [self.dateLabel setText:GetStringWithKey(@"date")];
        [self.timeLabel setText:GetStringWithKey(@"time")];
        
        [self.dateView.layer setCornerRadius:5.0];
        [self.dateView.layer setBorderWidth:1.0];
        [self.dateView.layer setBorderColor:[UIColor colorWithRed:158/255.0 green:157/255.0 blue:157/255.0 alpha:1.0].CGColor];
        
        [self.timeView.layer setCornerRadius:5.0];
        [self.timeView.layer setBorderWidth:1.0];
        [self.timeView.layer setBorderColor:[UIColor colorWithRed:158/255.0 green:157/255.0 blue:157/255.0 alpha:1.0].CGColor];
        
        self.timePicker = [[UIDatePicker alloc] init];
        [self.timePicker setDatePickerMode:UIDatePickerModeTime];
        [self.timePicker setDate:[NSDate date]];
        [self.timePicker addTarget:self action:@selector(time:) forControlEvents:UIControlEventValueChanged];
        self.timeTextField.inputView = self.timePicker;
        [self addToolBarToTextField:self.timeTextField WithSelector:@selector(timeDone)];
        [self time:nil];
        
        self.datePicker = [[UIDatePicker alloc] init];
        [self.datePicker setDatePickerMode:UIDatePickerModeDate];
        [self.datePicker setMinimumDate:[NSDate date]];
        [self.datePicker setDate:[NSDate date]];
        [self.datePicker addTarget:self action:@selector(date:) forControlEvents:UIControlEventValueChanged];
        self.dateTextField.inputView = self.datePicker;
        [self addToolBarToTextField:self.dateTextField WithSelector:@selector(dateDone)];
        [self date:nil];
    }
    if (self.minLabel) {
        [self.minLabel setText:GetStringWithKey(@"min")];
        [self.maxLabel setText:GetStringWithKey(@"max")];
        self.unlimit = NO;
        [self.unlimitButton setBackgroundImage:[UIImage imageNamed:@"btn_off_ppl.png"] forState:UIControlStateNormal];
        
        [self.minHolderLabel.layer setCornerRadius:5.0];
        [self.minHolderLabel.layer setBorderWidth:1.0];
        [self.minHolderLabel.layer setBorderColor:[UIColor colorWithRed:158/255.0 green:157/255.0 blue:157/255.0 alpha:1.0].CGColor];
        
        [self.maxHolderLabel.layer setCornerRadius:5.0];
        [self.maxHolderLabel.layer setBorderWidth:1.0];
        [self.maxHolderLabel.layer setBorderColor:[UIColor colorWithRed:158/255.0 green:157/255.0 blue:157/255.0 alpha:1.0].CGColor];
    }
    
    [self.title2Label setAdjustsFontSizeToFitWidth:YES];
    
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
    }
}

- (BOOL) isAddress{
    return self.inlandAddressView != nil;
}

- (void) addToolBarToTextField:(UITextField *)aTextField WithSelector:(SEL)aSelector{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:GetStringWithKey(@"done")
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:aSelector];
    [toolbar setItems:[NSArray arrayWithObjects:flex,rightButton,nil]];
    aTextField.inputAccessoryView = toolbar;
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

- (void) setTheme:(NSString *)aString WithStar:(BOOL)aStar{
    NSMutableAttributedString *tempAttString;
    
    tempAttString = [[NSMutableAttributedString alloc] init];
    [tempAttString appendAttributedString:[[NSAttributedString alloc] initWithString:aString
                                                                          attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}]];
    if (aStar) {
        [tempAttString appendAttributedString:[[NSAttributedString alloc] initWithString:@"*"
                                                                              attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}]];
    }
    [self.themeTitleLabel setAttributedText:tempAttString];
}

- (void) setStarWithStar:(int)star{
    self.star = star;
    for (int i = 1; i <= 5; i++) {
        UIButton *tempButton = (UIButton *)[self viewWithTag:i];
        if (i <= star) {
            [tempButton setImage:[UIImage imageNamed:@"btn_star_on.png"] forState:UIControlStateNormal];
        }else{
            [tempButton setImage:[UIImage imageNamed:@"btn_star_off.png"] forState:UIControlStateNormal];
        }
    }
}

- (void) setDateStringWithString:(NSString *)aString{
    NSDateFormatter *tempFormatter = [NSDateFormatter new];
    [tempFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *tempDate = [tempFormatter dateFromString:aString];
    NSDateComponents *tempCompo = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:tempDate];
    
    self.dateString = aString;
    self.datePicker.date = tempDate;
    [self.yearLabel setText:[NSString stringWithFormat:@"%d%@",(int)tempCompo.year,GetStringWithKey(@"year")]];
    [self.monthLabel setText:[NSString stringWithFormat:@"%d%@",(int)tempCompo.month,GetStringWithKey(@"month")]];
    [self.dayLabel setText:[NSString stringWithFormat:@"%d%@",(int)tempCompo.day,GetStringWithKey(@"day")]];
}

- (void) setTimeWithTimeString:(NSString *)timeString{
    self.timeString = timeString;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    [components setHour:[[timeString substringToIndex:2] intValue]];
    [components setMinute:[[timeString substringFromIndex:3] intValue]];
    NSDate *timeDate = [calendar dateFromComponents:components];
    self.timePicker.date = timeDate;
    [self.timeTextField setText:timeString];
}

- (void) setTypeWithType:(int)aType Color:(NSString *)aColor OtherType:(NSString *)aOtherType{
    self.type = aType;
    self.color = aColor;
    self.otherType = aOtherType;
    
    [self.typeButton setBackgroundColor:ColorWithHexString(aColor)];
    
    if (aType > 0) {
        [self.typeButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"calender_icon_%02d.png",aType]] forState:UIControlStateNormal];
        [self.typeButton setTitle:[NSString string] forState:UIControlStateNormal];
    }else if (aOtherType.length > 0){
        [self.typeButton setImage:nil forState:UIControlStateNormal];
        [self.typeButton setTitle:self.otherType forState:UIControlStateNormal];
    }else{
        [self.typeButton setImage:[UIImage imageNamed:@"icn_event_green_26.png"] forState:UIControlStateNormal];
        [self.typeButton setTitle:[NSString string] forState:UIControlStateNormal];
    }
}

- (void) setStartAndEndDateWithStart:(int)aStart WithEnd:(int)aEnd{
    
    [self setStartDateWithStartDate:aStart];
    [self setEndDateWithEndDate:aEnd];
    
    self.startDatePickerDataSource.startDay = aStart;
    self.endDatePickerDataSource.startDay = aStart;
    
    UIPickerView *start = ((UIPickerView *)self.startTextField.inputView);
    UIPickerView *end = ((UIPickerView *)self.endTextField.inputView);
    
    [start reloadComponent:0];
    [end reloadComponent:0];
    
    [start selectRow:0 inComponent:0 animated:NO];
    [end selectRow:aEnd-aStart inComponent:0 animated:NO];
}

- (void) setStartDateWithStartDate:(int)startDate{
    self.startDate = startDate;
    [self.startLabel setText:[NSString stringWithFormat:GetStringWithKey(@"the_day"),startDate]];
}

- (void) setEndDateWithEndDate:(int)endDate{
    self.endDate = endDate;
    [self.endLabel setText:[NSString stringWithFormat:GetStringWithKey(@"the_day"),endDate]];
}

- (void) setEndDateEnable:(BOOL)aEnable{
    [self.endTextField setEnabled:aEnable];
    if (aEnable) {
        [self.endHolderView setAlpha:1];
    }else{
        [self.endHolderView setAlpha:0.7];
    }
}

- (void) setUnlimitWithUnlimit:(BOOL)unlimit{
    if (self.unlimit) {
        [self.maxTextField setText:nil];
        [self.unlimitButton setBackgroundImage:[UIImage imageNamed:@"btn_on_ppl.png"] forState:UIControlStateNormal];
    }else{
        [self.unlimitButton setBackgroundImage:[UIImage imageNamed:@"btn_off_ppl.png"] forState:UIControlStateNormal];
    }
    if ([self.maxTextField isFirstResponder]) {
        [self.maxTextField resignFirstResponder];
    }
}

- (void)date:(id)sender{
    NSDate *tempDate = self.datePicker.date;
    if ([tempDate compare:[NSDate date]] == NSOrderedAscending) {
        tempDate = [NSDate date];
    }
    NSDateFormatter *tempFormatter = [NSDateFormatter new];
    [tempFormatter setDateFormat:@"yyyy-MM-dd"];
    
    [self setDateStringWithString:[tempFormatter stringFromDate:tempDate]];
}

- (void)time:(id)sender{
    NSDate *tempDate = self.timePicker.date;
    NSDateFormatter *tempFormatter = [NSDateFormatter new];
    [tempFormatter setDateFormat:@"HH:mm"];

    [self setTimeWithTimeString:[tempFormatter stringFromDate:tempDate]];
}

- (IBAction)type:(id)sender{
    if (self.delegate) {
        [self.delegate AddEditTextViewDidSelectType];
    }
}

- (IBAction)addEditText:(UIButton *)sender {
    if (self.delegate) {
        [self.delegate AddEditTextViewDidSelect:self WithTag:(int)[sender tag]];
    }
}

- (IBAction)starButton:(UIButton *)sender{
    int tag = (int)[sender tag];
    [self setStarWithStar:tag];
}

- (IBAction)unlimit:(id)sender{
    self.unlimit = !self.unlimit;
    [self setUnlimitWithUnlimit:self.unlimit];
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
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(AddEditTextViewDidSelectOption:)]) {
            [self.delegate AddEditTextViewDidSelectOption:YES];
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
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(AddEditTextViewDidSelectOption:)]) {
            [self.delegate AddEditTextViewDidSelectOption:NO];
        }
    }
}

- (IBAction)removeTrip:(id)sender{
    if (self.delegate) {
        [self.delegate AddEditTextViewDidClickRemoveTrip:self];
    }
}

- (IBAction)activityImage:(UIButton *)sender{
    if (self.delegate){
        [self.delegate AddEditTextViewDidSelectActivityImage:self WithTag:(int)[sender tag]];
    }
}

- (IBAction)detailAddress:(id)sender{
    if (self.delegate){
        [self.delegate AddEditTextViewDidSelectDetailAddress:self];
    }
}

#pragma mark - UIToolbar method
- (void) endDone{
    int endDay = (int)[((UIPickerView *)self.endTextField.inputView) selectedRowInComponent:0] + self.endDatePickerDataSource.startDay;
    [self setEndDateWithEndDate:endDay];
    if (self.delegate) {
        [self.delegate AddEditTextViewDidSelect:self WithEndDay:endDay];
    }
    
    [self.endTextField resignFirstResponder];
}

- (void) dateDone{
    [self date:nil];
    [self.dateTextField resignFirstResponder];
}

- (void) timeDone{
    [self time:nil];
    [self.timeTextField resignFirstResponder];
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
//    if (self.delegate && [self.delegate respondsToSelector:@selector(CustomEditTextViewDidBegin:)]) {
//        [self.delegate CustomEditTextViewDidBegin:self];
//    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(CustomEditTextViewDidEnd:)]) {
//        [self.delegate CustomEditTextViewDidEnd:self];
//    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    BOOL begin = YES;
    if (textField == self.maxTextField && self.unlimit) {
        begin = NO;
    }
    return begin;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.delegate && [self.delegate respondsToSelector:@selector(AddEditTextViewDidBeginEdit:)]) {
        [self.delegate AddEditTextViewDidBeginEdit:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
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

#pragma mark - NumberPickerDataSourceDelegate
- (void) NumberPickerDataSource:(NumberPickerDataSource *)aSelf DidSelectDay:(int)aDay{
    if (aSelf == self.startDatePickerDataSource) {
        [self setStartDateWithStartDate:aDay];
        self.endDatePickerDataSource.startDay = aDay;
        [((UIPickerView *)self.endTextField.inputView) reloadComponent:0];
    }else{
        [self setEndDateWithEndDate:aDay];
        if (self.delegate) {
            [self.delegate AddEditTextViewDidSelect:self WithEndDay:aDay];
        }
    }
}

@end
