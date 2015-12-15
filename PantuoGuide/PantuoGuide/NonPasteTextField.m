//
//  NonPasteTextField.m
//  PantuoGuide
//
//  Created by Christopher Leung on 27/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "NonPasteTextField.h"

@implementation NonPasteTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
//    NSLog(@"selector=%s",sel_getName(action));
    if (action == @selector(paste:)
        || action == @selector(cut:)
        || action == @selector(delete:)
//        || action == @selector(_transliterateChinese:)
//        || action == @selector(_promptForReplace:)
        )
        return NO;
    return [super canPerformAction:action withSender:sender];
}


@end
