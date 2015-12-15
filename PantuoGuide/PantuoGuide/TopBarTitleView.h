//
//  TopBarTitleView.h
//  PantuoGuide
//
//  Created by Christopher Leung on 9/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"

@interface TopBarTitleView : UIView

@property (nonatomic, retain) IBOutlet UIImageView *backImageView;
@property (nonatomic, retain) IBOutlet UIButton *backButton;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UIView  *titleUnderlineView;

@property (nonatomic, retain) IBOutlet UIButton *infoButton;
@property (nonatomic, retain) IBOutlet UIButton *aboutButton;
@property (nonatomic, retain) IBOutlet UIButton *eventButton;
@property (nonatomic, retain) IBOutlet UIButton *editButton;


- (void) setUpAsMainTopBar;
- (void) updateTitleAndUnderlineView;

@end
