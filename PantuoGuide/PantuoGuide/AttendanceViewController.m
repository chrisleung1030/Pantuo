//
//  AttendanceViewController.m
//  PantuoGuide
//
//  Created by Christopher Leung on 28/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "AttendanceViewController.h"
#import "AttendanceTableViewCell.h"
#import "EventTableViewCell.h"
#import "InputTextViewController.h"
#import "LandingViewController.h"
#import "QRCodeViewController.h"
#import "BrowserViewController.h"

@interface AttendanceViewController () <UITableViewDataSource, UITableViewDelegate, AttendanceTableViewCellDelegate, QRCodeViewControllerDelegate>

@property (nonatomic, retain) IBOutlet UIView *subInfoView;
@property (nonatomic, retain) IBOutlet UILabel *leftSubLabel;
@property (nonatomic, retain) IBOutlet UILabel *rightSubLabel;
@property (nonatomic, retain) IBOutlet UILabel *leftListTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *rightListTitleLabel;
@property (nonatomic, retain) IBOutlet UITableView *mTableView;
@property (nonatomic, retain) IBOutlet UIButton *actionButton;
@property (nonatomic, retain) IBOutlet UIImageView *greenTickImageView;

@property (nonatomic, retain) UIView *joinHeaderView;
@property (nonatomic, retain) UIView *unjoinHeaderView;

@property (nonatomic, retain) NSMutableArray *joinArray;
@property (nonatomic, retain) NSMutableArray *unjoinArray;
@property (nonatomic, retain) NSDictionary *attendance;

@property (nonatomic, retain) QRCodeViewController *qrcodevc;

@property (nonatomic, assign) BOOL departureAlert;
@property (nonatomic, assign) BOOL appearRefersh;

@end

@implementation AttendanceViewController

