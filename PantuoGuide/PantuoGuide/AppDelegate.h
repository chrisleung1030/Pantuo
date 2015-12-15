//
//  AppDelegate.h
//  PantuoGuide
//
//  Created by Christopher Leung on 8/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *wbtoken;

- (void) tencentLogin;
- (void) tencentShareWithInfoArray:(NSArray *)aArray;
- (void) handleQQAPIInterfaceResp:(QQBaseResp *)resp;

- (void) registerPushNote;
- (void) checkVersionWithShowAlreadyUpdateAlert:(BOOL)aShow;
- (void) checkActivityPushNote;


@end

