//
//  LanguageManager.h
//  NTP
//
//  Created by Adam Tang on 27/04/2011.
//  Copyright 2011 TANG HING KON. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"

typedef enum _Language{
    kLanguageSimplifiedChinese,
	kLanguageTotal
} Language;

void SetLanguage(Language aLanguage);
Language GetLanguage();
NSString *GetStringWithKey(NSString *aKey);
NSString *GetRequestLanguage();
