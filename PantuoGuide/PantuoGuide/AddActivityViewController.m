//
//  AddActivityViewController.m
//  PantuoGuide
//
//  Created by Christopher Leung on 23/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "AddActivityViewController.h"
#import "InputTextViewController.h"
#import "InputChoiceViewController.h"
#import "InputTypeViewController.h"
#import "AddEditTextView.h"
#import "PreviewViewController.h"
#import "LandingViewController.h"
#import "MyInfoDetailViewController.h"

typedef enum {
    
    AddInputTypeTitle,
    AddInputTypeHighlight,
    AddInputTypeFee,
    AddInputTypeFeeDesc,
    AddInputTypeRemark,
    AddInputTypeAttention,
    AddInputTypeEquipment,
    AddInputTypeTheme,
    AddInputTypeVenue,
    AddInputTypeDetail,
    AddInputTypeDetailAddress,
    
} AddInputType;

typedef enum {
    
    AddImageTypeProfile,
    AddImageTypeActivityImage1,
    AddImageTypeActivityImage2,
    AddImageTypeActivityImage3
    
} AddImageType;


@interface AddActivityViewController () <UIGestureRecognizerDelegate, AddEditTextViewDelegate, InputTextViewControllerDelegate, InputChoiceViewControllerDelegate, InputTypeViewControllerDelegate>

@property (nonatomic, retain) UIScrollView *mScrollView;
@property (nonatomic, retain) AddEditTextView *titleAndTypeAddEditTextView;
@property (nonatomic, retain) AddEditTextView *highlightAddEditTextView;
@property (nonatomic, retain) AddEditTextView *starAddEditTextView;
@property (nonatomic, retain) AddEditTextView *dateTimeAddEditTextView;
@property (nonatomic, retain) AddEditTextView *peopleAddEditTextView;
@property (nonatomic, retain) AddEditTextView *addressAddEditTextView;
@property (nonatomic, retain) AddEditTextView *activityImageAddEditTextView;
@property (nonatomic, retain) AddEditTextView *feeAddEditTextView;
@property (nonatomic, retain) AddEditTextView *feeExtraAddEditTextView;
@property (nonatomic, retain) AddEditTextView *remarkAddEditTextView;
@property (nonatomic, retain) UIView *journeyTitleView;
@property (nonatomic, retain) UIView *dayActivityView;
@property (nonatomic, retain) UIButton *halfDayActivityButton;
@property (nonatomic, retain) UIButton *fullDayActivityButton;
@property (nonatomic, retain) UIButton *addJourneyButton;
@property (nonatomic, retain) NSMutableArray *journeyAddEditTextViewArray;
@property (nonatomic, retain) AddEditTextView *attentionAddEditTextView;
@property (nonatomic, retain) AddEditTextView *equipmentAddEditTextView;
@property (nonatomic, retain) UIView *actionButtonView;
@property (nonatomic, retain) UIButton *saveButton;
@property (nonatomic, retain) UIButton *previewButton;
@property (nonatomic, retain) UIButton *deleteButton;

@property (nonatomic, assign) AddInputType addInputType;
@property (nonatomic, assign) AddImageType addImageType;
@property (nonatomic, assign) int errorY;
@property (nonatomic, assign) int journeySelected;
@property (nonatomic, assign) int journeyTagSelected;
@property (nonatomic, assign) BOOL isFullDay;
@property (nonatomic, assign) BOOL goToPreview;

@property (nonatomic, assign) BOOL initSetup;

@property (nonatomic, retain) NSDictionary *addEditActivityResponse;

@property (nonatomic, assign) BOOL isPhotoNewlyAddedForSimilarActivity;

@end

@implementation AddActivityViewController

- (NSString *) getTopBarTitle{
    return GetStringWithKey(@"create_activity");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addTopBarTitleView];
    
    self.journeyAddEditTextViewArray = [NSMutableArray array];
    self.isFullDay = YES;
    self.isFinishInfoDetail = NO;
    self.addEditActivityResponse = [NSDictionary dictionary];
    self.isPhotoNewlyAddedForSimilarActivity = self.isCreateNewActivity;
    
    self.mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, SCREEN_HEIGHT-90)];
    [self.view addSubview:self.mScrollView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    [self.mScrollView addGestureRecognizer:tap];
    
    self.titleAndTypeAddEditTextView = (AddEditTextView *)[[[NSBundle mainBundle] loadNibNamed:@"AddEditTextView" owner:self options:nil] objectAtIndex:1];
    self.titleAndTypeAddEditTextView.delegate = self;
    [self.mScrollView addSubview:self.titleAndTypeAddEditTextView];
    
    self.highlightAddEditTextView = (AddEditTextView *)[[[NSBundle mainBundle] loadNibNamed:@"AddEditTextView" owner:self options:nil] objectAtIndex:0];
    self.highlightAddEditTextView.delegate = self;
    [self.mScrollView addSubview:self.highlightAddEditTextView];
    
    self.starAddEditTextView = (AddEditTextView *)[[[NSBundle mainBundle] loadNibNamed:@"AddEditTextView" owner:self options:nil] objectAtIndex:2];
    self.starAddEditTextView.delegate = self;
    [self.mScrollView addSubview:self.starAddEditTextView];
    
    self.dateTimeAddEditTextView = (AddEditTextView *)[[[NSBundle mainBundle] loadNibNamed:@"AddEditTextView" owner:self options:nil] objectAtIndex:3];
    self.dateTimeAddEditTextView.delegate = self;
    [self.mScrollView addSubview:self.dateTimeAddEditTextView];
    
    self.peopleAddEditTextView = (AddEditTextView *)[[[NSBundle mainBundle] loadNibNamed:@"AddEditTextView" owner:self options:nil] objectAtIndex:4];
    self.peopleAddEditTextView.delegate = self;
    [self.mScrollView addSubview:self.peopleAddEditTextView];
    
    self.addressAddEditTextView = (AddEditTextView *)[[[NSBundle mainBundle] loadNibNamed:@"AddEditTextView" owner:self options:nil] objectAtIndex:6];
    self.addressAddEditTextView.delegate = self;
    [self.mScrollView addSubview:self.addressAddEditTextView];
    
    int interval = 0;
    int y = 0;
    CGRect tempFrame;
    
    tempFrame = self.titleAndTypeAddEditTextView.frame;
    tempFrame.origin.y = y ;
    tempFrame.size.width = SCREEN_WIDTH;
    [self.titleAndTypeAddEditTextView setFrame:tempFrame];
    y += self.titleAndTypeAddEditTextView.frame.size.height + interval;
    
    tempFrame = self.highlightAddEditTextView.frame;
    tempFrame.origin.y = y ;
    tempFrame.size.width = SCREEN_WIDTH;
    [self.highlightAddEditTextView setFrame:tempFrame];
    y += self.highlightAddEditTextView.frame.size.height + interval;
    
    tempFrame = self.starAddEditTextView.frame;
    tempFrame.origin.y = y ;
    tempFrame.size.width = SCREEN_WIDTH;
    [self.starAddEditTextView setFrame:tempFrame];
    y += self.starAddEditTextView.frame.size.height + interval;
    
    tempFrame = self.dateTimeAddEditTextView.frame;
    tempFrame.origin.y = y ;
    tempFrame.size.width = SCREEN_WIDTH;
    [self.dateTimeAddEditTextView setFrame:tempFrame];
    y += self.dateTimeAddEditTextView.frame.size.height + interval;
    
    tempFrame = self.peopleAddEditTextView.frame;
    tempFrame.origin.y = y ;
    tempFrame.size.width = SCREEN_WIDTH;
    [self.peopleAddEditTextView setFrame:tempFrame];
    y += self.peopleAddEditTextView.frame.size.height + interval;
    
    tempFrame = self.addressAddEditTextView.frame;
    tempFrame.origin.y = y ;
    tempFrame.size.width = SCREEN_WIDTH;
    [self.addressAddEditTextView setFrame:tempFrame];
    
    [self.titleAndTypeAddEditTextView setTitle:[self getTitleWithType:AddInputTypeTitle] WithStar:YES];
    [self.highlightAddEditTextView setTitle:[self getTitleWithType:AddInputTypeHighlight] WithStar:YES];
    [self.starAddEditTextView setTitle:GetStringWithKey(@"activity_strength") WithStar:YES];
    [self.dateTimeAddEditTextView setTitle:GetStringWithKey(@"activity_dates") WithStar:YES];
    [self.peopleAddEditTextView setTitle:GetStringWithKey(@"activity_participants_num") WithStar:YES];
    [self.addressAddEditTextView setTitle:GetStringWithKey(@"activity_participants_num") WithStar:YES];
    [self.addressAddEditTextView.leftLabel setText:GetStringWithKey(@"local")];
    [self.addressAddEditTextView.rightLabel setText:GetStringWithKey(@"foreign")];
    [self.addressAddEditTextView setTitle:GetStringWithKey(@"activity_place") WithStar:YES];
    [self.addressAddEditTextView.provinceTextView setText:GetStringWithKey(@"province")];
    [self.addressAddEditTextView.cityTextView setText:GetStringWithKey(@"city")];
    [self.addressAddEditTextView.areaTextView setText:GetStringWithKey(@"district")];
    [self.addressAddEditTextView.detailAddressLabel setText:[self getHintWithType:AddInputTypeDetailAddress]];
    
    [self.titleAndTypeAddEditTextView.contentLabel setText:[self getHintWithType:AddInputTypeTitle]];
    [self.highlightAddEditTextView.contentLabel setText:[self getHintWithType:AddInputTypeHighlight]];
    [self.starAddEditTextView setStarWithStar:1];
    
    if (self.activityDict) {
        self.initSetup = NO;
        GuideInfo *guideInfo = [self getGuideInfo];
        [self callIPOSCSLAPIWithLink:API_GET_ACTIVITY_DETAIL
                       WithParameter:[NSDictionary dictionaryWithObjectsAndKeys:
                                      guideInfo.token,@"token",
                                      guideInfo.guide_id,@"guide_id",
                                      [self.activityDict objectForKey:@"activity_id"],@"activity_id", nil]
                             WithGet:NO];
    }else{
        self.initSetup = YES;
    }
}