- (NSString *) getTopBarTitle{
    if (self.isTakeAttendance) {
        return GetStringWithKey(@"attendance");
    }else{
        return GetStringWithKey(@"my_activities");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addTopBarTitleView];
    [self.topBarTitleView.eventButton setHidden:NO];
    if (self.isTakeAttendance) {
        [self.topBarTitleView.eventButton setBackgroundImage:[UIImage imageNamed:@"icon_scanner.png"] forState:UIControlStateNormal];
    }else{
        [self.topBarTitleView.eventButton setBackgroundImage:[UIImage imageNamed:@"icon_export.png"] forState:UIControlStateNormal];
    }
    
    [self.topBarTitleView.eventButton addTarget:self action:@selector(eventDidSelected) forControlEvents:UIControlEventTouchUpInside];
    
    self.joinArray = [NSMutableArray array];
    self.unjoinArray = [NSMutableArray array];

    self.joinHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    [self.joinHeaderView setBackgroundColor:ColorWithHexString(@"4CAF50")];
    UILabel *tempLael = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH, 30)];
    [tempLael setFont:[UIFont systemFontOfSize:14.0f]];
    [tempLael setTextColor:[UIColor whiteColor]];
    [tempLael setText:GetStringWithKey(@"attendance_join_header")];
    [self.joinHeaderView addSubview:tempLael];
    
    self.unjoinHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    [self.unjoinHeaderView setBackgroundColor:ColorWithHexString(@"EEEFF1")];
    tempLael = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH, 30)];
    [tempLael setFont:[UIFont systemFontOfSize:14.0f]];
    [tempLael setText:GetStringWithKey(@"attendance_unjoin_header")];
    [self.unjoinHeaderView addSubview:tempLael];

    
    [self.leftSubLabel setFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, self.subInfoView.frame.size.height)];
    [self.rightSubLabel setFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, self.subInfoView.frame.size.height)];
    [self.rightSubLabel setTextColor:ColorWithHexString(@"4CAF50")];
    
    EventTableViewCell *cell = (EventTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"EventTableViewCell" owner:self options:nil] objectAtIndex:0];
    cell.arrowImageView.hidden = YES;
    cell.peopleButton.hidden = YES;
    cell.lineView.frame = CGRectMake(0, cell.lineView.frame.origin.y, SCREEN_WIDTH, 1);
    cell.frame = CGRectMake(0, 90, SCREEN_WIDTH, cell.frame.size.height);
    [self.view addSubview:cell];
    
    NSString *start = GetDateStringFromNormalFormat([self.activityDict objectForKey:@"start_date"],GetStringWithKey(@"date_format"));
    if ([[self.activityDict objectForKey:@"start_date"] isEqualToString:[self.activityDict objectForKey:@"end_date"]]) {
        cell.dateLabel.text = start;
    }else{
        NSString *end = GetDateStringFromNormalFormat([self.activityDict objectForKey:@"end_date"],GetStringWithKey(@"date_format"));
        cell.dateLabel.text = [NSString stringWithFormat:@"%@ - %@",start,end];
    }
    
    if ([[self.activityDict objectForKey:@"title"] length] == 0) {
        cell.titleLabel.text = GetStringWithKey(@"default_title");
    }else{
        cell.titleLabel.text = [self.activityDict objectForKey:@"title"];
    }
    
    NSString *color = RemoveColorSign([self.activityDict objectForKey:@"color"]);
    [cell.eventButton setBackgroundColor:ColorWithHexString(color)];
    [cell.eventButton setImage:nil forState:UIControlStateNormal];
    [cell.eventButton setTitle:[NSString string] forState:UIControlStateNormal];
    int type = [[self.activityDict objectForKey:@"type"] intValue];
    if (type > 0) {
        [cell.eventButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"calender_icon_%02d.png",type]] forState:UIControlStateNormal];
    }else if ([[self.activityDict objectForKey:@"other_type"] length] > 0){
        [cell.eventButton setTitle:[self.activityDict objectForKey:@"other_type"] forState:UIControlStateNormal];
    }else if ([self getActivityStatus:self.activityDict] == ActivityStatusEnded){
        [cell.eventButton setImage:[UIImage imageNamed:@"icn_grey_other.png"] forState:UIControlStateNormal];
    }else{
        [cell.eventButton setImage:[UIImage imageNamed:@"icn_event_green_26.png"] forState:UIControlStateNormal];
    }
    
    CGRect tempFrame = cell.dateLabel.frame;
    tempFrame.origin.y += tempFrame.size.height + 3;
    tempFrame.size.height = 70 - tempFrame.origin.y;
    [cell.titleLabel setFrame:tempFrame];
    [cell.titleLabel sizeToFit];
    if (cell.titleLabel.frame.size.height >= tempFrame.size.height) {
        [cell.titleLabel setFrame:tempFrame];
    }
    
    [self.leftListTitleLabel setText:GetStringWithKey(@"attendance_realname")];
    [self.rightListTitleLabel setText:GetStringWithKey(@"mobile_num")];
    
    GuideInfo *tempInfo = [self getGuideInfo];
    [self callIPOSCSLAPIWithLink:API_GET_ATTENDANCE
                  WithParameter:[NSDictionary dictionaryWithObjectsAndKeys:
                                 tempInfo.token,@"token",
                                 tempInfo.guide_id,@"guide_id",
                                 [self.activityDict objectForKey:@"activity_id"],@"activity_id",nil]
                         WithGet:YES];
    self.appearRefersh = NO;
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.appearRefersh) {
        if (self.isTakeAttendance && ![[self.activityDict objectForKey:@"is_departure"] boolValue]) {
            NSString *startDateString = [self.activityDict objectForKey:@"start_date"];
            NSString *startTimeString = [self.activityDict objectForKey:@"start_time"];
            
            NSDateFormatter *tempFormatter = [NSDateFormatter new];
            [tempFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSDate *tempDate = [tempFormatter dateFromString:[NSString stringWithFormat:@"%@ %@",startDateString,startTimeString]];
            
            NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:tempDate];
            float hour = interval/3600.0;
            if (hour >= 2) {
                GuideInfo *tempInfo = [self getGuideInfo];
                [self callIPOSCSLAPIWithLink:API_GET_ATTENDANCE
                               WithParameter:[NSDictionary dictionaryWithObjectsAndKeys:
                                              tempInfo.token,@"token",
                                              tempInfo.guide_id,@"guide_id",
                                              [self.activityDict objectForKey:@"activity_id"],@"activity_id",nil]
                                     WithGet:YES];
            }
        }
    }else{
        self.appearRefersh = YES;
    }
}

