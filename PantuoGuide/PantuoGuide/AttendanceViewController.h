//
//  AttendanceViewController.h
//  PantuoGuide
//
//  Created by Christopher Leung on 28/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface AttendanceViewController : BaseViewController

@property (nonatomic, assign) BOOL isTakeAttendance;
@property (nonatomic, retain) NSDictionary *activityDict;

@end
