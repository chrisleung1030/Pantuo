//
//  AddressPickerDataSource.m
//  PantuoGuide
//
//  Created by Christopher Leung on 22/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "AddressPickerDataSource.h"

@interface AddressPickerDataSource()

@property (nonatomic, assign) AddressPickerPlace addressPickerPlace;
@property (nonatomic, assign) int provinceId;
@property (nonatomic, assign) int cityId;
@property (nonatomic, assign) int areaId;

@end

@implementation AddressPickerDataSource
@synthesize delegate;

- (void) setPickerWithAdressPickerPlace:(AddressPickerPlace)aAddressPickerPlace{
    self.addressPickerPlace = aAddressPickerPlace;
    self.provinceId = -1;
    self.cityId = -1;
    self.areaId = -1;
    self.currentRow = -1;
    
    AddressManager *tempAddressManager = [AddressManager new];
    if (self.addressPickerPlace == AddressPickerProvince) {
        self.infoArray = [tempAddressManager getProvinces];
    }else if (self.addressPickerPlace == AddressPickerCity){
        self.infoArray = [tempAddressManager getCityWithProvincesIndex:self.provinceId];
    }else if (self.addressPickerPlace == AddressPickerArea){
        self.infoArray = [tempAddressManager getAreaWithProvincesIndex:self.provinceId WithCityIndex:self.cityId];
    }
}

- (void) updateWithProvince:(int)aProvice WithCity:(int)aCity WithArea:(int)aArea{
    AddressManager *tempAddressManager = [AddressManager new];
    if (self.addressPickerPlace == AddressPickerProvince) {
        self.infoArray = [tempAddressManager getProvinces];
    }else if (self.addressPickerPlace == AddressPickerCity){
        self.infoArray = [tempAddressManager getCityWithProvincesIndex:aProvice];
    }else if (self.addressPickerPlace == AddressPickerArea){
        aCity = aCity==-1?0:aCity;
        self.infoArray = [tempAddressManager getAreaWithProvincesIndex:aProvice WithCityIndex:aCity];
    }
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.infoArray count];
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.infoArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.currentRow = (int)row;
    if (self.delegate) {
        [self.delegate AddressPickerDataSource:self SelectRow:(int)row WithText:[self.infoArray objectAtIndex:row]];
    }
}

@end