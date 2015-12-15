//
//  BaseObject.m
//  PantuoGuide
//
//  Created by Christopher Leung on 29/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "BaseObject.h"

@implementation BaseObject

- (NSString *) parseString:(id)object{
    if (isStringEmpty(object)) {
        return [NSString string];
    }else if ([object isKindOfClass:[NSString class]]) {
        return (NSString *)object;
    }else{
        return [NSString string];
    }
}


@end
