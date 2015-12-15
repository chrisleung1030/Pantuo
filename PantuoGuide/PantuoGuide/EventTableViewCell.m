//
//  EventTableViewCell.m
//  PantuoGuide
//
//  Created by Christopher Leung on 15/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "EventTableViewCell.h"

@implementation EventTableViewCell
@synthesize delegate;

- (void)awakeFromNib {
    // Initialization code
    [self.peopleButton.layer setCornerRadius:8];
    [self.notFinishButton.layer setCornerRadius:8];
    [self.notReleaseButton.layer setCornerRadius:8];
    [self.finishButton.layer setCornerRadius:8];
    [self.eventButton.layer setCornerRadius:self.eventButton.frame.size.width/2];
    [self.eventButton.titleLabel setNumberOfLines:2];
    [self.eventButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self.notFinishButton setAdjustsImageWhenDisabled:NO];
    [self.notReleaseButton setAdjustsImageWhenDisabled:NO];
    [self.finishButton setAdjustsImageWhenHighlighted:NO];
}

- (IBAction)people:(id)sender{
    if (self.delegate) {
        [self.delegate EventTableViewCellDidSelectPeople:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
