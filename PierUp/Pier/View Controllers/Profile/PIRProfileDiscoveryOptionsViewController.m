//
//  PIRProfileDiscoveryOptionsViewController.m

//
//  Created by Kenny Tang on 1/5/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRProfileDiscoveryOptionsViewController.h"
#import "PIRPeerConnectivity.h"
#import "PIRUser+Extensions.h"
#import "PIRUserServices.h"

@interface PIRProfileDiscoveryOptionsViewController ()

@property (nonatomic, strong) UIBarButtonItem * doneButton;

@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) UIView * contentView;

@property (nonatomic, strong) UIButton * visibleToPierUsersButton;
@property (nonatomic, strong) UIButton * visibleToContactsButton;
@property (nonatomic, strong) UIButton * visibleToSocialFriendsButton;
@property (nonatomic, strong) UIButton * cancelButton;

@property (nonatomic, strong) UIImageView * headerViewIconImageView;
@property (nonatomic, strong) UILabel * headerViewTitleLabel;
@property (nonatomic, strong) UILabel * headerViewDescriptionLabel;

@end

@implementation PIRProfileDiscoveryOptionsViewController

#pragma mark - Public

#pragma mark - View lifecycle

- (void)loadView
{
    self.view = [self mainView];
    [self addSubviewTree];
    [self setupNavigationBar];
    [self constrainViews];
    PIRUser * user = [[PIRUserServices sharedService] currentUser];
    [self updateViewWithUser:user];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


#pragma mark - Initialization

#pragma mark - Public properties

#pragma mark - Public mehtods

#pragma mark - Private

#pragma mark - Private properties



- (UIBarButtonItem*)doneButton
{
    if (!_doneButton) {
        _doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonTapped:)];
        _doneButton.tintColor = [PIRColor navigationBarButtonItemsTitleColor];
    }
    return _doneButton;
}

- (UIView*)contentView
{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentView.backgroundColor = [PIRColor defaultBackgroundColor];
    }
    return _contentView;
}

- (UIView*)headerView
{
    if (!_headerView) {
        _headerView = [UIView new];
        _headerView.translatesAutoresizingMaskIntoConstraints = NO;
        _headerView.backgroundColor = [PIRColor defaultBackgroundColor];
    }
    return _headerView;
}

- (UIButton*)visibleToPierUsersButton
{
    if (!_visibleToPierUsersButton) {
        _visibleToPierUsersButton = [UIButton new];
        _visibleToPierUsersButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_visibleToPierUsersButton setTitle:@"Pier Users" forState:UIControlStateNormal];
        _visibleToPierUsersButton.titleLabel.font = [PIRFont navigationBarTitleFont];
        [_visibleToPierUsersButton setTitleColor:[PIRColor defaultTintColor] forState:UIControlStateNormal];
        [_visibleToPierUsersButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _visibleToPierUsersButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _visibleToPierUsersButton.layer.borderWidth = 0.5;
        _visibleToPierUsersButton.backgroundColor = [UIColor clearColor];
        [_visibleToPierUsersButton addTarget:self action:@selector(visibleToPierUsersButtonTapped:) forControlEvents:UIControlEventTouchDown];
    }
    return _visibleToPierUsersButton;
}

- (UIButton*)visibleToContactsButton
{
    if (!_visibleToContactsButton) {
        _visibleToContactsButton = [UIButton new];
        _visibleToContactsButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_visibleToContactsButton setTitle:@"Contacts" forState:UIControlStateNormal];
        _visibleToContactsButton.titleLabel.font = [PIRFont navigationBarTitleFont];
        [_visibleToContactsButton setTitleColor:[PIRColor defaultTintColor] forState:UIControlStateNormal];
        [_visibleToContactsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _visibleToContactsButton.backgroundColor = [UIColor clearColor];
        _visibleToContactsButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _visibleToContactsButton.layer.borderWidth = 0.5;
        [_visibleToContactsButton addTarget:self action:@selector(visibleToContactsButtonTapped:) forControlEvents:UIControlEventTouchDown];
    }
    return _visibleToContactsButton;
}