- (ActivityStatus) getActivityStatus:(NSDictionary *)aDict{
    ActivityStatus status;
    
    NSDateComponents *tempCompo = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
    NSString *today = [NSString stringWithFormat:@"%d-%02d-%02d",(int)tempCompo.year,(int)tempCompo.month,(int)tempCompo.day];
    if ([today compare:[aDict objectForKey:@"end_date"]] == NSOrderedDescending) {
        status = ActivityStatusEnded;
    }else if ([[aDict objectForKey:@"action"] isEqualToString:@"published"]) {
        status = ActivityStatusOnGoing;
    }else{
        status = ActivityStatusIncomplete;
    }
    return status;
}


- (BOOL) haveAttendance{
    BOOL hvAttend = NO;
    for (NSDictionary *tempDict in self.joinArray) {
        if ([[tempDict objectForKey:@"is_attend"] boolValue]){
            hvAttend = YES;
            break;
        }
    }
    return hvAttend;
}

- (void) setUpActionButton{
    if (self.isTakeAttendance) {
        if ([[self.activityDict objectForKey:@"is_departure"] boolValue]) {
            [self.actionButton setTitle:GetStringWithKey(@"started_trip") forState:UIControlStateNormal];
            [self.actionButton setBackgroundImage:[UIImage imageNamed:@"disable_btn.png"] forState:UIControlStateNormal];
        }else{
            [self.actionButton setTitle:GetStringWithKey(@"start_trip") forState:UIControlStateNormal];
            if ([self haveAttendance]) {
                [self.actionButton setBackgroundImage:[UIImage imageNamed:@"action_btn.png"] forState:UIControlStateNormal];
                [self.actionButton setEnabled:YES];
            }else{
                [self.actionButton setBackgroundImage:[UIImage imageNamed:@"disable_btn.png"] forState:UIControlStateNormal];
                [self.actionButton setEnabled:NO];
            }
        }
    }else{
        if ([self.joinArray count] == 0){
            [self.actionButton setBackgroundImage:[UIImage imageNamed:@"disable_btn.png"] forState:UIControlStateNormal];
            [self.actionButton setEnabled:NO];
        }else{
            [self.actionButton setBackgroundImage:[UIImage imageNamed:@"action_btn.png"] forState:UIControlStateNormal];
            [self.actionButton setEnabled:YES];
        }
        [self.actionButton setTitle:GetStringWithKey(@"attendance_send_sms") forState:UIControlStateNormal];
    }
}

- (void) eventDidSelected{
    if (self.isTakeAttendance) {
        [self removeQRCodeVC];
        self.qrcodevc = [QRCodeViewController new];
        self.qrcodevc.delegate = self;
        [self.navigationController pushViewController:self.qrcodevc animated:YES];
    }else{
        GuideInfo *tempInfo = [self getGuideInfo];
        NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:
                              tempInfo.token,@"token",
                              tempInfo.guide_id,@"guide_id",
                              [self.activityDict objectForKey:@"activity_id"],@"activity_id",
                              nil];
        [self callIPOSCSLAPIWithLink:API_EXPORT_ACTIVITY WithParameter:para WithGet:YES];
    }
}

