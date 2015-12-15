//
//  TypePickerDataSource.h
//  PantuoGuide
//
//  Created by Christopher Leung on 14/9/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LanguageManager.h"

@protocol TypePickerDataSourceDelegate;

@interface TypePickerDataSource : NSObject <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, retain) NSMutableArray *typeArray;
@property (nonatomic, assign) id<TypePickerDataSourceDelegate>delegate;
@property (nonatomic, assign) int currentType;

@end

@protocol TypePickerDataSourceDelegate <NSObject>

- (void) TypePickerDataSourceDidSelectWithIndex:(int)aIndex WithName:(NSString *)aName;

@end
