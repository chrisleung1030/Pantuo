//
//  AddActivityViewController.h
//  PantuoGuide
//
//  Created by Christopher Leung on 23/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface AddActivityViewController : BaseViewController

@property (nonatomic, retain) NSDictionary *activityDict;
@property (nonatomic, assign) BOOL isFromPreview;
@property (nonatomic, assign) BOOL isFinishInfoDetail;
@property (nonatomic, assign) BOOL isCreateNewActivity;

@end
