//
//  HistorySearchViewController.m
//  PantuoGuide
//
//  Created by Christopher Leung on 14/9/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "HistorySearchViewController.h"
#import "NonPasteTextField.h"
#import "TypePickerDataSource.h"
#import "HistoryViewController.h"
#import "AddressPickerDataSource.h"

@interface HistorySearchViewController () <UITextFieldDelegate, UITextViewDelegate, TypePickerDataSourceDelegate, AddressPickerDataSourceDelegate>

@property (nonatomic, retain) IBOutlet UILabel *searchTitleLabel;

@property (nonatomic, retain) IBOutlet UIScrollView *holderScrollView;

@property (nonatomic, retain) IBOutlet UILabel *fromTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *toTitleLabel;
@property (nonatomic, retain) IBOutlet UIView *fromDateView;
@property (nonatomic, retain) IBOutlet UIView *toDateView;
@property (nonatomic, retain) IBOutlet NonPasteTextField *fromDateTextField;
@property (nonatomic, retain) IBOutlet NonPasteTextField *toDateTextField;

@property (nonatomic, retain) IBOutlet UILabel *typeTitleLabel;
@property (nonatomic, retain) IBOutlet UIView *typeView;
@property (nonatomic, retain) IBOutlet NonPasteTextField *typeTextField;

@property (nonatomic, retain) IBOutlet UILabel *addressTitleLabel;
@property (nonatomic, retain) IBOutlet UIView *addressView;
@property (nonatomic, retain) IBOutlet UITextView *provinceTextView;
@property (nonatomic, retain) IBOutlet UITextView *cityTextView;

@property (nonatomic, retain) IBOutlet UILabel *themeTitleLabel;
@property (nonatomic, retain) IBOutlet UIView *themeView;
@property (nonatomic, retain) IBOutlet UITextField *themeTextField;

@property (nonatomic, retain) UIButton *resetButton;
@property (nonatomic, retain) UIButton *searchButton;

@property (nonatomic, retain) UIDatePicker *fromDatePicker;
@property (nonatomic, retain) UIDatePicker *toDatePicker;

@property (nonatomic, retain) NSString *fromDateString;
@property (nonatomic, retain) NSString *toDateString;

@property (nonatomic, retain) UIPickerView *typePickerView;
@property (nonatomic, retain) TypePickerDataSource *typePickerDataSource;

@property (nonatomic, retain) AddressPickerDataSource *provinceDataSource;
@property (nonatomic, retain) AddressPickerDataSource *cityDataSource;
@property (nonatomic, retain) UIPickerView *provincePickerView;
@property (nonatomic, retain) UIPickerView *cityPickerView;

@end

@implementation HistorySearchViewController

- (NSString *) getTopBarTitle{
    return GetStringWithKey(@"profile_activity_record");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addTopBarTitleView];
