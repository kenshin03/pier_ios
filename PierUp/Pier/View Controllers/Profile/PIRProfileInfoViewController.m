//
//  PIRProfileInfoViewController.m

//
//  Created by Kenny Tang on 1/3/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRProfileInfoViewController.h"
@import AssetsLibrary;

#import "MRProgress.h"
#import "PIRAvatar.h"
#import "PIRProfileInfoTableViewCell.h"
#import "PIRProfilePasscodeViewController.h"
#import "PIRProfileVerifyViewController.h"
#import "PIRUser.h"
#import "PIRUserServices.h"

static NSUInteger const kPIRProfileInfoTableCellsCount = 4;
static CGFloat const kPIRProfileInfoTableViewCellHeight = 44.0;
static NSString * const kPIRProfileInfoTableViewCellIdentifier = @"kPIRProfileInfoTableViewCellIdentifier";


@interface PIRProfileInfoViewController ()<
PIRProfileHeaderViewDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UITableViewDataSource,
UITableViewDelegate
>

@property (nonatomic, strong) PIRProfileHeaderView * headerView;
@property (nonatomic, strong) UITableView * profileInfoTableView;
@property (nonatomic, strong) UIRefreshControl * refreshControl;
@property (nonatomic, strong) PIRUser * currentUser;
@property (nonatomic, strong) UIButton * updatePassCodeButton;
@property (nonatomic, strong) UIButton *verifyUserButton;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@end

@implementation PIRProfileInfoViewController

#pragma mark - Public

#pragma mark - View lifecycle

- (void)loadView
{
    self.view = [self mainView];
    [self addSubviewTree];
    [self constrainViews];
    self.currentUser = [[PIRUserServices sharedService] currentUser];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    PIRUser *currentUser = [[PIRUserServices sharedService] currentUser];
    if ([currentUser.status integerValue] == PIRUserStatusPendingVerification){
        self.verifyUserButton.hidden = NO;
    }else{
        self.verifyUserButton.hidden = YES;
    }
}

#pragma mark - Initialization

#pragma mark - Public methods

-(void)refreshData
{
    self.currentUser = [[PIRUserServices sharedService] currentUser];
    [self.profileInfoTableView reloadData];
}

#pragma mark - Private

#pragma mark - Private properties


-(PIRProfileHeaderView*)headerView
{
    if (!_headerView) {
        _headerView = [PIRProfileHeaderView new];
        _headerView.translatesAutoresizingMaskIntoConstraints = NO;
        _headerView.backgroundColor = [UIColor clearColor];
        _headerView.user = [[PIRUserServices sharedService] currentUser];
        UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTapped:)];
        [_headerView addGestureRecognizer:tapRecognizer];
    }
    return _headerView;
}

-(UITableView*)profileInfoTableView
{
    if (!_profileInfoTableView) {
        _profileInfoTableView = [UITableView new];
        _profileInfoTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _profileInfoTableView.backgroundColor = [UIColor clearColor];
        _profileInfoTableView.dataSource = self;
        _profileInfoTableView.delegate = self;
        [_profileInfoTableView addSubview:self.refreshControl];
        
        // this line hides empty cells below the cells
        _profileInfoTableView.tableFooterView = [UIView new];
        [_profileInfoTableView registerClass:[PIRProfileInfoTableViewCell class] forCellReuseIdentifier:kPIRProfileInfoTableViewCellIdentifier];
    }
    return _profileInfoTableView;
}

