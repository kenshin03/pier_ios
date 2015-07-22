//
//  PIRProfileViewController.m

//
//  Created by Kenny Tang on 1/2/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRProfileViewController.h"
#import "PIRAvatar.h"
#import "PIRProfileBankAccountsViewController.h"
#import "PIRProfileInfoViewController.h"
#import "PIRProfilePaymentOptionsViewController.h"
#import "PIRProfilePierCreditsViewController.h"
#import "PIRProfileTransactionsViewController.h"
#import "PIRSeparator.h"
#import "PIRUserServices.h"


@interface PIRProfileViewController ()<
UIScrollViewDelegate,
PIRProfileInfoViewControllerDelegate,
PIRProfileMenuViewDelegate
>

@property (nonatomic, strong) PIRProfileMenuView * menuView;
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UIScrollView * infoScrollView;
@property (nonatomic, strong) UIBarButtonItem * doneEditingButton;


@property (nonatomic, strong) PIRProfileInfoViewController * profileInfoViewController;

@property (nonatomic, strong) PIRProfileBankAccountsViewController * profileBankAccountsViewController;
@property (nonatomic, strong) PIRProfileTransactionsViewController * profileTransactionsViewController;
@property (nonatomic, strong) PIRProfilePaymentOptionsViewController * profilePaymentOptionsViewController;
@property (nonatomic, strong) PIRProfilePierCreditsViewController * profileCreditsViewController;



@end

@implementation PIRProfileViewController

#pragma mark - Public

#pragma mark - View lifecycle

- (void)loadView
{
    self.view = [self mainView];
    [self setupNavigationBar];
    [self addSubviewTree];
    [self constrainViews];
    [self subscribeToUpdateNotifications];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)dealloc
{
    [self removeFromUpdateNotifications];
}

#pragma mark - Initialization

#pragma mark - Public methods

-(void)highlightStatementsScreen
{
//    [self transactionsButtonViewTapped];
}

#pragma mark - Private

#pragma mark - Private properties

- (UIView*)contentView
{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _contentView;
}


-(PIRProfileMenuView*)menuView
{
    if (!_menuView) {
        _menuView = [PIRProfileMenuView new];
        _menuView.translatesAutoresizingMaskIntoConstraints = NO;
        _menuView.delegate = self;
    }
    return _menuView;
}

- (PIRProfileTransactionsViewController*)profileTransactionsViewController
{
    if (!_profileTransactionsViewController) {
        _profileTransactionsViewController = [PIRProfileTransactionsViewController new];
        [self addChildViewController:_profileTransactionsViewController];
    }
    return _profileTransactionsViewController;
}

- (PIRProfileInfoViewController*)profileInfoViewController
{
    if (!_profileInfoViewController) {
        _profileInfoViewController = [PIRProfileInfoViewController new];
        _profileInfoViewController.delegate = self;
        [self addChildViewController:_profileInfoViewController];
    }
    return _profileInfoViewController;
}

- (PIRProfileBankAccountsViewController*)profileBankAccountsViewController
{
    if (!_profileBankAccountsViewController) {
        _profileBankAccountsViewController = [PIRProfileBankAccountsViewController new];
        [self addChildViewController:_profileBankAccountsViewController];
    }
    return _profileBankAccountsViewController;
}

- (PIRProfilePaymentOptionsViewController*)profilePaymentOptionsViewController
{
    if (!_profilePaymentOptionsViewController) {
        _profilePaymentOptionsViewController = [PIRProfilePaymentOptionsViewController new];
        [self addChildViewController:_profilePaymentOptionsViewController];
    }
    return _profilePaymentOptionsViewController;
}

- (PIRProfilePierCreditsViewController*) profileCreditsViewController
{
    if (!_profileCreditsViewController) {
        _profileCreditsViewController = [PIRProfilePierCreditsViewController new];
        [self addChildViewController:_profileCreditsViewController];
    }
    return _profileCreditsViewController;
}


- (UIScrollView*)infoScrollView
{
    if (!_infoScrollView) {
        _infoScrollView = [UIScrollView new];
        _infoScrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _infoScrollView.delegate = self;
        _infoScrollView.backgroundColor = [UIColor clearColor];
        _infoScrollView.pagingEnabled = YES;
    }
    return _infoScrollView;
}


- (UIBarButtonItem*)doneEditingButton
{
    if (!_doneEditingButton) {
        _doneEditingButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneEditingButtonTapped:)];
        _doneEditingButton.tintColor = [PIRColor navigationBarButtonItemsTitleColor];
    }
    return _doneEditingButton;
}


