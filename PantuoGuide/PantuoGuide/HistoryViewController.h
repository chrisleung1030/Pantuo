//
//  HistoryViewController.h
//  PantuoGuide
//
//  Created by Leung Shun Kan on 7/9/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface HistoryViewController : BaseViewController

@property (nonatomic, assign) BOOL showSearch;
@property (nonatomic, retain) NSMutableDictionary *searchDict;

@end
