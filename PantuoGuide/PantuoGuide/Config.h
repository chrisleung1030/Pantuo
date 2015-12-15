//
//  Config.h
//  PantuoGuide
//
//  Created by Christopher Leung on 8/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifndef PantuoGuide_Config_h
#define PantuoGuide_Config_h

#define SHOW_VERSION YES
#define SHOW_API_ERROR_POP_UP YES
#define DEBUG_SMS YES
#define DEBUG_API NO


#if DEBUG

//#define PROGRAM_CONFIG @"d"
//#define PANTUO_DOMAIN @"http://pt.api.pantuo.com/"
//#define IPOSCSL_DOMAIN @"http://panda.iposcsl.com/"

#define PROGRAM_CONFIG @"u"
#define PANTUO_DOMAIN @"http://pt.api.pantuo.com/"
#define IPOSCSL_DOMAIN @"http://hk.pantuo.com/"

#else

//#define PROGRAM_CONFIG @"d"
//#define PANTUO_DOMAIN @"http://pt.api.pantuo.com/"
//#define IPOSCSL_DOMAIN @"http://panda.iposcsl.com/"

#define PROGRAM_CONFIG @"u"
#define PANTUO_DOMAIN @"http://pt.api.pantuo.com/"
#define IPOSCSL_DOMAIN @"http://hk.pantuo.com/"

//#define PROGRAM_CONFIG @""
//#define PANTUO_DOMAIN @"http://api.pantuo.com/"
//#define IPOSCSL_DOMAIN @"http://app.pantuo.com/"

#endif

#define API_LOGIN                       [PANTUO_DOMAIN stringByAppendingString:@"member/login"]
#define API_REGISTRATION                [PANTUO_DOMAIN stringByAppendingString:@"member/registration"]
#define API_SEND_SMS                    [PANTUO_DOMAIN stringByAppendingString:@"member/get_mobile_code"]
#define API_FORGET_PASSWORD             [PANTUO_DOMAIN stringByAppendingString:@"member/forget_password"]
#define API_LOGOUT                      [PANTUO_DOMAIN stringByAppendingString:@"member/logout"]
#define API_UPDATE_PASSWORD             [PANTUO_DOMAIN stringByAppendingString:@"member/update_password"]
#define API_UPDATE_GUIDE_IMAGE          [PANTUO_DOMAIN stringByAppendingString:@"guide/update_guide_image"]
#define API_UPDATE_GUIDE_SOCIAL_INFO    [PANTUO_DOMAIN stringByAppendingString:@"guide/update_guide_social_info"]
#define API_UPDATE_GUIDE_LOCATION       [PANTUO_DOMAIN stringByAppendingString:@"guide/update_guide_location"]
#define API_UPDATE_GUIDE_INFO           [PANTUO_DOMAIN stringByAppendingString:@"guide/update_guide_info"]
#define API_GET_GUIDE_INFO              [PANTUO_DOMAIN stringByAppendingString:@"guide/get_guide_info"]
#define API_UPDATE_GUIDE_INFO_COMPLETED [PANTUO_DOMAIN stringByAppendingString:@"guide/profile/completed"]
#define API_GET_POINTS_DETAIL           [PANTUO_DOMAIN stringByAppendingString:@"member/points/list"]