- (void) handleResponse:(id)response WithLink:(NSString *)aLink WithRequest:(NSDictionary *)aRequest{
    if ([aLink isEqualToString:API_GET_ATTENDANCE]) {
        [self.joinArray removeAllObjects];
        [self.unjoinArray removeAllObjects];
        for (NSDictionary *tempDict in (NSArray *)response) {
            if ([[tempDict objectForKey:@"is_removed"] boolValue]) {
                [self.unjoinArray addObject:tempDict];
            }else{
                [self.joinArray addObject:tempDict];
            }
        }
        
        if ([self.joinArray count] > 0) {
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"join_date" ascending:NO];
            NSArray *sortedArray = [self.joinArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
            self.joinArray = [NSMutableArray arrayWithArray:sortedArray];
        }
        
        if ([self.unjoinArray count] > 0) {
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"join_date" ascending:NO];
            NSArray *sortedArray = [self.unjoinArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
            self.unjoinArray = [NSMutableArray arrayWithArray:sortedArray];
        }
        
        [self setUpActionButton];
        [self.mTableView reloadData];
        
        if (self.isTakeAttendance) {
            [self.leftSubLabel setText:[NSString stringWithFormat:GetStringWithKey(@"attendance_joined_people"),[self.joinArray count]]];
            int count = 0;
            for (NSDictionary *tempDict in self.joinArray) {
                if ([[tempDict objectForKey:@"is_attend"] boolValue]) {
                    count ++;
                }
            }
            [self.rightSubLabel setText:[NSString stringWithFormat:GetStringWithKey(@"attendance_arrived_people"),count]];
            [self.greenTickImageView setHidden:NO];
            
            [self.leftSubLabel setFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 50)];
            [self.leftSubLabel sizeToFit];
            [self.rightSubLabel setFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 50)];
            [self.rightSubLabel sizeToFit];
            
            CGRect tempFrame = self.leftSubLabel.frame;
            tempFrame.origin.x = (SCREEN_WIDTH/2 - tempFrame.size.width)/2;
            tempFrame.origin.y = (50 - tempFrame.size.height)/2;
            [self.leftSubLabel setFrame:tempFrame];
            
            tempFrame = self.rightSubLabel.frame;
            tempFrame.origin.x = (SCREEN_WIDTH/2 - tempFrame.size.width - self.greenTickImageView.frame.size.width)/2 + self.greenTickImageView.frame.size.width + SCREEN_WIDTH/2 + 5;
            tempFrame.origin.y = (50 - tempFrame.size.height)/2;
            [self.rightSubLabel setFrame:tempFrame];
            
            tempFrame = self.greenTickImageView.frame;
            tempFrame.origin.x = self.rightSubLabel.frame.origin.x - self.greenTickImageView.frame.size.width - 5;
            tempFrame.origin.y = (50 - tempFrame.size.height)/2;
            [self.greenTickImageView setFrame:tempFrame];
        }else{
            if ([[self.activityDict objectForKey:@"unlimit_ppl"] boolValue]) {
                [self.leftSubLabel setText:GetStringWithKey(@"participation_unlimit")];
            }else{
                [self.leftSubLabel setText:[NSString stringWithFormat:GetStringWithKey(@"attendance_number_of_people"),[[self.activityDict objectForKey:@"max_ppl"] intValue]]];
            }
            [self.rightSubLabel setText:[NSString stringWithFormat:GetStringWithKey(@"attendance_already_joined_people"),[self.joinArray count]]];
        }
    }else if ([aLink isEqualToString:API_EXPORT_ACTIVITY]){
        UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:GetStringWithKey(@"history_export_success") delegate:nil cancelButtonTitle:GetStringWithKey(@"confirm") otherButtonTitles:nil];
        [tempAlertView show];
    }else{
        if ([aLink isEqualToString:API_TAKE_ATTENDANCE_QRCODE]){
            UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:GetStringWithKey(@"attendance_checkin_success") delegate:nil cancelButtonTitle:GetStringWithKey(@"confirm") otherButtonTitles:nil];
            [tempAlertView show];
        }else if ([aLink isEqualToString:API_ACTIVITY_DEPARTURE]){
            if (self.departureAlert) {
                UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:GetStringWithKey(@"attendance_departure") delegate:nil cancelButtonTitle:GetStringWithKey(@"confirm") otherButtonTitles:nil];
                [tempAlertView setTag:1];
                [tempAlertView show];
            }
            ((LandingViewController *)[self.navigationController.viewControllers objectAtIndex:1]).refreshView = YES;
            NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:self.activityDict];
            [tempDict setObject:[NSNumber numberWithBool:YES] forKey:@"is_departure"];
            self.activityDict = [NSDictionary dictionaryWithDictionary:tempDict];
        }

        GuideInfo *tempInfo = [self getGuideInfo];
        [self callIPOSCSLAPIWithLink:API_GET_ATTENDANCE
                       WithParameter:[NSDictionary dictionaryWithObjectsAndKeys:
                                      tempInfo.token,@"token",
                                      tempInfo.guide_id,@"guide_id",
                                      [self.activityDict objectForKey:@"activity_id"],@"activity_id",nil]
                             WithGet:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc{
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

#pragma mark - AttendanceTableViewCellDelegate
- (void) AttendanceTableViewCellDidCall:(AttendanceTableViewCell *)aCell{
    NSIndexPath *indexPath = [self.mTableView indexPathForCell:aCell];
    NSMutableArray *tempArray;
    if (indexPath.section == 0) {
        tempArray = self.joinArray;
    }else{
        tempArray = self.unjoinArray;
    }
    NSDictionary *tempDict = [tempArray objectAtIndex:indexPath.row];
    if ([[tempDict objectForKey:@"mobile"] length] > 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[tempDict objectForKey:@"mobile"]]]];
    }
}

