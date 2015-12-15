//
//  LanguageManager.m
//  NTP
//
//  Created by Adam Tang on 27/04/2011.
//  Copyright 2011 TANG HING KON. All rights reserved.
//

#import "LanguageManager.h"

void SetLanguage(Language aLanguage)
{
    if (aLanguage >= kLanguageTotal) {
        aLanguage = kLanguageSimplifiedChinese;
    }
	[[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d", aLanguage] forKey:KEY_LANGUAGE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

Language GetLanguage()
{
    int lang = 0;
    NSString *tempString = [[NSUserDefaults standardUserDefaults] stringForKey:KEY_LANGUAGE];
    if ([tempString length] == 1) {
        lang = [tempString intValue];
    }
	return (Language)lang;
}

NSString *GetStringWithKey(NSString *aKey)
{
	NSString *tableName = [NSString stringWithFormat:@"Language%d", GetLanguage()];
	return NSLocalizedStringFromTable(aKey, tableName, nil);
}

NSString *GetRequestLanguage()
{
    if(GetLanguage()==0)
        return @"sc";
    return @"tc";
}
