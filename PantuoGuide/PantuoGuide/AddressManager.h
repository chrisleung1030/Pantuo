//
//  AddressManager.h
//  PantuoGuide
//
//  Created by Christopher Leung on 22/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressManager : NSObject

- (NSMutableArray *) getProvinces;
- (NSMutableArray *) getCityWithProvincesIndex:(int)pIndex;
- (NSMutableArray *) getAreaWithProvincesIndex:(int)pIndex WithCityIndex:(int)cIndex;

- (BOOL) hasCityInProvince:(int)aProvince;
- (BOOL) hasAreaInProvince:(int)aProvince;

- (int) getProvinceIdWithName:(NSString *)aProvince;
- (int) getCityIdWithProvince:(NSString *)aProvince WithCity:(NSString *)aCity;
- (int) getAreaIdWithProvince:(NSString *)aProvince WithCity:(NSString *)aCity WithArea:(NSString *)aArea;

- (BOOL) isCorrectProvince:(NSString *)aProvince City:(NSString *)aCity Area:(NSString *)aArea;

@end
