//
//  PointTableViewCell.h
//  PantuoGuide
//
//  Created by Leung Shun Kan on 8/9/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PointTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *pointLabel;
@property (nonatomic, retain) IBOutlet UIImageView *upDownImageView;

@end
