//
//  MyInfoTableViewCell.m
//  PantuoGuide
//
//  Created by Leung Shun Kan on 7/9/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "MyInfoTableViewCell.h"

@implementation MyInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.unfinishedButton.layer setCornerRadius:8];
    [self.unfinishedButton setAdjustsImageWhenHighlighted:NO];
    [self.onOffView.layer setCornerRadius:8];

}

- (IBAction)calendarDidSelectd:(id)sender{
    [self.delegate MyInfoTableViewCellDidSelectOnOff:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
