//
//  HistoryTableViewCell.h
//  PantuoGuide
//
//  Created by Leung Shun Kan on 7/9/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HistoryTableViewCellDelegate;

@interface HistoryTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIButton *eventButton;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UIButton *exportButton;
@property (nonatomic, retain) IBOutlet UIButton *viewButton;
@property (nonatomic, retain) IBOutlet UIButton *addSimilarButton;

@property (nonatomic, assign) id<HistoryTableViewCellDelegate>delegate;

- (IBAction)exportDidSelected:(id)sender;
- (IBAction)viewDidSelected:(id)sender;
- (IBAction)addSimilarDidSelected:(id)sender;

@end

@protocol HistoryTableViewCellDelegate <NSObject>

- (void) HistoryTableViewCellDidSelectedExport:(HistoryTableViewCell *)aSelf;
- (void) HistoryTableViewCellDidSelectedView:(HistoryTableViewCell *)aSelf;
- (void) HistoryTableViewCellDidSelectedAddSimilar:(HistoryTableViewCell *)aSelf;

@end