//    UIKeyboardDidShowNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    [self.view addGestureRecognizer:tap];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    [self.searchTitleLabel setText:GetStringWithKey(@"history_quick_search")];
    [self.fromTitleLabel setText:GetStringWithKey(@"history_from")];
    [self.toTitleLabel setText:GetStringWithKey(@"history_to")];
    [self.typeTitleLabel setText:GetStringWithKey(@"history_activity_type")];
    [self.addressTitleLabel setText:GetStringWithKey(@"activity_place")];
    [self.themeTitleLabel setText:GetStringWithKey(@"activity_theme")];
    [self.themeTextField setPlaceholder:GetStringWithKey(@"points_enter_keyword")];
    [self.provinceTextView setText:GetStringWithKey(@"province")];
    [self.cityTextView setText:GetStringWithKey(@"city")];
    
    self.fromDatePicker = [[UIDatePicker alloc] init];
    [self.fromDatePicker setDatePickerMode:UIDatePickerModeDate];
    [self.fromDatePicker setDate:[NSDate date]];
    [self.fromDatePicker addTarget:self action:@selector(fromDate:) forControlEvents:UIControlEventValueChanged];
    self.fromDateTextField.inputView = self.fromDatePicker;
    [self addToolBarToTextField:self.fromDateTextField WithSelector:@selector(fromDateDone)];
    
    [self.fromDateView.layer setCornerRadius:5.0];
    [self.fromDateView.layer setBorderWidth:1.0];
    [self.fromDateView.layer setBorderColor:[UIColor colorWithRed:158/255.0 green:157/255.0 blue:157/255.0 alpha:1.0].CGColor];
    
    self.toDatePicker = [[UIDatePicker alloc] init];
    [self.toDatePicker setDatePickerMode:UIDatePickerModeDate];
    [self.toDatePicker setDate:[NSDate date]];
    [self.toDatePicker setMinimumDate:[self.fromDatePicker date]];
    [self.toDatePicker addTarget:self action:@selector(toDate:) forControlEvents:UIControlEventValueChanged];
    self.toDateTextField.inputView = self.toDatePicker;
    [self addToolBarToTextField:self.toDateTextField WithSelector:@selector(toDateDone)];
    
    [self.toDateView.layer setCornerRadius:5.0];
    [self.toDateView.layer setBorderWidth:1.0];
    [self.toDateView.layer setBorderColor:[UIColor colorWithRed:158/255.0 green:157/255.0 blue:157/255.0 alpha:1.0].CGColor];
    
    [self fromDate:nil];
    [self toDate:nil];
    
    [self.typeView.layer setCornerRadius:5.0];
    [self.typeView.layer setBorderWidth:1.0];
    [self.typeView.layer setBorderColor:[UIColor colorWithRed:158/255.0 green:157/255.0 blue:157/255.0 alpha:1.0].CGColor];
    
    self.typePickerView = [[UIPickerView alloc] init];
    self.typePickerDataSource = [[TypePickerDataSource alloc] init];
    self.typePickerDataSource .delegate = self;
    self.typePickerView.delegate = self.typePickerDataSource;
    self.typePickerView.dataSource = self.typePickerDataSource;
    self.typeTextField.inputView = self.typePickerView;
    [self addToolBarToTextField:self.typeTextField WithSelector:@selector(typeDone)];
    [self.typeTextField setText:GetStringWithKey(@"history_select_type")];
    
    
    [self.addressView.layer setCornerRadius:5.0];
    [self.addressView.layer setBorderWidth:1.0];
    [self.addressView.layer setBorderColor:[UIColor colorWithRed:158/255.0 green:157/255.0 blue:157/255.0 alpha:1.0].CGColor];
    
    
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
    
    
    [self.themeView.layer setCornerRadius:5.0];
    [self.themeView.layer setBorderWidth:1.0];
    [self.themeView.layer setBorderColor:[UIColor colorWithRed:158/255.0 green:157/255.0 blue:157/255.0 alpha:1.0].CGColor];
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-65, SCREEN_WIDTH, 65)];
    [tempView setBackgroundColor:ColorWithHexString(@"EEEFF1")];
    [self.view addSubview:tempView];
    
    int leftMargin = (SCREEN_WIDTH-150*2-5)/2;
    self.resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.resetButton setBackgroundImage:[UIImage imageNamed:@"btn_planning_save.png"] forState:UIControlStateNormal];
    [self.resetButton setTitle:GetStringWithKey(@"history_reset") forState:UIControlStateNormal];
    [self.resetButton setTitleColor:ColorWithHexString(@"4CAF50") forState:UIControlStateNormal];
    [self.resetButton setFrame:CGRectMake(leftMargin, 10, 150, 45)];
    [self.resetButton addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    [self.resetButton.layer setCornerRadius:5];
    [tempView addSubview:self.resetButton];
    
    self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.searchButton setBackgroundImage:[UIImage imageNamed:@"btn_planning_preview.png"] forState:UIControlStateNormal];
    [self.searchButton setTitle:GetStringWithKey(@"confirm") forState:UIControlStateNormal];
    [self.searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.searchButton setFrame:CGRectMake(leftMargin+150+5, 10, 150, 45)];
    [self.searchButton addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [self.searchButton.layer setCornerRadius:5];
    [tempView addSubview:self.searchButton];
}

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

