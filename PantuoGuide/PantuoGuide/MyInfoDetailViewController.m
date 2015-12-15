//
//  MyInfoDetailViewController.m
//  PantuoGuide
//
//  Created by Christopher Leung on 15/4/15.
//  Copyright (c) 2015 Christopher Leung. All rights reserved.
//

#import "MyInfoDetailViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "CustomEditTextView.h"
#import "InputTextViewController.h"
#import "ClickableNameView.h"
#import "AppDelegate.h"
#import "AddActivityViewController.h"

@interface MyInfoDetailViewController () <CLLocationManagerDelegate, CustomEditTextViewDelegate, InputTextViewControllerDelegate>

@property (nonatomic, retain) UIScrollView *mScrollView;
@property (nonatomic, retain) CustomEditTextView *nicknameTextView;
@property (nonatomic, retain) CustomEditTextView *realnameTextView;
@property (nonatomic, retain) CustomEditTextView *sexTextView;
@property (nonatomic, retain) CustomEditTextView *emailTextView;
@property (nonatomic, retain) CustomEditTextView *idCardTextView;
@property (nonatomic, retain) CustomEditTextView *imageTextView;
@property (nonatomic, retain) CustomEditTextView *socialTextView;
@property (nonatomic, retain) CustomEditTextView *addressTextView;
@property (nonatomic, retain) ClickableNameView *skillNameView;
@property (nonatomic, retain) CustomEditTextView *otherSkillTextView;
@property (nonatomic, retain) CustomEditTextView *ePersonTextView;
@property (nonatomic, retain) CustomEditTextView *eNumberTextView;
@property (nonatomic, retain) CustomEditTextView *experienceTextView;
@property (nonatomic, retain) UIButton *updateButton;

@property (nonatomic, retain) CustomEditTextView *customEditTextViewFirstResponder;

@property (nonatomic, retain) GuideInfo *guideInfo;

@property (nonatomic, assign) BOOL needUpdateImage;
@property (nonatomic, assign) BOOL selectedLeft;
@property (nonatomic, retain) UIImage *image1;
@property (nonatomic, retain) UIImage *image2;

@property (nonatomic, retain) NSString *socialTypeUpdate;

@property (nonatomic, retain) UIView *scrollToView;

@property (nonatomic,strong) CLLocationManager *locationManager;

@end

@implementation MyInfoDetailViewController

