//
//  InputTypeViewController.h
//  PantuoGuide
//
//  Created by Christopher Leung on 1/5/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol InputTypeViewControllerDelegate;

@interface InputTypeViewController : BaseViewController

@property (nonatomic, assign) int selectedType;
@property (nonatomic, assign) int selectedColor;
@property (nonatomic, retain) NSString *otherType;
@property (nonatomic, assign) id<InputTypeViewControllerDelegate> delegate;

@end

@protocol InputTypeViewControllerDelegate <NSObject>

- (void) InputTypeViewControllerDidFinishWithType:(int)aType WithColor:(NSString *)aColor WithOtherType:(NSString *)aOtherType;

@end
