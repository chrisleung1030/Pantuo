//
//  CustomEditTextView.h
//  PantuoGuide
//
//  Created by Christopher Leung on 9/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressPickerDataSource.h"
#import "NonPasteTextView.h"

@protocol CustomEditTextViewDelegate <NSObject>

- (void) CustomEditTextViewDidReturn:(id)aSelf;

@optional

- (void) CustomEditTextViewDidBegin:(id)aSelf;
- (void) CustomEditTextViewDidEnd:(id)aSelf;
- (void) CustomEditTextViewDidSelectOption:(BOOL)aLeft;
- (void) CustomEditTextViewDidSelectImage:(BOOL)aLeft;
- (void) CustomEditTextViewDidSelectSocial:(NSString *)aType;
- (void) CustomEditTextViewDidSelectFullpage:(id)aSelf;;

@end


@interface CustomEditTextView : UIView <UITextFieldDelegate, UITextViewDelegate>

@property(nonatomic, retain) IBOutlet UILabel *titleLabel;
@property(nonatomic, retain) IBOutlet UILabel *title2Label;
@property(nonatomic, retain) IBOutlet UITextField *mTextField;
@property(nonatomic, retain) IBOutlet UILabel *contentLabel;

@property(nonatomic, retain) IBOutlet UIButton *leftButton;
@property(nonatomic, retain) IBOutlet UIButton *rightButton;
@property(nonatomic, retain) IBOutlet UILabel *leftLabel;
@property(nonatomic, retain) IBOutlet UILabel *rightLabel;
@property(nonatomic, retain) IBOutlet UIImageView *leftImageView;
@property(nonatomic, retain) IBOutlet UIImageView *rightImageView;


@property(nonatomic, retain) IBOutlet UIButton *image1Button;
@property(nonatomic, retain) IBOutlet UIButton *image2Button;

@property(nonatomic, retain) IBOutlet UIButton *qqButton;
@property(nonatomic, retain) IBOutlet UIButton *weChatButton;
@property(nonatomic, retain) IBOutlet UIButton *weiboButton;

@property(nonatomic, retain) IBOutlet UIView *inlandAddressView;
@property(nonatomic, retain) IBOutlet UITextView *provinceTextView;
@property(nonatomic, retain) IBOutlet UITextView *cityTextView;
@property(nonatomic, retain) IBOutlet UITextView *areaTextView;

@property (nonatomic, assign) int leftRightSelection;

@property (nonatomic, retain) UIPickerView *provincePickerView;
@property (nonatomic, retain) UIPickerView *cityPickerView;
@property (nonatomic, retain) UIPickerView *areaPickerView;
@property (nonatomic, retain) AddressPickerDataSource *provinceDataSource;
@property (nonatomic, retain) AddressPickerDataSource *cityDataSource;
@property (nonatomic, retain) AddressPickerDataSource *areaDataSource;

@property (nonatomic, assign) id<CustomEditTextViewDelegate> delegate;

- (void) setTitle:(NSString *)aString WithStar:(BOOL)aStar;
- (void) setTitle2:(NSString *)aString WithStar:(BOOL)aStar;
- (void) setPlaceHolder:(NSString *)aString  WithStar:(BOOL)aStar;
- (void) setLeft:(NSString *)aString;
- (void) setRight:(NSString *)aString;
- (void) setLongContent:(NSString *)aContent;

- (IBAction)left:(id)sender;
- (IBAction)right:(id)sender;

- (NSString *) getContent;
- (void) setContent:(NSString *)aString;

@end
