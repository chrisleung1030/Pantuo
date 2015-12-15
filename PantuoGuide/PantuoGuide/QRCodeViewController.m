//
//  QRCodeViewController.m
//  PantuoGuide
//
//  Created by Leung Shun Kan on 7/9/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "QRCodeViewController.h"

@interface QRCodeViewController ()

@property (nonatomic, retain) IBOutlet ZBarReaderView *readerView;
@property (nonatomic, retain) IBOutlet UIImageView *lineImageView;
@property (nonatomic, assign) BOOL animateLine;

@end

#define kScreenSize 200.0f
@implementation QRCodeViewController
@synthesize readerView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addTopBarView];
    [self.topBarView.logoImageView setHidden:NO];
    [self.topBarView.backButton setHidden:NO];
    [self.topBarView.backImageView setHidden:NO];
    
    readerView.readerDelegate = self;
    
    // you can use this to support the simulator
    if(TARGET_IPHONE_SIMULATOR) {
        cameraSim = [[ZBarCameraSimulator alloc]
                     initWithViewController: self];
        cameraSim.readerView = readerView;
    }
}

- (void) startAnimation{
    if (self.lineImageView && self.animateLine) {
        [UIView animateWithDuration:6.0 animations:^{
            CGRect tempFrame = self.lineImageView.frame;
            tempFrame.origin.y = SCREEN_HEIGHT;
            [self.lineImageView setFrame:tempFrame];
        } completion:^(BOOL finished) {
            CGRect tempFrame = self.lineImageView.frame;
            tempFrame.origin.y = 0;
            [self.lineImageView setFrame:tempFrame];
            
            [self startAnimation];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) start{
    self.animateLine = YES;
    [self startAnimation];
    [self.readerView start];
}

- (void) stop{
    self.animateLine = NO;
    [self.lineImageView.layer removeAllAnimations];
    [self.readerView stop];
}



- (void) viewDidAppear: (BOOL) animated
{
    // run the reader when the view is visible
    [self start];
}

- (void) viewWillDisappear: (BOOL) animated
{
    [self stop];
}

- (void) readerView: (ZBarReaderView*) view
     didReadSymbols: (ZBarSymbolSet*) syms
          fromImage: (UIImage*) img
{
    // do something useful with results
    for(ZBarSymbol *sym in syms) {
        NSLog(@"sym.data:%@",sym.data);
        if (self.delegate) {
            [self.delegate QRCodeViewControllerDidCheckinWitheCode:sym.data];
        }
        break;
    }
    [self stop];
}

-(void)dealloc
{
    [self stop]; // then stop continue scanning stream of "self.ZBarReaderVC"
    for(UIView *subViews in self.readerView.subviews) // remove all subviews
        [subViews removeFromSuperview];
    [self.readerView removeFromSuperview];
    readerView.readerDelegate = nil;
    readerView = nil;
    
    cameraSim = nil;
    
    self.view = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
