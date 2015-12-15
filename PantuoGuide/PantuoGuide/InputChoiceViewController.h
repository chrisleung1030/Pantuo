//
//  InputChoiceViewController.h
//  PantuoGuide
//
//  Created by Christopher Leung on 27/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol InputChoiceViewControllerDelegate;

@interface InputChoiceViewController : BaseViewController

@property (nonatomic, assign) int maxCount;
@property (nonatomic, assign) int currentCount;
@property (nonatomic, retain) NSString *titleText;
@property (nonatomic, retain) NSString *selectedChoice;
@property (nonatomic, retain) NSString *otherChoice;
@property (nonatomic, retain) NSString *apiForChoice;
@property (nonatomic, retain) NSMutableArray *choiceArray;
@property (nonatomic, retain) NSArray *choosenTextArray;
@property (nonatomic, assign) id<InputChoiceViewControllerDelegate> delegate;

@end

@protocol InputChoiceViewControllerDelegate <NSObject>

- (void) InputChoiceViewControllerDidFinishWithText:(NSString *)aText WithOtherText:(NSString *)aOtherText;

@end