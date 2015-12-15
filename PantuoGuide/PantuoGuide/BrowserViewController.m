//
//  BrowserViewController.m
//  PantuoGuide
//
//  Created by Leung Shun Kan on 21/9/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "BrowserViewController.h"

@interface BrowserViewController () <UIWebViewDelegate>

@property (nonatomic, retain) IBOutlet UIWebView *mWebView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *mIndicatorView;

- (IBAction)previous:(id)sender;
- (IBAction)next:(id)sender;
- (IBAction)refresh:(id)sender;

@end

@implementation BrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addTopBarView];
    [self.topBarView.logoImageView setHidden:NO];
    
    NSURL *url = [NSURL URLWithString:self.link];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:3.0];
    [self.mWebView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)previous:(id)sender{
    if ([self.mWebView canGoBack]) {
        [self.mWebView goBack];
    }
}

- (IBAction)next:(id)sender{
    if ([self.mWebView canGoForward]) {
        [self.mWebView goForward];
    }
}

- (IBAction)refresh:(id)sender{
    [self.mWebView reload];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.mIndicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.mIndicatorView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.mIndicatorView stopAnimating];
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
