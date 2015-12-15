//
//  AddressManager.m
//  PantuoGuide
//
//  Created by Christopher Leung on 22/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "AddressManager.h"
#import "TBXML.h"

@implementation AddressManager

- (NSMutableArray *) getProvinces{
    NSMutableArray * tempArray = [NSMutableArray new];
    TBXML *tbxml = [[TBXML alloc] initWithXMLFile:@"inland" fileExtension:@"xml"];
    TBXMLElement *root = tbxml.rootXMLElement;
    //NSLog(@"XML result %@",resultStr);
    if(root) {
        TBXMLElement *child = root->firstChild;
        
        do {
            NSString *name = [TBXML valueOfAttributeNamed:@"name" forElement:child];
            if ([name isEqualToString:@"provinces"]) {
                TBXMLElement *provinceElement = child->firstChild;
                do {
                    [tempArray addObject:[TBXML textForElement:provinceElement]];
                } while ((provinceElement = provinceElement->nextSibling));
            }
        } while ((child = child->nextSibling));
        
    }
    return tempArray;
}

- (NSMutableArray *) getCityWithProvincesIndex:(int)pIndex{

    NSMutableArray * tempArray = [NSMutableArray new];
    TBXML *tbxml = [[TBXML alloc] initWithXMLFile:@"inland" fileExtension:@"xml"];
    TBXMLElement *root = tbxml.rootXMLElement;
    //NSLog(@"XML result %@",resultStr);
    if(root) {
        TBXMLElement *child = root->firstChild;
        if (child) {
            do {
                NSString *name = [TBXML valueOfAttributeNamed:@"name" forElement:child];
                if ([name isEqualToString:[NSString stringWithFormat:@"city_p_%d",pIndex]]) {
                    TBXMLElement *provinceElement = child->firstChild;
                    if (provinceElement) {
                        do {
                            [tempArray addObject:[TBXML textForElement:provinceElement]];
                        } while ((provinceElement = provinceElement->nextSibling));
                    }
                }
            } while ((child = child->nextSibling));
        }
    }
    return tempArray;
}

- (NSMutableArray *) getAreaWithProvincesIndex:(int)pIndex WithCityIndex:(int)cIndex{
    
    NSMutableArray * tempArray = [NSMutableArray new];
    TBXML *tbxml = [[TBXML alloc] initWithXMLFile:@"inland" fileExtension:@"xml"];
    TBXMLElement *root = tbxml.rootXMLElement;
    //NSLog(@"XML result %@",resultStr);
    if(root) {
        TBXMLElement *child = root->firstChild;
        if (child) {
            do {
                NSString *name = [TBXML valueOfAttributeNamed:@"name" forElement:child];
                if ([name isEqualToString:[NSString stringWithFormat:@"area_p_%d_c_%d",pIndex,cIndex]]) {
                    TBXMLElement *provinceElement = child->firstChild;
                    if (provinceElement) {
                        do {
                            [tempArray addObject:[TBXML textForElement:provinceElement]];
                        } while ((provinceElement = provinceElement->nextSibling));
                    }
                }
            } while ((child = child->nextSibling));
        }
    }
    return tempArray;
}

- (BOOL) hasCityInProvince:(int)aProvince{
    return [[self getCityWithProvincesIndex:aProvince] count] > 0;
}

- (BOOL) hasAreaInProvince:(int)aProvince{
    return [[self getAreaWithProvincesIndex:aProvince WithCityIndex:0] count] > 0;
}

- (int) getProvinceIdWithName:(NSString *)aProvince{
    int provinceId = -1;
    TBXML *tbxml = [[TBXML alloc] initWithXMLFile:@"inland" fileExtension:@"xml"];
    TBXMLElement *root = tbxml.rootXMLElement;
    //NSLog(@"XML result %@",resultStr);
    if(root) {
        TBXMLElement *child = root->firstChild;
        
        do {
            NSString *name = [TBXML valueOfAttributeNamed:@"name" forElement:child];
            if ([name isEqualToString:@"provinces"]) {
                TBXMLElement *provinceElement = child->firstChild;
                int tempIndex = 0;
                do {
                    NSString *province = [TBXML textForElement:provinceElement];
                    if ([province isEqualToString:aProvince]) {
                        provinceId = tempIndex;
                        break;
                    }
                    tempIndex ++;
                } while ((provinceElement = provinceElement->nextSibling));
            }
        } while ((child = child->nextSibling));
    }
    return provinceId;
}

