//
//  DHParticleAnimationPresentatioinViewController.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/27/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHObjectAnimationPresentatioinViewController.h"
#import "DHObjectAnimationSettings.h"
#import "DHTransitionSettingViewController.h"
#import "DHObjectAnimationSettingsViewController.h"
#import "DHConstants.h"
#import "DHObjectAnimationRenderer.h"

@interface DHObjectAnimationPresentatioinViewController ()
@property (nonatomic, strong) DHObjectAnimationSettings *settings;
@property (nonatomic, strong) DHObjectAnimationRenderer *renderer;
@property (nonatomic, strong) UIImageView *fromView;
@property (nonatomic, strong) UIImageView *toView;
@property (nonatomic, strong) GLKView *animationView;
@end

@implementation DHObjectAnimationPresentatioinViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.animationView = [[GLKView alloc] initWithFrame:self.view.bounds context:[[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3]];
    [self.view addSubview:self.animationView];
    self.settings = [DHObjectAnimationSettings defaultSettingsForAnimationType:self.animationType event:self.animationEvent forView:self.fromView];
    UIBarButtonItem *animationSettingButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(showSettingsPanel)];
    UIBarButtonItem *startAnimationButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(performAnimation)];
    [self.navigationItem setRightBarButtonItems:@[animationSettingButton, startAnimationButton]];
    
}

- (void) showSettingsPanel
{
    DHObjectAnimationSettingsViewController *settingsController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DHObjectAnimationSettingsViewController"];
    settingsController.settings = self.settings;
    [self.navigationController pushViewController:settingsController animated:YES];
}

- (void) performAnimation
{
    [self updateAnimationSettings];
    self.renderer = [DHConstants animationRendererForName:[DHConstants animationNameForAnimationType:self.animationType]];

    [UIView animateWithDuration:0.5 animations:^{
        self.navigationController.navigationBar.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height);
    } completion:^(BOOL finished) {
        [self.renderer prepareAnimationWithSettings:self.settings];
        [self.renderer startAnimation];
    }];
}

- (void) updateAnimationSettings
{
    self.settings.animationView = self.animationView;
    [self.fromView removeFromSuperview];
    [self.toView removeFromSuperview];
    self.settings.event = self.animationEvent;
    if (self.settings.event == DHAnimationEventBuiltOut) {
        [self.view addSubview:self.fromView];
    }
    self.fromView.image = [self randomImage];
    self.settings.containerView = self.view;
    self.settings.targetView = self.fromView;
    __weak DHObjectAnimationPresentatioinViewController *weakSelf = self;
    self.settings.completion = ^{
        if (weakSelf.settings.event == DHAnimationEventBuiltIn) {
            [weakSelf.view addSubview:weakSelf.fromView];
        } else {
            [weakSelf.toView removeFromSuperview];
        }
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.navigationController.navigationBar.transform = CGAffineTransformIdentity;
        } completion:nil];
    };
}

- (UIImageView *)fromView
{
    if (!_fromView) {
        _fromView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 300, 400)];
//        _fromView.transform = CGAffineTransformMakeRotation(M_PI / 6);
        _fromView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
        _fromView.contentMode = UIViewContentModeScaleToFill;
        _fromView.image = [self randomImage];
    }
    return _fromView;
}

- (UIImageView *) toView
{
    if (!_toView) {
        _toView = [[UIImageView alloc] initWithFrame:CGRectMake(200, 100, 200, 200)];
//        _toView.transform = CGAffineTransformMakeRotation(M_PI / 6);
        _toView.image = [self randomImage];
    }
    return _toView;
}

- (UIImage *)randomImage
{
    int randomNumber = arc4random() % 10;
    return [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", randomNumber]];
}

- (void) viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.transform = CGAffineTransformIdentity;
    [super viewWillDisappear:animated];
}

@end