#pragma mark - Initialization helpers

- (UIView *)mainView
{
    UIView *mainView = [UIView new];
    mainView.backgroundColor = [UIColor clearColor];
    mainView.translatesAutoresizingMaskIntoConstraints = NO;
    return mainView;
}


- (void)setupNavigationBar
{
    self.navigationItem.title = NSLocalizedString(@"Profile", nil);
}

- (void)addSubviewTree
{
    [self.contentView addSubview:self.menuView];
    [self.contentView addSubview:self.infoScrollView];
    [self.infoScrollView addSubview:self.profileInfoViewController.view];
    [self.infoScrollView addSubview:self.profileBankAccountsViewController.view];
    [self.infoScrollView addSubview:self.profileCreditsViewController.view];
    [self.infoScrollView addSubview:self.profilePaymentOptionsViewController.view];
    [self.infoScrollView addSubview:self.profileTransactionsViewController.view];
    
    [self.view addSubview:self.contentView];
}

- (void)constrainInfoScrollViews
{
    NSDictionary * views = @{
                             @"infoView":self.profileInfoViewController.view,
                             @"bankAccountsView":self.profileBankAccountsViewController.view,
                             @"creditsView":self.profileCreditsViewController.view,
                             @"optionsView":self.profilePaymentOptionsViewController.view,
                             @"transactionsView":self.profileTransactionsViewController.view,
                             };
    [self.infoScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"V:|[infoView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]
     ];
    [self.infoScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                         @"V:|[bankAccountsView]|"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:views]
     ];
    [self.infoScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                         @"V:|[optionsView]|"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:views]
     ];
    [self.infoScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                         @"V:|[transactionsView]|"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:views]
     ];
    [self.infoScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                         @"H:|[infoView(320)][bankAccountsView(320)][creditsView(320)][optionsView(320)][transactionsView(320)]|"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:views]
     ];
    
}

- (void)constrainViews
{
    NSDictionary * views = @{
                             @"contentView":self.contentView,
                             @"menuView":self.menuView,
                             @"infoScrollView":self.infoScrollView,
                             };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"V:|[contentView(568)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]
     ];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|[contentView(320)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]
     ];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|[menuView(320)]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"V:|[menuView][infoScrollView]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|[infoScrollView(320)]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]];
    
    [self constrainInfoScrollViews];
    
}

- (void)subscribeToUpdateNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userProfileUpdatedNotification:) name:kPIRConstantsProfileUpdatedNotification object:nil];
}

- (void)removeFromUpdateNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPIRConstantsProfileUpdatedNotification object:nil];
}


#pragma mark - Event handlers

- (void)userProfileUpdatedNotification:(NSNotification*)notification
{
//    PIRUser *user = [[PIRUserServices sharedService] currentUser];
    [self.profileInfoViewController refreshData];
//    [self updateViewWithUser:user];
    
}

- (void)doneEditingButtonTapped:(id)sender
{
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)scrollToProfileInfoView
{
    CGRect infoScrollRect = self.infoScrollView.frame;
    [self.infoScrollView scrollRectToVisible:CGRectMake(0, 0, infoScrollRect.size.width, infoScrollRect.size.height) animated:YES];
}

- (void)scrollToBankAccountsView
{
    CGRect infoScrollRect = self.infoScrollView.frame;
    [self.infoScrollView scrollRectToVisible:CGRectMake(infoScrollRect.size.width, 0, infoScrollRect.size.width, infoScrollRect.size.height) animated:YES];
}

- (void)scrollToCreditsView
{
    CGRect infoScrollRect = self.infoScrollView.frame;
    [self.infoScrollView scrollRectToVisible:CGRectMake(infoScrollRect.size.width*2, 0, infoScrollRect.size.width, infoScrollRect.size.height) animated:YES];
}

- (void)scrollToOptionsView
{
    CGRect infoScrollRect = self.infoScrollView.frame;
    [self.infoScrollView scrollRectToVisible:CGRectMake(infoScrollRect.size.width*3, 0, infoScrollRect.size.width, infoScrollRect.size.height) animated:YES];
}

- (void)scrollToStatementsView
{
    CGRect infoScrollRect = self.infoScrollView.frame;
    [self.infoScrollView scrollRectToVisible:CGRectMake(infoScrollRect.size.width*4, 0, infoScrollRect.size.width, infoScrollRect.size.height) animated:YES];
}