#define API_GET_ACTIVITY                [IPOSCSL_DOMAIN stringByAppendingString:@"pantuo/api/guide/get_activity.is"]
#define API_GET_ACTIVITY_DETAIL         [IPOSCSL_DOMAIN stringByAppendingString:@"pantuo/api/guide/get_activity_detail.is"]
#define API_ADD_EDIT_ACTIVITY           [IPOSCSL_DOMAIN stringByAppendingString:@"pantuo/api/guide/add_edit_activity.is"]
#define API_DELETE_ACTIVITY             [IPOSCSL_DOMAIN stringByAppendingString:@"pantuo/api/guide/delete_activity.is"]
#define API_HAS_CREATED_ACTIVITY        [IPOSCSL_DOMAIN stringByAppendingString:@"pantuo/api/guide/has_created_activity.is"]
#define API_GET_ATTENDANCE              [IPOSCSL_DOMAIN stringByAppendingString:@"pantuo/api/guide/get_attendance.is"]
#define API_TAKE_ATTENDANCE             [IPOSCSL_DOMAIN stringByAppendingString:@"pantuo/api/guide/take_attendance.is"]
#define API_REMOVE_ATTENDANCE           [IPOSCSL_DOMAIN stringByAppendingString:@"pantuo/api/guide/remove_attendance.is"]
#define API_REMOVE_USER                 [IPOSCSL_DOMAIN stringByAppendingString:@"pantuo/api/guide/remove_user.is"]
#define API_SEND_ACTIVITY_SMS           [IPOSCSL_DOMAIN stringByAppendingString:@"pantuo/api/guide/activity_sms.is"]
#define API_ACTIVITY_DEPARTURE          [IPOSCSL_DOMAIN stringByAppendingString:@"pantuo/api/guide/activity_departure.is"]
#define API_ACTIVITY_SHARED             [IPOSCSL_DOMAIN stringByAppendingString:@"pantuo/api/guide/activity_shared.is"]
#define API_GET_BACKGROUNDS             [IPOSCSL_DOMAIN stringByAppendingString:@"pantuo/api/guide/get_bg_image.is"]
#define API_GET_SLOGAN                  [IPOSCSL_DOMAIN stringByAppendingString:@"pantuo/api/guide/get_slogan.is"]
#define API_GET_EQUIPMENT               [IPOSCSL_DOMAIN stringByAppendingString:@"pantuo/api/guide/get_equipment.is"]
#define API_GET_PROFESSTIONAL           [IPOSCSL_DOMAIN stringByAppendingString:@"pantuo/api/guide/get_professional.is"]
#define API_CHECK_VERSION               [IPOSCSL_DOMAIN stringByAppendingString:@"pantuo/api/guide/check_version.is"]
#define API_GET_TNC                     [IPOSCSL_DOMAIN stringByAppendingString:@"pantuo/api/guide/t_and_c_register.is"]
#define API_WARM_REMIND                 [IPOSCSL_DOMAIN stringByAppendingString:@"pantuo/web/risk"]
#define API_PUSH_NOTE                   [IPOSCSL_DOMAIN stringByAppendingString:@"pantuo/api/guide/reg_push_note.is"]
#define API_GET_WECHAT_TOKEN            @"https://api.weixin.qq.com/sns/oauth2/access_token"
#define API_WRITE_COMMENT               [IPOSCSL_DOMAIN stringByAppendingString:@"pantuo/api/guide/comment.is"]
#define API_APP_UPDATE                  [IPOSCSL_DOMAIN stringByAppendingString:@"pantuo/web/review/index.html?type=0"]
#define API_ABOUT_US                    [IPOSCSL_DOMAIN stringByAppendingString:@"pantuo/api/guide/about.is"]
#define API_RESTORE_USER                [IPOSCSL_DOMAIN stringByAppendingString:@"pantuo/api/guide/restore_user.is"]
#define API_SEARCH_ACTIVITY             [IPOSCSL_DOMAIN stringByAppendingString:@"pantuo/api/guide/search_activity.is"]
#define API_EXPORT_ACTIVITY             [IPOSCSL_DOMAIN stringByAppendingString:@"pantuo/api/guide/export_email.is"]
#define API_TAKE_ATTENDANCE_QRCODE      [IPOSCSL_DOMAIN stringByAppendingString:@"pantuo/api/guide/take_attendance_qr.is"]

#define WEBSITE_ACTIVITY_QRCODE         [IPOSCSL_DOMAIN stringByAppendingString:@"activity/"]

#define APP_DELEGATE                    [[UIApplication sharedApplication] delegate]
#define SCREEN_WIDTH                    [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT                   [[UIScreen mainScreen] bounds].size.height

#define KEY @"pantuoguideghijuklmno01234567890"
#define ROLE @"guide"

#define DAY_TIME_MILLIS 86400000
#define PLATFORM_ID @"0"

#define HTTP_HEADER_CONSUMER_KEY @"consumer"
#define HTTP_HEADER_CONSUMER_VALUE @"app"
#define HTTP_HEADER_TOKEN_KEY @"token"
#define HTTP_HEADER_TOKEN_VALUE @"uK8mCh3U8CVaY03Q0DivZQefHuq7OG5V"

#define UPLOAD_IMAGE_PREFIX @"data:image/jpeg;base64,"

#define GREEN_PANTUO [UIColor colorWithRed:14/255.0 green:175/255.0 blue:20/255.0 alpha:1.0]
#define YELLOW_PANTUO [UIColor colorWithRed:1 green:193/255.0 blue:7/255.0 alpha:1.0]

