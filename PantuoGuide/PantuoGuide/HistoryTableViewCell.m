
//
//  HistoryTableViewCell.m
//  PantuoGuide
//
//  Created by Leung Shun Kan on 7/9/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "HistoryTableViewCell.h"
#import "LanguageManager.h"

@implementation HistoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.exportButton.layer setCornerRadius:8];
    [self.viewButton.layer setCornerRadius:8];
    [self.addSimilarButton.layer setCornerRadius:8];
    
    [self.exportButton setTitle:GetStringWithKey(@"history_export_attendance") forState:UIControlStateNormal];
    [self.viewButton setTitle:GetStringWithKey(@"history_view_activity") forState:UIControlStateNormal];
    [self.addSimilarButton setTitle:GetStringWithKey(@"history_add_similar_activity") forState:UIControlStateNormal];
    
    [self.eventButton.layer setCornerRadius:self.eventButton.frame.size.width/2];
    [self.eventButton.titleLabel setNumberOfLines:2];
    [self.eventButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
}

- (IBAction)exportDidSelected:(id)sender{
    [self.delegate HistoryTableViewCellDidSelectedExport:self];
}

- (IBAction)viewDidSelected:(id)sender{
    [self.delegate HistoryTableViewCellDidSelectedView:self];
}

- (IBAction)addSimilarDidSelected:(id)sender{
    [self.delegate HistoryTableViewCellDidSelectedAddSimilar:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