- (UIButton*)visibleToSocialFriendsButton
{
    if (!_visibleToSocialFriendsButton) {
        _visibleToSocialFriendsButton = [UIButton new];
        [_visibleToSocialFriendsButton setTitle:@"Social Friends" forState:UIControlStateNormal];
        _visibleToSocialFriendsButton.titleLabel.font = [PIRFont navigationBarTitleFont];
        [_visibleToSocialFriendsButton setTitleColor:[PIRColor defaultTintColor] forState:UIControlStateNormal];
        [_visibleToSocialFriendsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _visibleToSocialFriendsButton.backgroundColor = [UIColor clearColor];
        _visibleToSocialFriendsButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _visibleToSocialFriendsButton.layer.borderWidth = 0.5;
        _visibleToSocialFriendsButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_visibleToSocialFriendsButton addTarget:self action:@selector(visibleToSocialFriendsButtonTapped:) forControlEvents:UIControlEventTouchDown];
    }
    return _visibleToSocialFriendsButton;
}

- (UILabel*)headerViewTitleLabel
{
    if (!_headerViewTitleLabel) {
        _headerViewTitleLabel = [UILabel new];
        _headerViewTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _headerViewTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        _headerViewTitleLabel.text = @"Visibility Options";
    }
    return _headerViewTitleLabel;
}

- (UILabel*)headerViewDescriptionLabel
{
    if (!_headerViewDescriptionLabel) {
        _headerViewDescriptionLabel = [UILabel new];
        _headerViewDescriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _headerViewDescriptionLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        _headerViewDescriptionLabel.text = @"You can make yourself discoverable to all Pier users, only people in your contacts or your Social friends.";
        _headerViewDescriptionLabel.numberOfLines = 0;
    }
    return _headerViewDescriptionLabel;
}

- (UIImageView*)headerViewIconImageView
{
    if (!_headerViewIconImageView) {
        _headerViewIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ReceiveIcon"]];
        _headerViewIconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _headerViewIconImageView;
}


#pragma mark - Initialization helpers

- (UIView *)mainView
{
    UIView *mainView = [UIView new];
    mainView.backgroundColor = [PIRColor defaultBackgroundColor];
    mainView.translatesAutoresizingMaskIntoConstraints = NO;
    return mainView;
}


- (void)setupNavigationBar
{
    self.navigationItem.title = NSLocalizedString(@"Visibility Options", nil);
    self.navigationItem.rightBarButtonItem = self.doneButton;
}

- (void)addHeaderViewSubview
{
    [self.headerView addSubview:self.headerViewIconImageView];
    [self.headerView addSubview:self.headerViewTitleLabel];
    [self.headerView addSubview:self.headerViewDescriptionLabel];
}

- (void)addSubviewTree
{
    [self addHeaderViewSubview];
    [self.contentView addSubview:self.headerView];
    [self.contentView addSubview:self.visibleToPierUsersButton];
    [self.contentView addSubview:self.visibleToContactsButton];
    [self.contentView addSubview:self.visibleToSocialFriendsButton];
    [self.view addSubview:self.contentView];
}

- (void)constrainHeaderSubviews
{
    NSDictionary * views = @{
                             @"headerViewTitleLabel":self.headerViewTitleLabel,
                             @"headerViewDescriptionLabel": self.headerViewDescriptionLabel,
                             @"headerViewIconImageView": self.headerViewIconImageView
                             };
    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                     @"H:|[headerViewIconImageView(40)]"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:views]];
    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                     @"V:|[headerViewIconImageView(50)]"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:views]];
    
    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                     @"H:[headerViewTitleLabel(210)]|"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:views]];
    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                     @"H:[headerViewDescriptionLabel(210)]|"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:views]];
    [self.headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                     @"V:|[headerViewTitleLabel]-[headerViewDescriptionLabel]"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:views]];
    
}

