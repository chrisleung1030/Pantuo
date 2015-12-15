//
//  NumberPickerDataSource.m
//  PantuoGuide
//
//  Created by Christopher Leung on 3/5/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "NumberPickerDataSource.h"

@implementation NumberPickerDataSource

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.endDay-self.startDay+1;
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%d",self.startDay+(int)row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (self.delegate) {
        [self.delegate NumberPickerDataSource:self DidSelectDay:self.startDay+(int)row];
    }
}

@end
