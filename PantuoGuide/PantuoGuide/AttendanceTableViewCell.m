//
//  AttendanceTableViewCell.m
//  PantuoGuide
//
//  Created by Christopher Leung on 28/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "AttendanceTableViewCell.h"
#import "LanguageManager.h"

@implementation AttendanceTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.restoreButton.layer setCornerRadius:8];
    [self.notCheckinButton.layer setCornerRadius:8];
    [self.haveCheckinButton.layer setCornerRadius:8];
    [self.notCheckinButton setTitle:GetStringWithKey(@"attendance_not_checkin") forState:UIControlStateNormal];
    [self.haveCheckinButton setTitle:GetStringWithKey(@"attendance_have_checkin") forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)call:(id)sender{
    if (self.delegate) {
        [self.delegate AttendanceTableViewCellDidCall:self];
    }
}

- (IBAction)deleteAction:(id)sender{
    if (self.delegate) {
        [self.delegate AttendanceTableViewCellDidDelete:self];
    }
}

- (IBAction)restore:(id)sender{
    if (self.delegate) {
        [self.delegate AttendanceTableViewCellDidRestore:self];
    }
}

- (IBAction)notcheckin:(id)sender{
    if (self.delegate) {
        [self.delegate AttendanceTableViewCellDidNotCheckin:self];
    }
}

@end
