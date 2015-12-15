//
//  GuideInfo.h
//  PantuoGuide
//
//  Created by Christopher Leung on 9/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface GuideInfo : BaseObject <NSCoding>


@property(nonatomic, retain) NSString *token;
@property(nonatomic, retain) NSString *guide_id;
@property(nonatomic, retain) NSString *member_id;
@property(nonatomic, retain) NSString *nickname;
@property(nonatomic, retain) NSString *profile_image;
@property(nonatomic, retain) NSString *mobile;
@property(nonatomic, retain) NSString *realname;
@property(nonatomic, retain) NSString *email;
@property(nonatomic, assign) BOOL isOverseas;
@property(nonatomic, retain) NSString *address1;
@property(nonatomic, retain) NSString *address2;
@property(nonatomic, retain) NSString *address3;
@property(nonatomic, retain) NSString *skill_id;
@property(nonatomic, retain) NSString *id_number;
@property(nonatomic, retain) NSString *emergency_name;
@property(nonatomic, retain) NSString *emergency_phone;
@property(nonatomic, retain) NSString *other_skill;
@property(nonatomic, retain) NSString *id_image_1;
@property(nonatomic, retain) NSString *id_image_2;
@property(nonatomic, retain) NSString *experience;
@property(nonatomic, retain) NSString *gender;
@property(nonatomic, retain) NSString *point_balance;
@property(nonatomic, assign) BOOL is_guide;

@property(nonatomic, retain) NSString *social_media_qq;
@property(nonatomic, retain) NSString *social_media_wechat;
@property(nonatomic, retain) NSString *social_media_weibo;

- (BOOL) isGuideProfileCompleted;
- (void) setUpGuideInfo:(NSDictionary *)response;

@end
