//
//  LandingViewController.h
//  PantuoGuide
//
//  Created by Christopher Leung on 9/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface LandingViewController : BaseViewController

@property (nonatomic, assign) BOOL hasCreatedActivity;
@property (nonatomic, assign) BOOL refreshView;

- (void) updateOnTimeChange;
- (void) goToAttendanceWithActivityID:(NSString *)aActivityID;

@end