- (UIRefreshControl*)refreshControl
{
    if (!_refreshControl) {
        _refreshControl = [UIRefreshControl new];
        _refreshControl.tintColor = [PIRColor defaultTintColor];
        [_refreshControl addTarget:self action:@selector(refreshControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}

- (UIButton *)updatePassCodeButton
{
    if(!_updatePassCodeButton)
    {
        _updatePassCodeButton = [UIButton new];
        _updatePassCodeButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_updatePassCodeButton setTitle:@"Update Passcode" forState:UIControlStateNormal];
        _updatePassCodeButton.titleLabel.font = [PIRFont navigationBarTitleFont];
        [_updatePassCodeButton setTitleColor:[PIRColor defaultTintColor] forState:UIControlStateNormal];
        [_updatePassCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        _updatePassCodeButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _updatePassCodeButton.layer.borderWidth = 0.5;
        [_updatePassCodeButton setBackgroundImage:[UIImage imageFromColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [_updatePassCodeButton setBackgroundImage:[UIImage imageFromColor:[PIRColor defaultTintColor]] forState:UIControlStateHighlighted];
        [_updatePassCodeButton addTarget:self action:@selector(updatePassCodeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _updatePassCodeButton;
}


- (UIButton *)verifyUserButton
{
    if(!_verifyUserButton)
    {
        _verifyUserButton = [UIButton new];
        _verifyUserButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_verifyUserButton setTitle:@"Verify Email/Phone" forState:UIControlStateNormal];
        _verifyUserButton.titleLabel.font = [PIRFont navigationBarTitleFont];
        [_verifyUserButton setTitleColor:[PIRColor defaultTintColor] forState:UIControlStateNormal];
        [_verifyUserButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        _verifyUserButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _verifyUserButton.layer.borderWidth = 0.5;
        [_verifyUserButton setBackgroundImage:[UIImage imageFromColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [_verifyUserButton setBackgroundImage:[UIImage imageFromColor:[PIRColor defaultTintColor]] forState:UIControlStateHighlighted];
        [_verifyUserButton addTarget:self action:@selector(verifyUserButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _verifyUserButton;
}

- (UIImagePickerController*)imagePickerController
{
    if (!_imagePickerController) {
        UIImagePickerController * picker = [UIImagePickerController new];
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary | UIImagePickerControllerSourceTypeCamera;
            
        }else{
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
        }
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
    mainView.userInteractionEnabled = YES;
    return mainView;
}

- (void)addSubviewTree
{
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.profileInfoTableView];
    [self.view addSubview:self.verifyUserButton];
    [self.view addSubview:self.updatePassCodeButton];
}

- (void)constrainViews
{
    NSDictionary * views = @{
                             @"headerView":self.headerView,
                             @"profileInfoTableView":self.profileInfoTableView,
                             @"verifyUserButton":self.verifyUserButton,
                             @"updatePassCodeButton":self.updatePassCodeButton,
                             };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|[profileInfoTableView(320)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|-[updatePassCodeButton]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|-[verifyUserButton]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|-[headerView]-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"V:|[headerView(120)][profileInfoTableView(200)]-20-[verifyUserButton(40)]-[updatePassCodeButton(40)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kPIRProfileInfoTableCellsCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PIRProfileInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kPIRProfileInfoTableViewCellIdentifier forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
        {
            cell.titleLabel.text = NSLocalizedString(@"Username", nil);
            cell.valueLabel.text = self.currentUser.userName;
        }
            break;
        case 1:
        {
            cell.titleLabel.text = NSLocalizedString(@"Email", nil);
            cell.valueLabel.text = self.currentUser.email;
        }
            break;
        case 2:
        {
            cell.titleLabel.text = NSLocalizedString(@"Phone", nil);
            cell.valueLabel.text = self.currentUser.phoneNumber;
        }
            break;
        case 3:
        {
            cell.titleLabel.text = NSLocalizedString(@"Status", nil);
            switch ([self.currentUser.status integerValue]) {
                case PIRUserStatusPendingVerification:
                    cell.valueLabel.text = NSLocalizedString(@"Pending Verfification", nil);
                    break;
                case PIRUserStatusInactive:
                    cell.valueLabel.text = NSLocalizedString(@"Inactive", nil);
                    break;
                case PIRUserStatusActive:
                    cell.valueLabel.text = NSLocalizedString(@"Active", nil);
                    break;
                case PIRUserStatusLocked:
                    cell.valueLabel.text = NSLocalizedString(@"Locked", nil);
                    break;
                    
                default:
                    break;
            }
        }
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    [tableViewCell setSelected:NO animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kPIRProfileInfoTableViewCellHeight;
}

#pragma mark - Event handler methods

-(void)verifyUserButtonTapped:(id)sender
{
    DLog(@"verifyUserButtonTapped");
    PIRProfileVerifyViewController * vc = [PIRProfileVerifyViewController new];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navController animated:YES completion:^{
        // nothing
    }];
}

-(void)updatePassCodeButtonTapped:(id)sender
{
    DLog(@"updatePassCodeButtonTapped");
    PIRProfilePasscodeViewController * vc = [PIRProfilePasscodeViewController new];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navController animated:YES completion:^{
        // nothing
    }];
}

-(void)refreshControlValueChanged:(id)sender
{
    MRProgressOverlayView * progressView = [MRProgressOverlayView new];
    progressView.titleLabelText = NSLocalizedString(@"Refreshing...", nil);
    progressView.mode = MRProgressOverlayViewModeIndeterminate;
    [self.view.superview addSubview:progressView];
    [progressView show:YES];
    
    [[PIRUserServices sharedService] updateCurrentUserFromServer:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.profileInfoTableView reloadData];
            [progressView dismiss:YES];
            [self.refreshControl endRefreshing];
        });
        
    } error:^(NSError *error) {
        DLog(@"error in %@", error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [progressView dismiss:YES];
            [self.refreshControl endRefreshing];
        });
    }];
}

- (void)avatarTapped:(id)sender
{
    [self profileHeaderView:self.headerView didRequestPresentImagePicker:YES];
}


#pragma mark - PIRProfileHeaderViewDelegate methods

-(void)profileHeaderView:(PIRProfileHeaderView*)view didRequestPresentImagePicker:(BOOL)request
{
    [self presentViewController:self.imagePickerController animated:YES completion:^{
        // done
    }];
}

#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __weak typeof(self) weakSelf = self;
    
    NSURL * assetImageURL = info[UIImagePickerControllerReferenceURL];
    ALAssetsLibrary * assetsLibrary = [ALAssetsLibrary new];
    [assetsLibrary assetForURL:assetImageURL resultBlock:^(ALAsset *asset) {
        ALAssetRepresentation * rep = [asset defaultRepresentation];
        
        CGImageRef imageRef = [rep fullResolutionImage];
        UIImage * selectedImage = [UIImage imageWithCGImage:imageRef];
        
        // got image, clear out user's thumbnailURL
        __strong typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.currentUser.thumbnailURL = nil;
        strongSelf.currentUser.thumbnailImage = selectedImage;
        
        
        // update avatar
        strongSelf.headerView.user = strongSelf.currentUser;
        [strongSelf.imagePickerController dismissViewControllerAnimated:YES completion:^{
            // done
            [[PIRUserServices sharedService] updateUserPhoto:strongSelf.currentUser success:^{
                // ws is failing now
            } error:^(NSError *error) {
                // to-do: handle error. ignore for now as web service is failing
            }];
            
        }];
        
        [[PIRUserServices sharedService] updateCurrentUser:strongSelf.currentUser];
        
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

@end



@interface PIRProfileHeaderView()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) PIRAvatar *avatar;
@end

@implementation PIRProfileHeaderView

#pragma mark - Public

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.userInteractionEnabled = YES;
        [self addSubviewTree];
        [self constrainViews];
    }
    return self;
}

#pragma mark - Public properties

- (void)setUser:(PIRUser*)user {
    [self updateViewWithUser:user];
}


#pragma mark - Private

#pragma mark - Private properties

- (UILabel*)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _nameLabel.textAlignment = NSTextAlignmentRight;
        _nameLabel.font = [PIRFont avatarNameFont];
        _nameLabel.textColor = [PIRColor primaryTextColor];
        _nameLabel.numberOfLines = 2;
    }
    return _nameLabel;
}


- (PIRAvatar*)avatar
{
    if (!_avatar) {
        _avatar = [PIRAvatar new];
        _avatar.backgroundColor = [UIColor clearColor];
        _avatar.userInteractionEnabled = YES;
        _avatar.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _avatar;
}


#pragma mark - Initialization helpers

- (void)addSubviewTree
{
    [self addSubview:self.nameLabel];
    [self addSubview:self.avatar];
}

- (void)constrainViews
{
    NSDictionary * views = @{
                             @"nameLabel":self.nameLabel,
                             @"avatar":self.avatar,
                             };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[avatar(80)]-[nameLabel]-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[avatar(80)]" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[nameLabel]" options:0 metrics:nil views:views]];
    
}

-(void)updateViewWithUser:(PIRUser*)user
{
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    self.avatar.user = user;
}


@end