- (void) AttendanceTableViewCellDidDelete:(AttendanceTableViewCell *)aCell{
    NSIndexPath *indexPath = [self.mTableView indexPathForCell:aCell];
    NSMutableArray *tempArray;
    if (indexPath.section == 0) {
        tempArray = self.joinArray;
    }else{
        tempArray = self.unjoinArray;
    }
    NSDictionary *tempDict = [tempArray objectAtIndex:indexPath.row];
    self.attendance = tempDict;
    UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:GetStringWithKey(@"attendance_remove_message") delegate:self cancelButtonTitle:GetStringWithKey(@"quit_app_neg") otherButtonTitles:GetStringWithKey(@"quit_app_pos"), nil];
    [tempAlertView setTag:2];
    [tempAlertView show];
}

- (void) AttendanceTableViewCellDidRestore:(AttendanceTableViewCell *)aCell{
    NSIndexPath *indexPath = [self.mTableView indexPathForCell:aCell];
    if (indexPath.row < [self.unjoinArray count]) {
        NSDictionary *tempDict = [self.unjoinArray objectAtIndex:indexPath.row];
        self.attendance = tempDict;
        UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:GetStringWithKey(@"attendance_restore_message") delegate:self cancelButtonTitle:GetStringWithKey(@"quit_app_neg") otherButtonTitles:GetStringWithKey(@"quit_app_pos"), nil];
        [tempAlertView setTag:3];
        [tempAlertView show];
    }
}

