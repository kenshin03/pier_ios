//
//  PIRRegisterv2ViewController.m
//

#import "PIRRegisterViewController.h"
@import AssetsLibrary;
#import <MobileCoreServices/UTCoreTypes.h>
#import "MRProgress.h"
#import "PIRAppDelegate.h"
#import "PIRAvatar.h"
#import "PIRMenuTabBarController.h"
#import "PIRSeparator.h"
#import "PIRTextFieldElementView.h"
#import "PIRRegistrationPrefixView.h"
#import "PIRUser+Extensions.h"
#import "PIRUserServices.h"
#import "PIRPushNotificationTokens.h"


@interface PIRRegisterViewController ()<
PIRTextFieldElementViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
PIRRegistrationPrefixViewDelegate
>

@property (nonatomic, strong) PIRAvatar *avatar;
@property (nonatomic, strong) UILabel *smsTipLabel;
@property (nonatomic, strong) UILabel *passCodeTipLabel;
@property (nonatomic, strong) PIRSeparator *passCodeSeparator;
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) PIRSeparator *buttonSeparator;
@property (nonatomic, strong) PIRTextFieldElementView *userNameEditView;
@property (nonatomic, strong) PIRTextFieldElementView *firstNameEditView;
@property (nonatomic, strong) PIRTextFieldElementView *lastNameEditView;
@property (nonatomic, strong) PIRRegistrationPrefixView *prefixView;
@property (nonatomic, strong) PIRTextFieldElementView *emailEditView;
@property (nonatomic, strong) PIRTextFieldElementView *phoneEditView;
@property (nonatomic, strong) PIRTextFieldElementView *passCodeEditView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@property (nonatomic, strong) UIImage *profileImage;


@end

@implementation PIRRegisterViewController

#pragma mark - Public
#pragma mark - View lifecycle


- (void)loadView
{
    self.view = [self mainView];
    [self setupNavigationBar];
    [self addSubviewTree];
    [self constrainViews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setupViewWithUserInfo];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public properties

//- (void)setUser:(PIRUser *)user
//{
//    _user = user;
//    [self updateViewWithUser:user];
//}


#pragma mark - Private
#pragma mark - Private properties
- (PIRAvatar *)avatar
{
    if(!_avatar) {
        _avatar = [PIRAvatar new];
        _avatar.backgroundColor = [UIColor clearColor];
        _avatar.translatesAutoresizingMaskIntoConstraints = NO;
        
        UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTapped:)];
        [_avatar addGestureRecognizer:tapRecognizer];
    }
    return _avatar;
}


- (PIRTextFieldElementView *)userNameEditView
{
    if(!_userNameEditView) {
        _userNameEditView = [[PIRTextFieldElementView alloc] initTextFieldElementViewWith:NSLocalizedString(@"Username:", nil) keyBoardType:UIKeyboardTypeDefault  delagate:self];
        _userNameEditView.validateOptions =    PIRTextFieldElementViewValidationNonEmpty |
        PIRTextFieldElementViewValidationIsAlphaNum |
        PIRTextFieldElementViewValidationLength;
        _userNameEditView.validateMinLength = 1;
        _userNameEditView.validateMaxLength = 20;
        
    }
    return _userNameEditView;
}

- (PIRTextFieldElementView *)firstNameEditView
{
    if(!_firstNameEditView) {
        _firstNameEditView = [[PIRTextFieldElementView alloc] initTextFieldElementViewWith:NSLocalizedString(@"First:", nil) keyBoardType:UIKeyboardTypeDefault  delagate:self];
        _firstNameEditView.validateOptions =    PIRTextFieldElementViewValidationNonEmpty |
                                                PIRTextFieldElementViewValidationIsAlphaOnly |
                                                PIRTextFieldElementViewValidationLength;
        _firstNameEditView.validateMinLength = 1;
        _firstNameEditView.validateMaxLength = 100;

    }
    return _firstNameEditView;
}
- (PIRTextFieldElementView *)lastNameEditView
{
    if (!_lastNameEditView){
        _lastNameEditView = [[PIRTextFieldElementView alloc] initTextFieldElementViewWith:NSLocalizedString(@"Last:", nil) keyBoardType:UIKeyboardTypeDefault  delagate:self];
        _lastNameEditView.validateOptions = PIRTextFieldElementViewValidationNonEmpty |
                                            PIRTextFieldElementViewValidationIsAlphaOnly |
                                            PIRTextFieldElementViewValidationLength;
        _lastNameEditView.validateMinLength = 1;
        _lastNameEditView.validateMaxLength = 100;
    }
    return _lastNameEditView;
}

