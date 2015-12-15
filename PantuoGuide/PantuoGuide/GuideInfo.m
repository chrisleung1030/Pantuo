//
//  GuideInfo.m
//  PantuoGuide
//
//  Created by Christopher Leung on 9/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "GuideInfo.h"
#import "Config.h"
#import "AddressManager.h"

@implementation GuideInfo
@synthesize token, guide_id, member_id, nickname, profile_image, mobile, realname, email, isOverseas, address1, address2, address3, skill_id, id_number, emergency_name, emergency_phone, other_skill, id_image_1, id_image_2, experience, gender, point_balance, is_guide, social_media_qq, social_media_wechat, social_media_weibo;

- (void)encodeWithCoder:(NSCoder *)coder {

    [coder encodeObject:self.token forKey:@"token"];
    [coder encodeObject:self.guide_id forKey:@"guide_id"];
    [coder encodeObject:self.member_id forKey:@"member_id"];
    [coder encodeObject:self.nickname forKey:@"nickname"];
    [coder encodeObject:self.profile_image forKey:@"profile_image"];
    [coder encodeObject:self.mobile forKey:@"mobile"];
    [coder encodeObject:self.realname forKey:@"realname"];
    [coder encodeObject:self.email forKey:@"email"];
    [coder encodeObject:[NSNumber numberWithBool:self.isOverseas] forKey:@"isOverseas"];
    [coder encodeObject:self.address1 forKey:@"address1"];
    [coder encodeObject:self.address2 forKey:@"address2"];
    [coder encodeObject:self.address3 forKey:@"address3"];
    [coder encodeObject:self.skill_id forKey:@"skill_id"];
    [coder encodeObject:self.id_number forKey:@"id_number"];
    [coder encodeObject:self.emergency_name forKey:@"emergency_name"];
    [coder encodeObject:self.emergency_phone forKey:@"emergency_phone"];
    [coder encodeObject:self.other_skill forKey:@"other_skill"];
    [coder encodeObject:self.id_image_1 forKey:@"id_image_1"];
    [coder encodeObject:self.id_image_2 forKey:@"id_image_2"];
    
    [coder encodeObject:self.experience forKey:@"experience"];
    [coder encodeObject:self.gender forKey:@"gender"];
    [coder encodeObject:self.point_balance forKey:@"point_balance"];
    
    [coder encodeObject:[NSNumber numberWithBool:self.is_guide] forKey:@"is_guide"];
    
    [coder encodeObject:self.social_media_qq forKey:@"social_media_qq"];
    [coder encodeObject:self.social_media_wechat forKey:@"social_media_wechat"];
    [coder encodeObject:self.social_media_weibo forKey:@"social_media_weibo"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.token = [coder decodeObjectForKey:@"token"];
        self.guide_id = [coder decodeObjectForKey:@"guide_id"];
        self.member_id = [coder decodeObjectForKey:@"member_id"];
        self.nickname = [coder decodeObjectForKey:@"nickname"];
        self.profile_image = [coder decodeObjectForKey:@"profile_image"];
        self.mobile = [coder decodeObjectForKey:@"mobile"];
        self.realname = [coder decodeObjectForKey:@"realname"];
        self.email = [coder decodeObjectForKey:@"email"];
        self.isOverseas = [[coder decodeObjectForKey:@"isOverseas"] boolValue];
        self.address1 = [coder decodeObjectForKey:@"address1"];
        self.address2 = [coder decodeObjectForKey:@"address2"];
        self.address3 = [coder decodeObjectForKey:@"address3"];
        self.skill_id = [coder decodeObjectForKey:@"skill_id"];
        self.id_number = [coder decodeObjectForKey:@"id_number"];
        self.emergency_name = [coder decodeObjectForKey:@"emergency_name"];
        self.emergency_phone = [coder decodeObjectForKey:@"emergency_phone"];
        self.other_skill = [coder decodeObjectForKey:@"other_skill"];
        self.id_image_1 = [coder decodeObjectForKey:@"id_image_1"];
        self.id_image_2 = [coder decodeObjectForKey:@"id_image_2"];
        self.experience = [coder decodeObjectForKey:@"experience"];
        self.gender = [coder decodeObjectForKey:@"gender"];
        self.point_balance = [coder decodeObjectForKey:@"point_balance"];
        self.is_guide = [[coder decodeObjectForKey:@"is_guide"] boolValue];
        self.social_media_qq = [coder decodeObjectForKey:@"social_media_qq"];
        self.social_media_wechat = [coder decodeObjectForKey:@"social_media_wechat"];
        self.social_media_weibo = [coder decodeObjectForKey:@"social_media_weibo"];
    }
    return self;
}