- (void) setUpForInit:(BOOL)aInit{
    if (aInit) {
        self.activityImageAddEditTextView = (AddEditTextView *)[[[NSBundle mainBundle] loadNibNamed:@"AddEditTextView" owner:self options:nil] objectAtIndex:5];
        self.activityImageAddEditTextView.delegate = self;
        [[self.activityImageAddEditTextView.image1Button imageView] setContentMode: UIViewContentModeScaleAspectFit];
        [[self.activityImageAddEditTextView.image2Button imageView] setContentMode: UIViewContentModeScaleAspectFit];
        [[self.activityImageAddEditTextView.image3Button imageView] setContentMode: UIViewContentModeScaleAspectFit];
        
        [self.mScrollView addSubview:self.activityImageAddEditTextView];
        
        self.feeAddEditTextView = (AddEditTextView *)[[[NSBundle mainBundle] loadNibNamed:@"AddEditTextView" owner:self options:nil] objectAtIndex:0];
        self.feeAddEditTextView.delegate = self;
        [self.mScrollView addSubview:self.feeAddEditTextView];
        
        self.feeExtraAddEditTextView = (AddEditTextView *)[[[NSBundle mainBundle] loadNibNamed:@"AddEditTextView" owner:self options:nil] objectAtIndex:0];
        self.feeExtraAddEditTextView.delegate = self;
        [self.mScrollView addSubview:self.feeExtraAddEditTextView];
        
        self.remarkAddEditTextView = (AddEditTextView *)[[[NSBundle mainBundle] loadNibNamed:@"AddEditTextView" owner:self options:nil] objectAtIndex:0];
        self.remarkAddEditTextView.delegate = self;
        [self.mScrollView addSubview:self.remarkAddEditTextView];
        
        if (self.activityDict) {
            if ([[self.activityDict objectForKey:@"image1"] length] > 0){
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                [manager downloadImageWithURL:[NSURL URLWithString:[self.activityDict objectForKey:@"image1"]]
                                      options:0
                                     progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                         // progression tracking code
                                     }
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                        if (image) {
                                            self.activityImageAddEditTextView.image1 = image;
                                            [self.activityImageAddEditTextView.image1Button setImage:image forState:UIControlStateNormal];
                                        }
                                        if (self.isPhotoNewlyAddedForSimilarActivity) {
                                            self.activityImageAddEditTextView.updateImage1 = YES;
                                        }
                                    }];
            }
            if ([[self.activityDict objectForKey:@"image2"] length] > 0){
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                [manager downloadImageWithURL:[NSURL URLWithString:[self.activityDict objectForKey:@"image2"]]
                                      options:0
                                     progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                         // progression tracking code
                                     }
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                        if (image) {
                                            self.activityImageAddEditTextView.image2 = image;
                                            [self.activityImageAddEditTextView.image2Button setImage:image forState:UIControlStateNormal];
                                            if (self.isPhotoNewlyAddedForSimilarActivity) {
                                                self.activityImageAddEditTextView.updateImage2 = YES;
                                            }
                                        }
                                    }];
            }
            if ([[self.activityDict objectForKey:@"image3"] length] > 0){
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                [manager downloadImageWithURL:[NSURL URLWithString:[self.activityDict objectForKey:@"image3"]]
                                      options:0
                                     progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                         // progression tracking code
                                     }
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                        if (image) {
                                            self.activityImageAddEditTextView.image3 = image;
                                            [self.activityImageAddEditTextView.image3Button setImage:image forState:UIControlStateNormal];
                                        }
                                        if (self.isPhotoNewlyAddedForSimilarActivity) {
                                            self.activityImageAddEditTextView.updateImage3 = YES;
                                        }
                                    }];
            }
        }
    }
    
    if (self.activityDict) {
        if ([[self.activityDict objectForKey:@"title"] length] > 0) {
            [self.titleAndTypeAddEditTextView.contentLabel setText:[self.activityDict objectForKey:@"title"]];
            [self setUpLabel:self.titleAndTypeAddEditTextView.contentLabel TextColorWithIsHint:NO];
        }else{
            [self.titleAndTypeAddEditTextView.contentLabel setText:GetStringWithKey(@"default_title")];
        }
    }else{
        [self.titleAndTypeAddEditTextView.contentLabel setText:[self getHintWithType:AddInputTypeTitle]];
    }
    
    if (self.activityDict) {
        [self.titleAndTypeAddEditTextView setTypeWithType:[[self.activityDict objectForKey:@"type"] intValue]
                                                    Color:RemoveColorSign([self.activityDict objectForKey:@"color"])
                                                OtherType:[self.activityDict objectForKey:@"other_type"]];
    }
    
    if (self.activityDict){
        NSString *tempText = [NSString string];
        if ([[self.activityDict objectForKey:@"slogan"] length] > 0) {
            tempText = [self.activityDict objectForKey:@"slogan"];
            
            tempText = [tempText
                        stringByReplacingOccurrencesOfString:@","
                        withString:GetStringWithKey(@"activity_text_seperator")];
            
            self.highlightAddEditTextView.selectedChoice = tempText;
        }
        if ([[self.activityDict objectForKey:@"other_slogan"] length] > 0) {
            self.highlightAddEditTextView.otherChoice = [self.activityDict objectForKey:@"other_slogan"];
            if ([tempText length] > 0) {
                tempText = [tempText stringByAppendingString:GetStringWithKey(@"activity_text_seperator")];
            }
            tempText = [tempText stringByAppendingString:[self.activityDict objectForKey:@"other_slogan"]];
        }
        if ([tempText length] == 0) {
            [self.highlightAddEditTextView.contentLabel setText:[self getHintWithType:AddInputTypeHighlight]];
        }else{
            [self.highlightAddEditTextView.contentLabel setText:tempText];
            [self setUpLabel:self.highlightAddEditTextView.contentLabel TextColorWithIsHint:NO];
        }
    }else{
        [self.highlightAddEditTextView.contentLabel setText:[self getHintWithType:AddInputTypeHighlight]];
    }
    
    
    if (self.activityDict && [[self.activityDict objectForKey:@"toughness"] length] > 0) {
        int star = [[self.activityDict objectForKey:@"toughness"] intValue];
        [self.starAddEditTextView setStarWithStar:star];
    }else{
        [self.starAddEditTextView setStarWithStar:1];
    }
    
    if (self.activityDict && [[self.activityDict objectForKey:@"start_date"] length] > 0) {
        [self.dateTimeAddEditTextView setDateStringWithString:[self.activityDict objectForKey:@"start_date"]];
    }
    if (self.activityDict && [[self.activityDict objectForKey:@"start_time"] length] > 0) {
        [self.dateTimeAddEditTextView setTimeWithTimeString:[self.activityDict objectForKey:@"start_time"]];
    }
    
    if (self.activityDict && [[self.activityDict objectForKey:@"min_ppl"] length] > 0) {
        int min = [[self.activityDict objectForKey:@"min_ppl"] intValue];
        if (min > 0) {
            [self.peopleAddEditTextView.minTextField setText:[self.activityDict objectForKey:@"min_ppl"]];
        }
    }
    
    BOOL unlimit = [[self.activityDict objectForKey:@"unlimit_ppl"] boolValue];
    if (self.activityDict && unlimit) {
        self.peopleAddEditTextView.unlimit = unlimit;
        [self.peopleAddEditTextView setUnlimitWithUnlimit:unlimit];
    }else if (self.activityDict && [[self.activityDict objectForKey:@"max_ppl"] length] > 0) {
        int max = [[self.activityDict objectForKey:@"max_ppl"] intValue];
        if (max > 0) {
            [self.peopleAddEditTextView.maxTextField setText:[self.activityDict objectForKey:@"max_ppl"]];
        }
    }
    
    if (self.activityDict) {
        BOOL isOversea = [[self.activityDict objectForKey:@"oversea"] boolValue];
        if (isOversea) {
            [self.addressAddEditTextView right:nil];
        }else{
            [self.addressAddEditTextView left:nil];
        }
        
        [self.addressAddEditTextView.detailAddressLabel setText:[self.activityDict objectForKey:@"venue"]];
        [self setUpLabel:self.addressAddEditTextView.detailAddressLabel TextColorWithIsHint:[[self.activityDict objectForKey:@"venue"] length] == 0];
        
        AddressManager *tempManager = [AddressManager new];
        if ([[self.activityDict objectForKey:@"province"] length] > 0) {
            self.addressAddEditTextView.provinceDataSource.currentRow = [tempManager getProvinceIdWithName:[self.activityDict objectForKey:@"province"]];
            [self.addressAddEditTextView.provinceTextView setText:[self.activityDict objectForKey:@"province"]];
        }
        if ([[self.activityDict objectForKey:@"city"] length] > 0) {
            self.addressAddEditTextView.cityDataSource.currentRow = [tempManager getCityIdWithProvince:[self.activityDict objectForKey:@"province"] WithCity:[self.activityDict objectForKey:@"city"]];
            [self.addressAddEditTextView.cityTextView setText:[self.activityDict objectForKey:@"city"]];
        }
        if ([[self.activityDict objectForKey:@"area"] length] > 0) {
            self.addressAddEditTextView.areaDataSource.currentRow = [tempManager getAreaIdWithProvince:[self.activityDict objectForKey:@"province"] WithCity:[self.activityDict objectForKey:@"city"] WithArea:[self.activityDict objectForKey:@"area"]];
            [self.addressAddEditTextView.areaTextView setText:[self.activityDict objectForKey:@"area"]];
        }
    }
    
    if (aInit) {
        self.journeyTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        [self.journeyTitleView setBackgroundColor:YELLOW_PANTUO];
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        [tempLabel setText:GetStringWithKey(@"day_plan")];
        [tempLabel setTextAlignment:NSTextAlignmentCenter];
        [self.journeyTitleView addSubview:tempLabel];
        [self.mScrollView addSubview:self.journeyTitleView];
        
        self.dayActivityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        [self.mScrollView addSubview:self.dayActivityView];
        
        self.fullDayActivityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.fullDayActivityButton setFrame:CGRectMake(104, 8, 88, 34)];
        [self.fullDayActivityButton setBackgroundImage:[UIImage imageNamed:@"btn_on_wholeday_event.png"] forState:UIControlStateNormal];
        [self.fullDayActivityButton addTarget:self action:@selector(fullDay) forControlEvents:UIControlEventTouchUpInside];
        [self.dayActivityView addSubview:self.fullDayActivityButton];
        
        self.halfDayActivityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.halfDayActivityButton setFrame:CGRectMake(8, 8, 88, 34)];
        [self.halfDayActivityButton setBackgroundImage:[UIImage imageNamed:@"btn_off_today_event.png"] forState:UIControlStateNormal];
        [self.halfDayActivityButton addTarget:self action:@selector(halfDay) forControlEvents:UIControlEventTouchUpInside];
        [self.dayActivityView addSubview:self.halfDayActivityButton];
    }
    
    if (self.activityDict && [[self.activityDict objectForKey:@"plan"] count] > 0) {
        NSArray *tempArray = [self.activityDict objectForKey:@"plan"];
        for (int i = 0; i < [tempArray count]; i ++) {
            
            NSDictionary *tempDict = [tempArray objectAtIndex:i];
            
            NSString *planId = [tempDict objectForKey:@"plan_id"];
            int start = [[tempDict objectForKey:@"from_day"] intValue];
            int end = [[tempDict objectForKey:@"to_day"] intValue];
            NSString *theme = [tempDict objectForKey:@"theme"];
            NSString *venue = [tempDict objectForKey:@"venue"];
            NSString *detail = [tempDict objectForKey:@"detail"];
            NSString *image1 = [tempDict objectForKey:@"image1"];
            NSString *image2 = [tempDict objectForKey:@"image2"];
            NSString *image3 = [tempDict objectForKey:@"image3"];
            
            AddEditTextView *tempJourneyAddEditTextView;
            if (aInit) {
                tempJourneyAddEditTextView = (AddEditTextView *)[[[NSBundle mainBundle] loadNibNamed:@"AddEditTextView" owner:self options:nil] objectAtIndex:7];
                [[tempJourneyAddEditTextView.image1Button imageView] setContentMode:UIViewContentModeScaleAspectFit];
                [[tempJourneyAddEditTextView.image2Button imageView] setContentMode:UIViewContentModeScaleAspectFit];
                [[tempJourneyAddEditTextView.image3Button imageView] setContentMode:UIViewContentModeScaleAspectFit];
                if (i == 0){
                    [tempJourneyAddEditTextView.topSeparateView setHidden:YES];
                    [tempJourneyAddEditTextView.removeTripButton setHidden:YES];
                    
                    if ([[self.activityDict objectForKey:@"is_half_day_activity"] boolValue]) {
                        [tempJourneyAddEditTextView setEndDateEnable:NO];
                    }
                }
                tempJourneyAddEditTextView.delegate = self;
                [self initJourneyAddEditTextViewText:tempJourneyAddEditTextView];
                if ([theme length] > 0) {
                    [tempJourneyAddEditTextView.themeContentLabel setText:theme];
                    [self setUpLabel:tempJourneyAddEditTextView.themeContentLabel TextColorWithIsHint:NO];
                }
                if ([venue length] > 0) {
                    [tempJourneyAddEditTextView.venueContentLabel setText:venue];
                    [self setUpLabel:tempJourneyAddEditTextView.venueContentLabel TextColorWithIsHint:NO];
                }
                if ([detail length] > 0) {
                    [tempJourneyAddEditTextView.detailContentLabel setText:detail];
                    [self setUpLabel:tempJourneyAddEditTextView.detailContentLabel TextColorWithIsHint:NO];
                }
                if ([image1 length] > 0) {
                    SDWebImageManager *manager = [SDWebImageManager sharedManager];
                    [manager downloadImageWithURL:[NSURL URLWithString:image1]
                                          options:0
                                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                             // progression tracking code
                                         }
                                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                            if (image) {
                                                tempJourneyAddEditTextView.image1 = image;
                                                [tempJourneyAddEditTextView.image1Button setImage:image forState:UIControlStateNormal];
                                                if (self.isPhotoNewlyAddedForSimilarActivity) {
                                                    tempJourneyAddEditTextView.updateImage1 = YES;
                                                }
                                            }
                                        }];
                }
                if ([image2 length] > 0) {
                    SDWebImageManager *manager = [SDWebImageManager sharedManager];
                    [manager downloadImageWithURL:[NSURL URLWithString:image2]
                                          options:0
                                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                             // progression tracking code
                                         }
                                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                            if (image) {
                                                tempJourneyAddEditTextView.image2 = image;
                                                [tempJourneyAddEditTextView.image2Button setImage:image forState:UIControlStateNormal];
                                                if (self.isPhotoNewlyAddedForSimilarActivity) {
                                                    tempJourneyAddEditTextView.updateImage2 = YES;
                                                }
                                            }
                                        }];
                }
                if ([image3 length] > 0) {
                    SDWebImageManager *manager = [SDWebImageManager sharedManager];
                    [manager downloadImageWithURL:[NSURL URLWithString:image3]
                                          options:0
                                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                             // progression tracking code
                                         }
                                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                            if (image) {
                                                tempJourneyAddEditTextView.image3 = image;
                                                [tempJourneyAddEditTextView.image3Button setImage:image forState:UIControlStateNormal];
                                                if (self.isPhotoNewlyAddedForSimilarActivity) {
                                                    tempJourneyAddEditTextView.updateImage3 = YES;
                                                }
                                            }
                                        }];
                }
            }else{
                tempJourneyAddEditTextView = [self.journeyAddEditTextViewArray objectAtIndex:i];
            }
            if (!self.isCreateNewActivity) {
                tempJourneyAddEditTextView.planId = planId;
            }
            [tempJourneyAddEditTextView setStartAndEndDateWithStart:start WithEnd:end];
            if (aInit) {
                [self.mScrollView addSubview:tempJourneyAddEditTextView];
                [self.journeyAddEditTextViewArray addObject:tempJourneyAddEditTextView];
            }
        }
    }else{
        AddEditTextView *tempJourneyAddEditTextView = (AddEditTextView *)[[[NSBundle mainBundle] loadNibNamed:@"AddEditTextView" owner:self options:nil] objectAtIndex:7];
        tempJourneyAddEditTextView.delegate = self;
        [tempJourneyAddEditTextView.topSeparateView setHidden:YES];
        [tempJourneyAddEditTextView.removeTripButton setHidden:YES];
        [self initJourneyAddEditTextViewText:tempJourneyAddEditTextView];
        [tempJourneyAddEditTextView setStartAndEndDateWithStart:1 WithEnd:1];
        [self.mScrollView addSubview:tempJourneyAddEditTextView];
        [self.journeyAddEditTextViewArray addObject:tempJourneyAddEditTextView];
    }
    
    if (aInit) {
        self.addJourneyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.addJourneyButton setBackgroundColor:YELLOW_PANTUO];
        [self.addJourneyButton setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-83)/2, 16, 83, 17)];
        UIImage *tempImage = [UIImage imageNamed:@"btn_on_trip_schdeule.png"];
        [tempImageView setImage:tempImage];
        [self.addJourneyButton addTarget:self action:@selector(addJourney) forControlEvents:UIControlEventTouchUpInside];
        [self.addJourneyButton addSubview:tempImageView];
        [self.mScrollView addSubview:self.addJourneyButton];
        
        self.attentionAddEditTextView = (AddEditTextView *)[[[NSBundle mainBundle] loadNibNamed:@"AddEditTextView" owner:self options:nil] objectAtIndex:0];
        self.attentionAddEditTextView.delegate = self;
        [self.mScrollView addSubview:self.attentionAddEditTextView];
        
        self.equipmentAddEditTextView = (AddEditTextView *)[[[NSBundle mainBundle] loadNibNamed:@"AddEditTextView" owner:self options:nil] objectAtIndex:0];
        self.equipmentAddEditTextView.delegate = self;
        [self.mScrollView addSubview:self.equipmentAddEditTextView];
        
        int interval = 0;
        int y = self.addressAddEditTextView.frame.origin.y + self.addressAddEditTextView.frame.size.height;
        CGRect tempFrame;
        
        tempFrame = self.activityImageAddEditTextView.frame;
        tempFrame.origin.y = y ;
        tempFrame.size.width = SCREEN_WIDTH;
        [self.activityImageAddEditTextView setFrame:tempFrame];
        y += self.activityImageAddEditTextView.frame.size.height + interval;
        
        tempFrame = self.feeAddEditTextView.frame;
        tempFrame.origin.y = y ;
        tempFrame.size.width = SCREEN_WIDTH;
        [self.feeAddEditTextView setFrame:tempFrame];
        y += self.feeAddEditTextView.frame.size.height + interval;
        
        tempFrame = self.feeExtraAddEditTextView.frame;
        tempFrame.origin.y = y ;
        tempFrame.size.width = SCREEN_WIDTH;
        [self.feeExtraAddEditTextView setFrame:tempFrame];
        y += self.feeExtraAddEditTextView.frame.size.height + interval;
        
        tempFrame = self.remarkAddEditTextView.frame;
        tempFrame.origin.y = y ;
        tempFrame.size.width = SCREEN_WIDTH;
        [self.remarkAddEditTextView setFrame:tempFrame];
        y += self.remarkAddEditTextView.frame.size.height + interval;
        
        tempFrame = self.journeyTitleView.frame;
        tempFrame.origin.y = y ;
        tempFrame.size.width = SCREEN_WIDTH;
        [self.journeyTitleView setFrame:tempFrame];
        y += self.journeyTitleView.frame.size.height;
        
        tempFrame = self.dayActivityView.frame;
        tempFrame.origin.y = y ;
        tempFrame.size.width = SCREEN_WIDTH;
        [self.dayActivityView setFrame:tempFrame];
        y += self.dayActivityView.frame.size.height + interval;
        
        for (AddEditTextView *tempView in self.journeyAddEditTextViewArray) {
            tempFrame = tempView.frame;
            tempFrame.origin.y = y ;
            tempFrame.size.width = SCREEN_WIDTH;
            [tempView setFrame:tempFrame];
            y += tempView.frame.size.height + interval;
        }
        
        tempFrame = self.addJourneyButton.frame;
        tempFrame.origin.y = y ;
        tempFrame.size.width = SCREEN_WIDTH;
        [self.addJourneyButton setFrame:tempFrame];
        y += self.addJourneyButton.frame.size.height + interval;
        
        tempFrame = self.attentionAddEditTextView.frame;
        tempFrame.origin.y = y ;
        tempFrame.size.width = SCREEN_WIDTH;
        [self.attentionAddEditTextView setFrame:tempFrame];
        y += self.attentionAddEditTextView.frame.size.height + interval;
        
        tempFrame = self.equipmentAddEditTextView.frame;
        tempFrame.origin.y = y ;
        tempFrame.size.width = SCREEN_WIDTH;
        [self.equipmentAddEditTextView setFrame:tempFrame];
        y += self.equipmentAddEditTextView.frame.size.height + interval;
        
        BOOL canDelete = NO;
        if (self.activityDict && [[self.activityDict objectForKey:@"joined_ppl"] intValue] == 0 && !self.isCreateNewActivity) {
            canDelete = YES;
        }
        
        self.actionButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, canDelete?110:65)];
        [self.actionButtonView setBackgroundColor:ColorWithHexString(@"EEEFF1")];
        [self.mScrollView addSubview:self.actionButtonView];
        
        int leftMargin = (SCREEN_WIDTH-150*2-5)/2;
        self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.saveButton setBackgroundImage:[UIImage imageNamed:@"btn_planning_save.png"] forState:UIControlStateNormal];
        [self.saveButton setTitle:GetStringWithKey(@"save") forState:UIControlStateNormal];
        [self.saveButton setTitleColor:ColorWithHexString(@"4CAF50") forState:UIControlStateNormal];
        [self.saveButton setFrame:CGRectMake(leftMargin, 10, 150, 45)];
        [self.saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        [self.saveButton.layer setCornerRadius:5];
        [self.actionButtonView addSubview:self.saveButton];
        
        self.previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.previewButton setBackgroundImage:[UIImage imageNamed:@"btn_planning_preview.png"] forState:UIControlStateNormal];
        [self.previewButton setTitle:GetStringWithKey(@"preview") forState:UIControlStateNormal];
        [self.previewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.previewButton setFrame:CGRectMake(leftMargin+150+5, 10, 150, 45)];
        [self.previewButton addTarget:self action:@selector(preview) forControlEvents:UIControlEventTouchUpInside];
        [self.previewButton.layer setCornerRadius:5];
        [self.actionButtonView addSubview:self.previewButton];
        
        if (canDelete) {
            self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.deleteButton setBackgroundColor:ColorWithHexString(@"9E9D9D")];
            [self.deleteButton setTitle:GetStringWithKey(@"discard") forState:UIControlStateNormal];
            [self.deleteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.deleteButton setFrame:CGRectMake(0, 65, SCREEN_WIDTH, 45)];
            [self.deleteButton addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
            [self.actionButtonView addSubview:self.deleteButton];
        }
        
        y += self.actionButtonView.frame.size.height + interval;
        
        [self.mScrollView setContentSize:CGSizeMake(self.mScrollView.frame.size.width, y)];
    }
    
    [self.activityImageAddEditTextView setTitle:GetStringWithKey(@"activity_highlight_pics") WithStar:YES];
    [self.activityImageAddEditTextView setTitle2:GetStringWithKey(@"activity_highlight_pics_subtitle") WithStar:NO];
    
    [self.feeAddEditTextView setTitle:[self getTitleWithType:AddInputTypeFee] WithStar:YES];
    if (self.activityDict && [[self.activityDict objectForKey:@"fee"] length] > 0) {
        [self.feeAddEditTextView.contentLabel setText:[self.activityDict objectForKey:@"fee"]];
        [self setUpLabel:self.feeAddEditTextView.contentLabel TextColorWithIsHint:NO];
    }else{
        [self.feeAddEditTextView.contentLabel setText:[self getHintWithType:AddInputTypeFee]];
    }
    
    [self.feeExtraAddEditTextView setTitle:[self getTitleWithType:AddInputTypeFeeDesc] WithStar:NO];
    if (self.activityDict && [[self.activityDict objectForKey:@"fee_desc"] length] > 0) {
        [self.feeExtraAddEditTextView.contentLabel setText:[self.activityDict objectForKey:@"fee_desc"]];
        [self setUpLabel:self.feeExtraAddEditTextView.contentLabel TextColorWithIsHint:NO];
    }else{
        [self.feeExtraAddEditTextView.contentLabel setText:[self getHintWithType:AddInputTypeFeeDesc]];
    }
    
    [self.remarkAddEditTextView setTitle:[self getTitleWithType:AddInputTypeRemark] WithStar:NO];
    if (self.activityDict && [[self.activityDict objectForKey:@"remark"] length] > 0) {
        [self.remarkAddEditTextView.contentLabel setText:[self.activityDict objectForKey:@"remark"]];
        [self setUpLabel:self.remarkAddEditTextView.contentLabel TextColorWithIsHint:NO];
    }else{
        [self.remarkAddEditTextView.contentLabel setText:[self getHintWithType:AddInputTypeRemark]];
    }
    
    if (self.activityDict) {
        if ([[self.activityDict objectForKey:@"is_half_day_activity"] boolValue]) {
            [self halfDay];
        }else{
            [self fullDay];
        }
    }
    
    [self.attentionAddEditTextView setTitle:[self getTitleWithType:AddInputTypeAttention] WithStar:YES];
    if (self.activityDict && [[self.activityDict objectForKey:@"activity_notice"] length] > 0) {
        [self.attentionAddEditTextView.contentLabel setText:[self.activityDict objectForKey:@"activity_notice"]];
        [self setUpLabel:self.attentionAddEditTextView.contentLabel TextColorWithIsHint:NO];
    }else{
        [self.attentionAddEditTextView.contentLabel setText:[self getHintWithType:AddInputTypeAttention]];
    }
    
    [self.equipmentAddEditTextView setTitle:[self getTitleWithType:AddInputTypeEquipment] WithStar:YES];
    if (self.activityDict){
        NSString *tempText = [NSString string];
        if ([[self.activityDict objectForKey:@"equipment"] length] > 0) {
            tempText = [self.activityDict objectForKey:@"equipment"];
            tempText = [tempText
                        stringByReplacingOccurrencesOfString:@","
                        withString:GetStringWithKey(@"activity_text_seperator")];
            self.equipmentAddEditTextView.selectedChoice = tempText;
        }
        if ([[self.activityDict objectForKey:@"other_equipment"] length] > 0) {
            self.equipmentAddEditTextView.otherChoice = [self.activityDict objectForKey:@"other_equipment"];
            if ([tempText length] > 0) {
                tempText = [tempText stringByAppendingString:GetStringWithKey(@"activity_text_seperator")];
            }
            tempText = [tempText stringByAppendingString:[self.activityDict objectForKey:@"other_equipment"]];
        }
        if ([tempText length] == 0) {
            [self.equipmentAddEditTextView.contentLabel setText:[self getHintWithType:AddInputTypeEquipment]];
        }else{
            [self.equipmentAddEditTextView.contentLabel setText:tempText];
            [self setUpLabel:self.equipmentAddEditTextView.contentLabel TextColorWithIsHint:NO];
        }
    }else{
        [self.equipmentAddEditTextView.contentLabel setText:[self getHintWithType:AddInputTypeEquipment]];
    }
    if (self.isCreateNewActivity) {
        self.activityDict = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.isFromPreview && [self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    if (self.initSetup) {
        self.initSetup = NO;
        [self setUpForInit:YES];
    }
    if (self.isFinishInfoDetail) {
        self.isFinishInfoDetail = NO;
        [self preview];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isFromPreview && [self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void) back:(id)sender{
    if ([self isUserChangeDetail]) {
        UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:GetStringWithKey(@"error_activity_quit_without_save")
                                                               delegate:self
                                                      cancelButtonTitle:GetStringWithKey(@"quit_app_neg")
                                                      otherButtonTitles:GetStringWithKey(@"quit_app_pos"), nil];
        [tempAlertView setTag:3];
        [tempAlertView show];
    }else{
        LandingViewController *lvc = (LandingViewController *)[self.navigationController.viewControllers objectAtIndex:1];
        [self.navigationController popToViewController:lvc animated:YES];
    }
}

- (void) doBack{
    LandingViewController *lvc = (LandingViewController *)[self.navigationController.viewControllers objectAtIndex:1];
    [self.navigationController popToViewController:lvc animated:YES];
}


- (void) initJourneyAddEditTextViewText:(AddEditTextView *)tempView{
    [tempView setTheme:[self getTitleWithType:AddInputTypeTheme] WithStar:YES];
    [tempView.venueTitleLabel setText:[self getTitleWithType:AddInputTypeVenue]];
    [tempView.detailTitleLabel setText:[self getTitleWithType:AddInputTypeDetail]];
    [tempView setTitle:GetStringWithKey(@"activity_pics") WithStar:NO];
    [tempView setTitle2:GetStringWithKey(@"activity_highlight_pics_subtitle") WithStar:NO];
    
    [tempView.themeContentLabel setText:[self getHintWithType:AddInputTypeTheme]];
    [tempView.venueContentLabel setText:[self getHintWithType:AddInputTypeVenue]];
    [tempView.detailContentLabel setText:[self getHintWithType:AddInputTypeDetail]];
}

- (void) addJourney{
    if (self.isFullDay) {
        [self logEventWithId:GetStringWithKey(@"Tracking_create_activity_add_plan_id") WithLabel:GetStringWithKey(@"Tracking_create_activity_add_plan")];
        
        AddEditTextView *lastJourney = (AddEditTextView *)[self.journeyAddEditTextViewArray lastObject];
        int interval = 0;
        int y = lastJourney.frame.origin.y + lastJourney.frame.size.height;
        CGRect tempFrame;
        
        AddEditTextView *tempJourneyAddEditTextView = (AddEditTextView *)[[[NSBundle mainBundle] loadNibNamed:@"AddEditTextView" owner:self options:nil] objectAtIndex:7];
        [self initJourneyAddEditTextViewText:tempJourneyAddEditTextView];
        int startDate = lastJourney.endDate+1>100?100:lastJourney.endDate+1;
        [tempJourneyAddEditTextView setStartAndEndDateWithStart:startDate WithEnd:startDate];
        tempJourneyAddEditTextView.delegate = self;
        [self.mScrollView addSubview:tempJourneyAddEditTextView];
        [self.journeyAddEditTextViewArray addObject:tempJourneyAddEditTextView];
        
        tempFrame = tempJourneyAddEditTextView.frame;
        tempFrame.origin.y = y ;
        tempFrame.size.width = SCREEN_WIDTH;
        [tempJourneyAddEditTextView setFrame:tempFrame];
        y += tempJourneyAddEditTextView.frame.size.height + interval;
        
        tempFrame = self.addJourneyButton.frame;
        tempFrame.origin.y = y ;
        tempFrame.size.width = SCREEN_WIDTH;
        [self.addJourneyButton setFrame:tempFrame];
        y += self.addJourneyButton.frame.size.height + interval;
        
        tempFrame = self.attentionAddEditTextView.frame;
        tempFrame.origin.y = y ;
        tempFrame.size.width = SCREEN_WIDTH;
        [self.attentionAddEditTextView setFrame:tempFrame];
        y += self.attentionAddEditTextView.frame.size.height + interval;
        
        tempFrame = self.equipmentAddEditTextView.frame;
        tempFrame.origin.y = y ;
        tempFrame.size.width = SCREEN_WIDTH;
        [self.equipmentAddEditTextView setFrame:tempFrame];
        y += self.equipmentAddEditTextView.frame.size.height + interval;
        
        tempFrame = self.actionButtonView.frame;
        tempFrame.origin.y = y ;

        [self.actionButtonView setFrame:tempFrame];
        y += self.actionButtonView.frame.size.height + interval;
        
        [self.mScrollView setContentSize:CGSizeMake(self.mScrollView.frame.size.width, y)];
    }
}

- (void) fullDay{
    if (!self.isFullDay) {
        self.isFullDay = YES;
        [self.fullDayActivityButton setBackgroundImage:[UIImage imageNamed:@"btn_on_wholeday_event.png"] forState:UIControlStateNormal];
        [self.halfDayActivityButton setBackgroundImage:[UIImage imageNamed:@"btn_off_today_event.png"] forState:UIControlStateNormal];
        
        AddEditTextView *tempJourneyAddEditTextView = [self.journeyAddEditTextViewArray objectAtIndex:0];
        [tempJourneyAddEditTextView setEndDateEnable:YES];
    }
}

- (void) halfDay{
    if (self.isFullDay && [self.journeyAddEditTextViewArray count] == 1) {
        
        AddEditTextView *tempJourneyAddEditTextView = [self.journeyAddEditTextViewArray objectAtIndex:0];
        [tempJourneyAddEditTextView setStartAndEndDateWithStart:1 WithEnd:1];
        
        [tempJourneyAddEditTextView setEndDateEnable:NO];
        
        self.isFullDay = NO;
        [self.fullDayActivityButton setBackgroundImage:[UIImage imageNamed:@"btn_off_wholeday_event.png"] forState:UIControlStateNormal];
        [self.halfDayActivityButton setBackgroundImage:[UIImage imageNamed:@"btn_on_today_event.png"] forState:UIControlStateNormal];
    }
}

- (BOOL) isUserChangeDetail{
    BOOL isChange = NO;
    
    if (self.activityDict) {
        if ([self isUserChangePreviousDetail]) {
            isChange = YES;
        }
    }else if ([self isUserChangeOneDetail]){
        isChange = YES;
    }
    return isChange;
}

- (BOOL) isUserChangeOneDetail{
    BOOL isChange = NO;
    
    if (!(self.titleAndTypeAddEditTextView.color.length == 0 || (self.titleAndTypeAddEditTextView.type <= 0 && self.titleAndTypeAddEditTextView.otherType.length == 0))){
        isChange = YES;
    }else if (![self.titleAndTypeAddEditTextView.contentLabel.text isEqualToString:[self getHintWithType:AddInputTypeTitle]]) {
        isChange = YES;
    }else if (![self.highlightAddEditTextView.contentLabel.text isEqualToString:[self getHintWithType:AddInputTypeHighlight]]) {
        isChange = YES;
    }else if (self.starAddEditTextView.star > 1) {
        isChange = YES;
    }else if (self.peopleAddEditTextView.minTextField.text.length > 0) {
        isChange = YES;
    }else if (self.peopleAddEditTextView.unlimit || self.peopleAddEditTextView.maxTextField.text.length > 0) {
        isChange = YES;
    }else if (self.addressAddEditTextView.leftRightSelection == 1 &&
              (self.addressAddEditTextView.provinceDataSource.currentRow != -1 ||
               self.addressAddEditTextView.cityDataSource.currentRow != -1 ||
               self.addressAddEditTextView.areaDataSource.currentRow != -1)
              ) {
        isChange = YES;
    }else if (![self.addressAddEditTextView.detailAddressLabel.text isEqualToString:[self getHintWithType:AddInputTypeDetailAddress]]){
        isChange = YES;
    }else if (self.activityImageAddEditTextView.image1 || self.activityImageAddEditTextView.image2 || self.activityImageAddEditTextView.image3) {
        isChange = YES;
    }else if (![self.feeAddEditTextView.contentLabel.text isEqualToString:[self getHintWithType:AddInputTypeFee]]) {
        isChange = YES;
    }else if (![self.feeExtraAddEditTextView.contentLabel.text isEqualToString:[self getHintWithType:AddInputTypeFeeDesc]]) {
        isChange = YES;
    }else if (![self.remarkAddEditTextView.contentLabel.text isEqualToString:[self getHintWithType:AddInputTypeRemark]]) {
        isChange = YES;
    }else if ([self.journeyAddEditTextViewArray count] > 1){
        isChange = YES;
    }else if (!self.isFullDay){
        isChange = YES;
    }else{
        AddEditTextView *tempView = [self.journeyAddEditTextViewArray objectAtIndex:0];
        if (![tempView.themeContentLabel.text isEqualToString:[self getHintWithType:AddInputTypeTheme]]) {
            isChange = YES;
        }else if (![tempView.venueContentLabel.text isEqualToString:[self getHintWithType:AddInputTypeVenue]]) {
            isChange = YES;
        }else if (![tempView.detailContentLabel.text isEqualToString:[self getHintWithType:AddInputTypeDetail]]) {
            isChange = YES;
        }else if (tempView.image1 || tempView.image2 || tempView.image3) {
            isChange = YES;
        }else if (tempView.endDate != 1){
            isChange = YES;
        }
    }
    
    if (!isChange) {
        if (![self.attentionAddEditTextView.contentLabel.text isEqualToString:[self getHintWithType:AddInputTypeAttention]]) {
            isChange = YES;
        }else if (![self.equipmentAddEditTextView.contentLabel.text isEqualToString:[self getHintWithType:AddInputTypeEquipment]]) {
            isChange = YES;
        }
    }
    
    return isChange;
}

- (BOOL) isUserChangePreviousDetail{
    BOOL isChange = NO;
    
    NSString *choosenColor = [@"#" stringByAppendingString:self.titleAndTypeAddEditTextView.color];
    if (choosenColor.length != [[self.activityDict objectForKey:@"color"] length]) {
        isChange = YES;
    }else if ([[self.activityDict objectForKey:@"color"] length] > 0){
        if (![choosenColor isEqualToString:[self.activityDict objectForKey:@"color"]]){
            isChange = YES;
        }
    }
    
    if (!isChange) {
        if (self.titleAndTypeAddEditTextView.type != [[self.activityDict objectForKey:@"type"] intValue]){
            isChange = YES;
        }else if (![self.titleAndTypeAddEditTextView.otherType isEqualToString:[self.activityDict objectForKey:@"other_type"]]){
            isChange = YES;
        }
    }
    
    if (!isChange) {
        NSString *selectedChoice = [self.highlightAddEditTextView.selectedChoice
                                    stringByReplacingOccurrencesOfString:GetStringWithKey(@"activity_text_seperator")
                                    withString:@","];
        if (![selectedChoice isEqualToString:[self.activityDict objectForKey:@"slogan"]]) {
            isChange = YES;
        }else if (![self.highlightAddEditTextView.otherChoice isEqualToString:[self.activityDict objectForKey:@"other_slogan"]]){
            isChange = YES;
        }else{
            if ([[self.activityDict objectForKey:@"toughness"] length] > 0) {
                int star = [[self.activityDict objectForKey:@"toughness"] intValue];
                if (star != self.starAddEditTextView.star) {
                    isChange = YES;
                }
            }else{
                isChange = YES;
            }
        }
    }
    
    if (!isChange) {
        NSString *min = self.peopleAddEditTextView.minTextField.text.length == 0 ?@"0":self.peopleAddEditTextView.minTextField.text;
        NSString *max = self.peopleAddEditTextView.maxTextField.text.length == 0 ?@"0":self.peopleAddEditTextView.maxTextField.text;
        if (![min isEqualToString:[self.activityDict objectForKey:@"min_ppl"]]) {
            isChange = YES;
        }else if (self.peopleAddEditTextView.unlimit != [[self.activityDict objectForKey:@"unlimit_ppl"] boolValue]){
            isChange = YES;
        }else if (!self.peopleAddEditTextView.unlimit){
            if (![max isEqualToString:[self.activityDict objectForKey:@"max_ppl"]]) {
                isChange = YES;
            }
        }
    }
    
    BOOL isOversea = self.addressAddEditTextView.leftRightSelection != 1;
    if (isOversea != [[self.activityDict objectForKey:@"oversea"] boolValue]) {
        isChange = YES;
    }else if (self.isFullDay == [[self.activityDict objectForKey:@"is_half_day_activity"] boolValue]){
        isChange = YES;
    }else if (self.activityImageAddEditTextView.updateImage1 || self.activityImageAddEditTextView.updateImage2 || self.activityImageAddEditTextView.updateImage3) {
        isChange = YES;
    }
    
    if (!isChange) {
        if ([self isCurrentText:self.titleAndTypeAddEditTextView.contentLabel.text
        DifferentToPreviousText:[self.activityDict objectForKey:@"title"]
                       WithHint:[self getHintWithType:AddInputTypeTitle]]){
            isChange = YES;
        }else if ([self isCurrentText:self.feeAddEditTextView.contentLabel.text
              DifferentToPreviousText:[self.activityDict objectForKey:@"fee"]
                             WithHint:[self getHintWithType:AddInputTypeFee]]){
            isChange = YES;
        }else if ([self isCurrentText:self.feeExtraAddEditTextView.contentLabel.text
              DifferentToPreviousText:[self.activityDict objectForKey:@"fee_desc"]
                             WithHint:[self getHintWithType:AddInputTypeFeeDesc]]){
            isChange = YES;
        }else if ([self isCurrentText:self.remarkAddEditTextView.contentLabel.text
              DifferentToPreviousText:[self.activityDict objectForKey:@"remark"]
                             WithHint:[self getHintWithType:AddInputTypeRemark]]){
            isChange = YES;
        }else if ([self isCurrentText:self.addressAddEditTextView.detailAddressLabel.text
              DifferentToPreviousText:[self.activityDict objectForKey:@"venue"]
                             WithHint:[self getHintWithType:AddInputTypeDetailAddress]]){
            isChange = YES;
        }else if ([self isCurrentText:self.attentionAddEditTextView.contentLabel.text
              DifferentToPreviousText:[self.activityDict objectForKey:@"activity_notice"]
                             WithHint:[self getHintWithType:AddInputTypeAttention]]){
            isChange = YES;
        }
    }
    
    NSString *equipment = [self.equipmentAddEditTextView.selectedChoice
                           stringByReplacingOccurrencesOfString:GetStringWithKey(@"activity_text_seperator")
                           withString:@","];
    if (![equipment isEqualToString:[self.activityDict objectForKey:@"equipment"]]) {
        isChange = YES;
    }else if (![self.equipmentAddEditTextView.otherChoice isEqualToString:[self.activityDict objectForKey:@"other_equipment"]]){
        isChange = YES;
    }
    
    NSString *province = @"";
    NSString *city = @"";
    NSString *area = @"";
    if (![self.addressAddEditTextView.provinceTextView.text isEqualToString:GetStringWithKey(@"province")]) {
        province = self.addressAddEditTextView.provinceTextView.text;
    }
    if (![self.addressAddEditTextView.cityTextView.text isEqualToString:GetStringWithKey(@"city")]) {
        city = self.addressAddEditTextView.cityTextView.text;
    }
    if (![self.addressAddEditTextView.areaTextView.text isEqualToString:GetStringWithKey(@"district")]) {
        area = self.addressAddEditTextView.areaTextView.text;
    }
    
    if (![province isEqualToString:[self.activityDict objectForKey:@"province"]]) {
        isChange = YES;
    }else if (![city isEqualToString:[self.activityDict objectForKey:@"city"]]) {
        isChange = YES;
    }else if (![area isEqualToString:[self.activityDict objectForKey:@"area"]]) {
        isChange = YES;
    }else if (![self.dateTimeAddEditTextView.dateString isEqualToString:[self.activityDict objectForKey:@"start_date"]]){
        isChange = YES;
    }else if (![self.dateTimeAddEditTextView.timeString isEqualToString:[self.activityDict objectForKey:@"start_time"]]){
        isChange = YES;
    }
    
    if (!isChange) {
        int previousPlan = (int)[[self.activityDict objectForKey:@"plan"] count];
        int currentPlan = (int)[self.journeyAddEditTextViewArray count];
        if (previousPlan == 0 && currentPlan == 1) {
            AddEditTextView *tempView = [self.journeyAddEditTextViewArray objectAtIndex:0];
            if (tempView.startDate == 1 &&
                tempView.endDate == 1 &&
                [tempView.themeContentLabel.text isEqualToString:[self getHintWithType:AddInputTypeTheme]] &&
                [tempView.venueContentLabel.text isEqualToString:[self getHintWithType:AddInputTypeVenue]] &&
                [tempView.detailContentLabel.text isEqualToString:[self getHintWithType:AddInputTypeDetail]] &&
                !tempView.updateImage1 && !tempView.updateImage2 && !tempView.updateImage3) {
                isChange = NO;
            }else{
                isChange = YES;
            }
        }else if (previousPlan == currentPlan) {
            for (int i = 0; i < [self.journeyAddEditTextViewArray count]; i++) {
                AddEditTextView *tempView = [self.journeyAddEditTextViewArray objectAtIndex:i];
                NSDictionary *tempDict = [[self.activityDict objectForKey:@"plan"] objectAtIndex:i];
                
                if (![tempDict objectForKey:@"plan_id"]) {
                    isChange = YES;
                    break;
                }else{
                    if (tempView.startDate != [[tempDict objectForKey:@"from_day"] intValue]) {
                        isChange = YES;
                    }else if (tempView.endDate != [[tempDict objectForKey:@"to_day"] intValue]){
                        isChange = YES;
                    }else if ([self isCurrentText:tempView.themeContentLabel.text
                          DifferentToPreviousText:[tempDict objectForKey:@"theme"]
                                         WithHint:[self getHintWithType:AddInputTypeTheme]]){
                        isChange = YES;
                    }else if ([self isCurrentText:tempView.venueContentLabel.text
                          DifferentToPreviousText:[tempDict objectForKey:@"venue"]
                                         WithHint:[self getHintWithType:AddInputTypeVenue]]){
                        isChange = YES;
                    }else if ([self isCurrentText:tempView.detailContentLabel.text
                          DifferentToPreviousText:[tempDict objectForKey:@"detail"]
                                         WithHint:[self getHintWithType:AddInputTypeDetail]]){
                        isChange = YES;
                    }else if (tempView.updateImage1 || tempView.updateImage2 || tempView.updateImage3){
                        isChange = YES;
                    }
                }
            }
        }else{
            isChange = YES;
        }
    }
    
    return isChange;
}

- (BOOL) isCurrentText:(NSString *)aCurrentText DifferentToPreviousText:(NSString *)aPreviousText WithHint:(NSString *)aHintText{
    BOOL isDifferent = NO;
    if ([aCurrentText isEqualToString:aHintText] || [aCurrentText isEqualToString:GetStringWithKey(@"default_title")]) {
        if (aPreviousText.length > 0){
            isDifferent = YES;
        }
    }else if(![aCurrentText isEqualToString:aPreviousText]){
        isDifferent = YES;
    }
    
    return isDifferent;
}

- (BOOL) isUserInputAll{
    NSString *message = [NSString string];
    if (self.titleAndTypeAddEditTextView.color.length == 0 || (self.titleAndTypeAddEditTextView.type <= 0 && self.titleAndTypeAddEditTextView.otherType.length == 0)){
        message = GetStringWithKey(@"error_activity_type");
        self.errorY = self.titleAndTypeAddEditTextView.frame.origin.y;
    }else if ([self.titleAndTypeAddEditTextView.contentLabel.text isEqualToString:[self getHintWithType:AddInputTypeTitle]] ||
              [self.titleAndTypeAddEditTextView.contentLabel.text isEqualToString:GetStringWithKey(@"default_title")]) {
        message = GetStringWithKey(@"error_activity_theme");
        self.errorY = self.titleAndTypeAddEditTextView.frame.origin.y;
    }else if ([self.highlightAddEditTextView.contentLabel.text isEqualToString:[self getHintWithType:AddInputTypeHighlight]]) {
        message = GetStringWithKey(@"error_activity_hightlight");
        self.errorY = self.highlightAddEditTextView.frame.origin.y;
    }else if (self.starAddEditTextView.star <= 0) {
        message = GetStringWithKey(@"error_activity_strength");
        self.errorY = self.starAddEditTextView.frame.origin.y;
    }else if (self.peopleAddEditTextView.minTextField.text.length == 0) {
        message = GetStringWithKey(@"error_activity_participants_min_num");
        self.errorY = self.peopleAddEditTextView.frame.origin.y;
    }else if (!self.peopleAddEditTextView.unlimit && self.peopleAddEditTextView.maxTextField.text.length == 0) {
        message = GetStringWithKey(@"error_activity_participants_max_num");
        self.errorY = self.peopleAddEditTextView.frame.origin.y;
    }else if (self.peopleAddEditTextView.minTextField.text.length > 0 && self.peopleAddEditTextView.maxTextField.text.length > 0 &&
              [self.peopleAddEditTextView.minTextField.text intValue] > [self.peopleAddEditTextView.maxTextField.text intValue]){
        message = GetStringWithKey(@"error_activity_participants_min_more_than_max_num");
        self.errorY = self.peopleAddEditTextView.frame.origin.y;
    }else if (self.addressAddEditTextView.leftRightSelection == 1){
        if (self.addressAddEditTextView.provinceDataSource.currentRow == -1) {
            message = GetStringWithKey(@"error_activity_place");
            self.errorY = self.addressAddEditTextView.frame.origin.y;
        }else{
            int city = self.addressAddEditTextView.cityDataSource.currentRow;
            int area = self.addressAddEditTextView.areaDataSource.currentRow;
            AddressManager *tempAddressManager = [AddressManager new];
            if ([tempAddressManager hasCityInProvince:self.addressAddEditTextView.provinceDataSource.currentRow] && city == -1) {
                message = GetStringWithKey(@"error_activity_place");
                self.errorY = self.addressAddEditTextView.frame.origin.y;
            }else if ([tempAddressManager hasAreaInProvince:self.addressAddEditTextView.provinceDataSource.currentRow] && area == -1) {
                message = GetStringWithKey(@"error_activity_place");
                self.errorY = self.addressAddEditTextView.frame.origin.y;
            }
        }
    }else if (self.addressAddEditTextView.detailAddressLabel.text.length == 0 ||
              [self.addressAddEditTextView.detailAddressLabel.text isEqualToString:[self getHintWithType:AddInputTypeDetailAddress]]){
        message = GetStringWithKey(@"error_activity_place");
        self.errorY = self.addressAddEditTextView.frame.origin.y;
    }

    if ([message length] == 0) {
        if (!self.activityImageAddEditTextView.image1 && !self.activityImageAddEditTextView.image2 && !self.activityImageAddEditTextView.image3) {
            if (self.activityDict) {
                if ([[self.activityDict objectForKey:@"image1"] length] == 0 && [[self.activityDict objectForKey:@"image2"] length] == 0 && [[self.activityDict objectForKey:@"image3"] length] == 0) {
                    message = GetStringWithKey(@"error_activity_highlight_pics");
                    self.errorY = self.activityImageAddEditTextView.frame.origin.y;
                }
            }else{
                message = GetStringWithKey(@"error_activity_highlight_pics");
                self.errorY = self.activityImageAddEditTextView.frame.origin.y;
            }
        }
    }
    
    if ([message length] == 0) {
        if ([self.feeAddEditTextView.contentLabel.text isEqualToString:[self getHintWithType:AddInputTypeFee]]) {
            message = GetStringWithKey(@"error_activity_fees");
            self.errorY = self.feeAddEditTextView.frame.origin.y;
        }else{
            for (AddEditTextView *tempView in self.journeyAddEditTextViewArray) {
                if ([tempView.themeContentLabel.text isEqualToString:[self getHintWithType:AddInputTypeTheme]]) {
                    message = GetStringWithKey(@"error_activity_journey_theme");
                    self.errorY = tempView.frame.origin.y;
                }
            }
        }
    }
    
    if ([message length] == 0) {
        if ([self.attentionAddEditTextView.contentLabel.text isEqualToString:[self getHintWithType:AddInputTypeAttention]]) {
            message = GetStringWithKey(@"error_activity_attention");
            self.errorY = self.attentionAddEditTextView.frame.origin.y;
        }else if ([self.equipmentAddEditTextView.contentLabel.text isEqualToString:[self getHintWithType:AddInputTypeEquipment]]) {
            message = GetStringWithKey(@"error_activity_equipment");
            self.errorY = self.equipmentAddEditTextView.frame.origin.y;
        }
    }
    
    if ([message length] > 0) {
        UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:GetStringWithKey(@"confirm") otherButtonTitles:nil];
        [tempAlertView setTag:1];
        [tempAlertView show];
    }
    
    return [message length] == 0;
}

- (NSString *) getTextWithAddEditTextView:(AddEditTextView *)aView WithType:(AddInputType)aType{
    NSString *content = [NSString string];
    NSString *hint = [self getHintWithType:aType];
    UILabel *tempLabel;
    
    if (aType == AddInputTypeTheme) {
        tempLabel = aView.themeContentLabel;
    }else if (aType == AddInputTypeVenue){
        tempLabel = aView.venueContentLabel;
    }else if (aType == AddInputTypeDetail){
        tempLabel = aView.detailContentLabel;
    }else if (aType == AddInputTypeDetailAddress){
        tempLabel = aView.detailAddressLabel;
    }else{
        tempLabel = aView.contentLabel;
    }
    
    if (aType == AddInputTypeTitle) {
        if (!([tempLabel.text isEqualToString:hint] || [tempLabel.text isEqualToString:GetStringWithKey(@"default_title")])){
            content = tempLabel.text;
        }
    }else if (![tempLabel.text isEqualToString:hint]) {
        content = tempLabel.text;
    }
    
    return content;
}

- (NSMutableDictionary *) getSubmitActivityDict{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    
    GuideInfo *tempInfo = [self getGuideInfo];
    [para setObject:tempInfo.token forKey:@"token"];
    [para setObject:tempInfo.guide_id forKey:@"guide_id"];
    if (self.activityDict) {
        [para setObject:[self.activityDict objectForKey:@"activity_id"] forKey:@"activity_id"];
    }
    
    if (self.activityDict) {
        [para setObject:[self.activityDict objectForKey:@"action"] forKey:@"action"];
    }
    
    if (self.titleAndTypeAddEditTextView.color > 0){
        [para setObject:[@"#" stringByAppendingString:self.titleAndTypeAddEditTextView.color] forKey:@"color"];
    }else{
        [para setObject:[NSString string] forKey:@"color"];
    }
    
    if (self.titleAndTypeAddEditTextView.type > 0) {
        [para setObject:[NSString stringWithFormat:@"%d",self.titleAndTypeAddEditTextView.type] forKey:@"type"];
    }else{
        [para setObject:@"0" forKey:@"type"];
    }
    
    [para setObject:self.titleAndTypeAddEditTextView.otherType forKey:@"other_type"];
    [para setObject:[self getTextWithAddEditTextView:self.titleAndTypeAddEditTextView WithType:AddInputTypeTitle] forKey:@"title"];
    
    NSString *selectedChoice = [self.highlightAddEditTextView.selectedChoice
                                stringByReplacingOccurrencesOfString:GetStringWithKey(@"activity_text_seperator")
                                withString:@","];

    [para setObject:selectedChoice forKey:@"slogan"];
    [para setObject:self.highlightAddEditTextView.otherChoice forKey:@"other_slogan"];
    
    [para setObject:self.peopleAddEditTextView.unlimit?@"true":@"false" forKey:@"unlimit_ppl"];
    [para setObject:[self.peopleAddEditTextView.minTextField.text length]==0?@"0":self.peopleAddEditTextView.minTextField.text forKey:@"min_ppl"];
    if (!self.peopleAddEditTextView.unlimit) {
        [para setObject:[self.peopleAddEditTextView.maxTextField.text length] ==0?@"0":self.peopleAddEditTextView.maxTextField.text forKey:@"max_ppl"];
    }
    [para setObject:[self getTextWithAddEditTextView:self.feeAddEditTextView WithType:AddInputTypeFee] forKey:@"fee"];
    [para setObject:[self getTextWithAddEditTextView:self.feeExtraAddEditTextView WithType:AddInputTypeFeeDesc] forKey:@"fee_desc"];
    [para setObject:[self getTextWithAddEditTextView:self.remarkAddEditTextView WithType:AddInputTypeRemark] forKey:@"remark"];
    BOOL isNotOversea = self.addressAddEditTextView.leftRightSelection == 1;
    NSString *oversea = isNotOversea?@"false":@"true";
    [para setObject:oversea forKey:@"oversea"];
    
    [para setObject:[self getTextWithAddEditTextView:self.addressAddEditTextView WithType:AddInputTypeDetailAddress] forKey:@"venue"];
    if (isNotOversea) {
        if ([self.addressAddEditTextView.provinceTextView.text isEqualToString:GetStringWithKey(@"province")]) {
            [para setObject:@"" forKey:@"province"];
        }else{
            [para setObject:self.addressAddEditTextView.provinceTextView.text forKey:@"province"];
        }
        if ([self.addressAddEditTextView.cityTextView.text isEqualToString:GetStringWithKey(@"city")]) {
            [para setObject:@"" forKey:@"city"];
        }else {
            [para setObject:self.addressAddEditTextView.cityTextView.text forKey:@"city"];
        }
        if ([self.addressAddEditTextView.areaTextView.text isEqualToString:GetStringWithKey(@"district")]) {
            [para setObject:@"" forKey:@"area"];
        }else{
            [para setObject:self.addressAddEditTextView.areaTextView.text forKey:@"area"];
        }
    }else{
        [para setObject:@"" forKey:@"province"];
        [para setObject:@"" forKey:@"city"];
        [para setObject:@"" forKey:@"area"];
    }
    
    NSData *tempData;
    if (self.activityImageAddEditTextView.image1 && self.activityImageAddEditTextView.updateImage1) {
        tempData = UIImageJPEGRepresentation(self.activityImageAddEditTextView.image1, 1.0f);
        [para setObject:[Base64 encode:tempData] forKey:@"image1"];
    }else{
        [para setObject:@"" forKey:@"image1"];
    }
    if (self.activityImageAddEditTextView.image2 && self.activityImageAddEditTextView.updateImage2) {
        tempData = UIImageJPEGRepresentation(self.activityImageAddEditTextView.image2, 1.0f);
        [para setObject:[Base64 encode:tempData] forKey:@"image2"];
    }else{
        [para setObject:@"" forKey:@"image2"];
    }
    if (self.activityImageAddEditTextView.image3 && self.activityImageAddEditTextView.updateImage3) {
        tempData = UIImageJPEGRepresentation(self.activityImageAddEditTextView.image3, 1.0f);
        [para setObject:[Base64 encode:tempData] forKey:@"image3"];
    }else{
        [para setObject:@"" forKey:@"image3"];
    }
    
    [para setObject:self.isFullDay?@"false":@"true" forKey:@"is_half_day_activity"];
    [para setObject:self.dateTimeAddEditTextView.dateString forKey:@"start_date"];
    [para setObject:self.dateTimeAddEditTextView.timeString forKey:@"start_time"];
    
    NSDateFormatter *format = [NSDateFormatter new];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDateComponents *tempCompos = [NSDateComponents new];
    tempCompos.day = ((AddEditTextView *)[self.journeyAddEditTextViewArray lastObject]).endDate-1;
    NSDate *tempEndDate = [[NSCalendar currentCalendar] dateByAddingComponents:tempCompos toDate:[format dateFromString:self.dateTimeAddEditTextView.dateString] options:0];
    
    [para setObject:[format stringFromDate:tempEndDate] forKey:@"end_date"];
    [para setObject:[self getTextWithAddEditTextView:self.attentionAddEditTextView WithType:AddInputTypeAttention] forKey:@"activity_notice"];
    
    
    NSString *equipment = [self.equipmentAddEditTextView.selectedChoice
                                stringByReplacingOccurrencesOfString:GetStringWithKey(@"activity_text_seperator")
                                withString:@","];

    [para setObject:equipment forKey:@"equipment"];
    [para setObject:self.equipmentAddEditTextView.otherChoice forKey:@"other_equipment"];
    [para setObject:[NSString stringWithFormat:@"%d",self.starAddEditTextView.star] forKey:@"toughness"];
    
    for (int i = 0; i < [self.journeyAddEditTextViewArray count]; i++) {
        int tag = i+1;
        AddEditTextView *tempView = [self.journeyAddEditTextViewArray objectAtIndex:i];
        
        if (tempView.planId.length > 0) {
            [para setObject:tempView.planId
                     forKey:[NSString stringWithFormat:@"plan_id_%d",tag]];
        }
        [para setObject:[NSString stringWithFormat:@"%d",tempView.startDate]
                 forKey:[NSString stringWithFormat:@"from_day_%d",tag]];
        [para setObject:[NSString stringWithFormat:@"%d",tempView.endDate]
                 forKey:[NSString stringWithFormat:@"to_day_%d",tag]];
        [para setObject:[self getTextWithAddEditTextView:tempView WithType:AddInputTypeTheme]
                 forKey:[NSString stringWithFormat:@"theme_%d",tag]];
        [para setObject:[self getTextWithAddEditTextView:tempView WithType:AddInputTypeVenue]
                 forKey:[NSString stringWithFormat:@"venue_%d",tag]];
        [para setObject:[self getTextWithAddEditTextView:tempView WithType:AddInputTypeDetail]
                 forKey:[NSString stringWithFormat:@"detail_%d",tag]];
        
        NSData *tempData;
        if (tempView.image1 && tempView.updateImage1) {
            tempData = UIImageJPEGRepresentation(tempView.image1, 1.0f);
            [para setObject:[Base64 encode:tempData]
                     forKey:[NSString stringWithFormat:@"image1_%d",tag]];
        }else{
            [para setObject:@"" forKey:[NSString stringWithFormat:@"image1_%d",tag]];
        }
        if (tempView.image2 && tempView.updateImage2) {
            tempData = UIImageJPEGRepresentation(tempView.image2, 1.0f);
            [para setObject:[Base64 encode:tempData]
                     forKey:[NSString stringWithFormat:@"image2_%d",tag]];
        }else{
            [para setObject:@"" forKey:[NSString stringWithFormat:@"image2_%d",tag]];
        }
        if (tempView.image3 && tempView.updateImage3) {
            tempData = UIImageJPEGRepresentation(tempView.image3, 1.0f);
            [para setObject:[Base64 encode:tempData]
             forKey:[NSString stringWithFormat:@"image3_%d",tag]];
        }else{
            [para setObject:@"" forKey:[NSString stringWithFormat:@"image3_%d",tag]];
        }
    }

    return para;
}

- (void) save{
    [self logEventWithId:GetStringWithKey(@"Tracking_create_activity_save_id") WithLabel:GetStringWithKey(@"Tracking_create_activity_save")];
    if (self.activityDict && [[self.activityDict objectForKey:@"joined_ppl"] intValue] > 0) {
        if ([self isUserInputAll]) {
            self.goToPreview = NO;
            NSMutableDictionary *tempDict = [self getSubmitActivityDict];
            NSDictionary *parameters = [NSDictionary dictionaryWithDictionary:tempDict];
            [self callIPOSCSLAPIWithLink:API_ADD_EDIT_ACTIVITY WithParameter:parameters WithGet:NO];
        }
    }else{
        self.goToPreview = NO;
        NSMutableDictionary *tempDict = [self getSubmitActivityDict];
        NSDictionary *parameters = [NSDictionary dictionaryWithDictionary:tempDict];
        [self callIPOSCSLAPIWithLink:API_ADD_EDIT_ACTIVITY WithParameter:parameters WithGet:NO];
    }
}

- (void) preview{
    [self logEventWithId:GetStringWithKey(@"Tracking_create_activity_preview_id") WithLabel:GetStringWithKey(@"Tracking_create_activity_preview")];
    
    if ([self isUserInputAll]){
        if ([[self getGuideInfo] isGuideProfileCompleted]){
            self.goToPreview = YES;
            NSMutableDictionary *tempDict = [self getSubmitActivityDict];
            [tempDict setObject:@"1" forKey:@"preview"];
            NSDictionary *parameters = [NSDictionary dictionaryWithDictionary:tempDict];
            [self callIPOSCSLAPIWithLink:API_ADD_EDIT_ACTIVITY WithParameter:parameters WithGet:NO];
        }else{
            UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:GetStringWithKey(@"error_activity_incomplete_info") delegate:self cancelButtonTitle:GetStringWithKey(@"update_later") otherButtonTitles:GetStringWithKey(@"complete_info"), nil];
            [tempAlertView setTag:4];
            [tempAlertView show];
        }
    }
}

