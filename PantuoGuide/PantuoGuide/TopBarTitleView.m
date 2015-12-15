//
//  TopBarTitleView.m
//  PantuoGuide
//
//  Created by Christopher Leung on 9/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "TopBarTitleView.h"

@implementation TopBarTitleView

- (void) setUpAsMainTopBar{
    [self.backImageView setHidden:YES];
    [self.backButton setHidden:YES];
    [self.infoButton setHidden:NO];
    [self.aboutButton setHidden:NO];
    [self.eventButton setHidden:NO];
}

- (void) updateTitleAndUnderlineView{
    [self.titleLabel sizeToFit];
    CGRect tempFrame = self.titleLabel.frame;
    tempFrame.origin.x = (SCREEN_WIDTH - tempFrame.size.width)/2;
    [self.titleLabel setFrame:tempFrame];
    
    CGRect tempFrame2 = self.titleUnderlineView.frame;
    tempFrame2.size.width = tempFrame.size.width;
    tempFrame2.origin.x = tempFrame.origin.x;
    [self.titleUnderlineView setFrame:tempFrame2];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