- (PIRRegistrationPrefixView *)prefixView
{
    if (!_prefixView){
        _prefixView = [PIRRegistrationPrefixView new];
        _prefixView.delegate = self;
    }
    return _prefixView;
}

- (PIRTextFieldElementView *)emailEditView
{
    if(!_emailEditView)
    {
        _emailEditView = [[PIRTextFieldElementView alloc] initTextFieldElementViewWith:NSLocalizedString(@"Email:", nil) keyBoardType:UIKeyboardTypeEmailAddress  delagate:self];
        _emailEditView.validateOptions =    PIRTextFieldElementViewValidationNonEmpty |
                                            PIRTextFieldElementViewValidationIsEmail |
                                            PIRTextFieldElementViewValidationLength;
        
        // email length - http://stackoverflow.com/a/386302/1445534
        _emailEditView.validateMinLength = 4;
        _emailEditView.validateMaxLength = 320;
        
    }
    return _emailEditView;
}
- (PIRTextFieldElementView *)phoneEditView
{
    if(!_phoneEditView)
    {
        _phoneEditView = [[PIRTextFieldElementView alloc] initTextFieldElementViewWith:NSLocalizedString(@"Phone:", nil) keyBoardType:UIKeyboardTypePhonePad  delagate:self];
        _phoneEditView.validateOptions =    PIRTextFieldElementViewValidationNonEmpty |
                                            PIRTextFieldElementViewValidationIsInteger |
                                            PIRTextFieldElementViewValidationLength;
        
        // phone numbers - max 20 chars?
        _phoneEditView.validateMinLength = 8;
        _phoneEditView.validateMaxLength = 20;

    }
    return _phoneEditView;
}
- (PIRTextFieldElementView *)passCodeEditView
{
    if(!_passCodeEditView)
    {
        _passCodeEditView = [[PIRTextFieldElementView alloc] initTextFieldElementViewWith:NSLocalizedString(@"Passcode:", nil) keyBoardType:UIKeyboardTypeNumberPad  delagate:self];
        _passCodeEditView.validateOptions = PIRTextFieldElementViewValidationNonEmpty |
                                            PIRTextFieldElementViewValidationIsInteger |
                                            PIRTextFieldElementViewValidationLength;
        
        // pass codes must be 6 chars long
        _passCodeEditView.validateMinLength = 6;
        _passCodeEditView.validateMaxLength = 6;
        
    }
    return _passCodeEditView;
}
- (UILabel *)smsTipLabel
{
    if(!_smsTipLabel)
    {
        _smsTipLabel = [UILabel new];
        _smsTipLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _smsTipLabel.textAlignment = NSTextAlignmentCenter;
        _smsTipLabel.font = [PIRFont introduceLabelFont];
        _smsTipLabel.textColor = [PIRColor secondaryTextColor];
        _smsTipLabel.text = NSLocalizedString(@"Pier will send a text to this number for activation.", nil);
    }
    return _smsTipLabel;
}
- (UILabel *)passCodeTipLabel
{
    if(!_passCodeTipLabel)
    {
        _passCodeTipLabel = [UILabel new];
        _passCodeTipLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _passCodeTipLabel.textAlignment = NSTextAlignmentCenter;
        _passCodeTipLabel.font = [PIRFont introduceLabelFont];
        _passCodeTipLabel.textColor = [PIRColor secondaryTextColor];
        _passCodeTipLabel.text = NSLocalizedString(@"Passcode is for confirming payments.", nil);
    }
    return _passCodeTipLabel;
}
- (PIRSeparator *)passCodeSeparator
{
    if(!_passCodeSeparator)
    {
        _passCodeSeparator = [PIRSeparator new];
        _passCodeSeparator.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _passCodeSeparator;
}
- (UIButton *)registerButton
{
    if(!_registerButton)
    {
        _registerButton = [UIButton new];
        _registerButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_registerButton setTitle:NSLocalizedString(@"Sign up", nil) forState:UIControlStateNormal];
        [_registerButton setTintColor:[PIRColor defaultButtonTextColor]];
        _registerButton.backgroundColor = [PIRColor defaultTintColor];
        _registerButton.layer.cornerRadius = 3.0;
        _registerButton.layer.masksToBounds = YES;
        [_registerButton addTarget:self action:@selector(registerButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}
- (UIScrollView *)scrollView
{
    if(!_scrollView)
    {
        _scrollView = [UIScrollView new];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _scrollView;
}
- (UIView *)containerView
{
    if(!_containerView)
    {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor clearColor];
        _containerView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _containerView;
}

- (UIImagePickerController*)imagePickerController
{
    if (!_imagePickerController) {
        UIImagePickerController * picker = [UIImagePickerController new];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.mediaTypes = @[(__bridge NSString *)kUTTypeImage];
        picker.delegate = self;
        _imagePickerController = picker;
    }
    return _imagePickerController;
}

#pragma mark - Initialization helpers
- (UIView *)mainView
{
    UIView *mainView = [UIView new];
    mainView.backgroundColor = [UIColor whiteColor];
    mainView.translatesAutoresizingMaskIntoConstraints = NO;
    return mainView;
}

- (void)setupNavigationBar
{
    self.navigationItem.title = NSLocalizedString(@"Sign up", nil);
    self.navigationController.navigationBar.tintColor =[PIRColor navigationBarButtonItemsTitleColor];
}

- (void)addSubviewTree
{
    [self.containerView addSubview:self.avatar];
    [self.containerView addSubview:self.userNameEditView];
    [self.containerView addSubview:self.firstNameEditView];
    [self.containerView addSubview:self.lastNameEditView];
    [self.containerView addSubview:self.prefixView];
    [self.containerView addSubview:self.emailEditView];
    [self.containerView addSubview:self.phoneEditView];
    [self.containerView addSubview:self.smsTipLabel];
    [self.containerView addSubview:self.passCodeEditView];
    [self.containerView addSubview:self.passCodeTipLabel];
    [self.containerView addSubview:self.registerButton];
    [self.scrollView addSubview:self.containerView];
    [self.view addSubview:self.scrollView];
}

- (void)constrainViews
{

    NSDictionary * views = @{
                             @"avatar":self.avatar,
                             @"userNameEditView":self.userNameEditView,
                             @"firstNameEditView":self.firstNameEditView,
                             @"lastNameEditView":self.lastNameEditView,
                             @"prefixView":self.prefixView,
                             @"emailEditView":self.emailEditView,
                             @"phoneEditView":self.phoneEditView,
                             @"smsTipLabel":self.smsTipLabel,
                             @"passCodeEditView":self.passCodeEditView,
                             @"passCodeTipLabel":self.passCodeTipLabel,
                             @"registerButton":self.registerButton,
                             @"containerView":self.containerView,
                             @"scrollView":self.scrollView,
                             };
    //iPhone5 or else
    CGFloat height = 568.0;
//    if(iPhone5)
//        height = 568.0;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|[scrollView(320)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               [NSString stringWithFormat:@"V:|[scrollView(%f)]|",height]
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|[containerView(320)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               [NSString stringWithFormat:@"V:|[containerView(%f)]|",height]
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|-20-[avatar(80)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                        @"H:|[userNameEditView(320)]|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                        @"H:|[firstNameEditView(320)]|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                        @"H:|[lastNameEditView(320)]|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:views]];
    
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                        @"H:|[prefixView(320)]|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                        @"H:|[emailEditView(320)]|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                        @"H:|[phoneEditView(320)]|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                        @"H:|[smsTipLabel(320)]|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                        @"H:|[passCodeEditView(320)]|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                        @"H:|[passCodeTipLabel(320)]|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                        @"H:|-10-[registerButton(300)]-10-|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"V:|-[avatar(80)]-[userNameEditView(44)]-[firstNameEditView(44)]-[lastNameEditView(44)]-[prefixView(44)]-[emailEditView(44)]-[phoneEditView(44)]-[smsTipLabel]-5-[passCodeEditView(44)]-[passCodeTipLabel]-10-[registerButton(44)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    
    
    
}

- (void)setupViewWithUserInfo
{
    
    // attempt to get user info from address book
    NSDictionary * userInfoFromAddressBook = [[PIRUserServices sharedService] lookupOwnUserInfoFromAddressBook];
    
    self.firstNameEditView.elementTextField.text = userInfoFromAddressBook[@"firstName"];
    self.lastNameEditView.elementTextField.text = userInfoFromAddressBook[@"lastName"];
    self.phoneEditView.elementTextField.text = userInfoFromAddressBook[@"phoneNumbers"];
}



#pragma makr - private methods

- (void)updateViewWithUser:(PIRUser*)user
{
    if ([user.thumbnailURL length]) {
        self.avatar.user = user;
    }
    if ([user.firstName length]) {
        self.firstNameEditView.elementTextField.text = user.firstName;
    }
    if ([user.lastName length]) {
        self.lastNameEditView.elementTextField.text = user.lastName;
    }
    if ([user.email length]) {
        self.emailEditView.elementTextField.text = user.email;
    }
    if ([user.phoneNumber length]) {
        self.phoneEditView.elementTextField.text = user.phoneNumber;
    }
}

#pragma mark - Event Handler methods

- (void)avatarTapped:(id)sender
{
    // bring up camera roll
    DLog(@"avatarTapped");
    [self presentImagePicker];
}

- (void)registerButtonTapped:(id)sender
{
    // invoke validation on all textfields again
    BOOL isValidated = YES;
    isValidated = [self.firstNameEditView validateTextField];
    isValidated = [self.lastNameEditView validateTextField];
    isValidated = [self.emailEditView validateTextField];
    isValidated = [self.phoneEditView validateTextField];
    isValidated = [self.passCodeEditView validateTextField];
    isValidated = [self.userNameEditView validateTextField];
    
    if (isValidated) {
        
        // scroll to top, dismisses keyboard
        [self.userNameEditView.elementTextField resignFirstResponder];
        [self.firstNameEditView.elementTextField resignFirstResponder];
        [self.lastNameEditView.elementTextField resignFirstResponder];
        [self.emailEditView.elementTextField resignFirstResponder];
        [self.phoneEditView.elementTextField resignFirstResponder];
        [self.passCodeEditView.elementTextField resignFirstResponder];
        CGRect scrollViewFrame = self.scrollView.frame;
        scrollViewFrame.origin.y = 0;
        [self.scrollView scrollRectToVisible:scrollViewFrame animated:YES];
        
        // update user object
        PIRUser *newUser = [PIRUser createEntity];
        newUser.userName = self.userNameEditView.elementTextField.text;
        newUser.firstName = self.firstNameEditView.elementTextField.text;
        newUser.lastName = self.lastNameEditView.elementTextField.text;
        newUser.email = self.emailEditView.elementTextField.text;
        newUser.phoneNumber = self.phoneEditView.elementTextField.text;
        newUser.status = @(PIRUserStatusPendingVerification);
        
        // to-do: encrypt this passcode?
        newUser.passCode = self.passCodeEditView.elementTextField.text;
        
        /*
        PIRAppDelegate * appDelegate = (PIRAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        PIRPushNotificationTokens* token = [PIRPushNotificationTokens createEntity];
        token.token = [appDelegate valueForKey:@"pushNotificationToken"];
        [self.user addPushNotificationTokensObject:token];
        */
        
        // find country from locale
        NSString * countryCode = [[NSLocale autoupdatingCurrentLocale] objectForKey: NSLocaleCountryCode];
        newUser.country = countryCode;
        
        if (self.profileImage){
            newUser.thumbnailImage = self.profileImage;
        }
        
        MRProgressOverlayView * progressView = [MRProgressOverlayView new];
        progressView.titleLabelText = NSLocalizedString(@"Creating account...", nil);
        progressView.mode = MRProgressOverlayViewModeIndeterminate;
        [self.view.superview addSubview:progressView];
        [progressView show:YES];
        
        // call web service
        [[PIRUserServices sharedService] registerUser:newUser success:^{
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                progressView.titleLabelText = NSLocalizedString(@"You're all set. Welcome aboard!", nil);
                progressView.mode = MRProgressOverlayViewModeCheckmark;
                
                double delayInSeconds = 2.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [progressView dismiss:YES];
                    
                        DLog(@"saved user to coredata");
                        PIRMenuTabBarController * menuController = [PIRMenuTabBarController new];
                        
                        [UIView
                         transitionWithView:[[[UIApplication sharedApplication] delegate] window]
                         duration:0.4
                         options:UIViewAnimationOptionTransitionCrossDissolve
                         animations:^(void) {
                             BOOL oldState = [UIView areAnimationsEnabled];
                             [UIView setAnimationsEnabled:NO];
                             [[[UIApplication sharedApplication] delegate] window].rootViewController = menuController;
                             [UIView setAnimationsEnabled:oldState];
                         }
                         completion:^(BOOL finished) {
                             
                         }];
                    
                });
            });
            
        } error:^(NSError *error) {
            
            NSString *errorString = nil;
            switch (error.code) {
                case PIRUserServicesErrorCodePierEmailPhoneExisted:
                    errorString = NSLocalizedString(@"An account with provided Email or phone number already exists in ", nil);
                    break;
                case PIRUserServicesErrorCodePierUserNameExisted:
                    errorString = NSLocalizedString(@"An account with provided username already exists in ", nil);
                    break;
                default:
                    errorString = NSLocalizedString(@"An error occurred. Please try again later.", nil);
                    break;
            }
            progressView.titleLabelText = errorString;
            progressView.mode = MRProgressOverlayViewModeCross;
            
            double delayInSeconds = 2.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [progressView dismiss:YES];
            });
            
        }];
        
    }
}

#pragma mark - UIKeyboardWillShowNotification handling methods
- (void)keyBoardWillShow:(NSNotification *)notification
{
    CGFloat offset = 180.0;
    self.scrollView.contentSize = CGSizeMake(320, self.view.bounds.size.height+offset);
    
}
- (void)keyBoardWillHide:(NSNotification *)notification
{
    self.scrollView.contentSize = CGSizeMake(320, self.view.bounds.size.height);
}

#pragma mark - PIRTextFieldElementView delegate methods

- (void)textFieldElementView:(PIRTextFieldElementView*)view textFieldDidBeginEditing:(UITextField *)textField
{
    // adjust scrollview to show textfield
    CGRect fieldFrameinView = [self.scrollView convertRect:textField.frame fromView:textField.superview];
    // adjust scroll factor. no need to scroll element all the way to top.
    fieldFrameinView.origin.y -= 150.0;
    fieldFrameinView.origin.x = 0.0;
    [self.scrollView setContentOffset:fieldFrameinView.origin animated:YES];
    
}

#pragma mark - UIImagePicker related methods

- (void) presentImagePicker
{
    [self.navigationController presentViewController:self.imagePickerController animated:YES completion:^{
        // done
    }];
    
}

- (BOOL) isPhotoLibraryAvailable
{
    return [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary];
}


#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __weak PIRRegisterViewController * weakSelf = self;
    
    NSURL * assetImageURL = info[UIImagePickerControllerReferenceURL];
    ALAssetsLibrary * assetsLibrary = [ALAssetsLibrary new];
    [assetsLibrary assetForURL:assetImageURL resultBlock:^(ALAsset *asset) {
        ALAssetRepresentation * rep = [asset defaultRepresentation];
        
        // to-do: scale this down
        CGImageRef imageRef = [rep fullResolutionImage];
        UIImage * selectedImage = [UIImage imageWithCGImage:imageRef];
        
        // got image, clear out user's thumbnailURL
        weakSelf.profileImage = selectedImage;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // update avatar
            weakSelf.avatar.userImage = selectedImage;
            
            [weakSelf.imagePickerController dismissViewControllerAnimated:YES completion:^{
                // done
            }];
        });
    } failureBlock:^(NSError *error) {
        // to-do: handle error
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePickerController dismissViewControllerAnimated:YES completion:^{
        // done
    }];
    
}

#pragma mark - PIRRegistrationPrefixViewDelegate methods

-(void)prefixView:(PIRRegistrationPrefixView*)view misterButtonTapped:(BOOL)tapped
{
//    self.user.prefix = @"Mr.";
}

-(void)prefixView:(PIRRegistrationPrefixView*)view mrsButtonTapped:(BOOL)tapped
{
//    self.user.prefix = @"Mrs.";
}

-(void)prefixView:(PIRRegistrationPrefixView*)view missButtonTapped:(BOOL)tapped
{
//    self.user.prefix = @"Ms.";
}


@end