- (NSString *) getTopBarTitle{
    return GetStringWithKey(@"coach_reg_info");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addTopBarTitleView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, SCREEN_HEIGHT-90)];
    [self.view addSubview:self.mScrollView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    [self.mScrollView addGestureRecognizer:tap];
    
    // Add Input
    self.nicknameTextView = [[[NSBundle mainBundle] loadNibNamed:@"CustomEditTextView" owner:self options:nil] objectAtIndex:0];
    self.nicknameTextView.delegate = self;
    [self.nicknameTextView.mTextField setReturnKeyType:UIReturnKeyNext];
    [self.mScrollView addSubview:self.nicknameTextView];
    
    self.realnameTextView = [[[NSBundle mainBundle] loadNibNamed:@"CustomEditTextView" owner:self options:nil] objectAtIndex:0];
    self.realnameTextView.delegate = self;
    [self.realnameTextView.mTextField setReturnKeyType:UIReturnKeyNext];
    [self.mScrollView addSubview:self.realnameTextView];
    
    self.sexTextView = [[[NSBundle mainBundle] loadNibNamed:@"CustomEditTextView" owner:self options:nil] objectAtIndex:1];
    self.sexTextView.delegate = self;
    [self.mScrollView addSubview:self.sexTextView];
    
    self.nicknameTextView = [[[NSBundle mainBundle] loadNibNamed:@"CustomEditTextView" owner:self options:nil] objectAtIndex:0];
    self.nicknameTextView.delegate = self;
    [self.mScrollView addSubview:self.nicknameTextView];
    
    self.emailTextView = [[[NSBundle mainBundle] loadNibNamed:@"CustomEditTextView" owner:self options:nil] objectAtIndex:0];
    self.emailTextView.delegate = self;
    [self.emailTextView.mTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    [self.emailTextView.mTextField setReturnKeyType:UIReturnKeyNext];
    [self.mScrollView addSubview:self.emailTextView];
    
    self.idCardTextView = [[[NSBundle mainBundle] loadNibNamed:@"CustomEditTextView" owner:self options:nil] objectAtIndex:0];
    self.idCardTextView.delegate = self;
    [self.idCardTextView.mTextField setReturnKeyType:UIReturnKeyNext];
    [self.mScrollView addSubview:self.idCardTextView];
    
    self.imageTextView = [[[NSBundle mainBundle] loadNibNamed:@"CustomEditTextView" owner:self options:nil] objectAtIndex:2];
    self.imageTextView.delegate = self;
    [self.mScrollView addSubview:self.imageTextView];
    [[self.imageTextView.image1Button imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [[self.imageTextView.image2Button imageView] setContentMode: UIViewContentModeScaleAspectFit];

    
    self.socialTextView = [[[NSBundle mainBundle] loadNibNamed:@"CustomEditTextView" owner:self options:nil] objectAtIndex:3];
    self.socialTextView.delegate = self;
    [self.mScrollView addSubview:self.socialTextView];
    
    self.addressTextView = [[[NSBundle mainBundle] loadNibNamed:@"CustomEditTextView" owner:self options:nil] objectAtIndex:5];
    self.addressTextView.delegate = self;
    [self.mScrollView addSubview:self.addressTextView];
    
    self.skillNameView = [[[NSBundle mainBundle] loadNibNamed:@"ClickableNameView" owner:self options:nil] objectAtIndex:0];
    [self.skillNameView hideTitleBackground];
    [self.skillNameView addLowSeparator];
//    self.skillNameView.delegate = self;
    [self.mScrollView addSubview:self.skillNameView];
    
    self.otherSkillTextView = [[[NSBundle mainBundle] loadNibNamed:@"CustomEditTextView" owner:self options:nil] objectAtIndex:4];
    self.otherSkillTextView.delegate = self;
    [self.mScrollView addSubview:self.otherSkillTextView];
    
    self.ePersonTextView = [[[NSBundle mainBundle] loadNibNamed:@"CustomEditTextView" owner:self options:nil] objectAtIndex:0];
    self.ePersonTextView.delegate = self;
    [self.ePersonTextView.mTextField setReturnKeyType:UIReturnKeyNext];
    [self.mScrollView addSubview:self.ePersonTextView];
    
    self.eNumberTextView = [[[NSBundle mainBundle] loadNibNamed:@"CustomEditTextView" owner:self options:nil] objectAtIndex:0];
    self.eNumberTextView.delegate = self;
    [self.eNumberTextView.mTextField setKeyboardType:UIKeyboardTypePhonePad];
    [self.mScrollView addSubview:self.eNumberTextView];
    
    self.experienceTextView = [[[NSBundle mainBundle] loadNibNamed:@"CustomEditTextView" owner:self options:nil] objectAtIndex:4];
    self.experienceTextView.delegate = self;
    [self.mScrollView addSubview:self.experienceTextView];
    
    // Set Input Origin
    int interval = 0;
    int y = 0;
    CGRect tempFrame;
    
    tempFrame = self.nicknameTextView.frame;
    tempFrame.size.width = SCREEN_WIDTH;
    [self.nicknameTextView setFrame:tempFrame];
    y += self.nicknameTextView.frame.size.height + interval;
    
    tempFrame = self.realnameTextView.frame;
    tempFrame.origin.y = y ;
    tempFrame.size.width = SCREEN_WIDTH;
    [self.realnameTextView setFrame:tempFrame];
    y += self.realnameTextView.frame.size.height + interval;
    
    tempFrame = self.sexTextView.frame;
    tempFrame.origin.y = y ;
    tempFrame.size.width = SCREEN_WIDTH;
    [self.sexTextView setFrame:tempFrame];
    y += self.sexTextView.frame.size.height + interval;
    
    tempFrame = self.emailTextView.frame;
    tempFrame.origin.y = y ;
    tempFrame.size.width = SCREEN_WIDTH;
    [self.emailTextView setFrame:tempFrame];
    y += self.emailTextView.frame.size.height + interval;
    
    tempFrame = self.idCardTextView.frame;
    tempFrame.origin.y = y ;
    tempFrame.size.width = SCREEN_WIDTH;
    [self.idCardTextView setFrame:tempFrame];
    y += self.idCardTextView.frame.size.height + interval;
    
    tempFrame = self.imageTextView.frame;
    tempFrame.origin.y = y ;
    tempFrame.size.width = SCREEN_WIDTH;
    [self.imageTextView setFrame:tempFrame];
    y += self.imageTextView.frame.size.height + interval;
    
    tempFrame = self.socialTextView.frame;
    tempFrame.origin.y = y ;
    tempFrame.size.width = SCREEN_WIDTH;
    [self.socialTextView setFrame:tempFrame];
    y += self.socialTextView.frame.size.height + interval;
    
    tempFrame = self.addressTextView.frame;
    tempFrame.origin.y = y ;
    tempFrame.size.width = SCREEN_WIDTH;
    [self.addressTextView setFrame:tempFrame];
    y += self.addressTextView.frame.size.height + interval;
    
    tempFrame = self.skillNameView.frame;
    tempFrame.origin.y = y;
    tempFrame.size.width = SCREEN_WIDTH;
    [self.skillNameView setFrame:tempFrame];
    y += self.skillNameView.frame.size.height + interval;
    
    tempFrame = self.otherSkillTextView.frame;
    tempFrame.origin.y = y ;
    tempFrame.size.width = SCREEN_WIDTH;
    [self.otherSkillTextView setFrame:tempFrame];
    y += self.otherSkillTextView.frame.size.height + interval;
    
    tempFrame = self.ePersonTextView.frame;
    tempFrame.origin.y = y ;
    tempFrame.size.width = SCREEN_WIDTH;
    [self.ePersonTextView setFrame:tempFrame];
    y += self.ePersonTextView.frame.size.height + interval;
    
    tempFrame = self.eNumberTextView.frame;
    tempFrame.origin.y = y ;
    tempFrame.size.width = SCREEN_WIDTH;
    [self.eNumberTextView setFrame:tempFrame];
    y += self.eNumberTextView.frame.size.height + interval;
    
    tempFrame = self.experienceTextView.frame;
    tempFrame.origin.y = y ;
    tempFrame.size.width = SCREEN_WIDTH;
    [self.experienceTextView setFrame:tempFrame];
    y += self.experienceTextView.frame.size.height + interval;
    
    self.updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    int width = 300*SCREEN_WIDTH/320;
    [self.updateButton setFrame:CGRectMake((SCREEN_WIDTH-width)/2, y+20, width, 45)];
    [self.updateButton setTitle:GetStringWithKey(@"profile_update") forState:UIControlStateNormal];
    [self.updateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.updateButton setBackgroundImage:[UIImage imageNamed:@"action_btn.png"] forState:UIControlStateNormal];
    [self.updateButton addTarget:self action:@selector(update) forControlEvents:UIControlEventTouchUpInside];
    [self.mScrollView addSubview:self.updateButton];
    
    [self.mScrollView setContentSize:CGSizeMake(self.mScrollView.frame.size.width, y+85)];
    
    // Set Text
    [self.nicknameTextView setPlaceHolder:GetStringWithKey(@"coach_detail_nickname") WithStar:YES];
    [self.realnameTextView setPlaceHolder:GetStringWithKey(@"coach_detail_realname") WithStar:YES];
    [self.emailTextView setPlaceHolder:GetStringWithKey(@"coach_detail_email") WithStar:YES];
    [self.idCardTextView setPlaceHolder:GetStringWithKey(@"coach_detail_ids") WithStar:YES];
    [self.ePersonTextView setPlaceHolder:GetStringWithKey(@"coach_detail_emergency_contact") WithStar:YES];
    [self.eNumberTextView setPlaceHolder:GetStringWithKey(@"coach_detail_emergency_contact_mobile") WithStar:YES];
    
    [self.nicknameTextView setTitle:GetStringWithKey(@"coach_detail_nickname") WithStar:YES];
    [self.realnameTextView setTitle:GetStringWithKey(@"coach_detail_realname") WithStar:YES];
    [self.sexTextView setTitle:GetStringWithKey(@"gender") WithStar:YES];
    [self.sexTextView setLeft:GetStringWithKey(@"male")];
    [self.sexTextView setRight:GetStringWithKey(@"female")];
    [self.addressTextView setLeft:GetStringWithKey(@"local")];
    [self.addressTextView setRight:GetStringWithKey(@"foreign")];
    [self.emailTextView setTitle:GetStringWithKey(@"coach_detail_email") WithStar:YES];
    [self.idCardTextView setTitle:GetStringWithKey(@"coach_detail_ids") WithStar:YES];
    [self.imageTextView setTitle:GetStringWithKey(@"id_backup") WithStar:YES];
    [self.imageTextView setTitle2:GetStringWithKey(@"id_backup_size") WithStar:NO];
    [self.socialTextView setTitle:GetStringWithKey(@"social_media") WithStar:NO];
//    [self.socialTextView setTitle2:GetStringWithKey(@"social_media_at_least_one") WithStar:NO];
    [self.addressTextView setTitle:GetStringWithKey(@"coach_detail_address") WithStar:YES];
    [self.addressTextView.provinceTextView setText:GetStringWithKey(@"province")];
    [self.addressTextView.cityTextView setText:GetStringWithKey(@"city")];
    [self.addressTextView.areaTextView setText:GetStringWithKey(@"district")];
    [self.otherSkillTextView setTitle:GetStringWithKey(@"coach_detail_other_skills") WithStar:NO];
    [self.ePersonTextView setTitle:GetStringWithKey(@"coach_detail_emergency_contact") WithStar:YES];
    [self.eNumberTextView setTitle:GetStringWithKey(@"coach_detail_emergency_contact_mobile") WithStar:YES];
    [self.experienceTextView setTitle:GetStringWithKey(@"coach_detail_cv") WithStar:NO];
    
    self.guideInfo = [self getGuideInfo];
    [self.nicknameTextView setContent:self.guideInfo.nickname];
    [self.realnameTextView setContent:self.guideInfo.realname];
    [self.emailTextView setContent:self.guideInfo.email];
    [self.idCardTextView setContent:self.guideInfo.id_number];
    if ([self.guideInfo.gender isEqualToString:@"M"]) {
        [self.sexTextView left:nil];
    }else if ([self.guideInfo.gender isEqualToString:@"F"]){
        [self.sexTextView right:nil];
    }
    if (self.guideInfo.social_media_qq.length > 0){
        [self.socialTextView.qqButton setBackgroundImage:[UIImage imageNamed:@"icn_qq_on.png"] forState:UIControlStateNormal];
    }
    if (self.guideInfo.social_media_wechat.length > 0){
        [self.socialTextView.weChatButton setBackgroundImage:[UIImage imageNamed:@"icn_wechat_on.png"] forState:UIControlStateNormal];
    }
    if (self.guideInfo.social_media_weibo.length > 0){
        [self.socialTextView.weiboButton setBackgroundImage:[UIImage imageNamed:@"icn_weibo_on.png"] forState:UIControlStateNormal];
    }
    
    if (self.guideInfo.address1.length == 0) {
        [self.addressTextView left:nil];
        [self getLocation];
    }else{
        if (self.guideInfo.isOverseas) {
            [self.addressTextView right:nil];
            [self.addressTextView.mTextField setText:self.guideInfo.address1];
        }else{
            [self.addressTextView left:nil];
            AddressManager *tempManager = [AddressManager new];
            if (self.guideInfo.address1.length > 0) {
                self.addressTextView.provinceDataSource.currentRow = [tempManager getProvinceIdWithName:self.guideInfo.address1];
                [self.addressTextView.provinceTextView setText:self.guideInfo.address1];
            }
            if (self.guideInfo.address2.length > 0) {
                self.addressTextView.cityDataSource.currentRow = [tempManager getCityIdWithProvince:self.guideInfo.address1 WithCity:self.guideInfo.address2];
                [self.addressTextView.cityTextView setText:self.guideInfo.address2];
            }
            if (self.guideInfo.address3.length > 0) {
                self.addressTextView.areaDataSource.currentRow = [tempManager getAreaIdWithProvince:self.guideInfo.address1 WithCity:self.guideInfo.address2 WithArea:self.guideInfo.address3];
                [self.addressTextView.areaTextView setText:self.guideInfo.address3];
            }
        }
    }
    
    [self.ePersonTextView setContent:self.guideInfo.emergency_name];
    [self.eNumberTextView setContent:self.guideInfo.emergency_phone];
    
    self.needUpdateImage = NO;
    if (self.guideInfo.id_image_1.length > 0) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:self.guideInfo.id_image_1]
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                 // progression tracking code
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                if (image) {
                                    self.image1 = image;
                                    [self.imageTextView.image1Button setImage:image forState:UIControlStateNormal];
                                }
                            }];
    }
    if (self.guideInfo.id_image_2.length > 0) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:self.guideInfo.id_image_2]
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                 // progression tracking code
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                if (image) {
                                    self.image2 = image;
                                    [self.imageTextView.image2Button setImage:image forState:UIControlStateNormal];
                                }
                            }];
    }
    
    [self setUpExperience:self.guideInfo.experience];
    [self setUpOtherSkill:self.guideInfo.other_skill];
    [self callIPOSCSLAPIWithLink:API_GET_PROFESSTIONAL WithParameter:nil WithGet:YES];
}