- (void)constrainViews
{
    [self constrainHeaderSubviews];
    NSDictionary * views = @{
                             @"contentView":self.contentView,
                             @"headerView":self.headerView,
                             @"receiveFromPierUsersButton": self.visibleToPierUsersButton,
                             @"receiveFromContactsButton": self.visibleToContactsButton,
                             @"receiveFromSocialFriendsButton": self.visibleToSocialFriendsButton,
                             };
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"V:|-100-[headerView(80)]-40-[receiveFromPierUsersButton(40)]-20-[receiveFromContactsButton(40)]-20-[receiveFromSocialFriendsButton(40)]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|-[headerView]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|-[receiveFromPierUsersButton]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|-[receiveFromContactsButton]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|-[receiveFromSocialFriendsButton]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|[contentView(320)]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"V:|[contentView(568)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
}

- (void)updateViewWithUser:(PIRUser*)user
{
    PIRUser * currentUser = [[PIRUserServices sharedService] currentUser];
    switch ([currentUser.visibilityOptions integerValue]) {
        case PIRVisibilityOptionsPierUsers:
        {
            [self visibleToPierUsersButtonTapped:nil];
        }
            break;
        case PIRVisibilityOptionsContactsOnly:
        {
            [self visibleToContactsButtonTapped:nil];
        }
            break;
        case PIRVisibilityOptionsSocialFriends:
        {
            [self visibleToSocialFriendsButtonTapped:nil];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - Event Handler methods

- (void)doneButtonTapped:(id)sender
{
    PIRUser * user = [[PIRUserServices sharedService] currentUser];
    
    if (self.visibleToPierUsersButton.selected){
        user.visibilityOptions = @(PIRVisibilityOptionsPierUsers);
        
    }else if (self.visibleToContactsButton){
        user.visibilityOptions = @(PIRVisibilityOptionsContactsOnly);
        
    }else if (self.visibleToSocialFriendsButton){
        user.visibilityOptions = @(PIRVisibilityOptionsSocialFriends);
    }
    
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        
        [[PIRUserServices sharedService] updateCurrentUser:user];
        
        PIRPeerConnectivity* connectivity = [PIRPeerConnectivity sharedInstance];
        [connectivity startsReceivingPayments:[user.visibilityOptions integerValue] error:^(NSError *error) {
            ELog(@"connectivity error: %@", error);
        }];
    }];
}

- (void)visibleToPierUsersButtonTapped:(id)sender
{
    self.visibleToPierUsersButton.selected = YES;
    self.visibleToContactsButton.selected = NO;
    self.visibleToSocialFriendsButton.selected = NO;
    
    self.visibleToPierUsersButton.backgroundColor = [PIRColor defaultTintColor];
    self.visibleToContactsButton.backgroundColor = [UIColor clearColor];
    self.visibleToSocialFriendsButton.backgroundColor = [UIColor clearColor];
    
}

- (void)visibleToContactsButtonTapped:(id)sender
{
    self.visibleToPierUsersButton.selected = NO;
    self.visibleToContactsButton.selected = YES;
    self.visibleToSocialFriendsButton.selected = NO;
    
    self.visibleToPierUsersButton.backgroundColor = [UIColor clearColor];
    self.visibleToContactsButton.backgroundColor = [PIRColor defaultTintColor];
    self.visibleToSocialFriendsButton.backgroundColor = [UIColor clearColor];
    
}

- (void)visibleToSocialFriendsButtonTapped:(id)sender
{
    self.visibleToPierUsersButton.selected = NO;
    self.visibleToContactsButton.selected = NO;
    self.visibleToSocialFriendsButton.selected = YES;
    
    self.visibleToPierUsersButton.backgroundColor = [UIColor clearColor];
    self.visibleToContactsButton.backgroundColor = [UIColor clearColor];
    self.visibleToSocialFriendsButton.backgroundColor = [PIRColor defaultTintColor];
    
}


@end
