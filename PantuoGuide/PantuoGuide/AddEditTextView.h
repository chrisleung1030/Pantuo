//
//  AddEditTextView.h
//  PantuoGuide
//
//  Created by Christopher Leung on 23/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NonPasteTextView.h"
#import "NonPasteTextField.h"
#import "AddressPickerDataSource.h"
#import "NumberPickerDataSource.h"

@protocol AddEditTextViewDelegate;

@interface AddEditTextView : UIView <UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *title2Label;
@property (nonatomic, retain) IBOutlet UILabel *contentLabel;
@property (nonatomic, retain) IBOutlet UIButton *typeButton;

@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;

@property (nonatomic, retain) IBOutlet UIView *dateView;
@property (nonatomic, retain) IBOutlet UILabel *yearLabel;
@property (nonatomic, retain) IBOutlet UILabel *monthLabel;
@property (nonatomic, retain) IBOutlet UILabel *dayLabel;
@property (nonatomic, retain) IBOutlet UIView *timeView;
@property (nonatomic, retain) IBOutlet NonPasteTextField *dateTextField;
@property (nonatomic, retain) IBOutlet NonPasteTextField *timeTextField;


@property(nonatomic, retain) IBOutlet UIButton *leftButton;
@property(nonatomic, retain) IBOutlet UIButton *rightButton;
@property(nonatomic, retain) IBOutlet UILabel *leftLabel;
@property(nonatomic, retain) IBOutlet UILabel *rightLabel;
@property(nonatomic, retain) IBOutlet UIImageView *leftImageView;
@property(nonatomic, retain) IBOutlet UIImageView *rightImageView;

@property(nonatomic, retain) IBOutlet UIView *inlandAddressView;
@property(nonatomic, retain) IBOutlet UITextView *provinceTextView;
@property(nonatomic, retain) IBOutlet UITextView *cityTextView;
@property(nonatomic, retain) IBOutlet UITextView *areaTextView;

@property(nonatomic, retain) IBOutlet UIView *detailAddressView;
@property(nonatomic, retain) IBOutlet UILabel *detailAddressLabel;

@property (nonatomic, assign) int leftRightSelection;

@property (nonatomic, retain) UIPickerView *provincePickerView;
@property (nonatomic, retain) UIPickerView *cityPickerView;
@property (nonatomic, retain) UIPickerView *areaPickerView;
@property (nonatomic, retain) AddressPickerDataSource *provinceDataSource;
@property (nonatomic, retain) AddressPickerDataSource *cityDataSource;
@property (nonatomic, retain) AddressPickerDataSource *areaDataSource;


@property (nonatomic, retain) IBOutlet UILabel *minLabel;
@property (nonatomic, retain) IBOutlet UILabel *maxLabel;
@property (nonatomic, retain) IBOutlet NonPasteTextField *minTextField;
@property (nonatomic, retain) IBOutlet NonPasteTextField *maxTextField;
@property (nonatomic, retain) IBOutlet UIButton *unlimitButton;
@property (nonatomic, retain) IBOutlet UIView *minHolderLabel;
@property (nonatomic, retain) IBOutlet UIView *maxHolderLabel;


@property (nonatomic, retain) IBOutlet UIButton *image1Button;
@property (nonatomic, retain) IBOutlet UIButton *image2Button;
@property (nonatomic, retain) IBOutlet UIButton *image3Button;

@property (nonatomic, retain) IBOutlet UIView *topSeparateView;
@property (nonatomic, retain) IBOutlet UILabel *themeTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *venueTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *detailTitleLabel;

@property (nonatomic, retain) IBOutlet UILabel *themeContentLabel;
@property (nonatomic, retain) IBOutlet UILabel *venueContentLabel;
@property (nonatomic, retain) IBOutlet UILabel *detailContentLabel;

@property (nonatomic, retain) IBOutlet UITextField *startTextField;
@property (nonatomic, retain) IBOutlet UITextField *endTextField;
@property (nonatomic, retain) IBOutlet UILabel *startLabel;
@property (nonatomic, retain) IBOutlet UILabel *endLabel;
@property (nonatomic, retain) IBOutlet UIView *startHolderView;
@property (nonatomic, retain) IBOutlet UIView *endHolderView;
@property (nonatomic, retain) IBOutlet UIButton *removeTripButton;

@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) UIDatePicker *timePicker;

@property (nonatomic, retain) UIImage *image1;
@property (nonatomic, retain) UIImage *image2;
@property (nonatomic, retain) UIImage *image3;

@property (nonatomic, assign) BOOL updateImage1;
@property (nonatomic, assign) BOOL updateImage2;
@property (nonatomic, assign) BOOL updateImage3;

@property (nonatomic, assign) BOOL unlimit;
@property (nonatomic, assign) int star;
@property (nonatomic, retain) NSString *dateString;
@property (nonatomic, retain) NSString *timeString;
@property (nonatomic, assign) id<AddEditTextViewDelegate> delegate;

@property (nonatomic, assign) int type;
@property (nonatomic, retain) NSString *color;
@property (nonatomic, retain) NSString *otherType;

@property (nonatomic, retain) NSString *selectedChoice;
@property (nonatomic, retain) NSString *otherChoice;

@property (nonatomic, retain) NumberPickerDataSource *startDatePickerDataSource;
@property (nonatomic, retain) NumberPickerDataSource *endDatePickerDataSource;
@property (nonatomic, assign) int startDate;
@property (nonatomic, assign) int endDate;
@property (nonatomic, retain) NSString *planId;

- (void) setTitle:(NSString *)aString WithStar:(BOOL)aStar;
- (void) setTitle2:(NSString *)aString WithStar:(BOOL)aStar;
- (void) setTheme:(NSString *)aString WithStar:(BOOL)aStar;
- (IBAction)type:(id)sender;
- (IBAction)addEditText:(id)sender;
- (IBAction)starButton:(id)sender;
- (IBAction)unlimit:(id)sender;
- (IBAction)activityImage:(id)sender;
- (IBAction)detailAddress:(id)sender;

- (IBAction)left:(id)sender;
- (IBAction)right:(id)sender;
- (IBAction)removeTrip:(id)sender;

- (void) setDateStringWithString:(NSString *)aString;
- (void) setTimeWithTimeString:(NSString *)timeString;
- (void) setTypeWithType:(int)aType Color:(NSString *)aColor OtherType:(NSString *)aOtherType;
- (void) setStartAndEndDateWithStart:(int)aStart WithEnd:(int)aEnd;
- (void) setEndDateEnable:(BOOL)aEnable;
- (void) setStarWithStar:(int)star;
- (void) setUnlimitWithUnlimit:(BOOL)unlimit;

@end

@protocol AddEditTextViewDelegate <NSObject>

- (void) AddEditTextViewDidSelect:(AddEditTextView *)aSelf WithTag:(int)aTag;
- (void) AddEditTextViewDidSelectType;
- (void) AddEditTextViewDidSelectActivityImage:(AddEditTextView *)aSelf WithTag:(int)aTag;
- (void) AddEditTextViewDidSelectOption:(BOOL)aLeft;
- (void) AddEditTextViewDidClickRemoveTrip:(AddEditTextView *)aSelf;
- (void) AddEditTextViewDidSelect:(AddEditTextView *)aSelf WithEndDay:(int)aDay;
- (void) AddEditTextViewDidBeginEdit:(AddEditTextView *)aSelf;
- (void) AddEditTextViewDidSelectDetailAddress:(AddEditTextView *)aSelf;

@end
