//
//  PointViewController.h
//  PantuoGuide
//
//  Created by Leung Shun Kan on 7/9/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface PointViewController : BaseViewController

@property (nonatomic, retain) IBOutlet UILabel *pointsTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *pointsLabel;
@property (nonatomic, retain) IBOutlet UITextField *searchTextField;
@property (nonatomic, retain) IBOutlet UITableView *mTableView;

- (IBAction)searchDidSelected:(id)sender;

@end