//- (void) viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    
//    UIEdgeInsets contentInset = self.mScrollView.contentInset;
//    if (contentInset.top > 0) {
//        self.mScrollView.contentInset = UIEdgeInsetsZero;
//        self.mScrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
//        [self.mScrollView setHidden:NO];
//    }
//}

- (void) back:(id)sender{
    BOOL updated = NO;
    GuideInfo *oldGuideInfo = [self getGuideInfo];
    NSString *isOversea = self.guideInfo.isOverseas?@"1":@"0";
    NSString *gender = [self.sexTextView getContent]?[self.sexTextView getContent]:@"";
    
    if (![oldGuideInfo.nickname isEqualToString:[self.nicknameTextView getContent]]) {
        updated = YES;
    }else if (![oldGuideInfo.realname isEqualToString:[self.realnameTextView getContent]]){
        updated = YES;
    }else if (![oldGuideInfo.gender isEqualToString:gender]){
        updated = YES;
    }else if (![oldGuideInfo.email isEqualToString:[self.emailTextView getContent]]){
        updated = YES;
    }else if (![oldGuideInfo.id_number isEqualToString:[self.idCardTextView getContent]]){
        updated = YES;
    }else if (self.needUpdateImage){
        updated = YES;
    }else if (![isOversea isEqualToString:[self.addressTextView getContent]]){
        updated = YES;
    }else if (self.guideInfo.isOverseas && ![self.guideInfo.address1 isEqualToString:self.addressTextView.mTextField.text]){
        updated = YES;
    }else if (!self.guideInfo.isOverseas){
        NSString *oldProvine = oldGuideInfo.address1;
        NSString *oldCity = oldGuideInfo.address2;
//        NSString *oldArea = oldGuideInfo.address3;
        
        
        int province = self.addressTextView.provinceDataSource.currentRow;
        NSString *provinceString = [NSString string];
        if (province > -1) {
            provinceString = self.addressTextView.provinceTextView.text;
        }
        
        int city = self.addressTextView.cityDataSource.currentRow;
        NSString *cityString = [NSString string];
        if (city > -1) {
            cityString = self.addressTextView.cityTextView.text;
        }
        
//        int area = self.addressTextView.areaDataSource.currentRow;
//        NSString *areaString = [NSString string];
//        if (area > -1) {
//            areaString = self.addressTextView.areaTextView.text;
//        }
        
        BOOL sameProvince = [provinceString isEqualToString:oldProvine];
        BOOL sameCity = [cityString isEqualToString:oldCity];
//        BOOL sameArea = [areaString isEqualToString:oldArea];
        
        if (!(sameProvince && sameCity)) {
            updated = YES;
        }
    }
    
    if (!updated) {
        if (![oldGuideInfo.skill_id isEqualToString:[self.skillNameView getClickedId]]){
            updated = YES;
        }else if (![oldGuideInfo.other_skill isEqualToString:self.guideInfo.other_skill]){
            updated = YES;
        }else if (![oldGuideInfo.emergency_name isEqualToString:[self.ePersonTextView getContent]]){
            updated = YES;
        }else if (![oldGuideInfo.emergency_phone isEqualToString:[self.eNumberTextView getContent]]){
            updated = YES;
        }else if (![oldGuideInfo.experience isEqualToString:self.guideInfo.experience]){
            updated = YES;
        }
    }
    
    if (updated) {
        UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:GetStringWithKey(@"profile_alert_save_before_leave")
                                                               delegate:self
                                                      cancelButtonTitle:GetStringWithKey(@"quit_app_neg")
                                                      otherButtonTitles:GetStringWithKey(@"quit_app_pos"), nil];
        [tempAlertView setTag:4];
        [tempAlertView show];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) delayBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self tapped];
}

