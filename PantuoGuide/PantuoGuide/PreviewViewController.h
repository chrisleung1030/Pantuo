//
//  PreviewViewController.h
//  PantuoGuide
//
//  Created by Christopher Leung on 4/5/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import "BaseViewController.h"

@interface PreviewViewController : BaseViewController

@property (nonatomic, retain) NSString *previewLink;
@property (nonatomic, retain) NSString *activityLink;
@property (nonatomic, retain) NSString *activityTitle;
@property (nonatomic, retain) NSString *activityImageLink;
@property (nonatomic, retain) NSString *activityId;
@property (nonatomic, retain) UIImage *activityImage;
@property (nonatomic, retain) NSDictionary *activityDict;
@property (nonatomic, retain) NSString *shareType;
@property (nonatomic, assign) BOOL showEdit;
@property (nonatomic, assign) BOOL useMyActivityTitle;

- (void) shareToWeibo;
- (void) refreshWebView;

@end