- (int) getCityIdWithProvince:(NSString *)aProvince WithCity:(NSString *)aCity{
    int provinceId = [self getProvinceIdWithName:aProvince];
    int cityId = -1;
    TBXML *tbxml = [[TBXML alloc] initWithXMLFile:@"inland" fileExtension:@"xml"];
    TBXMLElement *root = tbxml.rootXMLElement;
    //NSLog(@"XML result %@",resultStr);
    if(root) {
        TBXMLElement *child = root->firstChild;
        if (child) {
            do {
                NSString *name = [TBXML valueOfAttributeNamed:@"name" forElement:child];
                if ([name isEqualToString:[NSString stringWithFormat:@"city_p_%d",provinceId]]) {
                    int tempIndex = 0;
                    TBXMLElement *cityElement = child->firstChild;
                    if (cityElement) {
                        do {
                            NSString *city = [TBXML textForElement:cityElement];
                            if ([city isEqualToString:aCity]) {
                                cityId = tempIndex;
                                break;
                            }
                            tempIndex++;
                        } while ((cityElement = cityElement->nextSibling));
                    }
                }
            } while ((child = child->nextSibling));
        }
    }
    return cityId;
}

- (int) getAreaIdWithProvince:(NSString *)aProvince WithCity:(NSString *)aCity WithArea:(NSString *)aArea{
    int provinceId = [self getProvinceIdWithName:aProvince];
    int cityId = [self getCityIdWithProvince:aProvince WithCity:aCity];
    cityId = cityId==-1?0:cityId;
    int areaId = -1;
    
    TBXML *tbxml = [[TBXML alloc] initWithXMLFile:@"inland" fileExtension:@"xml"];
    TBXMLElement *root = tbxml.rootXMLElement;
    //NSLog(@"XML result %@",resultStr);
    if(root) {
        TBXMLElement *child = root->firstChild;
        if (child) {
            do {
                NSString *name = [TBXML valueOfAttributeNamed:@"name" forElement:child];
                if ([name isEqualToString:[NSString stringWithFormat:@"area_p_%d_c_%d",provinceId,cityId]]) {
                    TBXMLElement *areaElement = child->firstChild;
                    if (areaElement) {
                        int tempIndex = 0;
                        do {
                            NSString *area = [TBXML textForElement:areaElement];
                            if ([area isEqualToString:aArea]) {
                                areaId = tempIndex;
                                break;
                            }
                            tempIndex ++;
                        } while ((areaElement = areaElement->nextSibling));
                    }
                }
            } while ((child = child->nextSibling));
        }
    }
    return areaId;
}

- (BOOL) isCorrectProvince:(NSString *)aProvince City:(NSString *)aCity Area:(NSString *)aArea{
    BOOL correct = YES;
    int pID = -1;
    int cID = -1;
    if ([aProvince length] == 0) {
        correct = NO;
    }else{
        pID = [self getProvinceIdWithName:aProvince];
        if (pID == -1) {
            correct = NO;
        }
    }
    
    if (correct) {
        if ([self hasCityInProvince:pID]) {
            if ([aCity length] == 0) {
                correct = NO;
            }else{
                cID = [self getCityIdWithProvince:aProvince WithCity:aCity];
                if (cID == -1) {
                    correct = NO;
                }
            }
        }else if ([aCity length] > 0){
            correct = NO;
        }
    }
    
    if (correct) {
        if ([self hasAreaInProvince:pID]) {
            if ([aArea length] == 0) {
                correct = NO;
            }else{
                int aID = [self getAreaIdWithProvince:aProvince WithCity:aCity WithArea:aArea];
                if (aID == -1) {
                    correct = NO;
                }
            }
        }else if ([aArea length] > 0) {
            correct = NO;
        }
    }
    
    return correct;
}


@end