#pragma mark - UIScrollview delegate methods


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self doneEditingButtonTapped:nil];
    CGFloat contentOffSet = scrollView.contentOffset.x;
    if (contentOffSet == 320.0) {
        [self.menuView setSelectedViewType:PIRProfileMenuViewTypeBanks];
        
    }else if (contentOffSet == 320.0*2) {
        [self.menuView setSelectedViewType:PIRProfileMenuViewTypeCredit];
        
    }else if (contentOffSet == 320.0*3) {
        [self.menuView setSelectedViewType:PIRProfileMenuViewTypeDiscover];
        
    }else if (contentOffSet == 320.0*4) {
        [self.menuView setSelectedViewType:PIRProfileMenuViewTypeStatements];
        
    }else if (contentOffSet == 0.0) {
        [self.menuView setSelectedViewType:PIRProfileMenuViewTypeInfo];
        
    }
}


#pragma mark - PIRProfileMenuViewDelegate methods

- (void)profileMenuView:(PIRProfileMenuView *)view infoButtonTapped:(BOOL)tapped
{
    [self scrollToProfileInfoView];
}

- (void)profileMenuView:(PIRProfileMenuView *)view banksButtonTapped:(BOOL)tapped
{
    [self scrollToBankAccountsView];
}

- (void)profileMenuView:(PIRProfileMenuView *)view creditButtonTapped:(BOOL)tapped
{
    [self scrollToCreditsView];
}

- (void)profileMenuView:(PIRProfileMenuView *)view visibilityButtonTapped:(BOOL)tapped
{
    [self scrollToOptionsView];
}

- (void)profileMenuView:(PIRProfileMenuView *)view statementsButtonTapped:(BOOL)tapped
{
    [self scrollToStatementsView];
}


@end






@interface PIRProfileOptionsButtonView()

@property (nonatomic, strong) UILabel * optionTitleLabel;

@end

@implementation PIRProfileOptionsButtonView

#pragma mark - Public

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubviewTree];
        [self constrainViews];
        UITapGestureRecognizer * tapRecognizer = [UITapGestureRecognizer new];
        [tapRecognizer addTarget:self action:@selector(viewTapped:)];
        [self addGestureRecognizer:tapRecognizer];
    }
    return self;
}

#pragma mark - Public properties

#pragma mark - Private

#pragma mark - Private properties

- (UILabel*)optionTitleLabel
{
    if (!_optionTitleLabel) {
        _optionTitleLabel = [UILabel new];
        _optionTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _optionTitleLabel.textAlignment = NSTextAlignmentCenter;
        _optionTitleLabel.font = [PIRFont profileOptionsLabelFont];
        _optionTitleLabel.numberOfLines = 0;
        _optionTitleLabel.textColor = [PIRColor primaryTextColor];
        _optionTitleLabel.minimumScaleFactor = 0.2;
    }
    return _optionTitleLabel;
}


#pragma mark - Initialization helpers

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(44.0, 44.0);
}

- (void)addSubviewTree
{
    [self addSubview:self.optionTitleLabel];
}

- (void)constrainViews
{
    NSDictionary * views = @{
                             @"optionTitleLabel":self.optionTitleLabel,
                             };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[optionTitleLabel]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[optionTitleLabel]|" options:0 metrics:nil views:views]];
    
}

#pragma mark - Event handlers

- (void)viewTapped:(id)sender
{
    if (self.actionBlock) {
        self.actionBlock();
    }
}

@end





@interface PIRProfileMenuView()

@property (nonatomic, strong) PIRProfileOptionsButtonView * infoButtonView;
@property (nonatomic, strong) PIRProfileOptionsButtonView * bankAccountsButtonView;
@property (nonatomic, strong) PIRProfileOptionsButtonView * pierCreditButtonView;
@property (nonatomic, strong) PIRProfileOptionsButtonView * visibilityButtonView;
@property (nonatomic, strong) PIRProfileOptionsButtonView * statementsButtonView;

@end



@implementation PIRProfileMenuView

#pragma mark - Public

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [PIRColor profileMenuColor];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubviewTree];
        [self constrainViews];
    }
    return self;
}

#pragma mark - Public methods