- (void) tapped{
    for (UIView *subView in self.mScrollView.subviews) {
        if ([subView isKindOfClass:[CustomEditTextView class]]) {
            CustomEditTextView *csubview = (CustomEditTextView *)subView;
            if ([csubview.mTextField isFirstResponder]) {
                [csubview.mTextField resignFirstResponder];
            }else if ([csubview.provinceTextView isFirstResponder]) {
                [csubview.provinceTextView resignFirstResponder];
            }else if ([csubview.cityTextView isFirstResponder]) {
                [csubview.cityTextView resignFirstResponder];
            }else if ([csubview.areaTextView isFirstResponder]) {
                [csubview.areaTextView resignFirstResponder];
            }
        }
    }
}

- (void) setUpSkill:(NSArray *)aArray{
    
    CGRect tempFrame = self.skillNameView.frame;
    int y = tempFrame.origin.y;
    int interval = 0;
    
    [self.skillNameView initViewWithTitle:GetStringWithKey(@"coach_detail_skills") WithStart:YES WithNameArray:[NSMutableArray arrayWithArray:aArray] WithClickedNameArray:nil];
    y += self.skillNameView.frame.size.height + interval;
    
    tempFrame = self.otherSkillTextView.frame;
    tempFrame.origin.y = y ;
    [self.otherSkillTextView setFrame:tempFrame];
    y += self.otherSkillTextView.frame.size.height + interval;
    
    tempFrame = self.ePersonTextView.frame;
    tempFrame.origin.y = y ;
    [self.ePersonTextView setFrame:tempFrame];
    y += self.ePersonTextView.frame.size.height + interval;
    
    tempFrame = self.eNumberTextView.frame;
    tempFrame.origin.y = y ;
    [self.eNumberTextView setFrame:tempFrame];
    y += self.eNumberTextView.frame.size.height + interval;
    
    tempFrame = self.experienceTextView.frame;
    tempFrame.origin.y = y ;
    [self.experienceTextView setFrame:tempFrame];
    y += self.experienceTextView.frame.size.height + interval;
    
    tempFrame = self.updateButton.frame;
    tempFrame.origin.y = y + 20;
    [self.updateButton setFrame:tempFrame];
    [self.mScrollView setContentSize:CGSizeMake(self.mScrollView.frame.size.width, y+85)];
    
    if (self.guideInfo.skill_id.length > 0) {
        NSArray *tempArray = [self.guideInfo.skill_id componentsSeparatedByString:@"|"];
        if ([tempArray count] > 0) {
            [self.skillNameView setClickNameWithId:[NSMutableArray arrayWithArray:tempArray]];
        }
    }
}

