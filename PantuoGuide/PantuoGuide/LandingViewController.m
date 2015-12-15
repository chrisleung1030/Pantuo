//
//  LandingViewController.m
//  PantuoGuide
//
//  Created by Christopher Leung on 9/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "LandingViewController.h"
#import "AboutUsViewController.h"
#import "MyInfoViewController.h"
#import "EventTableViewCell.h"
#import "MyInfoDetailViewController.h"
#import "AddActivityViewController.h"
#import "AttendanceViewController.h"
#import "PreviewViewController.h"
#import "AddressManager.h"
#import "QRCodeViewController.h"
#import "BrowserViewController.h"
#import "AppDelegate.h"

@interface LandingViewController () <UIGestureRecognizerDelegate, UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate, EventTableViewCellDelegate, QRCodeViewControllerDelegate>

@property (nonatomic, retain) IBOutlet UIView *calendarHolderView;
@property (nonatomic, retain) IBOutlet UIImageView *calendarImageView;
@property (nonatomic, retain) UIView *noCoachView;
@property (nonatomic, retain) IBOutlet UITableView *activitytableView;
@property (nonatomic, retain) IBOutlet UIButton *addActivityButton;

@property (nonatomic, retain) NSMutableArray *eventArray;
@property (nonatomic, retain) NSMutableArray *halfDayViewArray;

@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, retain) NSCalendar *calendar;
@property (nonatomic, retain) NSDateFormatter *monthDateFormatter;

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, retain) NSDate *calendarDate;
@property (nonatomic, retain) NSDate *selectedDate;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, assign) BOOL isShowingToday;

@property (nonatomic, retain) NSString *restaurantId;

@property (nonatomic, retain) NSMutableArray *dateButtonArray;
@property (nonatomic, retain) UIImage *selectedImage;

@property (nonatomic, retain) QRCodeViewController *qrcodevc;

@property (nonatomic, assign) BOOL isFromPush;

@end

@implementation LandingViewController
@synthesize hasCreatedActivity;

- (NSString *) getTopBarTitle{
    return GetStringWithKey(@"my_activities");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCalendarBg) name:NOTIFICATION_CALENDAR_UPDATED object:nil];
    [((AppDelegate *)[UIApplication sharedApplication].delegate) registerPushNote];
    
    self.refreshView = NO;
    self.eventArray = [NSMutableArray array];
    self.halfDayViewArray = [NSMutableArray array];
    [self.addActivityButton setTitle:GetStringWithKey(@"create_activity") forState:UIControlStateNormal];
    
    [self addTopBarLandingTitleView];
    [self initCalendar];
    
    [self addTopBarView];
    [self.topBarView.backButton setHidden:YES];
    [self.topBarView.backImageView setHidden:YES];
    [self.topBarView.titleLabel setHidden:YES];
    [self.topBarView.logoImageView setHidden:NO];
    self.noCoachView = [[[NSBundle mainBundle] loadNibNamed:@"NoCoachView" owner:self options:nil] objectAtIndex:0];
    [self.view addSubview:self.noCoachView];
    CGRect tempFrame = self.noCoachView.frame;
    tempFrame.origin.y = 60;
    tempFrame.size.height = SCREEN_HEIGHT - 60;
    [self.noCoachView setFrame:tempFrame];
    [self setUpNoCoachView];
    
    if (self.hasCreatedActivity) {
        [self updateView];
    }
}

- (void) updateOnTimeChange{
    if (self.hasCreatedActivity) {
        BOOL refreshCalendar = NO;
        
        if (self.isShowingToday) {
            // today label need to update
            refreshCalendar = YES;
        }else{
            NSDateComponents *currentCompo = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:self.calendarDate];
            NSDateComponents *updateCompo = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
            if (currentCompo.year == updateCompo.year && currentCompo.month == updateCompo.month) {
                // today label need to come out
                refreshCalendar = YES;
            }
        }
        
        if (refreshCalendar) {
            self.calendarDate = [NSDate date];
            [self updateLeftRightButton];
            [self updateCalendar];
            [self updateCalendarBg];
            NSDateComponents * tempCompo = [self.calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit) fromDate:self.calendarDate];
            [self getActivityWithYear:(int)tempCompo.year WithMonth:(int)tempCompo.month];
        }
    }
}

- (void) updateView{
    [self.noCoachView setHidden:self.hasCreatedActivity];
    [self.topBarView setHidden:self.hasCreatedActivity];
    if (self.hasCreatedActivity) {
        [self updateCalendar];
        NSDateComponents *tempCompo = [self.calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit) fromDate:self.calendarDate];
        [self getActivityWithYear:(int)tempCompo.year WithMonth:(int)tempCompo.month];
    }
}

- (void) getHasCreatedActivity:(GuideInfo *)aGuideInfo{
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:
                          aGuideInfo.token,@"token",
                          aGuideInfo.guide_id,@"guide_id",
                          nil];
    [self callIPOSCSLAPIWithLink:API_HAS_CREATED_ACTIVITY WithParameter:para WithGet:YES];
}

- (void) getActivityWithYear:(int)aYear WithMonth:(int)aMonth{
    [self.activitytableView setHidden:YES];
    [self removeAllHalfDayView];
    
    GuideInfo *tempInfo = [self getGuideInfo];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSString stringWithFormat:@"%d",aYear],@"year",
                          [NSString stringWithFormat:@"%d",aMonth],@"month",
                          tempInfo.token,@"token",
                          tempInfo.guide_id,@"guide_id",
                          nil];
    [self callIPOSCSLAPIWithLink:API_GET_ACTIVITY WithParameter:para WithGet:YES];
}

