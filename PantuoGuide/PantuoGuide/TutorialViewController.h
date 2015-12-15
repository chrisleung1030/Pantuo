//
//  TutorialViewController.h
//  PantuoGuide
//
//  Created by Christopher Leung on 8/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol TutorialViewControllerDelegate <NSObject>

- (void) TutorialViewControllerDidAnimated;
- (void) TutorialViewControllerDidFinish;

@end

@interface TutorialViewController : BaseViewController

@property (nonatomic, assign) id<TutorialViewControllerDelegate> delegate;

@end