- (void) setUpOtherSkill:(NSString *)aString{
    [self.otherSkillTextView setLongContent:aString];
    CGRect tempFrame = self.otherSkillTextView.frame;
    int y = tempFrame.origin.y + tempFrame.size.height;
    
    int interval = 0;
    tempFrame = self.ePersonTextView.frame;
    tempFrame.origin.y = y ;
    tempFrame.size.width = SCREEN_WIDTH;
    [self.ePersonTextView setFrame:tempFrame];
    y += self.ePersonTextView.frame.size.height + interval;
    
    tempFrame = self.eNumberTextView.frame;
    tempFrame.origin.y = y ;
    tempFrame.size.width = SCREEN_WIDTH;
    [self.eNumberTextView setFrame:tempFrame];
    y += self.eNumberTextView.frame.size.height + interval;
    
    tempFrame = self.experienceTextView.frame;
    tempFrame.origin.y = y ;
    tempFrame.size.width = SCREEN_WIDTH;
    [self.experienceTextView setFrame:tempFrame];
    y += self.experienceTextView.frame.size.height + interval;
    
    tempFrame = self.updateButton.frame;
    tempFrame.origin.y = y + 20;
    [self.updateButton setFrame:tempFrame];
    [self.mScrollView setContentSize:CGSizeMake(self.mScrollView.frame.size.width, y+85)];
}


- (void) setUpExperience:(NSString *)aString{
    [self.experienceTextView setLongContent:aString];
    CGRect tempFrame = self.experienceTextView.frame;
    int y = tempFrame.origin.y + tempFrame.size.height;
    
    tempFrame = self.updateButton.frame;
    tempFrame.origin.y = y + 20;
    [self.updateButton setFrame:tempFrame];
    [self.mScrollView setContentSize:CGSizeMake(self.mScrollView.frame.size.width, y+85)];
}

- (void) updateSocialInfo:(NSDictionary *)aDict{
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:aDict];
    [para setObject:self.guideInfo.token forKey:@"token"];
    [para setObject:self.guideInfo.guide_id forKey:@"guide_id"];
    [self callPantuoAPIWithLink:API_UPDATE_GUIDE_SOCIAL_INFO WithParameter:para];
}

