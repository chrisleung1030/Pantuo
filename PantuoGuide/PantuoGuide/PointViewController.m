//
//  PointViewController.m
//  PantuoGuide
//
//  Created by Leung Shun Kan on 7/9/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "PointViewController.h"
#import "PointTableViewCell.h"

@interface PointViewController () <UITableViewDataSource, UITabBarDelegate, UITextFieldDelegate>

@property (nonatomic, retain) NSMutableArray *pointsArray;
@property (nonatomic, retain) NSArray *filteredArray;
@property (nonatomic, retain) UIView *tableHeaderView;
@property (nonatomic, retain) UILabel *descriptionLabel;
@property (nonatomic, assign) int page;

@end

@implementation PointViewController

- (NSString *) getTopBarTitle{
    return GetStringWithKey(@"points_title");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addTopBarTitleView];
    self.pointsArray = [NSMutableArray array];
    self.filteredArray = [NSArray array];
    
    [self.pointsTitleLabel setText:GetStringWithKey(@"points_current")];
    [self.searchTextField setPlaceholder:GetStringWithKey(@"points_enter_keyword")];
    
    self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    [self.tableHeaderView setBackgroundColor:ColorWithHexString(@"4CAF50")];
    UILabel *tempLael = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH, 30)];
    [tempLael setFont:[UIFont systemFontOfSize:14.0f]];
    [tempLael setTextColor:[UIColor whiteColor]];
    [tempLael setText:GetStringWithKey(@"points_header_title")];
    [self.tableHeaderView addSubview:tempLael];
    
    self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 31, SCREEN_WIDTH-16, 10000)];
    [self.descriptionLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.descriptionLabel setNumberOfLines:0];
    [self.descriptionLabel setLineBreakMode:NSLineBreakByWordWrapping];
    
    self.page = 1;
    [self getPointsDetail:self.page];
}

- (IBAction)searchDidSelected:(id)sender{
    [self search];
}

- (void) search{
    if (!self.searchTextField.markedTextRange) {
        if (self.searchTextField.text.length == 0) {
            self.filteredArray = [NSArray arrayWithArray:self.pointsArray];
        }else{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"description contains[c] %@",self.searchTextField.text];
            self.filteredArray = [self.pointsArray filteredArrayUsingPredicate:predicate];
        }
        [self.mTableView reloadData];
        if ([self.filteredArray count] == 0) {
            [self performSelector:@selector(showNoResultAlert) withObject:nil afterDelay:0.5];
        }
    }
}

- (void) showNoResultAlert{
    UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:GetStringWithKey(@"poins_no_result") delegate:nil cancelButtonTitle:GetStringWithKey(@"confirm") otherButtonTitles:nil];
    [tempAlertView show];
}

- (void) getPointsDetail:(int)aPage{
    GuideInfo *tempInfo = [self getGuideInfo];
    NSMutableDictionary *aDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           tempInfo.token,@"token",
                           @"1",@"page",
                           @"100",@"items",nil];
    if (tempInfo.is_guide) {
        [aDict setObject:tempInfo.guide_id forKey:@"guide_id"];
    }else{
        [aDict setObject:tempInfo.member_id forKey:@"member_id"];
    }
    [self callPantuoAPIWithLink:API_GET_POINTS_DETAIL WithParameter:[NSDictionary dictionaryWithDictionary:aDict]];
}

- (void) handleResponse:(id)response WithLink:(NSString *)aLink WithRequest:(NSDictionary *)aRequest{
    NSArray *tempArray = [response objectForKey:@"list"];
    [self.pointsArray addObjectsFromArray:tempArray];
    if ([tempArray count] == 100) {
        self.page++;
        [self getPointsDetail:self.page];
    }else{
        [self.pointsLabel setText:[[response objectForKey:@"total_point"] stringByAppendingString:GetStringWithKey(@"points")]];
        self.filteredArray = [NSArray arrayWithArray:self.pointsArray];
        [self.mTableView reloadData];
        if ([self.pointsArray count] == 0) {
            UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:GetStringWithKey(@"poins_no_point") delegate:nil cancelButtonTitle:GetStringWithKey(@"confirm") otherButtonTitles:nil];
            [tempAlertView show];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.searchTextField resignFirstResponder];
    [self performSelector:@selector(search) withObject:nil afterDelay:0.5];
    return YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.filteredArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PointTableViewCell *cell = (PointTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PointTableViewCell"];
    if (!cell) {
        cell = (PointTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"PointTableViewCell" owner:self options:nil] objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    NSDictionary *tempDict = [self.filteredArray objectAtIndex:indexPath.row];
    [cell.dateLabel setText:[tempDict objectForKey:@"created_at"]];
    [cell.descriptionLabel setText:[tempDict objectForKey:@"description"]];
    [cell.pointLabel setText:[NSString stringWithFormat:@"%d",[[tempDict objectForKey:@"point"] intValue]]];
    
    BOOL isAward = [[tempDict objectForKey:@"is_award"] boolValue];
    if (isAward) {
        [cell.upDownImageView setImage:[UIImage imageNamed:@"icon_add.png"]];
    }else{
        [cell.upDownImageView setImage:[UIImage imageNamed:@"icon_subtract.png"]];
    }
    
    [cell.descriptionLabel setFrame:CGRectMake(8, 31, SCREEN_WIDTH-16, 10000)];
    [cell.descriptionLabel sizeToFit];
    
    CGRect tempFrame = cell.frame;
    tempFrame.size.height = cell.descriptionLabel.frame.origin.y + cell.descriptionLabel.frame.size.height + 5;
    [cell setFrame:tempFrame];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *tempDict = [self.filteredArray objectAtIndex:indexPath.row];
    [self.descriptionLabel setFrame:CGRectMake(8, 31, SCREEN_WIDTH-16, 10000)];
    [self.descriptionLabel setText:[tempDict objectForKey:@"description"]];
    [self.descriptionLabel sizeToFit];
    CGRect tempFrame = self.descriptionLabel.frame;
    float height = tempFrame.origin.y + tempFrame.size.height+5;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.tableHeaderView;
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
