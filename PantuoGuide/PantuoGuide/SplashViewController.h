//
//  ViewController.h
//  PantuoGuide
//
//  Created by Christopher Leung on 8/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol SplashViewControllerDelegate <NSObject>

- (void) SplashViewControllerDidFinishedWithGoToMainPage:(BOOL)aGoToMainPage WithHasCreatedActivity:(BOOL)aHasCreatedActivity WithAnimation:(BOOL)aAnimation;
- (void) SplashViewControllerDidFinishedWithGoToTutorial;


@end

@interface SplashViewController : BaseViewController

@property (nonatomic, assign) id<SplashViewControllerDelegate> delegate;

@end

