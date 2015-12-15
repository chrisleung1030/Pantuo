//
//  EventTableViewCell.h
//  PantuoGuide
//
//  Created by Christopher Leung on 15/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EventTableViewCellDelegate <NSObject>

- (void) EventTableViewCellDidSelectPeople:(UITableViewCell *)aCell;

@end

@interface EventTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIButton *eventButton;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UIButton *peopleHiddenButton;
@property (nonatomic, retain) IBOutlet UIButton *peopleButton;
@property (nonatomic, retain) IBOutlet UIButton *notFinishButton;
@property (nonatomic, retain) IBOutlet UIButton *notReleaseButton;
@property (nonatomic, retain) IBOutlet UIButton *finishButton;
@property (nonatomic, retain) IBOutlet UIView *lineView;
@property (nonatomic, retain) IBOutlet UIImageView *arrowImageView;
@property (nonatomic, assign) id<EventTableViewCellDelegate> delegate;

@end
