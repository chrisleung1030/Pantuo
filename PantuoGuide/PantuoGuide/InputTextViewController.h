//
//  InputTextViewController.h
//  PantuoGuide
//
//  Created by Christopher Leung on 16/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol InputTextViewControllerDelegate;

@interface InputTextViewController : BaseViewController

@property (nonatomic, assign) int maxCount;
@property (nonatomic, assign) int currentCount;
@property (nonatomic, retain) NSString *presetText;
@property (nonatomic, retain) NSString *titleText;
@property (nonatomic, assign) BOOL isSendSMS;
@property (nonatomic, retain) NSString *activityId;
@property (nonatomic, assign) id<InputTextViewControllerDelegate> delegate;

@end

@protocol InputTextViewControllerDelegate <NSObject>

- (void) InputTextViewControllerDidFinish:(InputTextViewController *)aSelf WithText:(NSString *)aText;

@end
