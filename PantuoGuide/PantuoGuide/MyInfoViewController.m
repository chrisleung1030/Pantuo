//
//  MyInfoViewController.m
//  PantuoGuide
//
//  Created by Christopher Leung on 9/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "MyInfoViewController.h"
#import "ChangePasswordViewController.h"
#import "MyInfoDetailViewController.h"
#import "MyInfoTableViewCell.h"
#import "HistoryViewController.h"
#import "PointViewController.h"

@interface MyInfoViewController () <MyInfoTableViewCellDelegate>

@property (nonatomic, retain) IBOutlet UIImageView *profileImageView;
@property (nonatomic, retain) IBOutlet UILabel *nicknameTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *nicknameLabel;
@property (nonatomic, retain) IBOutlet UILabel *mobileTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *mobileLabel;

@property (nonatomic, retain) IBOutlet UITableView *mTableView;

@property (nonatomic, retain) IBOutlet UIButton *logoutButton;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic, retain) NSData *profileData;

@end

@implementation MyInfoViewController

- (NSString *) getTopBarTitle{
    return GetStringWithKey(@"my_info");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addTopBarTitleView];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height /2;
    self.profileImageView.layer.borderColor = ColorWithHexString(@"BABBBC").CGColor;
    self.profileImageView.layer.borderWidth = 1.0f;
    self.profileImageView.layer.masksToBounds = YES;
    
    
    [self.nicknameTitleLabel setText:GetStringWithKey(@"profile_name_title")];
    [self.mobileTitleLabel setText:GetStringWithKey(@"profile_mobile_title")];
    [self.logoutButton setTitle:GetStringWithKey(@"profile_logout") forState:UIControlStateNormal];
    
    [self setUpGuideInfo];
    [self getProfileImage];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    GuideInfo *guideInfo = [self getGuideInfo];
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 guideInfo.token,@"token",
                                 guideInfo.guide_id,@"guide_id",nil];
    
    [self callPantuoAPIWithLink:API_GET_GUIDE_INFO WithParameter:para];
}

- (IBAction)editProfileImage:(id)sender{
    [self showChooseImageActionSheet];
}

- (IBAction)logout:(id)sender{
    GuideInfo *tempInfo = [self getGuideInfo];
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:tempInfo.token,@"token",ROLE,@"role",nil];
    [self callPantuoAPIWithLink:API_LOGOUT WithParameter:para];
}

- (void) setUpGuideInfo{
    GuideInfo *tempInfo = [self getGuideInfo];
    [self.nicknameLabel setText:tempInfo.nickname];
    [self.mobileLabel setText:tempInfo.mobile];
}

- (void) getProfileImage{
    [self.activityIndicatorView startAnimating];
    GuideInfo *tempInfo = [self getGuideInfo];
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:tempInfo.profile_image] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.activityIndicatorView stopAnimating];
    }];
}

- (void) handleError:(NSString *)aError WithLink:(NSString *)aLink{
    if ([aLink isEqualToString:API_LOGOUT]) {
        [self setUserDefaultWithKey:KEY_GUIDE_INFO WithValue:NULL];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [super handleError:aError WithLink:aLink];
    }
}

- (void) handleResponse:(id)response WithLink:(NSString *)aLink WithRequest:(NSDictionary *)aRequest{
    if ([aLink isEqualToString:API_LOGOUT]) {
        [self setUserDefaultWithKey:KEY_GUIDE_INFO WithValue:NULL];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if ([aLink isEqualToString:API_UPDATE_GUIDE_IMAGE]){
        NSString *link = [response objectForKey:@"profile_image"];
        UIImage *tempImage = [UIImage imageWithData:self.profileData];
        [[SDImageCache sharedImageCache] storeImage:tempImage forKey:link];
        
        [self.profileImageView setImage:tempImage];
    }else if ([aLink isEqualToString:API_GET_GUIDE_INFO]){
        GuideInfo *guideInfo = [GuideInfo new];
        [guideInfo setUpGuideInfo:response];
        NSData *guideInfoEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:guideInfo];
        [self setUserDefaultWithKey:KEY_GUIDE_INFO WithValue:guideInfoEncodedObject];
        
        [self setUpGuideInfo];
        [self getProfileImage];
    }
}