- (void) delete{
    [self logEventWithId:GetStringWithKey(@"Tracking_create_activity_delete_id") WithLabel:GetStringWithKey(@"Tracking_create_activity_delete")];
    UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:GetStringWithKey(@"error_activity_delete") delegate:self cancelButtonTitle:GetStringWithKey(@"quit_app_neg") otherButtonTitles:GetStringWithKey(@"quit_app_pos"),nil];
    [tempAlertView setTag:2];
    [tempAlertView show];
}

- (void) handleResponse:(id)response WithLink:(NSString *)aLink WithRequest:(NSDictionary *)aRequest{
    if ([aLink isEqualToString:API_ADD_EDIT_ACTIVITY]) {
        LandingViewController *lvc = (LandingViewController *)[self.navigationController.viewControllers objectAtIndex:1];
        lvc.refreshView = YES;
        if (self.goToPreview) {
            GuideInfo *guideInfo = [self getGuideInfo];
            [self callIPOSCSLAPIWithLink:API_GET_ACTIVITY_DETAIL
                           WithParameter:[NSDictionary dictionaryWithObjectsAndKeys:
                                          guideInfo.token,@"token",
                                          guideInfo.guide_id,@"guide_id",
                                          [response objectForKey:@"activity_id"],@"activity_id", nil]
                                 WithGet:NO];
            self.addEditActivityResponse = response;
        }else{
            [self.navigationController popToViewController:lvc animated:YES];
        }
    }else if ([aLink isEqualToString:API_DELETE_ACTIVITY]){
        LandingViewController *lvc = (LandingViewController *)[self.navigationController.viewControllers objectAtIndex:1];
        lvc.refreshView = YES;
        [self.navigationController popToViewController:lvc animated:YES];
    }else if ([aLink isEqualToString:API_GET_ACTIVITY_DETAIL]){
        self.activityDict = response;
        [self setUpForInit:!self.goToPreview];
        if (self.goToPreview) {
            NSMutableDictionary *tempDict;
            if (response) {
                tempDict = [NSMutableDictionary dictionaryWithDictionary:response];
            }else{
                tempDict = [NSMutableDictionary dictionary];
            }
            [tempDict setObject:[response objectForKey:@"activity_id"] forKey:@"activity_id"];
            self.activityDict = [NSDictionary dictionaryWithDictionary:tempDict];
            
            PreviewViewController *vc = [PreviewViewController new];
            vc.showEdit = NO;
            vc.useMyActivityTitle = NO;
            vc.activityLink = [response objectForKey:@"activity_link"];
            vc.activityId  = [response objectForKey:@"activity_id"];
            vc.previewLink = [self.addEditActivityResponse objectForKey:@"preview_link"];
            vc.activityTitle = [self getTextWithAddEditTextView:self.titleAndTypeAddEditTextView WithType:AddInputTypeTitle];
            vc.activityImageLink = [self.addEditActivityResponse objectForKey:@"image1"];
            UIImage *tempImage;
            if (self.activityImageAddEditTextView.image1) {
                tempImage = self.activityImageAddEditTextView.image1;
            }else if (self.activityImageAddEditTextView.image2) {
                tempImage = self.activityImageAddEditTextView.image2;
            }else if (self.activityImageAddEditTextView.image3) {
                tempImage = self.activityImageAddEditTextView.image3;
            }
            vc.activityImage = tempImage;
            vc.activityDict = tempDict;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self tapped];
}

- (void) tapped{
    for (UIView *subView in self.mScrollView.subviews) {
        if ([subView isKindOfClass:[AddEditTextView class]]) {
            AddEditTextView *csubview = (AddEditTextView *)subView;
            if ([csubview.minTextField isFirstResponder]) {
                [csubview.minTextField resignFirstResponder];
            }else if ([csubview.maxTextField isFirstResponder]) {
                [csubview.maxTextField resignFirstResponder];
            }else if ([csubview.dateTextField isFirstResponder]) {
                [csubview.dateTextField resignFirstResponder];
            }else if ([csubview.timeTextField isFirstResponder]) {
                [csubview.timeTextField resignFirstResponder];
            }else if ([csubview.provinceTextView isFirstResponder]) {
                [csubview.provinceTextView resignFirstResponder];
            }else if ([csubview.cityTextView isFirstResponder]) {
                [csubview.cityTextView resignFirstResponder];
            }else if ([csubview.areaTextView isFirstResponder]) {
                [csubview.areaTextView resignFirstResponder];
            }else if ([csubview.startTextField isFirstResponder]) {
                [csubview.startTextField resignFirstResponder];
            }else if ([csubview.endTextField isFirstResponder]) {
                [csubview.endTextField resignFirstResponder];
            }
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

- (AddInputType) getAddInputTypeWithAddEditTextView:(AddEditTextView *)aView WithTag:(int)aTag{
    if (aView == self.titleAndTypeAddEditTextView) {
        return AddInputTypeTitle;
    }else if (aView == self.highlightAddEditTextView){
        return AddInputTypeHighlight;
    }else if (aView == self.feeAddEditTextView){
        return AddInputTypeFee;
    }else if (aView == self.feeExtraAddEditTextView){
        return AddInputTypeFeeDesc;
    }else if (aView == self.remarkAddEditTextView){
        return AddInputTypeRemark;
    }else if (aView == self.attentionAddEditTextView){
        return AddInputTypeAttention;
    }else if (aView == self.equipmentAddEditTextView){
        return AddInputTypeEquipment;
    }else if (aTag >= 4){
        self.journeyTagSelected = aTag;
        for (int i = 0 ; i < [self.journeyAddEditTextViewArray count] ; i ++) {
            AddEditTextView *tempView = [self.journeyAddEditTextViewArray objectAtIndex:i];
            if (tempView == aView) {
                self.journeySelected = i;
                break;
            }
        }
        if (aTag == 4){
            return AddInputTypeTheme;
        }else if (aTag == 5){
            return AddInputTypeVenue;
        }else if (aTag == 6){
            return AddInputTypeDetail;
        }
    }
    return AddInputTypeTitle;
}

- (UILabel *) getAddEditTextViewWithAddInputType:(AddInputType)aType WithTag:(int)aTag{
    if (aType == AddInputTypeTitle) {
        return self.titleAndTypeAddEditTextView.contentLabel;
    }else if (aType == AddInputTypeHighlight){
        return self.highlightAddEditTextView.contentLabel;
    }else if (aType == AddInputTypeFee){
        return self.feeAddEditTextView.contentLabel;
    }else if (aType == AddInputTypeFeeDesc){
        return self.feeExtraAddEditTextView.contentLabel;
    }else if (aType == AddInputTypeRemark){
        return self.remarkAddEditTextView.contentLabel;
    }else if (aType == AddInputTypeAttention){
        return self.attentionAddEditTextView.contentLabel;
    }else if (aType == AddInputTypeEquipment){
        return self.equipmentAddEditTextView.contentLabel;
    }else if (aTag >= 4){
        AddEditTextView *tempView = [self.journeyAddEditTextViewArray objectAtIndex:self.journeySelected];
        if (aTag == 4){
            return tempView.themeContentLabel;
        }else if (aTag == 5){
            return tempView.venueContentLabel;
        }else if (aTag == 6){
            return tempView.detailContentLabel;
        }
    }
    
    return nil;
}

- (NSString *) getHintWithType:(AddInputType)aType{
    if (aType == AddInputTypeTitle) {
        return GetStringWithKey(@"activity_title_hint");
    }else if (aType == AddInputTypeHighlight){
        return GetStringWithKey(@"error_activity_hightlight");
    }else if (aType == AddInputTypeFee){
        return GetStringWithKey(@"error_activity_fees");
    }else if (aType == AddInputTypeFeeDesc){
        return GetStringWithKey(@"activity_fee_desc_hint2");
    }else if (aType == AddInputTypeRemark){
        return GetStringWithKey(@"activity_remark_hint");
    }else if (aType == AddInputTypeAttention){
        return GetStringWithKey(@"activity_attention_hint");
    }else if (aType == AddInputTypeEquipment){
        return GetStringWithKey(@"activity_equipment_hint");
    }else if (aType == AddInputTypeTheme){
        return GetStringWithKey(@"error_activity_theme");
    }else if (aType == AddInputTypeVenue){
        return GetStringWithKey(@"activity_venue_hint");
    }else if (aType == AddInputTypeDetail){
        return GetStringWithKey(@"activity_detail_hint");
    }else if (aType == AddInputTypeDetailAddress){
        return GetStringWithKey(@"activity_detail_address_hint");
    }
    
    return [NSString string];
}

- (NSString *) getTitleWithType:(AddInputType)aType{
    if (aType == AddInputTypeTitle) {
        return GetStringWithKey(@"activity_theme");
    }else if (aType == AddInputTypeHighlight){
        return GetStringWithKey(@"activity_hightlight");
    }else if (aType == AddInputTypeFee){
        return GetStringWithKey(@"activity_fees");
    }else if (aType == AddInputTypeFeeDesc){
        return GetStringWithKey(@"activity_fee_desc3");
    }else if (aType == AddInputTypeRemark){
        return GetStringWithKey(@"activity_remark");
    }else if (aType == AddInputTypeAttention){
        return GetStringWithKey(@"activity_attention");
    }else if (aType == AddInputTypeEquipment){
        return GetStringWithKey(@"activity_equipment");
    }else if (aType == AddInputTypeTheme){
        return GetStringWithKey(@"theme");
    }else if (aType == AddInputTypeVenue){
        return GetStringWithKey(@"place");
    }else if (aType == AddInputTypeDetail){
        return GetStringWithKey(@"activity_content");
    }else if (aType == AddInputTypeDetailAddress){
        return GetStringWithKey(@"activity_detail_address_hint");
    }
    
    return [NSString string];
}

- (int) getWordLimitWithType:(AddInputType)aType{
    if (aType == AddInputTypeTitle) {
        return 20;
    }else if (aType == AddInputTypeFee){
        return 20;
    }else if (aType == AddInputTypeFeeDesc){
        return 100;
    }else if (aType == AddInputTypeRemark){
        return 100;
    }else if (aType == AddInputTypeAttention){
        return 300;
    }else if (aType == AddInputTypeTheme){
        return 20;
    }else if (aType == AddInputTypeVenue){
        return 30;
    }else if (aType == AddInputTypeDetail){
        return 300;
    }else if (aType == AddInputTypeDetailAddress){
        return 30;
    }
    return 0;
}

- (BOOL) isShowInputTypeWithType:(AddInputType)aType{
    return aType == AddInputTypeTitle || aType == AddInputTypeFee || aType == AddInputTypeFeeDesc || aType == AddInputTypeRemark || aType == AddInputTypeAttention || aType == AddInputTypeTheme || aType == AddInputTypeVenue || aType == AddInputTypeDetail;
}

- (void) setUpLabel:(UILabel *)aLabel TextColorWithIsHint:(BOOL)aIsHint{
    if (aIsHint) {
        [aLabel setTextColor:GERY_PANTUO];
    }else{
        [aLabel setTextColor:[UIColor blackColor]];
    }
}

#pragma mark - AddEditTextViewDelegate
- (void) AddEditTextViewDidSelect:(id)aSelf WithTag:(int)aTag{
    AddEditTextView *addEditTextView = (AddEditTextView *)aSelf;
    self.addInputType = [self getAddInputTypeWithAddEditTextView:aSelf WithTag:aTag];
    if ([self isShowInputTypeWithType:self.addInputType]) {
        
        NSString *currentText;
        if (aTag >= 4) {
            self.journeySelected = -1;
            self.journeyTagSelected = aTag;
            if (aSelf != self.activityImageAddEditTextView) {
                for (int i = 0; [self.journeyAddEditTextViewArray count]; i++) {
                    AddEditTextView *tempView = [self.journeyAddEditTextViewArray objectAtIndex:i];
                    if (aSelf == tempView) {
                        self.journeySelected = i;
                        AddEditTextView *tempView = [self.journeyAddEditTextViewArray objectAtIndex:self.journeySelected];
                        if (aTag == 4){
                            currentText = tempView.themeContentLabel.text;
                        }else if (aTag == 5){
                            currentText = tempView.venueContentLabel.text;
                        }else if (aTag == 6){
                            currentText = tempView.detailContentLabel.text;
                        }
                        break;
                    }
                }
            }
        }else{
            currentText = addEditTextView.contentLabel.text;
        }
        
        NSString *hint = [self getHintWithType:self.addInputType];
        
        InputTextViewController *vc = [InputTextViewController new];
        vc.maxCount = [self getWordLimitWithType:self.addInputType];
        vc.delegate = self;
        
        if (self.addInputType ==  AddInputTypeTitle) {
            if (!([currentText isEqualToString:hint] || [currentText isEqualToString:GetStringWithKey(@"default_title")])){
                vc.presetText = currentText;
            }
        }else if (![currentText isEqualToString:hint]) {
            vc.presetText = currentText;
        }
        vc.titleText = [self getTitleWithType:self.addInputType];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.addInputType == AddInputTypeHighlight){
        InputChoiceViewController *vc = [InputChoiceViewController new];
        vc.delegate = self;
        vc.maxCount = 200;
        vc.selectedChoice = self.highlightAddEditTextView.selectedChoice;
        vc.otherChoice = self.highlightAddEditTextView.otherChoice;
        vc.titleText = [self getTitleWithType:self.addInputType];
        vc.apiForChoice = API_GET_SLOGAN;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.addInputType == AddInputTypeEquipment){
        InputChoiceViewController *vc = [InputChoiceViewController new];
        vc.delegate = self;
        vc.maxCount = 100;
        vc.selectedChoice = self.equipmentAddEditTextView.selectedChoice;
        vc.otherChoice = self.equipmentAddEditTextView.otherChoice;
        vc.titleText = [self getTitleWithType:self.addInputType];
        vc.apiForChoice = API_GET_EQUIPMENT;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void) AddEditTextViewDidSelectType{
    self.addImageType = AddImageTypeProfile;
    
    InputTypeViewController *vc = [InputTypeViewController new];
    
    if (self.titleAndTypeAddEditTextView.type > 0) {
        vc.selectedType = self.titleAndTypeAddEditTextView.type;
    }else if (self.titleAndTypeAddEditTextView.otherType.length == 0) {
        vc.selectedType = 1;
    }else{
        vc.selectedType = 0;
    }
    
    if ([self.titleAndTypeAddEditTextView.color length] == 6) {
        NSString *currentColor = self.titleAndTypeAddEditTextView.color;
        for (int i = 0; i < [ACTIVITY_COLOR count]; i++) {
            NSString *color = [ACTIVITY_COLOR objectAtIndex:i];
            if ([color isEqualToString:currentColor]) {
                vc.selectedColor = i+1;
                break;
            }
        }
    }else{
        vc.selectedColor = 1;
    }
    
    vc.otherType = self.titleAndTypeAddEditTextView.otherType;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) AddEditTextViewDidSelectActivityImage:(id)aSelf WithTag:(int)aTag{
    self.journeySelected = -1;
    self.journeyTagSelected = aTag;
    
    if (aSelf != self.activityImageAddEditTextView) {
        for (int i = 0; [self.journeyAddEditTextViewArray count]; i++) {
            AddEditTextView *tempView = [self.journeyAddEditTextViewArray objectAtIndex:i];
            if (aSelf == tempView) {
                self.journeySelected = i;
                break;
            }
        }
    }
    if (aTag == 1) {
        self.addImageType = AddImageTypeActivityImage1;
    }else if (aTag == 2) {
        self.addImageType = AddImageTypeActivityImage2;
    }else if (aTag == 3) {
        self.addImageType = AddImageTypeActivityImage3;
    }
    
    [self showChooseImageActionSheet];
}

- (void) AddEditTextViewDidSelectOption:(BOOL)aLeft{
    CGRect tempFrame = self.addressAddEditTextView.frame;
    if (aLeft) {
        tempFrame.size.height = 160;
        [self.addressAddEditTextView.inlandAddressView setHidden:NO];
    }else{
        tempFrame.size.height = 114;
        [self.addressAddEditTextView.inlandAddressView setHidden:YES];
    }
    [self.addressAddEditTextView setFrame:tempFrame];
    
    int interval = 0;
    int y = tempFrame.origin.y + tempFrame.size.height;
    
    tempFrame = self.activityImageAddEditTextView.frame;
    tempFrame.origin.y = y ;
    [self.activityImageAddEditTextView setFrame:tempFrame];
    y += self.activityImageAddEditTextView.frame.size.height + interval;
    
    tempFrame = self.feeAddEditTextView.frame;
    tempFrame.origin.y = y ;
    [self.feeAddEditTextView setFrame:tempFrame];
    y += self.feeAddEditTextView.frame.size.height + interval;
    
    tempFrame = self.feeExtraAddEditTextView.frame;
    tempFrame.origin.y = y ;
    [self.feeExtraAddEditTextView setFrame:tempFrame];
    y += self.feeExtraAddEditTextView.frame.size.height + interval;
    
    tempFrame = self.remarkAddEditTextView.frame;
    tempFrame.origin.y = y ;
    [self.remarkAddEditTextView setFrame:tempFrame];
    y += self.remarkAddEditTextView.frame.size.height + interval;
    
    tempFrame = self.journeyTitleView.frame;
    tempFrame.origin.y = y ;
    [self.journeyTitleView setFrame:tempFrame];
    y += self.journeyTitleView.frame.size.height;
    
    tempFrame = self.dayActivityView.frame;
    tempFrame.origin.y = y ;
    [self.dayActivityView setFrame:tempFrame];
    y += self.dayActivityView.frame.size.height + interval;
    
    for (AddEditTextView *tempView in self.journeyAddEditTextViewArray) {
        tempFrame = tempView.frame;
        tempFrame.origin.y = y ;
        [tempView setFrame:tempFrame];
        y += tempView.frame.size.height + interval;
    }
    
    tempFrame = self.addJourneyButton.frame;
    tempFrame.origin.y = y ;
    [self.addJourneyButton setFrame:tempFrame];
    y += self.addJourneyButton.frame.size.height + interval;
    
    tempFrame = self.attentionAddEditTextView.frame;
    tempFrame.origin.y = y ;
    [self.attentionAddEditTextView setFrame:tempFrame];
    y += self.attentionAddEditTextView.frame.size.height + interval;
    
    tempFrame = self.equipmentAddEditTextView.frame;
    tempFrame.origin.y = y ;
    [self.equipmentAddEditTextView setFrame:tempFrame];
    y += self.equipmentAddEditTextView.frame.size.height + interval;
    
    tempFrame = self.actionButtonView.frame;
    tempFrame.origin.y = y ;
    [self.actionButtonView setFrame:tempFrame];
    y += self.actionButtonView.frame.size.height + interval;
    
    [self.mScrollView setContentSize:CGSizeMake(self.mScrollView.frame.size.width, y)];
}

- (void) AddEditTextViewDidClickRemoveTrip:(AddEditTextView *)aSelf{
    int index = -1;
    for (int i = 0 ; i < [self.journeyAddEditTextViewArray count]; i++) {
        if (aSelf == [self.journeyAddEditTextViewArray objectAtIndex:i]) {
            index = i;
            break;
        }
    }
    if (index > -1) {
        if (index+1 == [self.journeyAddEditTextViewArray count]) {
            AddEditTextView *tempView = [self.journeyAddEditTextViewArray lastObject];
            tempView.delegate = nil;
            [tempView removeFromSuperview];
            [self.journeyAddEditTextViewArray removeLastObject];
            tempView = nil;
        }else{
            AddEditTextView *tempView = (AddEditTextView *)[self.journeyAddEditTextViewArray objectAtIndex:index];
            int dateDifference = tempView.endDate - tempView.startDate + 1;
            for (int i = index + 1; i < [self.journeyAddEditTextViewArray count]; i++) {
                AddEditTextView *tempView = (AddEditTextView *)[self.journeyAddEditTextViewArray objectAtIndex:i];
                CGRect tempFrame = tempView.frame;
                tempFrame.origin.y -= tempFrame.size.height;
                [tempView setFrame:tempFrame];
                [tempView setStartAndEndDateWithStart:tempView.startDate-dateDifference WithEnd:tempView.endDate-dateDifference];
            }
            
            tempView = [self.journeyAddEditTextViewArray objectAtIndex:index];
            tempView.delegate = nil;
            [tempView removeFromSuperview];
            [self.journeyAddEditTextViewArray removeObjectAtIndex:index];
            tempView = nil;
        }
        CGRect tempFrame;
        
        AddEditTextView *tempView = (AddEditTextView *)[self.journeyAddEditTextViewArray lastObject];
        int y = tempView.frame.origin.y + tempView.frame.size.height;
        int interval = 0;
        
        tempFrame = self.addJourneyButton.frame;
        tempFrame.origin.y = y ;
        [self.addJourneyButton setFrame:tempFrame];
        y += self.addJourneyButton.frame.size.height + interval;
        
        tempFrame = self.attentionAddEditTextView.frame;
        tempFrame.origin.y = y ;
        [self.attentionAddEditTextView setFrame:tempFrame];
        y += self.attentionAddEditTextView.frame.size.height + interval;
        
        tempFrame = self.equipmentAddEditTextView.frame;
        tempFrame.origin.y = y ;
        [self.equipmentAddEditTextView setFrame:tempFrame];
        y += self.equipmentAddEditTextView.frame.size.height + interval;
        
        tempFrame = self.actionButtonView.frame;
        tempFrame.origin.y = y ;
        [self.actionButtonView setFrame:tempFrame];
        y += self.actionButtonView.frame.size.height + interval;
        
        [self.mScrollView setContentSize:CGSizeMake(self.mScrollView.frame.size.width, y)];
        
    }
}

- (void) AddEditTextViewDidSelect:(AddEditTextView *)aSelf WithEndDay:(int)aDay{
    int index = -1;
    for (int i = 0 ; i < [self.journeyAddEditTextViewArray count]; i++) {
        if (aSelf == [self.journeyAddEditTextViewArray objectAtIndex:i]) {
            index = i;
            break;
        }
    }
    
    if (index >= 0 &&  index + 1 != [self.journeyAddEditTextViewArray count]) {
        AddEditTextView *tempView = [self.journeyAddEditTextViewArray objectAtIndex:index];
        int startDate = tempView.endDate + 1;
        if (startDate > 100) {
            startDate = 100;
        }
        for (int i = index+1; i < [self.journeyAddEditTextViewArray count]; i++) {
            AddEditTextView *tempView = [self.journeyAddEditTextViewArray objectAtIndex:i];
            int dateDifference = tempView.endDate - tempView.startDate;
            int endDate = startDate + dateDifference;
            if (endDate > 100) {
                endDate = 100;
            }
            [tempView setStartAndEndDateWithStart:startDate WithEnd:endDate];
            startDate += dateDifference + 1;
            if (startDate > 100) {
                startDate = 100;
            }
        }
    }
}

- (void) AddEditTextViewDidBeginEdit:(AddEditTextView *)aSelf{
    [self.mScrollView setContentOffset:CGPointMake(0, aSelf.frame.origin.y) animated:YES];
}

- (void) AddEditTextViewDidSelectDetailAddress:(AddEditTextView *)aSelf{
    self.addInputType = AddInputTypeDetailAddress;
    InputTextViewController *vc = [InputTextViewController new];
    vc.maxCount = [self getWordLimitWithType:self.addInputType];
    vc.delegate = self;
    if (![self.addressAddEditTextView.detailAddressLabel.text isEqualToString:[self getHintWithType:self.addInputType]]) {
        vc.presetText = self.addressAddEditTextView.detailAddressLabel.text;
    }
    vc.titleText = [self getTitleWithType:self.addInputType];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

#pragma mark - InputTextViewControllerDelegate
- (void) InputTextViewControllerDidFinish:(InputTextViewController *)aSelf WithText:(NSString *)aText{
    if (self.addInputType == AddInputTypeDetailAddress) {
        if (aText.length == 0) {
            self.addressAddEditTextView.detailAddressLabel.text = [self getHintWithType:AddInputTypeDetailAddress];
        }else{
            self.addressAddEditTextView.detailAddressLabel.text = aText;
        }
        [self setUpLabel:self.addressAddEditTextView.detailAddressLabel TextColorWithIsHint:aText.length == 0];
    }else{
        UILabel *tempLabel = [self getAddEditTextViewWithAddInputType:self.addInputType WithTag:self.journeyTagSelected];
        if ([aText length] > 0) {
            [tempLabel setText:aText];
            [self setUpLabel:tempLabel TextColorWithIsHint:NO];
        }else if (self.addInputType == AddInputTypeTitle){
            if (self.activityDict){
                [tempLabel setText:GetStringWithKey(@"default_title")];
                [self setUpLabel:tempLabel TextColorWithIsHint:NO];
            }else{
                [tempLabel setText:[self getHintWithType:self.addInputType]];
                [self setUpLabel:tempLabel TextColorWithIsHint:YES];
            }
        }else{
            [tempLabel setText:[self getHintWithType:self.addInputType]];
            [self setUpLabel:tempLabel TextColorWithIsHint:YES];
        }
    }
}

#pragma mark - InputChoiceViewControllerDelegate
- (void) InputChoiceViewControllerDidFinishWithText:(NSString *)aText WithOtherText:(NSString *)aOtherText{
    NSString *displayText;
    if ([aText length] > 0 && [aOtherText length] > 0) {
        displayText = [NSString stringWithFormat:@"%@%@%@",aText,GetStringWithKey(@"activity_text_seperator"),aOtherText];
    }else{
        displayText = [aText stringByAppendingString:aOtherText];
    }
    
    if (self.addInputType == AddInputTypeHighlight) {
        self.highlightAddEditTextView.selectedChoice = aText;
        self.highlightAddEditTextView.otherChoice = aOtherText;
    }else if (self.addInputType == AddInputTypeEquipment) {
        self.equipmentAddEditTextView.selectedChoice = aText;
        self.equipmentAddEditTextView.otherChoice = aOtherText;
    }
    UILabel *tempLabel = [self getAddEditTextViewWithAddInputType:self.addInputType WithTag:self.journeyTagSelected];
    if (displayText.length == 0) {
        [tempLabel setText:[self getHintWithType:self.addInputType]];
    }else{
        [tempLabel setText:displayText];
    }
    [self setUpLabel:tempLabel TextColorWithIsHint:displayText.length == 0];
}

#pragma mark - InputTypeViewControllerDelegate
- (void) InputTypeViewControllerDidFinishWithType:(int)aType WithColor:(NSString *)aColor WithOtherType:(NSString *)aOtherType{
    [self.titleAndTypeAddEditTextView setTypeWithType:aType Color:aColor OtherType:aOtherType];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView tag] == 1) {
        [self.mScrollView setContentOffset:CGPointMake(0, self.errorY) animated:YES];
    }else if ([alertView tag] == 2) {
        if (buttonIndex == 1) {
            GuideInfo *tempInfo = [self getGuideInfo];
            NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:
                                  tempInfo.token,@"token",
                                  tempInfo.guide_id,@"guide_id",
                                  [self.activityDict objectForKey:@"activity_id"],@"activity_id",nil];
            [self callIPOSCSLAPIWithLink:API_DELETE_ACTIVITY WithParameter:para WithGet:YES];
        }
    }else if ([alertView tag] == 3) {
        if (buttonIndex == 0) {
            [self doBack];
        }else{
            [self save];
        }
    }else if ([alertView tag] == 4) {
        if (buttonIndex == 1) {
            [self.navigationController pushViewController:[MyInfoDetailViewController new] animated:YES];
        }
    }
}

#pragma mark - Image picker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:NULL];
    UIImage *tempImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    AddEditTextView *tempView;
    if (self.journeySelected > -1) {
        tempView = [self.journeyAddEditTextViewArray objectAtIndex:self.journeySelected];
    }else{
        tempView = self.activityImageAddEditTextView;
    }
    
    if (self.addImageType == AddImageTypeActivityImage1) {
        tempView.image1 = tempImage;
        tempView.updateImage1 = YES;
        [tempView.image1Button setImage:tempImage forState:UIControlStateNormal];
    }else if (self.addImageType == AddImageTypeActivityImage2) {
        tempView.image2 = tempImage;
        tempView.updateImage2 = YES;
        [tempView.image2Button setImage:tempImage forState:UIControlStateNormal];
    }else if (self.addImageType == AddImageTypeActivityImage3) {
        tempView.image3 = tempImage;
        tempView.updateImage3 = YES;
        [tempView.image3Button setImage:tempImage forState:UIControlStateNormal];
        
    }
}


@end
