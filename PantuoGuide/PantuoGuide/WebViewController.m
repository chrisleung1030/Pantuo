//
//  WebViewController.m
//  PantuoGuide
//
//  Created by Christopher Leung on 8/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@property (nonatomic, retain) IBOutlet UIWebView *mWebView;

@end

@implementation WebViewController
@synthesize link;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addTopBarView];
    if (self.title.length == 0) {
        [self.topBarView.logoImageView setHidden:NO];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.link] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:2.0];
    [self.mWebView loadRequest:request];
}

- (NSString *) getTopBarTitle{
    return self.title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
