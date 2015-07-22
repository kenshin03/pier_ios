//
//  PIRAlertView.m

//
//  Created by Kenny Tang on 12/18/13.
//  Copyright (c) 2013 Kenny Tang. All rights reserved.
//

#import "PIRAlertView.h"
#import <UIImage+ImageEffects.h>
#import <QuartzCore/QuartzCore.h>

@interface PIRAlertView()

@property (nonatomic, strong) UIView * backgroundView;
@property (nonatomic, strong) UIView * contentView;

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * descriptionLabel;
@property (nonatomic, strong) NSArray * buttonLabelsArray;

@property (nonatomic, strong) UIButton * firstButton;
@property (nonatomic, strong) UIButton * secondButton;
@property (nonatomic, strong) UIButton * cancelButton;

@end

@implementation PIRAlertView

#pragma mark - Public

#pragma mark - Initialization

- (instancetype)initWithTitle:(NSString*)title desc:(NSString*)desc buttonsLabels:(NSArray*)buttonLabels
{
    self = [super init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubviewTree];
        [self constrainViews];
        
        self.titleLabel.text = title;
        self.descriptionLabel.text = desc;
        self.buttonLabelsArray = buttonLabels;
    }
    return self;
}

- (void)dismiss
{
    
}

#pragma mark - Public properties

- (void)setPresentingViewControllerImage:(UIImage *)presentingViewControllerImage
{
    _presentingViewControllerImage = presentingViewControllerImage;
    [self update];
}


#pragma mark - Overrides

- (CGSize)intrinsicContentSize
{
    return [[UIScreen mainScreen] bounds].size;
}


#pragma mark - Private

#pragma mark - Private properties

- (UIView*)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [UIView new];
        _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        _backgroundView.backgroundColor = [UIColor clearColor];
    }
    return _backgroundView;
}

- (UIView*)contentView
{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentView.backgroundColor = [PIRColor alertViewContentBackgroundColor];
        _contentView.layer.cornerRadius = 5.0;
        _contentView.clipsToBounds = YES;
    }
    return _contentView;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [PIRFont statusLabelFont];
        _titleLabel.textColor = [PIRColor primaryTextColor];
    }
    return _titleLabel;
}

- (UILabel*)descriptionLabel
{
    if (!_descriptionLabel) {
        _descriptionLabel = [UILabel new];
        _descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        _descriptionLabel.font = [PIRFont statusLabelFont];
        _descriptionLabel.textColor = [PIRColor primaryTextColor];
        _descriptionLabel.numberOfLines = 4;
    }
    return _descriptionLabel;
}

- (UIButton*)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [UIButton new];
        _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [PIRFont navigationBarTitleFont];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        _cancelButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _cancelButton.layer.borderWidth = 0.5;
        _cancelButton.backgroundColor = [UIColor clearColor];
        [_cancelButton addTarget:self action:@selector(cancelButtonButtonTapped:) forControlEvents:UIControlEventTouchDown];
    }
    return _cancelButton;
}

- (UIButton*)firstButton
{
    if (!_firstButton) {
        _firstButton = [UIButton new];
        _firstButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_firstButton setTitle:@"Confirm" forState:UIControlStateNormal];
        _firstButton.titleLabel.font = [PIRFont navigationBarTitleFont];
        [_firstButton setTitleColor:[PIRColor defaultTintColor] forState:UIControlStateNormal];
        [_firstButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _firstButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _firstButton.layer.borderWidth = 0.5;
        _firstButton.backgroundColor = [UIColor clearColor];
        [_firstButton addTarget:self action:@selector(firstButtonButtonTapped:) forControlEvents:UIControlEventTouchDown];
    }
    return _firstButton;
}

#pragma mark - Initialization helpers

- (void)update
{
    
    UIImage * blurredImage = [self.presentingViewControllerImage applyDarkEffect];
    
    // set final image
    UIImageView * bluredImageView = [[UIImageView alloc] initWithImage:blurredImage];
    [self.backgroundView addSubview:bluredImageView];
    
    CABasicAnimation * crossFade = [CABasicAnimation animationWithKeyPath:@"contents"];
    crossFade.duration = 0.2;
    crossFade.fromValue = (__bridge id)[self.presentingViewControllerImage CGImage];
    crossFade.toValue = (__bridge id)([blurredImage CGImage]);
    [bluredImageView.layer addAnimation:crossFade forKey:@"animateContents"];
}

- (void)addSubviewTree
{
    [self addSubview:self.backgroundView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.descriptionLabel];
    [self.contentView addSubview:self.firstButton];
    [self.contentView addSubview:self.cancelButton];
    
}


- (void)constrainViews
{
    NSDictionary * views = @{
                                 @"backgroundView": self.backgroundView,
                                 @"contentView": self.contentView,
                                 @"titleLabel": self.titleLabel,
                                 @"descriptionLabel": self.descriptionLabel,
                                 @"firstButton": self.firstButton,
                                 @"cancelButton": self.cancelButton,
                                 };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                          @"H:|[backgroundView]|"
                                                                 options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                          @"V:|[backgroundView]|"
                                                                 options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                          @"H:|-20-[contentView]-20-|"
                                                                 options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                          @"V:[contentView(230)]-40-|"
                                                                 options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                          @"H:|-[titleLabel]-|"
                                                                 options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                          @"H:|-[descriptionLabel]-|"
                                                                             options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|[firstButton]|"
                                                                             options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"H:|[cancelButton]|"
                                                                             options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                          @"V:|-[titleLabel]-20-[descriptionLabel]"
                                                                 options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:
                                      @"V:[firstButton][cancelButton]|"
                                                                             options:0 metrics:nil views:views]];
    
    
    
}

#pragma mark - Event handlers

- (void)firstButtonButtonTapped:(UIButton*)sender
{
    [self.delegate alertView:self tappedButtonAtIndex:sender.tag];
}

- (void)cancelButtonButtonTapped:(UIButton*)sender
{
    [self.delegate alertView:self tappedButtonAtIndex:sender.tag];
}
@end
