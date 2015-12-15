//
//  ClickableNameView.m
//  PantuoGuide
//
//  Created by Christopher Leung on 21/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "ClickableNameView.h"

@implementation ClickableNameView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) initViewWithTitle:(NSString *)aTitle WithStart:(BOOL)aStar WithNameArray:(NSMutableArray *)aArray WithClickedNameArray:(NSArray *)aClickedArray{
    self.nameArray = aArray;
    self.buttonArray = [NSMutableArray array];
    self.buttonTapArray = [NSMutableArray array];
    
    if (aTitle.length > 0) {
        NSMutableAttributedString *tempAttString;
        tempAttString = [[NSMutableAttributedString alloc] init];
        [tempAttString appendAttributedString:[[NSAttributedString alloc] initWithString:aTitle
                                                                              attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}]];
        if (aStar) {
            [tempAttString appendAttributedString:[[NSAttributedString alloc] initWithString:@"*"
                                                                                  attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}]];
        }
        [self.titleLabel setAttributedText:tempAttString];
    }else{
        [self.titleBgView setHidden:YES];
        [self.titleUnderlineView setHidden:YES];
    }
    
    
    UILabel *tempLabel = [[UILabel alloc] init];
    [tempLabel setFont:[UIFont systemFontOfSize:15]];
    
    int startX = 10;
    int x = startX;
    int y;
    if ([aTitle length] == 0) {
        y = 8;
    }else{
        y = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 5;
    }
    
    int height = 35;
    int tag = 1;
    for (NSString *name in self.nameArray) {
        UIButton *tempButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [tempButton setBackgroundColor:[UIColor grayColor]];
        [tempButton.layer setCornerRadius:5.0f];
        [tempButton setTitle:name forState:UIControlStateNormal];
        [tempButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [tempButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [tempButton addTarget:self action:@selector(buttonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
        [tempButton setTag:tag];
        
        [tempLabel setFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
        [tempLabel setText:name];
        [tempLabel sizeToFit];
        if (x + tempLabel.frame.size.width + 5 > SCREEN_WIDTH - startX) {
            x = startX;
            y += height + 8;
        }
        [tempButton setFrame:CGRectMake(x, y, tempLabel.frame.size.width+5, height)];
        
        [self addSubview:tempButton];
        x += tempButton.frame.size.width + 8;
        tag ++;
        [self.buttonArray addObject:tempButton];
        
        
        BOOL updated = NO;
        for (NSString *clickedName in aClickedArray) {
            if ([clickedName isEqualToString:name]) {
                [tempButton setBackgroundColor:GREEN_PANTUO];
                [self.buttonTapArray addObject:[NSNumber numberWithBool:YES]];
                updated = YES;
                break;
            }
        }
        if (!updated) {
            [self.buttonTapArray addObject:[NSNumber numberWithBool:NO]];
        }
        
    }
    CGRect tempFrame = self.frame;
    tempFrame.size.height = y + height + 10;
    [self setFrame:tempFrame];
}

- (void) addBorder:(BOOL)aUp{
    UIView *tempView;
    if (aUp) {
        tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        [tempView setBackgroundColor:ColorWithHexString(@"BABBBC")];
        [self addSubview:tempView];
    }
    
    tempView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, SCREEN_WIDTH, 1)];
    [tempView setBackgroundColor:ColorWithHexString(@"BABBBC")];
    [self addSubview:tempView];
}

- (void) hideTitleBackground{
    [self.titleBgView setHidden:YES];
    [self.titleUnderlineView setHidden:YES];
}

- (void) addLowSeparator{
    [self.lowSeparatoeBgView setHidden:NO];
    [self.lowSeparatoeUpperlineView setHidden:NO];
}

- (void) buttonDidTapped:(UIButton *)sender{
    int index = (int)[sender tag] - 1;
    BOOL tapped = [[self.buttonTapArray objectAtIndex:index] boolValue];
    [self setButtonTappedWithIndex:index WithTapped:!tapped];
}

- (void) setButtonTappedWithIndex:(int)aIndex WithTapped:(BOOL)aTapped{
    UIButton *tempButton = [self.buttonArray objectAtIndex:aIndex];
    if (aTapped) {
        [tempButton setBackgroundColor:GREEN_PANTUO];
    }else{
        [tempButton setBackgroundColor:[UIColor grayColor]];
    }
    [self.buttonTapArray replaceObjectAtIndex:aIndex withObject:[NSNumber numberWithBool:aTapped]];
}

- (void) setClickNameWithId:(NSMutableArray *)aId{
    for (NSString *ids in aId) {
        int index = [ids intValue];
        if (index < [self.buttonArray count]) {
            UIButton *button = [self.buttonArray objectAtIndex:index];
            [button setBackgroundColor:GREEN_PANTUO];
            [self.buttonTapArray replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:YES]];
        }
    }
}

- (NSString *) getClickedId{
    NSMutableString *clicked = [NSMutableString string];
    for (int i = 0; i<[self.buttonTapArray count]; i++) {
        if ([[self.buttonTapArray objectAtIndex:i] boolValue]) {
            if ([clicked length] > 0) {
                [clicked appendString:@"|"];
            }
            [clicked appendString:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return clicked;
}

- (void) setClickNameWithNames:(NSMutableArray *)aNames{
    
    for (NSString *name in aNames) {
        for (int i = 0; i < [self.buttonArray count]; i++) {
            UIButton *button = [self.buttonArray objectAtIndex:i];
            if ([[button titleForState:UIControlStateNormal] isEqualToString:name]) {
                [button setBackgroundColor:GREEN_PANTUO];
                [self.buttonTapArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:YES]];
                break;
            }
        }
    }
}

- (NSString *) getClickedNames{
    NSMutableString *clicked = [NSMutableString string];
    for (int i = 0; i<[self.buttonTapArray count]; i++) {
        if ([[self.buttonTapArray objectAtIndex:i] boolValue]) {
            if ([clicked length] > 0) {
                [clicked appendString:GetStringWithKey(@"activity_text_seperator")];
            }
            [clicked appendString:[[self.buttonArray objectAtIndex:i] titleForState:UIControlStateNormal]];
        }
    }
    return clicked;
}


@end