#pragma mark - Date methods
- (void)fromDate:(id)sender{
    NSDate *tempDate = self.fromDatePicker.date;
    
    NSDateFormatter *tempFormatter = [NSDateFormatter new];
    [tempFormatter setDateFormat:@"yyyy-MM-dd"];
    self.fromDateString = [tempFormatter stringFromDate:tempDate];
    
    [self.toDatePicker setMinimumDate:tempDate];
    if ([self.fromDateString compare:self.toDateString] == NSOrderedDescending) {
        [self.toDatePicker setDate:tempDate];
        [self toDate:nil];
    }
    
    [self displayDateOnView:self.fromDateView WitDate:tempDate];
}

- (void)toDate:(id)sender{
    NSDate *tempDate = self.toDatePicker.date;
    
    NSDateFormatter *tempFormatter = [NSDateFormatter new];
    [tempFormatter setDateFormat:@"yyyy-MM-dd"];
    self.toDateString = [tempFormatter stringFromDate:tempDate];
    
    [self displayDateOnView:self.toDateView WitDate:tempDate];
}

- (void) fromDateDone{
    [self fromDate:nil];
    [self.fromDateTextField resignFirstResponder];
}

- (void) toDateDone{
    [self toDate:nil];
    [self.toDateTextField resignFirstResponder];
}

- (void) displayDateOnView:(UIView *)aView WitDate:(NSDate *)aDate{
    NSDateComponents *tempCompo = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:aDate];
    
    UILabel *yearLabel = (UILabel *)[aView viewWithTag:1];
    UILabel *monthLabel = (UILabel *)[aView viewWithTag:2];
    UILabel *dayLabel = (UILabel *)[aView viewWithTag:3];
    
    [yearLabel setText:[NSString stringWithFormat:@"%d%@",(int)tempCompo.year,GetStringWithKey(@"year")]];
    [monthLabel setText:[NSString stringWithFormat:@"%d%@",(int)tempCompo.month,GetStringWithKey(@"month")]];
    [dayLabel setText:[NSString stringWithFormat:@"%d%@",(int)tempCompo.day,GetStringWithKey(@"day")]];
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

#pragma mark - Type methods
- (void) typeDone{
    [self.typeTextField resignFirstResponder];
}

- (void) TypePickerDataSourceDidSelectWithIndex:(int)aIndex WithName:(NSString *)aName{
    [self.typeTextField setText:aName];
}

#pragma mark - Address methods
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

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    BOOL shouldBegin = YES;
    if (textView == self.cityTextView) {
        [self.cityDataSource updateWithProvince:self.provinceDataSource.currentRow WithCity:-1 WithArea:-1];
        [self.cityPickerView reloadComponent:0];
        shouldBegin = [self.cityDataSource.infoArray count] > 0;
    }
    return shouldBegin;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (textView == self.provinceTextView) {
        int row = (int)[self.provincePickerView selectedRowInComponent:0];
        self.provinceDataSource.currentRow = row;
        [self.provinceTextView setText:[self.provinceDataSource.infoArray objectAtIndex:row]];
//        [self.holderScrollView setContentOffset:CGPointMake(0, self.addressView.frame.origin.y-3) animated:YES];
    }else if (textView == self.cityTextView) {
        int row = (int)[self.cityPickerView selectedRowInComponent:0];
        self.cityDataSource.currentRow = row;
        [self.cityTextView setText:[self.cityDataSource.infoArray objectAtIndex:row]];
//        [self.holderScrollView setContentOffset:CGPointMake(0, self.addressView.frame.origin.y-3) animated:YES];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [self.holderScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void) AddressPickerDataSource:(id)aSelf SelectRow:(int)aRow WithText:(NSString *)aText{
    if (aSelf == self.provinceDataSource) {
        [self.provinceTextView setText:aText];
        
        self.provinceDataSource.currentRow = aRow;
        self.cityDataSource.currentRow = -1;
        [self.cityTextView setText:GetStringWithKey(@"city")];
        
    }else if (aSelf == self.cityDataSource){
        [self.cityTextView setText:aText];
        
        self.cityDataSource.currentRow = aRow;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.typeTextField) {
        int row = (int)[self.typePickerView selectedRowInComponent:0];
        self.typePickerDataSource.currentType = row;
        [self.typeTextField setText:[self.typePickerDataSource.typeArray objectAtIndex:row]];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.holderScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.themeTextField resignFirstResponder];
    return YES;
}

