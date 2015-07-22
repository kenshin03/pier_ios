//
//  PIRSendPaymentsEmailViewController.m

//
//  Created by Kenny Tang on 2/3/14.
//  Copyright (c) 2014  All rights reserved.
//

#import "PIRSendPaymentsEmailViewController.h"
#import "PIRSendPaymentsAmountsViewController.h"
#import "PIRValidatorUtil.h"
#import "PIRUserServices.h"
#import "PIRTextFieldElementView.h"

static NSString * const kSendPaymentsEmailViewControllerCell = @"SendPaymentsEmailViewControllerCell";

@interface PIRSendPaymentsEmailViewController ()<
UITableViewDataSource,
UITableViewDelegate,
PIRTextFieldElementViewDelegate
>

@property (nonatomic, strong) UIView            *contentView;
@property (nonatomic, strong) PIRTextFieldElementView       *emailPhoneField;
@property (nonatomic, strong) UITableView       *suggestionTableView;
@property (nonatomic, strong) NSMutableArray    *contactsArray;
@property (nonatomic, strong) UIBarButtonItem   *nextButton;

@end

@implementation PIRSendPaymentsEmailViewController

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
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.emailPhoneField.elementTextField becomeFirstResponder];
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
}

#pragma mark - Initialization

#pragma mark - Public properties

#pragma mark - Private

#pragma mark - Private properties

- (UIView*)contentView
{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentView.backgroundColor = [PIRColor defaultBackgroundColor];
    }
    return _contentView;
}

-(NSMutableArray*)contactsArray
{
    if (!_contactsArray){
        _contactsArray = [@[] mutableCopy];
    }
    return _contactsArray;
}

-(UITableView*)suggestionTableView
{
    if (!_suggestionTableView){
        _suggestionTableView = [UITableView new];
        _suggestionTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _suggestionTableView.backgroundColor = [PIRColor defaultBackgroundColor];
        _suggestionTableView.delegate = self;
        _suggestionTableView.dataSource = self;
        _suggestionTableView.hidden = YES;
        [_suggestionTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kSendPaymentsEmailViewControllerCell];
    }
    return _suggestionTableView;
}


- (UIBarButtonItem*)nextButton
{
    if (!_nextButton) {
        _nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(nextButtonTapped:)];
        _nextButton.enabled = NO;
        _nextButton.tintColor = [PIRColor navigationBarButtonItemsTitleColor];
    }
    return _nextButton;
}

-(PIRTextFieldElementView*)emailPhoneField
{
    if (!_emailPhoneField) {
        _emailPhoneField = [[PIRTextFieldElementView alloc] initTextFieldElementViewWith:NSLocalizedString(@"", nil) keyBoardType:UIKeyboardTypeAlphabet  delagate:self];
        
        _emailPhoneField.translatesAutoresizingMaskIntoConstraints = NO;
        _emailPhoneField.validateOptions =    PIRTextFieldElementViewValidationNonEmpty;
        _emailPhoneField.elementTextField.placeholder = NSLocalizedString(@"Enter Email or Phone of recipient", @"");
    }
    return _emailPhoneField;
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
    self.navigationItem.title = NSLocalizedString(@"Enter Email or Phone", nil);
    self.navigationItem.rightBarButtonItem = self.nextButton;
}

- (void)addSubviewTree
{
    [self.contentView addSubview:self.emailPhoneField];
    [self.contentView addSubview:self.suggestionTableView];
    [self.view addSubview:self.contentView];
}


- (void)constrainViews
{
    NSDictionary * views = @{
                             @"contentView":self.contentView,
                             @"emailPhoneField":self.emailPhoneField,
                             @"suggestionTableView":self.suggestionTableView,
                             };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"H:|[contentView(320)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]
     ];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                               @"V:|[contentView(568)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]
     ];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                                      @"V:[emailPhoneField(44)]"
                                                                                             options:0
                                                                                             metrics:nil
                                                                                               views:views]
    ];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|-[emailPhoneField]-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|-5-[suggestionTableView]-5-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"V:|-80-[emailPhoneField]-[suggestionTableView(300)]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:views]
     ];
    
    
}

#pragma mark - Event handlers


-(void)nextButtonTapped:(id)sender
{
    DLog(@"nextButtonTapped");
    
    NSString *emailOrPhone = self.emailPhoneField.elementTextField.text;
    BOOL isEmail = [PIRValidatorUtil validateEmail:emailOrPhone];
    BOOL isPhone = [PIRValidatorUtil validatePhone:emailOrPhone];
    
    PIRSendPaymentsAmountsViewController *sendVC = [PIRSendPaymentsAmountsViewController new];
    PIRUser *toUser = [PIRUser createEntity];
    if (isEmail){
        toUser.email = emailOrPhone;
    }
    if (isPhone){
        toUser.phoneNumber = emailOrPhone;
    }
    sendVC.toUser = toUser;
    [self.navigationController pushViewController:sendVC animated:YES];
}


#pragma mark - UITableViewDelegate methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedValue = self.contactsArray[indexPath.row];
    self.emailPhoneField.elementTextField.text = selectedValue;
    [self validateTextFieldChanges];
}


#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contactsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:kSendPaymentsEmailViewControllerCell forIndexPath:indexPath];
    tableViewCell.backgroundColor = [PIRColor defaultBackgroundColor];
    tableViewCell.textLabel.text = self.contactsArray[indexPath.row];
    tableViewCell.textLabel.textColor = [PIRColor secondaryTextColor];
    return tableViewCell;
}

#pragma mark - PIRTextFieldElementViewDelegate methods


- (void)textFieldElementView:(PIRTextFieldElementView*)view textFieldDidChange:(UITextField *)textField
{
    NSString *updatedText = self.emailPhoneField.elementTextField.text;
    
     // look up contacts
     NSArray *matchingEmailContacts = [[PIRUserServices sharedService] lookupUserInfoFromAddressBookEmail:updatedText];
     
     NSArray *matchingPhoneContacts = [[PIRUserServices sharedService] lookupUserInfoFromAddressBookPhone:updatedText];
     
     [self.contactsArray removeAllObjects];
     [matchingEmailContacts enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
     NSString *email = dict[@"email"];
     NSArray *tokenizedEmailArray = [email componentsSeparatedByString:@" "];
     if ([tokenizedEmailArray count]){
     email = tokenizedEmailArray[0];
     }
     [self.contactsArray addObject:email];
     }];
     [matchingPhoneContacts enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
     NSString *phoneNumbers = dict[@"phoneNumbers"];
     NSArray *tokenizedEmailArray = [phoneNumbers componentsSeparatedByString:@" "];
     if ([tokenizedEmailArray count]){
     phoneNumbers = tokenizedEmailArray[0];
     }
     [self.contactsArray addObject:phoneNumbers];
     }];
     
     [self validateTextFieldChanges];
     
     if ([self.contactsArray count]){
     self.suggestionTableView.hidden = NO;
     [self.suggestionTableView reloadData];
     }else{
     self.suggestionTableView.hidden = YES;
     }
}


#pragma mark - UITextField delegate helpers

-(void)validateTextFieldChanges
{
    NSString *updatedText = self.emailPhoneField.elementTextField.text;
    if ([updatedText length]){
        // validate
        BOOL isEmail = [PIRValidatorUtil validateEmail:updatedText];
        BOOL isPhone = [PIRValidatorUtil validatePhone:updatedText];
        if (isEmail || isPhone){
            self.nextButton.enabled = YES;
        }else{
            self.nextButton.enabled = NO;
        }
    }else{
        self.nextButton.enabled = NO;
    }
}


@end