- (void) AttendanceTableViewCellDidNotCheckin:(AttendanceTableViewCell *)aCell{
    // Phase 1
//    NSIndexPath *indexPath = [self.mTableView indexPathForCell:aCell];
//    NSMutableArray *tempArray;
//    if (indexPath.section == 0) {
//        tempArray = self.joinArray;
//    }else{
//        tempArray = self.unjoinArray;
//    }
//    NSDictionary *tempDict = [tempArray objectAtIndex:indexPath.row];
//    self.attendance = tempDict;
//    GuideInfo *tempInfo = [self getGuideInfo];
//    if (![[self.activityDict objectForKey:@"is_departure"] boolValue]) {
//        NSString *link;
//        if ([[tempDict objectForKey:@"is_attend"] boolValue]) {
//            link = API_REMOVE_ATTENDANCE;
//        }else{
//            link = API_TAKE_ATTENDANCE;
//        }
//        NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:
//                              tempInfo.token,@"token",
//                              tempInfo.guide_id,@"guide_id",
//                              [self.activityDict objectForKey:@"activity_id"],@"activity_id",
//                              [tempDict objectForKey:@"user_id"],@"user_id",nil];
//        [self callIPOSCSLAPIWithLink:link
//                       WithParameter:para
//                             WithGet:NO];
//    }

    // Phase 2
//    NSIndexPath *indexPath = [self.mTableView indexPathForCell:aCell];
//    NSMutableArray *tempArray;
//    if (indexPath.section == 0) {
//        tempArray = self.joinArray;
//    }else{
//        tempArray = self.unjoinArray;
//    }
//    NSDictionary *tempDict = [tempArray objectAtIndex:indexPath.row];
//    self.attendance = tempDict;
}

