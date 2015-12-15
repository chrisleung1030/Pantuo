//
//  TypePickerDataSource.m
//  PantuoGuide
//
//  Created by Christopher Leung on 14/9/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "TypePickerDataSource.h"

@implementation TypePickerDataSource

- (id) init{
    self = [super init];
    if (self) {
        self.typeArray = [NSMutableArray arrayWithArray:[GetStringWithKey(@"history_all_type") componentsSeparatedByString:@"、"]];
        self.currentType = -1;
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.typeArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self getNameWithIndex:(int)row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (self.delegate) {
        self.currentType = (int)row;
        [self.delegate TypePickerDataSourceDidSelectWithIndex:(int)row WithName:[self getNameWithIndex:(int)row]];
    }
}

- (NSString *) getNameWithIndex:(int)aIndex{
    return [self.typeArray objectAtIndex:aIndex];
}

@end
