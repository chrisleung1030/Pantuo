//
//  ClickableNameView.h
//  PantuoGuide
//
//  Created by Christopher Leung on 21/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "LanguageManager.h"

@interface ClickableNameView : UIView

@property (nonatomic, retain) NSMutableArray *nameArray;
@property (nonatomic, retain) NSMutableArray *buttonArray;
@property (nonatomic, retain) NSMutableArray *buttonTapArray;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UIView *titleBgView;
@property (nonatomic, retain) IBOutlet UIView *titleUnderlineView;

@property (nonatomic, retain) IBOutlet UIView *lowSeparatoeBgView;
@property (nonatomic, retain) IBOutlet UIView *lowSeparatoeUpperlineView;

- (void) initViewWithTitle:(NSString *)aTitle WithStart:(BOOL)aStar WithNameArray:(NSMutableArray *)aArray WithClickedNameArray:(NSArray *)aClickedArray;

- (void) addBorder:(BOOL)aUp;
- (void) hideTitleBackground;
- (void) addLowSeparator;

- (void) setClickNameWithId:(NSMutableArray *)aId;
- (NSString *) getClickedId;

- (void) setClickNameWithNames:(NSMutableArray *)aNames;
- (NSString *) getClickedNames;


@end