#define ACTIVITY_COLOR [NSArray arrayWithObjects:@"4CAF50",@"007CBA",@"855c31", nil]
#define GERY_PANTUO [UIColor colorWithRed:158/255.0 green:157/255.0 blue:157/255.0 alpha:1.0]

#define SOCIAL_MEDIA_TYPE_QQ @"qq"
#define SOCIAL_MEDIA_TYPE_WECHAT @"weixin"
#define SOCIAL_MEDIA_TYPE_WEIBO @"weibo"

#define KEY_LANGUAGE                    @"KEY_LANGUAGE"
#define KEY_SKIP_TUTORIAL               @"KEY_SKIP_TUTORIAL"
#define KEY_REGISTRATION_BG             @"KEY_REGISTRATION_BG"
#define KEY_CALENDAR_BG                 @"KEY_CALENDAR_BG"
#define KEY_ALREADY_HV_IMAGE            @"KEY_ALREADY_HV_IMAGE"
#define KEY_GUIDE_INFO                  @"KEY_GUIDE_INFO"
#define KEY_CALENDAR                    @"KEY_CALENDAR"
#define KEY_ADD_TO_CALENDAR             @"KEY_ADD_TO_CALENDAR"
#define KEY_PREPARE_CALENDAR_ACTIVITY   @"KEY_PREPARE_CALENDAR_ACTIVITY"
#define KEY_SAVED_MOBILE                @"KEY_SAVED_MOBILE"

#define NOTIFICATION_CALENDAR_UPDATED   @"NOTIFICATION_CALENDAR_UPDATED"

#define WEIBO_APP_KEY       @"3338352407"
#define WEIBO_REDIRECT_URL  @"http://www.pantuo.com/"
#define WEIBO_SCOPE         @"all"
#define WECHAT_APP_KEY      @"wx281bfe32ec75b5de"
#define WECHAT_APP_SECRET   @"9d60fd4465c67b095e287fa4abf4c1c9"
#define QQ_APP_KEY          @"101195555"
#define BAIDU_KEY           @"004f728dde"
#define BAIDU_PUSH_API_KEY  @"tFpvIlHTuKGAjLfUq5iwo29d"
#define kAddShareResponse   @"addShareResponse"
#define kResponse           @"kResponse"

typedef enum {
    
    ActivityStatusIncomplete,
    ActivityStatusOnGoing,
    ActivityStatusEnded
    
} ActivityStatus;

static __inline__ NSString* GetUserID()
{
    return [[UIDevice currentDevice] identifierForVendor].UUIDString;
}

static __inline__ BOOL IsCorrectMobileNumber(NSString *mobile)
{
    BOOL correct = NO;
    
    NSString *pattern = @"^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9]))\\d{8}$";
    NSPredicate* valtest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    correct = [valtest evaluateWithObject:mobile];
    
    return correct;
}

static __inline__ BOOL IsCorrectPassword(NSString *password)
{
    BOOL correct = NO;
    
    if (password.length >= 6 && password.length <= 20) {
        correct = YES;
    }
    
    return correct;
}

static __inline__ BOOL isEmailValid (NSString *aEmail) {
    NSString *emailRegex = @"[A-Z0-9a-z\\._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:aEmail];
}


static __inline__ NSString* GetDateStringFromNormalFormat(NSString *date, NSString *format)
{
    NSDateFormatter *formater = [NSDateFormatter new];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSDate *tempDate = [formater dateFromString:date];
    
    formater = [NSDateFormatter new];
    [formater setDateFormat:format];
    NSString *dateString = [formater stringFromDate:tempDate];
    return dateString;
}

static __inline__ NSString* RemoveColorSign(NSString *color)
{
    if ([color hasPrefix:@"#"]) {
        color = [color substringFromIndex:1];
    }
    return color;
}

static __inline__ UIColor* ColorWithHexString(NSString *hex)
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return ColorWithHexString([ACTIVITY_COLOR objectAtIndex:0]);
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  ColorWithHexString([ACTIVITY_COLOR objectAtIndex:0]);
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

static __inline__ BOOL isStringEmpty(NSString *aString)
{
    BOOL empty = NO;
    if (!aString || [aString isKindOfClass:[NSNull class]] || [aString isEqualToString:@"null"] || aString.length == 0) {
        empty = YES;
    }
    return empty;
}



#endif
