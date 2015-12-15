//
//  AttendanceTableViewCell.h
//  PantuoGuide
//
//  Created by Christopher Leung on 28/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AttendanceTableViewCellDelegate;

@interface AttendanceTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *realameLabel;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *phoneLabel;
@property (nonatomic, retain) IBOutlet UIButton *callButton;
@property (nonatomic, retain) IBOutlet UIButton *deleteButton;
@property (nonatomic, retain) IBOutlet UIImageView *deleteImageView;
@property (nonatomic, retain) IBOutlet UIImageView *genderImageView;
@property (nonatomic, retain) IBOutlet UIButton *restoreButton;
@property (nonatomic, retain) IBOutlet UIButton *notCheckinButton;
@property (nonatomic, retain) IBOutlet UIButton *haveCheckinButton;
@property (nonatomic, assign) id<AttendanceTableViewCellDelegate> delegate;

- (IBAction)call:(id)sender;
- (IBAction)deleteAction:(id)sender;
- (IBAction)restore:(id)sender;
- (IBAction)notcheckin:(id)sender;

@end

@protocol AttendanceTableViewCellDelegate <NSObject>

- (void) AttendanceTableViewCellDidCall:(AttendanceTableViewCell *)aCell;
- (void) AttendanceTableViewCellDidDelete:(AttendanceTableViewCell *)aCell;
- (void) AttendanceTableViewCellDidRestore:(AttendanceTableViewCell *)aCell;
- (void) AttendanceTableViewCellDidNotCheckin:(AttendanceTableViewCell *)aCell;

@end