- (IBAction)action:(id)sender{
    if (self.isTakeAttendance) {
        [self logEventWithId:GetStringWithKey(@"Tracking_take_attendance_start_trip_id") WithLabel:GetStringWithKey(@"Tracking_take_attendance_start_trip")];
        [self doDepartureWithAlert:YES WithCheckAttendance:YES];
    }else if ([self.joinArray count] > 0) {
        [self logEventWithId:GetStringWithKey(@"Tracking_view_attendance_send_id") WithLabel:GetStringWithKey(@"Tracking_view_attendance_send")];
        InputTextViewController *vc = [InputTextViewController new];
        vc.maxCount = 30;
        vc.titleText = GetStringWithKey(@"attendance_send_sms_short");
        vc.isSendSMS = YES;
        vc.activityId = [self.activityDict objectForKey:@"activity_id"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void) doDepartureWithAlert:(BOOL)aDepartureAlert WithCheckAttendance:(BOOL)aCheckAttendance{
    if (![[self.activityDict objectForKey:@"is_departure"] boolValue]) {
        BOOL callAPI = YES;
        if (aCheckAttendance && ![self haveAttendance]) {
            callAPI = NO;
        }
        if (callAPI) {
            self.departureAlert = aDepartureAlert;
            GuideInfo *tempInfo = [self getGuideInfo];
            [self callIPOSCSLAPIWithLink:API_ACTIVITY_DEPARTURE
                           WithParameter:[NSDictionary dictionaryWithObjectsAndKeys:
                                          tempInfo.token,@"token",
                                          tempInfo.guide_id,@"guide_id",
                                          [self.activityDict objectForKey:@"activity_id"],@"activity_id",nil]
                                 WithGet:NO];
        }
    }
}

#pragma mark - QRCodeViewControllerDelegate
- (void) QRCodeViewControllerDidCheckinWitheCode:(NSString *)aCode{
    
    if ([aCode hasPrefix:@"http://"] || [aCode hasPrefix:@"https://"]){
        BrowserViewController *b = [BrowserViewController new];
        b.link = aCode;
        [self.navigationController pushViewController:b animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        if ([[self.activityDict objectForKey:@"is_departure"] boolValue]) {
            UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:GetStringWithKey(@"attendance_cannot_take_attendance") message:[NSString string] delegate:nil cancelButtonTitle:GetStringWithKey(@"confirm") otherButtonTitles:nil];
            [tempAlertView show];
        }else{
            GuideInfo *tempInfo = [self getGuideInfo];
            NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:
                                  tempInfo.token,@"token",
                                  tempInfo.guide_id,@"guide_id",
                                  [self.activityDict objectForKey:@"activity_id"],@"activity_id",
                                  aCode,@"qrcode",nil];
            
            [self callIPOSCSLAPIWithLink:API_TAKE_ATTENDANCE_QRCODE
                           WithParameter:para
                                 WithGet:NO];
        }
        [self removeQRCodeVC];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    int tag = (int)[alertView tag];
    if (tag == 1) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }else if (tag == 2){
        if (buttonIndex == 1) {
            GuideInfo *tempInfo = [self getGuideInfo];
            [self callIPOSCSLAPIWithLink:API_REMOVE_USER
                          WithParameter:[NSDictionary dictionaryWithObjectsAndKeys:
                                         tempInfo.token,@"token",
                                         tempInfo.guide_id,@"guide_id",
                                         [self.activityDict objectForKey:@"activity_id"],@"activity_id",
                                         [self.attendance objectForKey:@"user_id"],@"user_id", nil]
                                 WithGet:NO];
        }
    }else if (tag == 3){
        if (buttonIndex == 1) {
            GuideInfo *tempInfo = [self getGuideInfo];
            
            NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:
                                  tempInfo.token,@"token",
                                  tempInfo.guide_id,@"guide_id",
                                  [self.activityDict objectForKey:@"activity_id"],@"activity_id",
                                  [self.attendance objectForKey:@"user_id"],@"user_id",nil];
            [self callIPOSCSLAPIWithLink:API_RESTORE_USER
                           WithParameter:para
                                 WithGet:NO];
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [self.joinArray count];
    }else{
        return [self.unjoinArray count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AttendanceTableViewCell *cell = (AttendanceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AttendanceTableViewCell"];
    if (!cell) {
        cell = (AttendanceTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"AttendanceTableViewCell" owner:self options:nil] objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.delegate = self;
    }
    
    NSDictionary *tempDict;
    if (indexPath.section == 0) {
        tempDict = [self.joinArray objectAtIndex:(int)indexPath.row];
        if (self.isTakeAttendance) {
            [cell.deleteButton setHidden:YES];
            [cell.deleteImageView setHidden:YES];
            
            if (self.isTakeAttendance) {
                if ([[tempDict objectForKey:@"is_attend"] boolValue]){
                    [cell.notCheckinButton setHidden:YES];
                    [cell.haveCheckinButton setHidden:NO];
                }else{
                    [cell.notCheckinButton setHidden:NO];
                    [cell.haveCheckinButton setHidden:YES];
                }
            }
        }else{
            [cell.deleteButton setHidden:NO];
            [cell.deleteImageView setHidden:NO];
            [cell.notCheckinButton setHidden:YES];
            [cell.haveCheckinButton setHidden:YES];
        }
        
        [cell.restoreButton setHidden:YES];
    }else{
        tempDict = [self.unjoinArray objectAtIndex:(int)indexPath.row];
        [cell.deleteButton setHidden:YES];
        [cell.deleteImageView setHidden:YES];
        [cell.restoreButton setHidden:self.isTakeAttendance];
        [cell.notCheckinButton setHidden:YES];
        [cell.haveCheckinButton setHidden:YES];
    }
    
    [cell.nameLabel setText:[tempDict objectForKey:@"nickname"]];
    [cell.phoneLabel setText:[tempDict objectForKey:@"mobile"]];
    NSString *realName = [tempDict objectForKey:@"name"];
    if (isStringEmpty(realName)) {
        realName = @"--";
    }
    [cell.realameLabel setText:realName];
    [cell.callButton setTag:indexPath.row];
    [cell.deleteButton setTag:indexPath.row];
    
    if ([[tempDict objectForKey:@"gender"] isEqualToString:@"M"]) {
        [cell.genderImageView setImage:[UIImage imageNamed:@"icon_male.png"]];
    }else if ([[tempDict objectForKey:@"gender"] isEqualToString:@"F"]) {
        [cell.genderImageView setImage:[UIImage imageNamed:@"icon_female.png"]];
    }else{
        [cell.genderImageView setImage:[UIImage imageNamed:@"sex_none.png"]];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if ([self.joinArray count] > 0) {
            return 30;
        }else{
            return 0;
        }
    }else{
        if ([self.unjoinArray count] > 0) {
            return 30;
        }else{
            return 0;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return self.joinHeaderView;
    }else{
        return self.unjoinHeaderView;
    }
}

@end
