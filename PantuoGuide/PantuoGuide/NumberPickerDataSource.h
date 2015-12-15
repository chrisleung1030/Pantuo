//
//  NumberPickerDataSource.h
//  PantuoGuide
//
//  Created by Christopher Leung on 3/5/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol NumberPickerDataSourceDelegate;

@interface NumberPickerDataSource : NSObject <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, assign) int startDay;
@property (nonatomic, assign) int endDay;
@property (nonatomic, assign) id<NumberPickerDataSourceDelegate> delegate;

@end

@protocol NumberPickerDataSourceDelegate <NSObject>

- (void) NumberPickerDataSource:(NumberPickerDataSource *)aSelf DidSelectDay:(int)aDay;

@end
