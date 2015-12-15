//
//  MyInfoTableViewCell.h
//  PantuoGuide
//
//  Created by Leung Shun Kan on 7/9/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyInfoTableViewCellDelegate;

@interface MyInfoTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIImageView *mIconImageView;
@property (nonatomic, retain) IBOutlet UIImageView *mArrowImageView;
@property (nonatomic, retain) IBOutlet UILabel *mTitleLabel;
@property (nonatomic, retain) IBOutlet UIButton *unfinishedButton;
@property (nonatomic, retain) IBOutlet UIView *onOffView;
@property (nonatomic, retain) IBOutlet UILabel *onLabel;
@property (nonatomic, retain) IBOutlet UILabel *offLabel;
@property (nonatomic, retain) IBOutlet UIButton *onOffButton;

@property (nonatomic, assign) id<MyInfoTableViewCellDelegate> delegate;

- (IBAction)calendarDidSelectd:(id)sender;

@end

@protocol MyInfoTableViewCellDelegate <NSObject>

- (void) MyInfoTableViewCellDidSelectOnOff:(MyInfoTableViewCell *)aSelf;

@end