- (BOOL) isGuideProfileCompleted{
    BOOL completed = YES;
    BOOL isAddressValid = !isStringEmpty(self.address1);
    if (!self.isOverseas && isAddressValid) {
        AddressManager *tempAddressManager = [AddressManager new];
        int pID = [tempAddressManager getProvinceIdWithName:self.address1];
        BOOL city = [tempAddressManager hasCityInProvince:pID];
        if (city) {
            if (isStringEmpty(self.address2)) {
                isAddressValid = NO;
            }else{
                int cityID = [tempAddressManager getCityIdWithProvince:self.address1 WithCity:self.address2];
                if (cityID == -1) {
                    isAddressValid = NO;
                }
            }
        }
    }

    if (isStringEmpty(self.nickname)
        || isStringEmpty(self.realname)
        || isStringEmpty(self.email)
        || isStringEmpty(self.id_number)
        || isStringEmpty(self.id_image_1)
        || isStringEmpty(self.id_image_2)
//        || [self isStringEmpty:self.address1]
//        || (!self.isOverseas && [self isStringEmpty:self.address2] && [self isStringEmpty:self.address3])
        || (!isAddressValid)
        || isStringEmpty(self.skill_id)
        || isStringEmpty(self.emergency_name)
        || isStringEmpty(self.emergency_phone)
        || isStringEmpty(self.gender)
        ) {
        completed = NO;
    }
    return completed;
}

- (void) setUpGuideInfo:(NSDictionary *)response{
    self.token = [response objectForKey:@"token"];
//    if ([response objectForKey:@"hv_recommend"]){
//        BOOL hvRecommended = [[response objectForKey:@"hv_recommend"] boolValue];
//    }
    NSDictionary *guideInfo = [response objectForKey:@"guide_info"];
    self.guide_id = [self parseString:[guideInfo objectForKey:@"guide_id"]];
    self.member_id = [self parseString:[guideInfo objectForKey:@"member_id"]];
    self.nickname = [self parseString:[guideInfo objectForKey:@"nickname"]];
    self.profile_image = [self parseString:[guideInfo objectForKey:@"profile_image"]];
    self.mobile = [self parseString:[guideInfo objectForKey:@"mobile"]];
    self.realname = [self parseString:[guideInfo objectForKey:@"name"]];
    self.email = [self parseString:[guideInfo objectForKey:@"email"]];
    
    self.isOverseas = [[guideInfo objectForKey:@"oversea"] intValue] == 1;
    if (self.isOverseas) {
        self.address1 = [self parseString:[guideInfo objectForKey:@"location"]];
    }else{
        self.address1 = [self parseString:[guideInfo objectForKey:@"province"]];
        self.address2 = [self parseString:[guideInfo objectForKey:@"city"]];
        self.address3 = [self parseString:[guideInfo objectForKey:@"area"]];
    }
    
    self.skill_id = [self parseString:[guideInfo objectForKey:@"skill_id"]];
    self.id_number = [self parseString:[guideInfo objectForKey:@"id_number"]];
    self.emergency_name = [self parseString:[guideInfo objectForKey:@"emergency_name"]];
    self.emergency_phone = [self parseString:[guideInfo objectForKey:@"emergency_phone"]];
    self.experience = [self parseString:[guideInfo objectForKey:@"experience"]];
    self.other_skill = [self parseString:[guideInfo objectForKey:@"other_skill"]];
    self.gender = [self parseString:[guideInfo objectForKey:@"gender"]];
    self.point_balance = [NSString stringWithFormat:@"%d",[[guideInfo objectForKey:@"point_balance"] intValue]];
    
    self.is_guide = [[guideInfo objectForKey:@"is_guide"] boolValue];
    
    NSArray *socialArray = [guideInfo objectForKey:@"social"];
    if (socialArray && [socialArray count] > 0) {
        for (int i = 0; i < [socialArray count]; i++) {
            NSString *type = [[socialArray objectAtIndex:i] objectForKey:@"type"];
            
            if ([type isEqualToString:SOCIAL_MEDIA_TYPE_QQ]) {
                self.social_media_qq = [[socialArray objectAtIndex:i] objectForKey:@"id"];
            }else if ([type isEqualToString:SOCIAL_MEDIA_TYPE_WECHAT]){
                self.social_media_wechat = [[socialArray objectAtIndex:i] objectForKey:@"id"];
            }else if ([type isEqualToString:SOCIAL_MEDIA_TYPE_WEIBO]){
                self.social_media_weibo = [[socialArray objectAtIndex:i] objectForKey:@"id"];
            }
            
        }
    }
    
    self.id_image_1 = [self parseString:[guideInfo objectForKey:@"id_image_1"]];
    self.id_image_2 = [self parseString:[guideInfo objectForKey:@"id_image_2"]];
    
}

@end