- (void) handleResponse:(id)response WithLink:(NSString *)aLink WithRequest:(NSDictionary *)aRequest{
    if ([aLink isEqualToString:API_GET_ACTIVITY]) {
        self.eventArray = response;
        [self.activitytableView setHidden:NO];
        [self.activitytableView reloadData];
        for (int i = 0; i < [self.eventArray count]; i++) {
            NSDictionary *tempDict = [self.eventArray objectAtIndex:i];
            NSDateComponents *tempCompo = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
            NSString *today = [NSString stringWithFormat:@"%d-%02d-%02d",(int)tempCompo.year,(int)tempCompo.month,(int)tempCompo.day];
            if ([today compare:[tempDict objectForKey:@"end_date"]] != NSOrderedDescending) {
                [self.activitytableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                break;
            }
        }
        [self updateBgColorForButton];
        [(AppDelegate *)APP_DELEGATE checkActivityPushNote];
    }else if ([aLink isEqualToString:API_HAS_CREATED_ACTIVITY]) {
        BOOL tempHasCreatedActivity = [[response objectForKey:@"has_created_activity"] isEqualToString:@"1"];
        if (self.hasCreatedActivity != tempHasCreatedActivity || self.hasCreatedActivity) {
            self.hasCreatedActivity = tempHasCreatedActivity;
            [self updateView];
        }
    }else if ([aLink isEqualToString:API_GET_ACTIVITY_DETAIL]) {
        if (self.isFromPush) {
            [self goToAttendanceWithDict:response];
        }else{
            PreviewViewController *vc = [PreviewViewController new];
            vc.showEdit = NO;
            vc.useMyActivityTitle = NO;
            vc.activityLink = [response objectForKey:@"activity_link"];
            vc.activityId  = [response objectForKey:@"activity_id"];
            vc.previewLink = [response objectForKey:@"preview_link"];
            vc.activityTitle = [response objectForKey:@"title"];
            NSString *link = [response objectForKey:@"image1"];
            if ([link length] == 0) {
                link = [response objectForKey:@"image2"];
                if ([link length] == 0) {
                    link = [response objectForKey:@"image3"];
                }
            }
            vc.activityImageLink = link;
            vc.activityDict = response;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    if (self.refreshView) {
        self.refreshView = NO;
        [self getHasCreatedActivity:[self getGuideInfo]];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void) setUpNoCoachView{
    [((UIButton *)[self.noCoachView viewWithTag:2]) addTarget:self action:@selector(info:) forControlEvents:UIControlEventTouchUpInside];
    [((UIButton *)[self.noCoachView viewWithTag:3]) addTarget:self action:@selector(event:) forControlEvents:UIControlEventTouchUpInside];
    [((UIButton *)[self.noCoachView viewWithTag:4]) addTarget:self action:@selector(about:) forControlEvents:UIControlEventTouchUpInside];
    
    int month = (int)[[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:[NSDate date]].month;
    NSDictionary *tempDict = [self getUserDefault:KEY_CALENDAR_BG];
    NSString *link = [tempDict objectForKey:[NSString stringWithFormat:@"%d",month]];
    

    UIView *buttonView = [self.noCoachView viewWithTag:5];
    UIImageView *tempImageView = (UIImageView *)[self.noCoachView viewWithTag:1];
    
    CGRect tempFrame = buttonView.frame;
    tempFrame.origin.y = self.noCoachView.frame.size.height - buttonView.frame.size.height;
    [buttonView setFrame:tempFrame];
    
    tempFrame = tempImageView.frame;
    tempFrame.size.height = self.noCoachView.frame.size.height - buttonView.frame.size.height;
    [tempImageView setFrame:tempFrame];
    [tempImageView sd_setImageWithURL:[NSURL URLWithString:link]];
    
}

- (void) info:(id)sender{
    if (sender == self.topBarTitleView.infoButton) {
        [self logEventWithId:GetStringWithKey(@"Tracking_calendar_my_info_id") WithLabel:GetStringWithKey(@"Tracking_calendar_my_info")];
    }else{
        [self logEventWithId:GetStringWithKey(@"Tracking_no_calendar_my_info_id") WithLabel:GetStringWithKey(@"Tracking_no_calendar_my_info")];
    }
    [self.navigationController pushViewController:[MyInfoViewController new] animated:YES];
}

- (void) about:(id)sender{
    if (sender == self.topBarTitleView.aboutButton) {
        [self logEventWithId:GetStringWithKey(@"Tracking_calendar_about_us_id") WithLabel:GetStringWithKey(@"Tracking_calendar_about_us")];
    }else{
        [self logEventWithId:GetStringWithKey(@"Tracking_no_calendar_about_us_id") WithLabel:GetStringWithKey(@"Tracking_no_calendar_about_us")];
    }
    [self.navigationController pushViewController:[AboutUsViewController new] animated:YES];
}

- (IBAction) event:(id)sender{
    if (sender == self.topBarTitleView.eventButton) {
        [self logEventWithId:GetStringWithKey(@"Tracking_calendar_new_activity_top_id") WithLabel:GetStringWithKey(@"Tracking_calendar_new_activity_top")];
    }else if (sender == self.addActivityButton){
        [self logEventWithId:GetStringWithKey(@"Tracking_calendar_new_activity_bottom_id") WithLabel:GetStringWithKey(@"Tracking_calendar_new_activity_bottom")];
    }else{
        [self logEventWithId:GetStringWithKey(@"Tracking_no_calendar_new_activity_id") WithLabel:GetStringWithKey(@"Tracking_no_calendar_new_activity")];
    }
    AddActivityViewController *vc = [AddActivityViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) qrcode:(id)sender{
    [self removeQRCodeVC];
    self.qrcodevc = [QRCodeViewController new];
    self.qrcodevc.delegate = self;
    [self.navigationController pushViewController:self.qrcodevc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_CALENDAR_UPDATED object:nil];
    [self removeQRCodeVC];
}

- (void) removeQRCodeVC{
    if (self.qrcodevc) {
        self.qrcodevc.delegate = nil;
        self.qrcodevc = nil;
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

- (BOOL) isActivityInputFinished:(NSDictionary *)aDict{
    BOOL isFinished = YES;
    if ([[aDict objectForKey:@"color"] length] < 7 ) {
        isFinished = NO;
    }else if ([[aDict objectForKey:@"type"] intValue] == 0 && [[aDict objectForKey:@"other_type"] length] == 0){
        isFinished = NO;
    }else if ([[aDict objectForKey:@"title"] length] == 0){
        isFinished = NO;
    }else if ([[aDict objectForKey:@"slogan"] length] == 0){
        isFinished = NO;
    }else if ([[aDict objectForKey:@"toughness"] intValue] == 0){
        isFinished = NO;
    }else if ([[aDict objectForKey:@"min_ppl"] intValue] == 0){
        isFinished = NO;
    }else if ([[aDict objectForKey:@"max_ppl"] intValue] == 0 && ![[aDict objectForKey:@"unlimit_ppl"] boolValue]){
        isFinished = NO;
    }else if ([[aDict objectForKey:@"image1"] length] == 0 && [[aDict objectForKey:@"image2"] length] == 0 && [[aDict objectForKey:@"image3"] length] == 0){
        isFinished = NO;
    }else if ([[aDict objectForKey:@"fee"] length] == 0){
        isFinished = NO;
    }else if ([[aDict objectForKey:@"activity_notice"] length] == 0){
        isFinished = NO;
    }else if ([[aDict objectForKey:@"equipment"] length] == 0){
        isFinished = NO;
    }
    
    if (isFinished) {
        if ([(NSArray *)[aDict objectForKey:@"plan"] count] > 0) {
            for (NSDictionary *plan in [aDict objectForKey:@"plan"]) {
                if ([[plan objectForKey:@"theme"] length] == 0) {
                    isFinished = NO;
                    break;
                }
            }
        }else{
            isFinished = NO;
        }
    }
    if (isFinished) {
        if ([[aDict objectForKey:@"oversea"] boolValue]) {
            if ([[aDict objectForKey:@"venue"] length] == 0) {
                isFinished = NO;
            }
        }else if ([[aDict objectForKey:@"province"] length] == 0) {
            isFinished = NO;
        }else{
            AddressManager *am = [AddressManager new];
            isFinished = [am isCorrectProvince:[aDict objectForKey:@"province"] City:[aDict objectForKey:@"city"] Area:[aDict objectForKey:@"area"]];
        }
    }
    
    return isFinished;
}

#pragma mark - QRCodeViewControllerDelegate
- (void) QRCodeViewControllerDidCheckinWitheCode:(NSString *)aCode{
    if ([aCode hasPrefix:WEBSITE_ACTIVITY_QRCODE] && [aCode rangeOfString:@"?"].location != NSNotFound) {
        [self.navigationController popViewControllerAnimated:YES];
        
        NSString *trimFront = [aCode substringFromIndex:[WEBSITE_ACTIVITY_QRCODE length]];
        int location = (int)[trimFront rangeOfString:@"?"].location;
        NSString *activity_id = [trimFront substringToIndex:location];
        
        self.isFromPush = NO;
        GuideInfo *guideInfo = [self getGuideInfo];
        [self callIPOSCSLAPIWithLink:API_GET_ACTIVITY_DETAIL
                       WithParameter:[NSDictionary dictionaryWithObjectsAndKeys:
                                      guideInfo.token,@"token",
                                      guideInfo.guide_id,@"guide_id",
                                      activity_id,@"activity_id", nil]
                             WithGet:NO];
        
        [self removeQRCodeVC];
    }else if ([aCode hasPrefix:@"http://"] || [aCode hasPrefix:@"https://"]){
        BrowserViewController *b = [BrowserViewController new];
        b.link = aCode;
        [self.navigationController pushViewController:b animated:YES];
    }else{
        UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:aCode delegate:self cancelButtonTitle:GetStringWithKey(@"confirm") otherButtonTitles:nil];
        [tempAlertView show];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.qrcodevc start];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.eventArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EventTableViewCell *cell = (EventTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"EventTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EventTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.delegate = self;
    }
    
    NSDictionary *tempDict = [self.eventArray objectAtIndex:indexPath.row];
    
    
    NSString *start = GetDateStringFromNormalFormat([tempDict objectForKey:@"start_date"],GetStringWithKey(@"date_format"));
    if ([[tempDict objectForKey:@"start_date"] isEqualToString:[tempDict objectForKey:@"end_date"]]) {
        cell.dateLabel.text = start;
    }else{
        NSString *end = GetDateStringFromNormalFormat([tempDict objectForKey:@"end_date"],GetStringWithKey(@"date_format"));
        cell.dateLabel.text = [NSString stringWithFormat:@"%@ - %@",start,end];
    }
    
    if ([[tempDict objectForKey:@"title"] length] == 0) {
        cell.titleLabel.text = GetStringWithKey(@"default_title");
    }else{
        cell.titleLabel.text = [tempDict objectForKey:@"title"];
    }
    
    ActivityStatus status = [self getActivityStatus:tempDict];
    if (status == ActivityStatusEnded) {
        [cell.peopleButton setHidden:YES];
        [cell.peopleHiddenButton setHidden:YES];
        if ([[tempDict objectForKey:@"action"] isEqualToString:@"published"]) {
            [cell.notFinishButton setHidden:YES];
            [cell.notReleaseButton setHidden:YES];
            [cell.finishButton setHidden:NO];
        }else if ([self isActivityInputFinished:tempDict]){
            [cell.notFinishButton setHidden:YES];
            [cell.notReleaseButton setHidden:NO];
            [cell.finishButton setHidden:YES];
        }else{
            [cell.notFinishButton setHidden:NO];
            [cell.notReleaseButton setHidden:YES];
            [cell.finishButton setHidden:YES];
        }
        [cell.eventButton setBackgroundColor:[UIColor grayColor]];
    }else if (status == ActivityStatusIncomplete) {
        [cell.peopleButton setHidden:YES];
        [cell.peopleHiddenButton setHidden:YES];
        if ([self isActivityInputFinished:tempDict]){
            [cell.notFinishButton setHidden:YES];
            [cell.notReleaseButton setHidden:NO];
            [cell.finishButton setHidden:YES];
        }else{
            [cell.notFinishButton setHidden:NO];
            [cell.notReleaseButton setHidden:YES];
            [cell.finishButton setHidden:YES];
        }
        [cell.eventButton setBackgroundColor:ColorWithHexString(RemoveColorSign([tempDict objectForKey:@"color"]))];
    }else if (status == ActivityStatusOnGoing) {
        BOOL isunlimit = [[tempDict objectForKey:@"unlimit_ppl"] boolValue];
        if (isunlimit) {
            [cell.peopleButton setTitle:GetStringWithKey(@"participation_unlimit") forState:UIControlStateNormal];
        }else{
            int joined = [[tempDict objectForKey:@"joined_ppl"] intValue];
            int max = [[tempDict objectForKey:@"max_ppl"] intValue];
            [cell.peopleButton setTitle:[NSString stringWithFormat:GetStringWithKey(@"participation_num"),joined,max] forState:UIControlStateNormal];
        }
        
        [cell.peopleButton setHidden:NO];
        [cell.peopleHiddenButton setHidden:NO];
        [cell.notFinishButton setHidden:YES];
        [cell.notReleaseButton setHidden:YES];
        [cell.finishButton setHidden:YES];
        [cell.eventButton setBackgroundColor:ColorWithHexString(RemoveColorSign([tempDict objectForKey:@"color"]))];
    }
    
    
    [cell.eventButton setImage:nil forState:UIControlStateNormal];
    [cell.eventButton setTitle:[NSString string] forState:UIControlStateNormal];
    int type = [[tempDict objectForKey:@"type"] intValue];
    if (type > 0) {
        [cell.eventButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"calender_icon_%02d.png",type]] forState:UIControlStateNormal];
    }else if ([[tempDict objectForKey:@"other_type"] length] > 0){
        [cell.eventButton setTitle:[tempDict objectForKey:@"other_type"] forState:UIControlStateNormal];
    }else if (status == ActivityStatusEnded){
        [cell.eventButton setImage:[UIImage imageNamed:@"icn_grey_other.png"] forState:UIControlStateNormal];
    }else{
        [cell.eventButton setImage:[UIImage imageNamed:@"icn_event_green_26.png"] forState:UIControlStateNormal];
    }
    
    CGRect tempFrame = cell.dateLabel.frame;
    tempFrame.origin.y += tempFrame.size.height + 3;
    tempFrame.size.height = 80 - tempFrame.origin.y;
    [cell.titleLabel setFrame:tempFrame];
    [cell.titleLabel sizeToFit];
    if (cell.titleLabel.frame.origin.y + cell.titleLabel.frame.size.height >= 80) {
        [cell.titleLabel setFrame:tempFrame];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *tempDict = [self.eventArray objectAtIndex:indexPath.row];
    if ([[tempDict objectForKey:@"action"] isEqualToString:@"save"]) {
        // go to edit
        AddActivityViewController *vc = [AddActivityViewController new];
        vc.activityDict = tempDict;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        PreviewViewController *vc = [PreviewViewController new];
        vc.showEdit = YES;
        vc.useMyActivityTitle = YES;
        vc.activityId = [tempDict objectForKey:@"activity_id"];
        vc.activityLink = [tempDict objectForKey:@"activity_link"];
        vc.previewLink = [tempDict objectForKey:@"preview_link"];
        vc.activityTitle = [tempDict objectForKey:@"title"];
        NSString *link = [[tempDict objectForKey:@"image1"] length] >0?[tempDict objectForKey:@"image1"]:[[tempDict objectForKey:@"image2"] length]>0?[tempDict objectForKey:@"image2"]:[[tempDict objectForKey:@"image3"] length]>0?[tempDict objectForKey:@"image3"]:@"";
        vc.activityImageLink = link;
        vc.activityDict = tempDict;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - EventTableViewCellDelegate
- (void) EventTableViewCellDidSelectPeople:(UITableViewCell *)aCell{
    int row = (int)[self.activitytableView indexPathForCell:aCell].row;
    
    NSDictionary *tempDict = [self.eventArray objectAtIndex:row];
    [self goToAttendanceWithDict:tempDict];
    
}

- (void) goToAttendanceWithActivityID:(NSString *)aActivityID{
    self.isFromPush = YES;
    GuideInfo *guideInfo = [self getGuideInfo];
    [self callIPOSCSLAPIWithLink:API_GET_ACTIVITY_DETAIL
                   WithParameter:[NSDictionary dictionaryWithObjectsAndKeys:
                                  guideInfo.token,@"token",
                                  guideInfo.guide_id,@"guide_id",
                                  aActivityID,@"activity_id", nil]
                         WithGet:NO];
}

- (void) goToAttendanceWithDict:(NSDictionary *)aDict{
    NSString *endString = [aDict objectForKey:@"end_date"];
    
    NSDateFormatter *tempFormatter = [NSDateFormatter new];
    [tempFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *tempTodayString = [tempFormatter stringFromDate:[NSDate date]];
    
    if ([[aDict objectForKey:@"action"] isEqualToString:@"published"] && [tempTodayString compare:endString] != NSOrderedDescending) {
        NSString *startDateString = [aDict objectForKey:@"start_date"];
        NSString *startTimeString = [aDict objectForKey:@"start_time"];
        
        tempFormatter = [NSDateFormatter new];
        [tempFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *tempDate = [tempFormatter dateFromString:[NSString stringWithFormat:@"%@ %@",startDateString,startTimeString]];
        
        NSTimeInterval interval = [tempDate timeIntervalSinceDate:[NSDate date]];
        float hour = interval/3600.0;
        
        AttendanceViewController *vc = [AttendanceViewController new];
        vc.isTakeAttendance = hour <= 1;
        vc.activityDict = aDict;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Calendar
- (void) initCalendar{
    
    self.calendar = [NSCalendar currentCalendar];
    
    self.selectedImage = [UIImage imageNamed:@"icon_selected_date.png"];
    
    self.calendarDate = [NSDate date];
    
    self.monthDateFormatter = [NSDateFormatter new];
    [self.monthDateFormatter setDateFormat:@"yyyy年M月"];
    NSLocale *locale = [[NSLocale  alloc] initWithLocaleIdentifier:@"zh"];
    [self.monthDateFormatter setLocale:locale];
    
    self.monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    [self.monthLabel setBackgroundColor:[UIColor clearColor]];
    [self.monthLabel setTextColor:[UIColor blackColor]];
    [self.monthLabel setTextAlignment:NSTextAlignmentCenter];
    [self.calendarHolderView addSubview:self.monthLabel];
    
    self.dateButtonArray = [NSMutableArray new];
    int xCoordinate = 0 , yCoordinate = 50;
    int startX = 10;
//    int buttonWidth = (int)lround((SCREEN_WIDTH-startX*2)/7.0);
    int buttonWidth = (SCREEN_WIDTH-startX*2)/7;
    int buttonHeight = 30;
    
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftButton setFrame:CGRectMake(startX, 0, 40, 40)];
    [self.leftButton addTarget:self action:@selector(CalendarHolderViewDidSelectedLeft) forControlEvents:UIControlEventTouchUpInside];
    [self.calendarHolderView addSubview:self.leftButton];
    
    self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(startX+17, 10, 10, 10)];
    [self.leftImageView setImage:[UIImage imageNamed:@"black_arrow_left.png"]];
    [self.calendarHolderView addSubview:self.leftImageView];
    
    int rightX = startX+buttonWidth*6;
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton setFrame:CGRectMake(rightX, 0, 40, 40)];
    [self.rightButton addTarget:self action:@selector(CalendarHolderViewDidSelectedRight) forControlEvents:UIControlEventTouchUpInside];
    [self.calendarHolderView addSubview:self.rightButton];
    
    self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(rightX+17, 10, 10, 10)];
    [self.rightImageView setImage:[UIImage imageNamed:@"black_arrow_right.png"]];
    [self.calendarHolderView addSubview:self.rightImageView];
    
    
    for (int i = 0; i < 42; i++) {
//        xCoordinate = startX + oneDateWidth*(i%7);
        xCoordinate = startX + buttonWidth*(i%7);
            if (i % 7 == 0 && i > 0){
            yCoordinate += buttonHeight + 2;
        }
        
//        CGRect tempFrame = CGRectMake(xCoordinate+(oneDateWidth-30)/2, yCoordinate, 32, 32);
        CGRect tempFrame = CGRectMake(xCoordinate, yCoordinate, buttonWidth, buttonHeight);
        UIButton *tempButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [tempButton setFrame:tempFrame];
        tempButton.exclusiveTouch = YES;
        [tempButton.titleLabel setBackgroundColor:[UIColor clearColor]];
        [tempButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [tempButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [tempButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [tempButton.layer setBorderColor:[UIColor blackColor].CGColor];
        [tempButton addTarget:self action:@selector(dateDidSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.dateButtonArray addObject:tempButton];
        [self.calendarHolderView addSubview:tempButton];
        
        if (i < 7) {
//            UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(xCoordinate+(oneDateWidth-30)/2, yCoordinate-18, 32, 13)];
            UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(xCoordinate+(buttonWidth-32)/2, yCoordinate-18, 32, 13)];
            [tempLabel setBackgroundColor:[UIColor clearColor]];
            [tempLabel setTextColor:[UIColor blackColor]];
            [tempLabel setFont:[UIFont systemFontOfSize:12.0f]];
            [tempLabel setTextAlignment:NSTextAlignmentCenter];
            [tempLabel setText:GetStringWithKey([NSString stringWithFormat:@"Day%d",i])];
            [self.calendarHolderView addSubview:tempLabel];
        }
    }
    
    [self updateLeftRightButton];
    [self updateCalendar];
    [self updateCalendarBg];
}

- (void) updateCalendar{
    self.isShowingToday = NO;
    [self.monthLabel setText:[self.monthDateFormatter stringFromDate:self.calendarDate]];
    
    NSDateComponents *todayComp = [self.calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
//    NSDateComponents *selectedComp;
//    if (self.selectedDate){
//        selectedComp = [self.calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:self.selectedDate];
//    }
    
    NSDateComponents *tempComp = [self.calendar components:NSDayCalendarUnit fromDate:self.calendarDate];
    [tempComp setDay:[tempComp day]*-1+1];
    
    NSDate *firstDate = [self.calendar dateByAddingComponents:tempComp toDate:self.calendarDate options:0];
    tempComp = [self.calendar components:(NSWeekdayCalendarUnit|NSDayCalendarUnit) fromDate:firstDate];
    NSRange monthRange = [self.calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:firstDate];
    
    NSDateComponents *addOneCompo = [[NSDateComponents alloc] init];
    [addOneCompo setDay:1];
    NSDate *addOneDate = firstDate;
    
    // Now
    for (int i = 0; i < monthRange.length; i ++) {
        int day = i+1;
        int index = (int)[tempComp weekday] + i-1;
        UIButton *tempButton = [self.dateButtonArray objectAtIndex:index];
        NSString *tempString = [NSString stringWithFormat:@"%d",day];
        NSMutableAttributedString *tempAttributeString = [[NSMutableAttributedString alloc] initWithString:tempString];
        
        [tempButton setTag:day];
        [tempButton setHidden:NO];
        [tempButton setBackgroundColor:[UIColor clearColor]];
        
        NSDateComponents *buttonCompo = [self.calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit) fromDate:addOneDate];
        
//        if (selectedComp && [selectedComp year] == [buttonCompo year] && [selectedComp month] == [buttonCompo month] && [selectedComp day] == [buttonCompo day]) {
//            
//            [tempButton setBackgroundImage:self.selectedImage forState:UIControlStateNormal];
//            [tempAttributeString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, tempString.length)];
//        }else
        if ([todayComp year] == [buttonCompo year] && [todayComp month] == [buttonCompo month] && [todayComp day] == [buttonCompo day]) {
            
//            [tempButton setBackgroundImage:nil forState:UIControlStateNormal];
//            [tempAttributeString addAttribute:NSUnderlineStyleAttributeName
//                                        value:[NSNumber numberWithInt:NSUnderlineStyleSingle]
//                                        range:NSMakeRange(0, tempString.length)];
//            [tempAttributeString addAttribute:NSForegroundColorAttributeName value:[UIColor purpleColor] range:NSMakeRange(0, tempString.length)];
            
            self.isShowingToday = YES;
            [tempButton.layer setBorderWidth:1];
            [tempAttributeString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, tempString.length)];
            [tempAttributeString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16.0f] range:NSMakeRange(0, tempString.length)];
            
//        }else if ([self dateWithinRange:addOneDate] && [self checkCanBookDateWithDate:addOneDate]){
//            [tempButton setBackgroundImage:nil forState:UIControlStateNormal];
//            [tempAttributeString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, tempString.length)];
        }else{
            [tempButton.layer setBorderWidth:0];
            [tempAttributeString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, tempString.length)];
            [tempAttributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0f] range:NSMakeRange(0, tempString.length)];
        }
        [tempButton setAttributedTitle:tempAttributeString forState:UIControlStateNormal];
        addOneDate = [self.calendar dateByAddingComponents:addOneCompo toDate:addOneDate options:0];
    }
    
    // Next
    //	int nextMonthDay = 1;
    for (int i = (int)[tempComp weekday] + (int)monthRange.length -1; i < 42; i ++) {
        UIButton *tempButton = [self.dateButtonArray objectAtIndex:i];
        [tempButton setHidden:YES];
        [tempButton setTag:100+i];
        //		NSString *tempString = [NSString stringWithFormat:@"%d",nextMonthDay];
        //		[tempButton setTitle:tempString forState:UIControlStateNormal];
        //		[tempButton setTag:nextMonthDay];
        //		nextMonthDay ++;
        //		NSDateComponents *buttonCompo = [self.calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:addOneDate];
        //
        //        if (selectedComp && [selectedComp year] == [buttonCompo year] && [selectedComp month] == [buttonCompo month] && [selectedComp day] == [buttonCompo day]) {
        //			[tempButton setBackgroundImage:self.selectedImage forState:UIControlStateNormal];
        //            [tempButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //        }else if ([todayComp year] == [buttonCompo year] && [todayComp month] == [buttonCompo month] && [todayComp day] == [buttonCompo day]) {
        //            [tempButton setBackgroundImage:self.todayImage forState:UIControlStateNormal];
        //            [tempButton setTitleColor:GetTextColor() forState:UIControlStateNormal];
        //        }else if ([self dateWithinRange:addOneDate]){
        //            [tempButton setBackgroundImage:nil forState:UIControlStateNormal];
        //            [tempButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //        }else{
        //            [tempButton setBackgroundImage:nil forState:UIControlStateNormal];
        //            [tempButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        //        }
        
        addOneDate = [self.calendar dateByAddingComponents:addOneCompo toDate:addOneDate options:0];
    }
    
    [addOneCompo setDay:-1];
    
    // Last
    NSDateComponents *tempLastComp = [self.calendar components:NSMonthCalendarUnit fromDate:self.calendarDate];
    [tempLastComp setMonth:-1];
    //	NSDate *lastMonthDate = [self.calendar dateByAddingComponents:tempLastComp toDate:self.calendarDate options:0];
    //	NSRange lastMonthRange = [self.calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:lastMonthDate];
    //	int lastMonthDay = lastMonthRange.length;
    for (int i = (int)[tempComp weekday] - 2; i >= 0; i--) {
        //		firstDate = [self.calendar dateByAddingComponents:addOneCompo toDate:firstDate options:0];
        //		NSString *tempString = [NSString stringWithFormat:@"%d",lastMonthDay];
        
        UIButton *tempButton = [self.dateButtonArray objectAtIndex:i];
        [tempButton setHidden:YES];
        [tempButton setTag:200+i];
        //		[tempButton setTitle:tempString forState:UIControlStateNormal];
        //		[tempButton setTag:lastMonthDay];
        //		lastMonthDay --;
        //
        //		NSDateComponents *buttonCompo = [self.calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:firstDate];
        //
        //        if (selectedComp && [selectedComp year] == [buttonCompo year] && [selectedComp month] == [buttonCompo month] && [selectedComp day] == [buttonCompo day]) {
        //			[tempButton setBackgroundImage:self.selectedImage forState:UIControlStateNormal];
        //            [tempButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //        }else if ([todayComp year] == [buttonCompo year] && [todayComp month] == [buttonCompo month] && [todayComp day] == [buttonCompo day]) {
        //            [tempButton setBackgroundImage:self.todayImage forState:UIControlStateNormal];
        //            [tempButton setTitleColor:GetTextColor() forState:UIControlStateNormal];
        //        }else if ([self dateWithinRange:addOneDate]){
        //            [tempButton setBackgroundImage:nil forState:UIControlStateNormal];
        //            [tempButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //        }else{
        //            [tempButton setBackgroundImage:nil forState:UIControlStateNormal];
        //            [tempButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        //        }
    }
}

- (void) updateCalendarBg{
    
    int month = (int)[[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:self.calendarDate].month;
    NSDictionary *calBG = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_CALENDAR_BG];
    NSString *link = [calBG objectForKey:[NSString stringWithFormat:@"%d",month]];
    [self.calendarImageView sd_setImageWithURL:[NSURL URLWithString:link]];
}

- (void) dateDidSelected:(UIButton *)sender{
    //	int index = [self.dateButtonArray indexOfObject:sender];
    //	if (index < 6 && [sender tag] > 20) {
    //		// to last month
    //		NSDateComponents *tempCompo = [[NSDateComponents alloc] init];
    //		[tempCompo setMonth:-1];
    //		NSDate *lastMonthDate = [self.calendar dateByAddingComponents:tempCompo toDate:self.calendarDate options:0];
    //
    //        tempCompo = [self.calendar components:NSDayCalendarUnit fromDate:self.calendarDate];
    //        NSRange lastDayRange = [self.calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:lastMonthDate];
    //        [tempCompo setDay:[sender tag] - lastDayRange.length - [tempCompo day]];
    //        NSDate *tempDate = [self.calendar dateByAddingComponents:tempCompo toDate:self.calendarDate options:0];
    //
    //        if ([self dateWithinRange:tempDate]){
    //            self.selectedDate = tempDate;
    //            self.calendarDate = self.selectedDate;
    //            [self updateLeftRightButton];
    //            [self updateCalendar];
    //        }
    //	}else if (index > 27 && [sender tag] < 15) {
    //		// to next month
    //		NSRange dayRange = [self.calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self.calendarDate];
    //		NSDateComponents *tempCompo = [self.calendar components:NSDayCalendarUnit fromDate:self.calendarDate];
    //		[tempCompo setDay:dayRange.length - [tempCompo day] + [sender tag]];
    //        NSDate *nextMonthDate = [self.calendar dateByAddingComponents:tempCompo toDate:self.calendarDate options:0];
    //        if ([self dateWithinRange:nextMonthDate]){
    //            self.selectedDate = nextMonthDate;
    //            self.calendarDate = self.selectedDate;
    //            [self updateLeftRightButton];
    //            [self updateCalendar];
    //        }
    //	}else {
    
    NSDateComponents* tempComp = [self.calendar components:NSDayCalendarUnit fromDate:self.calendarDate];
    [tempComp setDay:(int)[sender tag] - [tempComp day]];
    NSDate *thisMonthDate = [self.calendar dateByAddingComponents:tempComp toDate:self.calendarDate options:0];
    
    NSDateFormatter *tempFormatter = [NSDateFormatter new];
    [tempFormatter setDateFormat:@"yyyy-MM-dd"];
    
    for (NSDictionary *aDict in self.eventArray) {
        NSDate *start = [tempFormatter dateFromString:[aDict objectForKey:@"start_date"]];
        NSDate *end = [tempFormatter dateFromString:[aDict objectForKey:@"end_date"]];
        if ([thisMonthDate compare:start] != NSOrderedAscending && [thisMonthDate compare:end] != NSOrderedDescending) {
//            NSLog(@"aDict:%@",[aDict description]);
            break;
        }
    }

//    tempComp = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:thisMonthDate];
//    if ([self dateWithinRange:thisMonthDate]){
//        tempComp = [self.calendar components:(NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit) fromDate:self.calendarDate];
//        int year = [tempComp year], month = [tempComp month], day = [tempComp day];
//        [tempComp setDay:[tempComp day]*-1+1];
//        [tempComp setMonth:0];
//        [tempComp setYear:0];
//        NSDate *firstDate = [self.calendar dateByAddingComponents:tempComp toDate:self.calendarDate options:0];
//        
//        tempComp = [self.calendar components:NSWeekdayCalendarUnit fromDate:firstDate];
//        int index = [tempComp weekday]+ day -2;
//        UIButton *tempButton = [self.dateButtonArray objectAtIndex:index];
//        
//        
//        NSString *tempString = tempButton.titleLabel.attributedText.string;
//        NSMutableAttributedString *tempAttributeString = [[NSMutableAttributedString alloc] initWithString:tempString];
//        
//        NSDateComponents *todayComp = [self.calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:self.todayDate];
//        
//        NSString *selectedDateString = [NSString string];
//        NSDateComponents *selectedDateCompo = [NSDateComponents new];
//        if (self.selectedDate) {
//            selectedDateString = [self getDateStringFromDate:self.selectedDate];
//            selectedDateCompo = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:self.selectedDate];
//        }
//        
//        if ([todayComp year] == year && [todayComp month] == month && [todayComp day] == day) {
//            [tempButton setBackgroundImage:nil forState:UIControlStateNormal];
//        }else if (self.selectedDate && [self dateWithinRange:self.selectedDate]){
//            [tempButton setBackgroundImage:nil forState:UIControlStateNormal];
//            
//            [tempAttributeString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, tempString.length)];
//            [tempButton setAttributedTitle:tempAttributeString forState:UIControlStateNormal];
//        }else{
//            [tempButton setBackgroundImage:nil forState:UIControlStateNormal];
//            [tempAttributeString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, tempString.length)];
//            [tempButton setAttributedTitle:tempAttributeString forState:UIControlStateNormal];
//        }
//        
//        self.selectedDate = thisMonthDate;
//        self.calendarDate = self.selectedDate;
//        
////        BOOL isTimeSetted = self.selectedTime && [self.selectedTime length] > 0;
////        BOOL haveTimePref = [self.calendarHolderView setUpPickerWithTimeSlotArray:[self getTimeArrayWithDate:self.selectedDate] WithTime:self.selectedTime];
////        if (!isTimeSetted && !haveTimePref) {
////            [self showTimePreference];
////        }else if (!haveTimePref && [self.calendarHolderView.timeTextField isEditing]){
////            [self.calendarHolderView selectPickerAtIndex:0];
////        }
//        
//        [self updateLeftRightButton];
//        [sender setBackgroundImage:self.selectedImage forState:UIControlStateNormal];
//        
//        tempString = ((UIButton *)sender).titleLabel.attributedText.string;
//        tempAttributeString = [[NSMutableAttributedString alloc] initWithString:((UIButton *)sender).titleLabel.attributedText.string];
//        
//        [tempAttributeString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, tempString.length)];
//        [(UIButton *)sender setAttributedTitle:tempAttributeString forState:UIControlStateNormal];
//        
//        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    }
    //	}
}

- (void) removeAllHalfDayView{
    for(UIView *tempView in self.halfDayViewArray){
        [tempView removeFromSuperview];
    }
    [self.halfDayViewArray removeAllObjects];
    for(UIView *tempView in self.halfDayViewArray){
        [tempView removeFromSuperview];
    }
    [self.halfDayViewArray removeAllObjects];
}

- (void) updateBgColorForButton{
    NSDateFormatter *tempFormatter = [NSDateFormatter new];
    [tempFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDateComponents *addOneCompo = [[NSDateComponents alloc] init];
    [addOneCompo setDay:1];
    
    NSString *tempTodayString = [tempFormatter stringFromDate:[NSDate date]];
    NSDate *tempTodayDate = [tempFormatter dateFromString:tempTodayString];
    
    int calendarMonth = (int)[[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:self.calendarDate].month;

    for (NSDictionary *aDict in self.eventArray) {
        if ([[aDict objectForKey:@"action"] isEqualToString:@"published"]) {
            NSString *colorString = RemoveColorSign([aDict objectForKey:@"color"]);
            UIColor *color = ColorWithHexString(colorString);
            
            NSDate *start = [tempFormatter dateFromString:[aDict objectForKey:@"start_date"]];
            
            int startDay = (int)[[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:start].day;
            if ([[aDict objectForKey:@"is_half_day_activity"] boolValue]) {
                UIButton *tempButton = (UIButton *)[self.calendarHolderView viewWithTag:startDay];
                [tempButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                NSString *tempString = [NSString stringWithFormat:@"%d",startDay];
                NSMutableAttributedString *tempAttributeString = [[NSMutableAttributedString alloc] initWithString:tempString];
                [tempAttributeString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, tempString.length)];
                [tempAttributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0f] range:NSMakeRange(0, tempString.length)];
                [tempButton setAttributedTitle:tempAttributeString forState:UIControlStateNormal];
                [tempButton setBackgroundColor:[UIColor clearColor]];
                
                NSString *time = [aDict objectForKey:@"start_time"];
                UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, [@"12:00" compare:time] == NSOrderedDescending?0:tempButton.frame.size.height/2, tempButton.frame.size.width, tempButton.frame.size.height/2)];
                if ([start compare:tempTodayDate] == NSOrderedAscending) {
                    [tempView setBackgroundColor:[UIColor grayColor]];
                }else{
                    [tempView setBackgroundColor:color];
                }
                [tempButton addSubview:tempView];
                [tempButton sendSubviewToBack:tempView];
                [self.halfDayViewArray addObject:tempView];
            }else{
                NSDate *end = [tempFormatter dateFromString:[aDict objectForKey:@"end_date"]];
                NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit
                                                                    fromDate:start
                                                                      toDate:end
                                                                     options:0];
                int endDay = startDay + (int)components.day;
                BOOL isFinished = NO;
                if ([end compare:tempTodayDate] == NSOrderedAscending) {
                    isFinished = YES;
                }
                NSDate *tempCurrentDate = start;
                for (int i = startDay; i <= endDay; i++) {
                    int tempMonth = (int)[[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:tempCurrentDate].month;
                    if (tempMonth == calendarMonth) {
                        int tag = (int)[[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:tempCurrentDate].day;
                        UIButton *tempButton = (UIButton *)[self.calendarHolderView viewWithTag:tag];
                        [tempButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        
                        NSString *tempString = [NSString stringWithFormat:@"%d",tag];
                        NSMutableAttributedString *tempAttributeString = [[NSMutableAttributedString alloc] initWithString:tempString];
                        [tempAttributeString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, tempString.length)];
                        [tempAttributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0f] range:NSMakeRange(0, tempString.length)];
                        [tempButton setAttributedTitle:tempAttributeString forState:UIControlStateNormal];
                        
                        if (isFinished) {
                            [tempButton setBackgroundColor:[UIColor grayColor]];
                        }else if (i == startDay) {
                            [tempButton setBackgroundColor:color];
                        }else{
                            [tempButton setBackgroundColor:[color colorWithAlphaComponent:0.6]];
                        }

                    }
                    
                    tempCurrentDate = [self.calendar dateByAddingComponents:addOneCompo toDate:tempCurrentDate options:0];
                }
            }
        }
    }
}

- (NSString *) getDateStringFromDate:(NSDate *)aDate{
    NSDateFormatter *tempFormatter = [NSDateFormatter new];
    [tempFormatter setDateFormat:@"yyyy-MM-dd"];
    return [tempFormatter stringFromDate:aDate];
}

- (void) updateLeftRightButton{
    NSDateComponents *tempCompo = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:self.calendarDate];
    int day = (int)tempCompo.day;
    tempCompo.day = tempCompo.day*-1;
//    NSDate *lastMonthDate = [[NSCalendar currentCalendar] dateByAddingComponents:tempCompo toDate:self.calendarDate options:0];
//    [self.calendarHolderView.leftButton setHidden:[lastMonthDate compare:self.todayDate] == NSOrderedAscending];
//    [self.calendarHolderView.leftImageView setHidden:[lastMonthDate compare:self.todayDate] == NSOrderedAscending];
    
    NSRange monthRange = [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self.calendarDate];
    tempCompo = [NSDateComponents new];
    tempCompo.day = monthRange.length - day + 1;
//    NSDate *nextMonthDate = [[NSCalendar currentCalendar] dateByAddingComponents:tempCompo toDate:self.calendarDate options:0];
//    [self.calendarHolderView.rightButton setHidden:[self.endDate compare:nextMonthDate] == NSOrderedAscending];
//    [self.calendarHolderView.rightImageView setHidden:[self.endDate compare:nextMonthDate] == NSOrderedAscending];
    
}

- (BOOL) dateWithinRange:(NSDate *)aCheckDate{
    return [aCheckDate compare:self.startDate] != NSOrderedAscending && [aCheckDate compare:self.endDate] != NSOrderedDescending;
}

- (void) CalendarHolderViewDidSelectedLeft{
    NSDateComponents *tempCompo = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:self.calendarDate];
    tempCompo.day = tempCompo.day*-1;
    self.calendarDate = [[NSCalendar currentCalendar] dateByAddingComponents:tempCompo toDate:self.calendarDate options:0];
    [self updateLeftRightButton];
    [self updateCalendar];
    [self updateCalendarBg];
    tempCompo = [self.calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit) fromDate:self.calendarDate];
    [self getActivityWithYear:(int)tempCompo.year WithMonth:(int)tempCompo.month];
    
//    [self isGoToSelectedMonth:[[NSCalendar currentCalendar] components:(NSYearCalendarUnit|NSMonthCalendarUnit) fromDate:self.calendarDate]];
}

- (void) CalendarHolderViewDidSelectedRight{
    NSDateComponents *tempCompo = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:self.calendarDate];
    int day = (int)tempCompo.day;
    NSRange monthRange = [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self.calendarDate];
    tempCompo = [NSDateComponents new];
    tempCompo.day = monthRange.length - day + 1;
    
    self.calendarDate = [[NSCalendar currentCalendar] dateByAddingComponents:tempCompo toDate:self.calendarDate options:0];
    [self updateLeftRightButton];
    [self updateCalendar];
    [self updateCalendarBg];
    tempCompo = [self.calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit) fromDate:self.calendarDate];
    [self getActivityWithYear:(int)tempCompo.year WithMonth:(int)tempCompo.month];
    
//    [self isGoToSelectedMonth:[[NSCalendar currentCalendar] components:(NSYearCalendarUnit|NSMonthCalendarUnit) fromDate:self.calendarDate]];
}



@end
