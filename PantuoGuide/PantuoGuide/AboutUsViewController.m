//
//  AboutUsViewController.m
//  PantuoGuide
//
//  Created by Christopher Leung on 9/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "AboutUsViewController.h"
#import "WebViewController.h"
#import "CommentViewController.h"
#import "AboutUsTableViewCell.h"
#import "AppDelegate.h"

@interface AboutUsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UILabel *appLabel;
@property (nonatomic, retain) IBOutlet UITableView *mTableView;
@property (nonatomic, retain) UILabel *aboutContentLabel;

@end

@implementation AboutUsViewController

- (NSString *) getTopBarTitle{
    return GetStringWithKey(@"about_us");
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addTopBarTitleView];
    // Do any additional setup after loading the view from its nib.
    
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
//    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];

    [self.appLabel setText:[NSString stringWithFormat:@"v%@%@",appVersion,PROGRAM_CONFIG]];
    
    self.aboutContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH-15, 10000)];
    [self.aboutContentLabel setBackgroundColor:[UIColor clearColor]];
    [self.aboutContentLabel setTextColor:[UIColor blackColor]];
    [self.aboutContentLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.aboutContentLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.aboutContentLabel setNumberOfLines:0];
    
    [self callIPOSCSLAPIWithLink:API_ABOUT_US WithParameter:nil WithGet:YES];
}

- (IBAction)showDeviceId:(id)sender{
//    NSString *udid = GetUserID();
//    
//    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//    pasteboard.string = udid;
//    
//    NSString *message = [NSString stringWithFormat:@"Device id:%@ copied.",udid];
//    UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [tempAlertView show];
}

- (void) handleResponse:(id)response WithLink:(NSString *)aLink WithRequest:(NSDictionary *)aRequest{
    NSString *title = [response objectForKey:@"title"];
    NSString *content = [response objectForKey:@"content"];
    [self.aboutContentLabel setText:[NSString stringWithFormat:@"%@\n\n%@",title,content]];
    [self.aboutContentLabel sizeToFit];
    
    [self.mTableView setTableFooterView:self.aboutContentLabel];
    [self.mTableView reloadData];
    
//    int maxHeight = SCREEN_HEIGHT - self.aboutContentLabel.frame.origin.y;
//    if (self.aboutContentLabel.frame.size.height > maxHeight) {
//        CGRect tempFrame = self.aboutContentLabel.frame;
//        tempFrame.size.height = maxHeight;
//        [self.aboutContentLabel setAdjustsFontSizeToFitWidth:YES];
//    }
//    [self.mScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.aboutContentLabel.frame.origin.y + self.aboutContentLabel.frame.size.height + 8)];
}

- (IBAction)review:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:API_APP_UPDATE]];
}

- (IBAction)comment:(id)sender{
    [self.navigationController pushViewController:[CommentViewController new] animated:YES];
}

- (IBAction)about:(id)sender{
//    WebViewController *vc = [WebViewController new];
//    vc.title = GetStringWithKey(@"about_company");
//    vc.link = ABOUT_US;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)version:(id)sender{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate checkVersionWithShowAlreadyUpdateAlert:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:API_APP_UPDATE]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AboutUsTableViewCell *cell = (AboutUsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AboutUsTableViewCell"];
    if (!cell) {
        cell = (AboutUsTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"AboutUsTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    NSString *title = [NSString string];
    if (indexPath.row == 0) {
        title = GetStringWithKey(@"rate_us");
    }else if (indexPath.row == 1){
        title = GetStringWithKey(@"write_comment_title");
    }else if (indexPath.row == 2){
        title = GetStringWithKey(@"");
    }
    
    UIImage *tempImage;
    if (indexPath.row == 0) {
        tempImage = [UIImage imageNamed:@"icn_rating.png"];
    }else if (indexPath.row == 1){
        tempImage = [UIImage imageNamed:@"icn_opinion.png"];
    }else if (indexPath.row == 2){
//        tempImage = [UIImage imageNamed:@""];
    }
    
    [cell.upperLineView setHidden:indexPath.row >0];
    [cell.mTitleLabel setText:title];
    [cell.mIconImageView setImage:tempImage];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self review:nil];
    }else if (indexPath.row == 1){
        [self comment:nil];
    }else if (indexPath.row == 2){
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
