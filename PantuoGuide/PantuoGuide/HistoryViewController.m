//
//  HistoryViewController.m
//  PantuoGuide
//
//  Created by Leung Shun Kan on 7/9/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryTableViewCell.h"
#import "PreviewViewController.h"
#import "AddActivityViewController.h"
#import "HistorySearchViewController.h"

@interface HistoryViewController () <HistoryTableViewCellDelegate>

@property (nonatomic, retain) NSMutableArray *historyArray;
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UILabel *endedActivityLabel;

@property (nonatomic, retain) IBOutlet UITableView *mTableView;

@end

@implementation HistoryViewController
- (NSString *) getTopBarTitle{
    return GetStringWithKey(@"profile_activity_record");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addTopBarTitleView];
    if (self.showSearch) {
        [self.topBarTitleView.eventButton setHidden:NO];
        [self.topBarTitleView.eventButton setBackgroundImage:[UIImage imageNamed:@"icon_search.png"] forState:UIControlStateNormal];
        [self.topBarTitleView.eventButton addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.historyArray = [NSMutableArray array];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    [self.headerView setBackgroundColor:ColorWithHexString(@"EEEFF1")];
    UILabel *tempLael = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH, 30)];
    [tempLael setFont:[UIFont systemFontOfSize:14.0f]];
    if (self.searchDict) {
        [tempLael setText:GetStringWithKey(@"history_result_title")];
    }else{
        [tempLael setText:GetStringWithKey(@"history_ended_activity")];
    }
    
    [self.headerView addSubview:tempLael];
    
    self.endedActivityLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH-16, 30)];
    [self.endedActivityLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.endedActivityLabel setTextAlignment:NSTextAlignmentRight];
    [self.headerView addSubview:self.endedActivityLabel];
    
    GuideInfo *tempInfo = [self getGuideInfo];
    NSMutableDictionary *para;
    if (self.searchDict) {
        para = [NSMutableDictionary dictionaryWithDictionary:self.searchDict];
    }else{
        para = [NSMutableDictionary dictionary];
    }
    [para setObject:tempInfo.token forKey:@"token"];
    [para setObject:tempInfo.guide_id forKey:@"guide_id"];
    [para setObject:@"0" forKey:@"status"];
    
    [self callIPOSCSLAPIWithLink:API_SEARCH_ACTIVITY WithParameter:[NSDictionary dictionaryWithDictionary:para]  WithGet:YES];
}

- (void) search{
    [self.navigationController pushViewController:[HistorySearchViewController new] animated:YES];
    
}

- (void) handleResponse:(id)response WithLink:(NSString *)aLink WithRequest:(NSDictionary *)aRequest{
    if ([aLink isEqualToString:API_SEARCH_ACTIVITY]) {
        self.historyArray = response;
        [self.endedActivityLabel setText:[NSString stringWithFormat:GetStringWithKey(@"history_total"),[self.historyArray count]]];
        [self.mTableView reloadData];
        NSString *message;
        if ([self.historyArray count] == 0) {
            if (self.searchDict) {
                message = GetStringWithKey(@"history_no_search_result");
            }else{
                message = GetStringWithKey(@"history_no_history");
            }
            UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:GetStringWithKey(@"confirm") otherButtonTitles:nil];
            [tempAlertView show];
        }
    }else if ([aLink isEqualToString:API_EXPORT_ACTIVITY]) {
        UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:GetStringWithKey(@"history_export_success") delegate:nil cancelButtonTitle:GetStringWithKey(@"confirm") otherButtonTitles:nil];
        [tempAlertView show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.historyArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HistoryTableViewCell *cell = (HistoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"HistoryTableViewCell"];
    if (!cell) {
        cell = (HistoryTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"HistoryTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *tempDict = [self.historyArray objectAtIndex:indexPath.row];
    ActivityStatus status = [self getActivityStatus:tempDict];
    
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
    
    if (status == ActivityStatusEnded) {
        [cell.eventButton setBackgroundColor:[UIColor grayColor]];
    }else if (status == ActivityStatusIncomplete) {
        [cell.eventButton setBackgroundColor:ColorWithHexString(RemoveColorSign([tempDict objectForKey:@"color"]))];
    }else if (status == ActivityStatusOnGoing) {
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
    tempFrame.size.width = cell.frame.size.width - tempFrame.origin.x - 8;
    [cell.titleLabel setFrame:tempFrame];
    [cell.titleLabel sizeToFit];
    if (cell.titleLabel.frame.origin.y + cell.titleLabel.frame.size.height >= 80) {
        [cell.titleLabel setFrame:tempFrame];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headerView;
}

#pragma mark - HistoryTableViewCellDelegate
- (void) HistoryTableViewCellDidSelectedExport:(HistoryTableViewCell *)aSelf{
    NSIndexPath *indexPath = [self.mTableView indexPathForCell:aSelf];
    NSDictionary *tempDict = [self.historyArray objectAtIndex:indexPath.row];
    NSString *activityID = [tempDict objectForKey:@"activity_id"];
    GuideInfo *tempInfo = [self getGuideInfo];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:
                          tempInfo.token,@"token",
                          tempInfo.guide_id,@"guide_id",
                          activityID,@"activity_id",
                          nil];
    [self callIPOSCSLAPIWithLink:API_EXPORT_ACTIVITY WithParameter:para WithGet:YES];
}

- (void) HistoryTableViewCellDidSelectedView:(HistoryTableViewCell *)aSelf{
    NSIndexPath *indexPath = [self.mTableView indexPathForCell:aSelf];
    NSDictionary *tempDict = [self.historyArray objectAtIndex:indexPath.row];
    PreviewViewController *vc = [PreviewViewController new];
    vc.showEdit = NO;
    vc.useMyActivityTitle = YES;
    vc.activityLink = [tempDict objectForKey:@"activity_link"];
    vc.activityId  = [tempDict objectForKey:@"activity_id"];
    vc.previewLink = [tempDict objectForKey:@"preview_link"];
    vc.activityTitle = [tempDict objectForKey:@"title"];
    NSString *link = [tempDict objectForKey:@"image1"];
    if ([link length] == 0) {
        link = [tempDict objectForKey:@"image2"];
        if ([link length] == 0) {
            link = [tempDict objectForKey:@"image3"];
        }
    }
    vc.activityImageLink = link;
    vc.activityDict = tempDict;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) HistoryTableViewCellDidSelectedAddSimilar:(HistoryTableViewCell *)aSelf{
    NSIndexPath *indexPath = [self.mTableView indexPathForCell:aSelf];
    NSDictionary *tempDict = [self.historyArray objectAtIndex:indexPath.row];
    AddActivityViewController *vc = [AddActivityViewController new];
    vc.activityDict = tempDict;
    vc.isCreateNewActivity = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
