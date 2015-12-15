//
//  QRCodeViewController.h
//  PantuoGuide
//
//  Created by Leung Shun Kan on 7/9/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ZBarSDK.h"

@protocol QRCodeViewControllerDelegate;

@interface QRCodeViewController : BaseViewController <ZBarReaderViewDelegate>
{
    ZBarReaderView *readerView;
    ZBarCameraSimulator *cameraSim;
}

@property (nonatomic, assign) id<QRCodeViewControllerDelegate> delegate;

- (void) start;
- (void) stop;

@end

@protocol QRCodeViewControllerDelegate <NSObject>

- (void) QRCodeViewControllerDidCheckinWitheCode:(NSString *)aCode;

@end