#pragma mark - Image picker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:NULL];
    UIImage *tempImage = [info objectForKey:UIImagePickerControllerEditedImage];
    if (tempImage.size.width > 160 || tempImage.size.height > 160) {
        UIGraphicsBeginImageContext(CGSizeMake(160, 160*tempImage.size.height/tempImage.size.width));
        [tempImage drawInRect:CGRectMake(0,0,160,160*tempImage.size.height/tempImage.size.width)];
        tempImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    self.profileData = UIImageJPEGRepresentation(tempImage, 1.0f);
    NSString *strEncoded = [Base64 encode:self.profileData];
    
    GuideInfo *tempInfo = [self getGuideInfo];
    
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:
                          tempInfo.token,@"token",
                          tempInfo.guide_id,@"guide_id",
                          [UPLOAD_IMAGE_PREFIX stringByAppendingString:strEncoded],@"profile_image",nil];
    [self callPantuoAPIWithLink:API_UPDATE_GUIDE_IMAGE WithParameter:para];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyInfoTableViewCell *cell = (MyInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MyInfoTableViewCell"];
    if (!cell) {
        cell = (MyInfoTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"MyInfoTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.delegate = self;
    }
    
    if (indexPath.row == 4) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }

    GuideInfo *tempInfo = [self getGuideInfo];
    NSString *title = [NSString string];
    if (indexPath.row == 0) {
        title = [NSString stringWithFormat:@"%@%@",tempInfo.point_balance ,GetStringWithKey(@"points")];
    }else if (indexPath.row == 1){
        title = GetStringWithKey(@"profile_more_info");
    }else if (indexPath.row == 2){
        title = GetStringWithKey(@"profile_update_password");
    }else if (indexPath.row == 3){
        title = GetStringWithKey(@"profile_activity_record");
    }else if (indexPath.row == 4){
        title = GetStringWithKey(@"profile_add_to_calendar");
    }
    
    UIImage *tempImage;
    if (indexPath.row == 0) {
        tempImage = [UIImage imageNamed:@"icn_point.png"];
    }else if (indexPath.row == 1){
        tempImage = [UIImage imageNamed:@"icn_trainer_info.png"];
    }else if (indexPath.row == 2){
        tempImage = [UIImage imageNamed:@"icn_change_pw.png"];
    }else if (indexPath.row == 3){
        tempImage = [UIImage imageNamed:@"icn_event_history.png"];
    }else if (indexPath.row == 4){
        tempImage = [UIImage imageNamed:@"icn_sync.png"];
    }
    
    
    [cell.mTitleLabel setText:title];
    [cell.mIconImageView setImage:tempImage];
    [cell.mArrowImageView setHidden:indexPath.row==4];
    if (indexPath.row == 0) {
        [cell.mTitleLabel setTextColor:ColorWithHexString(@"4CAF50")];
    }else{
        [cell.mTitleLabel setTextColor:[UIColor blackColor]];
    }
    
    [cell.unfinishedButton setHidden:indexPath.row!=1||[tempInfo isGuideProfileCompleted]];
    [cell.onOffView setHidden:indexPath.row!=4];
    
    if (indexPath.row == 4){
        NSUserDefaults *tempDefault = [NSUserDefaults standardUserDefaults];
        BOOL calendar = [[tempDefault objectForKey:KEY_CALENDAR] boolValue];
        if (calendar) {
            [cell.onLabel setBackgroundColor:GREEN_PANTUO];
            [cell.onLabel setTextColor:[UIColor whiteColor]];
            [cell.offLabel setBackgroundColor:[UIColor lightGrayColor]];
            [cell.offLabel setTextColor:[UIColor blackColor]];
        }else{
            [cell.offLabel setBackgroundColor:GREEN_PANTUO];
            [cell.offLabel setTextColor:[UIColor whiteColor]];
            [cell.onLabel setBackgroundColor:[UIColor lightGrayColor]];
            [cell.onLabel setTextColor:[UIColor blackColor]];
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && ![self getGuideInfo].is_guide) {
        return 0;
    }else{
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0){
        [self.navigationController pushViewController:[PointViewController new] animated:YES];
    }else if (indexPath.row == 1){
        [self.navigationController pushViewController:[MyInfoDetailViewController new] animated:YES];
    }else if (indexPath.row == 2){
        [self.navigationController pushViewController:[ChangePasswordViewController new] animated:YES];
    }else if (indexPath.row == 3){
        HistoryViewController *vc = [HistoryViewController new];
        vc.showSearch = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - MyInfoTableViewCellDelegate
- (void) MyInfoTableViewCellDidSelectOnOff:(MyInfoTableViewCell *)aSelf{
    [self logEventWithId:GetStringWithKey(@"Tracking_my_info_add_to_calendar_id") WithLabel:GetStringWithKey(@"Tracking_my_info_add_to_calendar")];
    NSUserDefaults *tempDefault = [NSUserDefaults standardUserDefaults];
    BOOL calendar = [[tempDefault objectForKey:KEY_CALENDAR] boolValue];
    calendar = !calendar;
    [tempDefault setObject:[NSNumber numberWithBool:calendar] forKey:KEY_CALENDAR];
    [tempDefault synchronize];
    
    [self.mTableView reloadData];
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