#pragma mark - action methods
- (void)keyboardDidShow:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    NSLog(@"%s %f",__FUNCTION__,keyboardFrameBeginRect.size.height);
    
    int originY = self.holderScrollView.frame.origin.y;
    int scrollTo = 0;
    
    if([self.fromDateTextField isFirstResponder]){
        originY += self.fromDateView.frame.origin.y + self.fromDateView.frame.size.height;
        scrollTo = self.fromDateView.frame.origin.y;
    }else if ([self.toDateTextField isFirstResponder]){
        originY += self.toDateView.frame.origin.y + self.toDateView.frame.size.height;
        scrollTo = self.toDateView.frame.origin.y;
    }else if ([self.typeTextField isFirstResponder]) {
        originY += self.typeView.frame.origin.y + self.typeView.frame.size.height;
        scrollTo = self.typeView.frame.origin.y;
    }else if ([self.themeTextField isFirstResponder]){
        originY += self.themeView.frame.origin.y + self.themeView.frame.size.height;
        scrollTo = self.themeView.frame.origin.y;
    }else if ([self.provinceTextView isFirstResponder]){
        originY += self.addressView.frame.origin.y + self.addressView.frame.size.height;
        scrollTo = self.addressView.frame.origin.y;
    }else if ([self.cityTextView isFirstResponder]){
        originY += self.addressView.frame.origin.y + self.addressView.frame.size.height;
        scrollTo = self.addressView.frame.origin.y;
    }
    
    if (originY >= SCREEN_HEIGHT - keyboardFrameBeginRect.size.height) {
        [self.holderScrollView setContentOffset:CGPointMake(0, scrollTo) animated:YES];
    }
}

- (void) tapped{
    if([self.fromDateTextField isFirstResponder]){
        [self.fromDateTextField resignFirstResponder];
    }else if ([self.toDateTextField isFirstResponder]){
        [self.toDateTextField resignFirstResponder];
    }else if ([self.typeTextField isFirstResponder]){
        [self.typeTextField resignFirstResponder];
    }else if ([self.provinceTextView isFirstResponder]){
        [self.provinceTextView resignFirstResponder];
    }else if ([self.cityTextView isFirstResponder]){
        [self.cityTextView resignFirstResponder];
    }else if ([self.themeTextField isFirstResponder]){
        [self.themeTextField resignFirstResponder];
    }
}

- (void) reset{
    [self.fromDatePicker setDate:[NSDate date]];
    [self.toDatePicker setDate:[NSDate date]];
    [self fromDate:nil];
    [self toDate:nil];
    
    self.typePickerDataSource.currentType = -1;
    [self.typePickerView selectRow:0 inComponent:0 animated:YES];
    [self.typeTextField setText:GetStringWithKey(@"history_select_type")];
    
    self.themeTextField.text = [NSString string];
    
    self.provinceDataSource.currentRow = -1;
    self.cityDataSource.currentRow = -1;
    [self.provinceTextView setText:GetStringWithKey(@"province")];
    [self.cityTextView setText:GetStringWithKey(@"city")];

    [self.provincePickerView selectRow:0 inComponent:0 animated:NO];
}

- (void) search{
    HistoryViewController *vc = [HistoryViewController new];
    vc.showSearch = NO;
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    if ([self.fromDateString length] > 0) {
        [para setObject:self.fromDateString forKey:@"start_date"];
    }
    if ([self.toDateString length] > 0) {
        [para setObject:self.toDateString forKey:@"end_date"];
    }
    if ([self.themeTextField.text length] > 0) {
        [para setObject:self.themeTextField.text forKey:@"keyword"];
    }
    
    if (self.typePickerDataSource.currentType >= 0) {
        [para setObject:[NSString stringWithFormat:@"%d",self.typePickerDataSource.currentType+1] forKey:@"activity_type"];
    }
    
    if (![self.provinceTextView.text isEqualToString:GetStringWithKey(@"province")]) {
        [para setObject:self.provinceTextView.text forKey:@"province"];
    }
    
    if (![self.cityTextView.text isEqualToString:GetStringWithKey(@"city")]) {
        [para setObject:self.cityTextView.text forKey:@"city"];
    }
    
    vc.searchDict = para;
    [self.navigationController pushViewController:vc animated:YES];
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