- (void)setSelectedViewType:(PIRProfileMenuViewType)type
{
    switch (type) {
        case PIRProfileMenuViewTypeInfo:
        {
            [self infoButtonViewTapped];
        }
            break;
        case PIRProfileMenuViewTypeBanks:
        {
            [self bankAccountsButtonViewTapped];
        }
            break;
        case PIRProfileMenuViewTypeCredit:
        {
            [self creditsButtonViewTapped];
        }
            break;
        case PIRProfileMenuViewTypeDiscover:
        {
            [self optionsButtonViewTapped];
        }
            break;
        case PIRProfileMenuViewTypeStatements:
        {
            [self transactionsButtonViewTapped];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Private

#pragma mark - Private properties

- (PIRProfileOptionsButtonView*)infoButtonView
{
    if (!_infoButtonView) {
        
        __weak PIRProfileMenuView * weakSelf = self;
        _infoButtonView = [PIRProfileOptionsButtonView new];
        _infoButtonView.translatesAutoresizingMaskIntoConstraints = NO;
        _infoButtonView.optionTitleLabel.text = NSLocalizedString(@"Profile", nil);
        _infoButtonView.optionTitleLabel.font = [PIRFont profileOptionsLabelFont];
        _infoButtonView.optionTitleLabel.textColor = [PIRColor defaultButtonTextColor];
        _infoButtonView.actionBlock = ^{
            [weakSelf infoButtonViewTapped];
        };
    }
    return _infoButtonView;
}

- (PIRProfileOptionsButtonView*)bankAccountsButtonView
{
    if (!_bankAccountsButtonView) {
        
        __weak PIRProfileMenuView * weakSelf = self;
        _bankAccountsButtonView = [PIRProfileOptionsButtonView new];
        _bankAccountsButtonView.translatesAutoresizingMaskIntoConstraints = NO;
        _bankAccountsButtonView.optionTitleLabel.text = NSLocalizedString(@"Banks", nil);
        _bankAccountsButtonView.optionTitleLabel.font = [PIRFont profileOptionsLabelFont];
        _bankAccountsButtonView.optionTitleLabel.textColor = [PIRColor profileOptionsButtonTextNormalColor];
        _bankAccountsButtonView.actionBlock = ^{
            [weakSelf bankAccountsButtonViewTapped];
        };
    }
    return _bankAccountsButtonView;
}

- (PIRProfileOptionsButtonView*)pierCreditButtonView
{
    if (!_pierCreditButtonView) {
        
        __weak PIRProfileMenuView * weakSelf = self;
        _pierCreditButtonView = [PIRProfileOptionsButtonView new];
        _pierCreditButtonView.translatesAutoresizingMaskIntoConstraints = NO;
        _pierCreditButtonView.optionTitleLabel.text = NSLocalizedString(@"Credit", nil);
        _pierCreditButtonView.optionTitleLabel.font = [PIRFont profileOptionsLabelFont];
        _pierCreditButtonView.optionTitleLabel.textColor = [PIRColor profileOptionsButtonTextNormalColor];
        _pierCreditButtonView.actionBlock = ^{
            [weakSelf creditsButtonViewTapped];
        };
    }
    return _pierCreditButtonView;
}

- (PIRProfileOptionsButtonView*)visibilityButtonView
{
    if (!_visibilityButtonView) {
        
        __weak PIRProfileMenuView * weakSelf = self;
        _visibilityButtonView = [PIRProfileOptionsButtonView new];
        _visibilityButtonView.translatesAutoresizingMaskIntoConstraints = NO;
        _visibilityButtonView.optionTitleLabel.text = NSLocalizedString(@"Discover", nil);
        _visibilityButtonView.optionTitleLabel.font = [PIRFont profileOptionsLabelFont];
        _visibilityButtonView.optionTitleLabel.textColor = [PIRColor profileOptionsButtonTextNormalColor];
        _visibilityButtonView.actionBlock = ^{
            [weakSelf optionsButtonViewTapped];
        };
    }
    return _visibilityButtonView;
}

- (PIRProfileOptionsButtonView*)statementsButtonView
{
    if (!_statementsButtonView) {
        
        __weak PIRProfileMenuView * weakSelf = self;
        _statementsButtonView = [PIRProfileOptionsButtonView new];
        _statementsButtonView.translatesAutoresizingMaskIntoConstraints = NO;
        _statementsButtonView.optionTitleLabel.text = NSLocalizedString(@"Stmts", nil);
        _statementsButtonView.optionTitleLabel.font = [PIRFont profileOptionsLabelFont];
        _statementsButtonView.optionTitleLabel.textColor = [PIRColor profileOptionsButtonTextNormalColor];
        _statementsButtonView.actionBlock = ^{
            [weakSelf transactionsButtonViewTapped];
        };
    }
    return _statementsButtonView;
}



#pragma mark - Initialization helpers

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(320.0, 64.0);
}

- (void)addSubviewTree
{
    [self addSubview:self.infoButtonView];
    [self addSubview:self.bankAccountsButtonView];
    [self addSubview:self.pierCreditButtonView];
    [self addSubview:self.visibilityButtonView];
    [self addSubview:self.statementsButtonView];
}

- (void)constrainViews
{
    NSDictionary * views = @{
                             @"infoButtonView":self.infoButtonView,
                             @"bankAccountsButtonView":self.bankAccountsButtonView,
                             @"pierCreditButtonView":self.pierCreditButtonView,
                             @"visibilityButtonView":self.visibilityButtonView,
                             @"statementsButtonView":self.statementsButtonView,
                             };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                          @"V:|[infoButtonView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                          @"V:|[bankAccountsButtonView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                          @"V:|[pierCreditButtonView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                          @"V:|[visibilityButtonView]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                          @"V:|[statementsButtonView]|" options:0 metrics:nil views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                          @"H:|[infoButtonView]-[bankAccountsButtonView]-[pierCreditButtonView]-[visibilityButtonView]-[statementsButtonView]-|" options:0 metrics:nil views:views]];
}

#pragma mark - event handlers


- (void)infoButtonViewTapped
{
    self.infoButtonView.optionTitleLabel.textColor = [PIRColor defaultButtonTextColor];
    self.bankAccountsButtonView.optionTitleLabel.textColor = [PIRColor profileOptionsButtonTextNormalColor];
    self.pierCreditButtonView.optionTitleLabel.textColor = [PIRColor profileOptionsButtonTextNormalColor];
    self.visibilityButtonView.optionTitleLabel.textColor = [PIRColor profileOptionsButtonTextNormalColor];
    self.statementsButtonView.optionTitleLabel.textColor = [PIRColor profileOptionsButtonTextNormalColor];
    [self.delegate profileMenuView:self infoButtonTapped:YES];
}

- (void)bankAccountsButtonViewTapped
{
    self.infoButtonView.optionTitleLabel.textColor = [PIRColor profileOptionsButtonTextNormalColor];
    self.bankAccountsButtonView.optionTitleLabel.textColor = [PIRColor defaultButtonTextColor];
    self.pierCreditButtonView.optionTitleLabel.textColor = [PIRColor profileOptionsButtonTextNormalColor];
    self.visibilityButtonView.optionTitleLabel.textColor = [PIRColor profileOptionsButtonTextNormalColor];
    self.statementsButtonView.optionTitleLabel.textColor = [PIRColor profileOptionsButtonTextNormalColor];
    [self.delegate profileMenuView:self banksButtonTapped:YES];
}

- (void)optionsButtonViewTapped
{
    self.infoButtonView.optionTitleLabel.textColor = [PIRColor profileOptionsButtonTextNormalColor];
    self.bankAccountsButtonView.optionTitleLabel.textColor = [PIRColor profileOptionsButtonTextNormalColor];
    self.pierCreditButtonView.optionTitleLabel.textColor = [PIRColor profileOptionsButtonTextNormalColor];
    self.visibilityButtonView.optionTitleLabel.textColor = [PIRColor defaultButtonTextColor];
    self.statementsButtonView.optionTitleLabel.textColor = [PIRColor profileOptionsButtonTextNormalColor];
    [self.delegate profileMenuView:self visibilityButtonTapped:YES];
    
}

- (void)creditsButtonViewTapped
{
    self.infoButtonView.optionTitleLabel.textColor = [PIRColor profileOptionsButtonTextNormalColor];
    self.bankAccountsButtonView.optionTitleLabel.textColor = [PIRColor profileOptionsButtonTextNormalColor];
    self.pierCreditButtonView.optionTitleLabel.textColor = [PIRColor defaultButtonTextColor];
    self.visibilityButtonView.optionTitleLabel.textColor = [PIRColor profileOptionsButtonTextNormalColor];
    self.statementsButtonView.optionTitleLabel.textColor = [PIRColor profileOptionsButtonTextNormalColor];
    [self.delegate profileMenuView:self creditButtonTapped:YES];
    
}

- (void)transactionsButtonViewTapped
{
    self.infoButtonView.optionTitleLabel.textColor = [PIRColor profileOptionsButtonTextNormalColor];
    self.bankAccountsButtonView.optionTitleLabel.textColor = [PIRColor profileOptionsButtonTextNormalColor];
    self.pierCreditButtonView.optionTitleLabel.textColor = [PIRColor profileOptionsButtonTextNormalColor];
    self.visibilityButtonView.optionTitleLabel.textColor = [PIRColor profileOptionsButtonTextNormalColor];
    self.statementsButtonView.optionTitleLabel.textColor = [PIRColor defaultButtonTextColor];
    [self.delegate profileMenuView:self statementsButtonTapped:YES];
    
}



@end