- (void) update{
    
    NSString *message = [NSString string];
    if ([self.nicknameTextView getContent].length == 0) {
        message = GetStringWithKey(@"coach_detail_nickname_missing");
        self.scrollToView = self.nicknameTextView;
    }
    else if ([self.realnameTextView getContent].length == 0) {
        message = GetStringWithKey(@"coach_detail_realname_missing");
        self.scrollToView = self.realnameTextView;
    }
    else if (self.sexTextView.leftRightSelection == 0){
        message = GetStringWithKey(@"coach_detail_gender_missing");
        self.scrollToView = self.sexTextView;
    }
    else if ([self.emailTextView getContent].length == 0) {
        message = GetStringWithKey(@"coach_detail_email_missing");
        self.scrollToView = self.emailTextView;
    }
    else if ([self.idCardTextView getContent].length == 0) {
        message = GetStringWithKey(@"coach_detail_ids_missing");
        self.scrollToView = self.idCardTextView;
    }
    else if (!self.image1 || ! self.image2) {
        message = GetStringWithKey(@"id_pic_missing");
        self.scrollToView = self.sexTextView;
//    }else if (self.guideInfo.social_media_weibo.length == 0 && self.guideInfo.social_media_wechat.length == 0 && self.guideInfo.social_media_qq.length == 0) {
//            message = GetStringWithKey(@"coach_detail_social_media_missing");
//        self.scrollToView = self.socialTextView;
    }else if ([[self.addressTextView getContent] isEqualToString:@"1"]) {
        // oversea
        if ([self.addressTextView.mTextField.text length] == 0) {
            message = GetStringWithKey(@"coach_detail_address_missing");
            self.scrollToView = self.addressTextView;
        }
    }else if ([[self.addressTextView getContent] isEqualToString:@"0"]){
        //not oversea
        if (self.addressTextView.provinceDataSource.currentRow == -1) {
            message = GetStringWithKey(@"coach_detail_address_missing");
            self.scrollToView = self.addressTextView;
        }else{
            int city = self.addressTextView.cityDataSource.currentRow;
//            int area = self.addressTextView.areaDataSource.currentRow;
            AddressManager *tempAddressManager = [AddressManager new];
            if ([tempAddressManager hasCityInProvince:self.addressTextView.provinceDataSource.currentRow] && city == -1) {
                message = GetStringWithKey(@"coach_detail_address_missing");
                self.scrollToView = self.addressTextView;
//            }else if ([tempAddressManager hasAreaInProvince:self.addressTextView.provinceDataSource.currentRow] && area == -1) {
//                message = GetStringWithKey(@"coach_detail_address_missing");
//                self.scrollToView = self.addressTextView;
            }
        }
    }else{
        message = GetStringWithKey(@"coach_detail_address_missing");
        self.scrollToView = self.addressTextView;
    }
    
    if (message.length == 0) {
        if ([[self.skillNameView getClickedId] length] == 0) {
            message = GetStringWithKey(@"coach_detail_skills_missing");
            self.scrollToView = self.skillNameView;
        }
        else if ([self.ePersonTextView getContent].length == 0) {
            message = GetStringWithKey(@"coach_detail_emergency_contact_missing");
            self.scrollToView = self.ePersonTextView;
        }
        else if ([self.eNumberTextView getContent].length == 0) {
            message = GetStringWithKey(@"coach_detail_emergency_contact_mobile_missing");
            self.scrollToView = self.eNumberTextView;
        }
        else if (!IsCorrectMobileNumber([self.eNumberTextView getContent])){
            message = GetStringWithKey(@"profile_alert_wrong_mobile_format");
            self.scrollToView = self.eNumberTextView;
        }else if (!isEmailValid([self.emailTextView getContent])){
            message = GetStringWithKey(@"coach_detail_email_invalid");
            self.scrollToView = self.emailTextView;
        }
    }
    
    if (message.length == 0) {
        NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     self.guideInfo.token,@"token",
                                     self.guideInfo.guide_id,@"guide_id",
                                     [self.skillNameView getClickedId],@"skill_id",
                                     self.guideInfo.other_skill,@"other_skill",
                                     [self.nicknameTextView getContent],@"nickname",
                                     [self.realnameTextView getContent],@"realname",
                                     self.guideInfo.mobile,@"mobile",
                                     [self.emailTextView getContent],@"email",
                                     [self.idCardTextView getContent],@"id_number",
                                     [self.ePersonTextView getContent],@"emergency_name",
                                     [self.eNumberTextView getContent],@"emergency_phone",
                                     [self.sexTextView getContent],@"gender",
                                     self.guideInfo.experience,@"experience",
                              nil];
        
        if ([[self.addressTextView getContent] isEqualToString:@"1"]) {
            [para setObject:@"1" forKey:@"oversea"];
            [para setObject:self.addressTextView.mTextField.text forKey:@"location"];
        }else{
            [para setObject:@"0" forKey:@"oversea"];
            [para setObject:self.addressTextView.provinceTextView.text forKey:@"province"];
            int city = self.addressTextView.cityDataSource.currentRow;
            NSString *cityString = [NSString string];
            if (city > -1) {
                cityString = self.addressTextView.cityTextView.text;
            }
            [para setObject:cityString forKey:@"city"];
            
//            int area = self.addressTextView.areaDataSource.currentRow;
//            NSString *areaString = [NSString string];
//            if (area > -1) {
//                areaString = self.addressTextView.areaTextView.text;
//            }
            [para setObject:@"" forKey:@"area"];
        }
        
        if (self.needUpdateImage) {
            NSString *str1Encoded =  [Base64 encode:UIImageJPEGRepresentation(self.image1, 1.0f)];
            NSString *str2Encoded =  [Base64 encode:UIImageJPEGRepresentation(self.image2, 1.0f)];
            
            [para setObject:[UPLOAD_IMAGE_PREFIX stringByAppendingString:str1Encoded] forKey:@"id_image_1"];
            [para setObject:[UPLOAD_IMAGE_PREFIX stringByAppendingString:str2Encoded] forKey:@"id_image_2"];
        }
        [self callPantuoAPIWithLink:API_UPDATE_GUIDE_INFO WithParameter:para];
    }else{
        UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:GetStringWithKey(@"confirm") otherButtonTitles:nil];
        [tempAlertView setTag:3];
        [tempAlertView show];
    }
}

- (void) handleResponse:(id)response WithLink:(NSString *)aLink WithRequest:(NSDictionary *)aRequest{
    if ([aLink isEqualToString:API_UPDATE_GUIDE_INFO]) {
        GuideInfo *guideInfo = [self getGuideInfo];
        BOOL isCompleted = [guideInfo isGuideProfileCompleted];
        if (isCompleted) {
            [self refreshGuideInfo];
        }else{
            NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:
                                  guideInfo.guide_id,@"guide_id",
                                  guideInfo.token,@"token",nil];
            [self callPantuoAPIWithLink:API_UPDATE_GUIDE_INFO_COMPLETED WithParameter:para];
        }
    }else if ([aLink isEqualToString:API_UPDATE_GUIDE_SOCIAL_INFO]){
        self.socialTypeUpdate = [aRequest objectForKey:@"social_type"];
        if ([self.socialTypeUpdate isEqualToString:SOCIAL_MEDIA_TYPE_QQ]){
            self.guideInfo.social_media_qq = [aRequest objectForKey:@"social_id"];
        }else if ([self.socialTypeUpdate isEqualToString:SOCIAL_MEDIA_TYPE_WEIBO]){
            self.guideInfo.social_media_weibo = [aRequest objectForKey:@"social_id"];
        }else if ([self.socialTypeUpdate isEqualToString:SOCIAL_MEDIA_TYPE_WECHAT]){
            self.guideInfo.social_media_wechat = [aRequest objectForKey:@"social_id"];
        }
        UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:GetStringWithKey(@"socialmedia_reg_success")
                                                               delegate:self
                                                      cancelButtonTitle:GetStringWithKey(@"confirm")
                                                      otherButtonTitles:nil];
        [tempAlertView setTag:2];
        [tempAlertView show];
    }else if ([aLink isEqualToString:API_GET_PROFESSTIONAL]){
        [self setUpSkill:response];
    }else if ([aLink isEqualToString:API_UPDATE_GUIDE_INFO_COMPLETED]){
        [self refreshGuideInfo];
    }else if ([aLink isEqualToString:API_GET_GUIDE_INFO]){
        GuideInfo *guideInfo = [GuideInfo new];
        [guideInfo setUpGuideInfo:response];
        NSData *guideInfoEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:guideInfo];
        [self setUserDefaultWithKey:KEY_GUIDE_INFO WithValue:guideInfoEncodedObject];
        
        [self showUpdatedAlert];
    }
}

