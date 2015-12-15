//
//  AddressPickerDataSource.h
//  PantuoGuide
//
//  Created by Christopher Leung on 22/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AddressManager.h"

typedef enum {
    
    AddressPickerProvince,
    AddressPickerCity,
    AddressPickerArea
    
} AddressPickerPlace;

@protocol AddressPickerDataSourceDelegate <NSObject>

- (void) AddressPickerDataSource:(id)aSelf SelectRow:(int)aRow WithText:(NSString *)aText;

@end

@interface AddressPickerDataSource : NSObject <UIPickerViewDataSource, UIPickerViewDelegate>

- (void) setPickerWithAdressPickerPlace:(AddressPickerPlace)aAddressPickerPlace;
- (void) updateWithProvince:(int)aProvice WithCity:(int)aCity WithArea:(int)aArea;

@property (nonatomic, retain) NSMutableArray *infoArray;
@property (nonatomic, assign) int currentRow;
@property (nonatomic, assign) id<AddressPickerDataSourceDelegate> delegate;

@end
