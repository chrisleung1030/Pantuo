//
//  TutorialViewController.m
//  PantuoGuide
//
//  Created by Christopher Leung on 8/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "TutorialViewController.h"

#define TOTAL_PAGE 3

@interface TutorialViewController () <UIScrollViewDelegate>

@property (nonatomic, retain) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic, retain) IBOutlet UIButton *skipButton;
@property (nonatomic, retain) IBOutlet UIPageControl *mainPageControl;

@property (nonatomic, assign) BOOL sendDelegate;

- (IBAction) skip:(id)sender;
- (IBAction) pageChange:(id)sender;

@end

@implementation TutorialViewController
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.mainPageControl setNumberOfPages:TOTAL_PAGE];
    self.sendDelegate = NO;

    for (int i = 0; i < TOTAL_PAGE; i++) {
        UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [tempImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"splash_0%d.jpg",i+1]]];
        [tempImageView setContentMode:UIViewContentModeScaleAspectFit];
        [tempImageView setClipsToBounds:YES];
        [self.mainScrollView addSubview:tempImageView];
    }
    [self.mainScrollView setContentSize:CGSizeMake(SCREEN_WIDTH*TOTAL_PAGE, SCREEN_HEIGHT)];
    [self.skipButton setTitle:GetStringWithKey(@"skip") forState:UIControlStateNormal];
    
    [self.view setAlpha:0];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.view.alpha == 0) {
        [UIView animateWithDuration:1.5 delay:1.0 options:0 animations:^{
            [self.view setAlpha:1];
        } completion:^(BOOL finished) {
            [self.delegate TutorialViewControllerDidAnimated];
        }];
    }
}

- (IBAction) skip:(id)sender{
//    int pageIndex = self.mainScrollView.contentOffset.x/SCREEN_WIDTH;
    [self setUserDefaultWithKey:KEY_SKIP_TUTORIAL WithValue:[NSNumber numberWithBool:YES]];
    [self.delegate TutorialViewControllerDidFinish];
}

- (IBAction) pageChange:(id)sender{
    [self.mainScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*self.mainPageControl.currentPage, 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int pageIndex = scrollView.contentOffset.x/SCREEN_WIDTH;
    [self.mainPageControl setCurrentPage:pageIndex];
    if (pageIndex + 1 >= TOTAL_PAGE) {
        [self.skipButton setTitle:GetStringWithKey(@"enter") forState:UIControlStateNormal];
    }else{
        [self.skipButton setTitle:GetStringWithKey(@"skip") forState:UIControlStateNormal];
    }

    if (scrollView.contentOffset.x + scrollView.frame.size.width > scrollView.contentSize.width + 10) {
        if (!self.sendDelegate) {
            self.sendDelegate  = YES;
            [self skip:nil];
        }
    }
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