- (void) refreshGuideInfo{
    GuideInfo *guideInfo = [self getGuideInfo];
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 guideInfo.token,@"token",
                                 guideInfo.guide_id,@"guide_id",nil];
    
    [self callPantuoAPIWithLink:API_GET_GUIDE_INFO WithParameter:para];
}

- (void) showAlertWithMessage:(NSString *)aMessage{
    UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:aMessage delegate:nil cancelButtonTitle:GetStringWithKey(@"confirm") otherButtonTitles:nil];
    [tempAlertView show];
}

- (void) showUpdatedAlert{
    UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:GetStringWithKey(@"coach_detail_update_success")
                                                           delegate:self
                                                  cancelButtonTitle:GetStringWithKey(@"confirm")
                                                  otherButtonTitles:nil];
    [tempAlertView setTag:1];
    [tempAlertView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - CLLocation
- (void) getLocation{
    if (!self.locationManager) {
        CLLocationManager *tempManager = [[CLLocationManager alloc] init];
        tempManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
        tempManager.desiredAccuracy = kCLLocationAccuracyBest;
        tempManager.delegate = self;
        self.locationManager = tempManager;
    }
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            [self.locationManager requestWhenInUseAuthorization];
        }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted ||
                  [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
            [self goToSetting];
        }else {
            [self.locationManager startUpdatingLocation];
        }
    }else{
        [self.locationManager startUpdatingLocation];
    }
}
- (void) getAddressWithLocation:(CLLocation *)aLocation{
//    // Shanghai 31.245485, 121.394012
//    // Changsha 28.236640, 113.057556
//    // HuiZhou 23.094758, 114.420891
//    aLocation = [[CLLocation alloc] initWithLatitude:23.094758 longitude:114.420891];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:aLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            
            NSString *province = [placemark.addressDictionary objectForKey:@"State"];
            NSString *city = [placemark.addressDictionary objectForKey:@"City"];
            if (self.addressTextView.provinceDataSource.currentRow == -1 && province.length > 0) {
                AddressManager *tempManager = [AddressManager new];
                int provinceId = [tempManager getProvinceIdWithName:province];
                if (provinceId > -1) {
                    self.addressTextView.provinceDataSource.currentRow = provinceId;
                    [self.addressTextView.provinceTextView setText:province];
                    if (city.length > 0) {
                        int cityId = [tempManager getCityIdWithProvince:province WithCity:city];
                        if (cityId > -1) {
                            self.addressTextView.provinceDataSource.currentRow = cityId;
                            [self.addressTextView.cityTextView setText:city];
                        }
                    }
                }
            }
            
//            NSLog(@"dict:%@",[placemark.addressDictionary description]);
//            NSLog(@"city:%@",[placemark.addressDictionary objectForKey:@"City"]);
//            NSLog(@"Country:%@",[placemark.addressDictionary objectForKey:@"Country"]);
//            NSLog(@"FormattedAddressLines:%@",[[placemark.addressDictionary objectForKey:@"FormattedAddressLines"] objectAtIndex:0]);
//            NSLog(@"Name:%@",[placemark.addressDictionary objectForKey:@"Name"]);
//            NSLog(@"State:%@",[placemark.addressDictionary objectForKey:@"State"]);
//            NSLog(@"Street:%@",[placemark.addressDictionary objectForKey:@"Street"]);
//            NSLog(@"Thoroughfare:%@",[placemark.addressDictionary objectForKey:@"Thoroughfare"]);
//            
//            
//            NSLog(@"name:%@",placemark.name);
//            NSLog(@"thoroughfare:%@",placemark.thoroughfare);
//            NSLog(@"subThoroughfare:%@",placemark.subThoroughfare);
//            NSLog(@"locality:%@",placemark.locality);
//            NSLog(@"subLocality:%@",placemark.subLocality);
//            NSLog(@"administrativeArea:%@",placemark.administrativeArea);
//            NSLog(@"subAdministrativeArea:%@",placemark.subAdministrativeArea);
//            NSLog(@"country:%@",placemark.country);
        }
    }];
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusAuthorized || status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    }else if (status != kCLAuthorizationStatusNotDetermined){
        [self goToSetting];
        
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    CLLocation *mLocation = newLocation;
    if (!mLocation) {
        mLocation = oldLocation;
    }
    if (mLocation) {
        [self.locationManager stopUpdatingLocation];
        [self getAddressWithLocation:mLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    self.locationManager.delegate = nil;
    if (error.code ==  kCLErrorDenied) {
        [self goToSetting];
    }
}

- (void) goToSetting{
    NSString *alertStr = [NSString stringWithFormat:@"%@%@%@",GetStringWithKey(@"Turn On Location Services to Allow \""),
                          [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"],
                          GetStringWithKey(@"\" to Determine Your Location")];
    
    UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:alertStr
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:GetStringWithKey(@"ALERT_Cancel")
                                                  otherButtonTitles:nil];
    [tempAlertView show];
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView tag] == 1) {
        NSArray *tempArray = [self.navigationController viewControllers];
        UIViewController *previousViewController = [tempArray objectAtIndex:[tempArray count]-2];
        if ([previousViewController isKindOfClass:[AddActivityViewController class]]) {
            ((AddActivityViewController *)previousViewController).isFinishInfoDetail = YES;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([alertView tag] == 2){
        if ([self.socialTypeUpdate isEqualToString:SOCIAL_MEDIA_TYPE_QQ]){
            [self.socialTextView.qqButton setBackgroundImage:[UIImage imageNamed:@"icn_qq_on.png"] forState:UIControlStateNormal];
        }else if ([self.socialTypeUpdate isEqualToString:SOCIAL_MEDIA_TYPE_WEIBO]){
            [self.socialTextView.weiboButton setBackgroundImage:[UIImage imageNamed:@"icn_weibo_on.png"] forState:UIControlStateNormal];
        }else if ([self.socialTypeUpdate isEqualToString:SOCIAL_MEDIA_TYPE_WECHAT]){
            [self.socialTextView.weChatButton setBackgroundImage:[UIImage imageNamed:@"icn_wechat_on.png"] forState:UIControlStateNormal];
        }
    }else if ([alertView tag] == 3) {
        if (self.scrollToView) {
            int y = self.scrollToView.frame.origin.y;
            [self.mScrollView setContentOffset:CGPointMake(0, y) animated:YES];
        }
    }else if ([alertView tag] == 4) {
        if (buttonIndex == 0) {
            [self tapped];
            [self performSelector:@selector(delayBack) withObject:nil afterDelay:0.5];
        }else{
            [self update];
        }
    }
}

#pragma mark - InputTextViewControllerDelegate
- (void) InputTextViewControllerDidFinish:(InputTextViewController *)aSelf WithText:(NSString *)aText{
    if ([aSelf.titleText isEqualToString:GetStringWithKey(@"coach_detail_other_skills")]) {
        self.guideInfo.other_skill = aText;
        [self setUpOtherSkill:aText];
    }else if ([aSelf.titleText isEqualToString:GetStringWithKey(@"coach_detail_cv")]) {
        self.guideInfo.experience = aText;
        [self setUpExperience:aText];
    }
}

#pragma mark - CustomEditTextViewDelegate
-(void)keyboardWillShow:(NSNotification*)notification
{
    CGFloat height = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGRect tempFrame = self.mScrollView.frame;
    tempFrame.size.height = SCREEN_HEIGHT-90 -height;
    [self.mScrollView setFrame:tempFrame];
    
    tempFrame = self.customEditTextViewFirstResponder.frame;
    if (self.mScrollView.contentOffset.y > tempFrame.origin.y ||
        self.mScrollView.contentOffset.y + self.mScrollView.frame.size.height < tempFrame.origin.y) {
        [self.mScrollView setContentOffset:CGPointMake(0, tempFrame.origin.y) animated:YES];
    }
    
}

-(void)keyboardWillHide:(NSNotification*)notification{
    CGRect tempFrame = self.mScrollView.frame;
    tempFrame.size.height = SCREEN_HEIGHT-90;
    [self.mScrollView setFrame:tempFrame];
}


- (void) CustomEditTextViewDidReturn:(id)aSelf{
    if (aSelf == self.nicknameTextView){
        [self.realnameTextView.mTextField becomeFirstResponder];
    }else if (aSelf == self.realnameTextView){
        [self.emailTextView.mTextField becomeFirstResponder];
    }else if (aSelf == self.emailTextView){
        [self.idCardTextView.mTextField becomeFirstResponder];
    }else if (aSelf == self.idCardTextView){
        [self.otherSkillTextView.mTextField becomeFirstResponder];
    }else if (aSelf == self.otherSkillTextView){
        [self.ePersonTextView.mTextField becomeFirstResponder];
    }else if (aSelf == self.ePersonTextView){
        [self.eNumberTextView.mTextField becomeFirstResponder];
    }else if (aSelf == self.eNumberTextView){
        [self.eNumberTextView.mTextField resignFirstResponder];
    }
}

- (void) CustomEditTextViewDidBegin:(id)aSelf{
    
    CustomEditTextView *tempCustomEditTextView = (CustomEditTextView *)aSelf;
    self.customEditTextViewFirstResponder = tempCustomEditTextView;
}

- (void) CustomEditTextViewDidEnd:(id)aSelf{
}

- (void) CustomEditTextViewDidSelectImage:(BOOL)aLeft{
    self.selectedLeft = aLeft;
    [self showChooseImageActionSheet];
}

- (void) CustomEditTextViewDidSelectSocial:(NSString *)aType{
    if ([aType isEqualToString:SOCIAL_MEDIA_TYPE_QQ]) {
        if (self.guideInfo.social_media_qq.length == 0) {
            AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate tencentLogin];
        }
    }else if ([aType isEqualToString:SOCIAL_MEDIA_TYPE_WECHAT]) {
        if (self.guideInfo.social_media_wechat.length == 0) {
            [self loginWeChat];
        }
    }else if ([aType isEqualToString:SOCIAL_MEDIA_TYPE_WEIBO]) {
        if (self.guideInfo.social_media_weibo.length == 0) {
            WBAuthorizeRequest *request = [WBAuthorizeRequest request];
            request.redirectURI = WEIBO_REDIRECT_URL;
            request.scope = WEIBO_SCOPE;
            [WeiboSDK sendRequest:request];
        }
    }
}

- (void) CustomEditTextViewDidSelectFullpage:(id)aSelf{
    if (aSelf == self.otherSkillTextView) {
        InputTextViewController *vc = [InputTextViewController new];
        vc.maxCount = 100;
        vc.presetText = self.guideInfo.other_skill;
        vc.titleText = GetStringWithKey(@"coach_detail_other_skills");
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
//        [self tapped];
    }else if (aSelf == self.experienceTextView) {
        InputTextViewController *vc = [InputTextViewController new];
        vc.maxCount = 500;
        vc.presetText = self.guideInfo.experience;
        vc.titleText = GetStringWithKey(@"coach_detail_cv");
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
//        [self tapped];
    }
}

#pragma mark - action sheet
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:NULL];
    self.needUpdateImage = YES;
    UIImage *tempImage = [info objectForKey:UIImagePickerControllerEditedImage];
    if (tempImage.size.width > 250 || tempImage.size.height > 250) {
        UIGraphicsBeginImageContext(CGSizeMake(250, 250*tempImage.size.height/tempImage.size.width));
        [tempImage drawInRect:CGRectMake(0,0,250,250*tempImage.size.height/tempImage.size.width)];
        tempImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    if (self.selectedLeft) {
        self.image1 = tempImage;
        [self.imageTextView.image1Button setImage:tempImage forState:UIControlStateNormal];
    }else{
        self.image2 = tempImage;
        [self.imageTextView.image2Button setImage:tempImage forState:UIControlStateNormal];
    }
}

@end
