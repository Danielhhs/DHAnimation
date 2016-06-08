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
#import "DHShimmerAnimationRenderer.h"
#import "DHSparkleAnimationRenderer.h"
#import "DHObjectAnimationSettingsViewController.h"
#import "DHRotationAnimationRenderer.h"
#import "DHConfettiAnimationRenderer.h"
#import "DHBlindsAnimationRenderer.h"
#import "DHFireworkAnimationRenderer.h"
#import "DHBlurAnimationRenderer.h"
#import "DHDropAnimationRenderer.h"
#import "DHPivotAnimationRenderer.h"
#import "DHPopAnimationRenderer.h"
#import "DHScaleAnimationRenderer.h"
#import "DHScaleBigAnimationRenderer.h"
#import "DHSpinAnimationRenderer.h"
#import "DHTwirlAnimationRenderer.h"
#import "DHDissolveAnimationRenderer.h"
#import "DHSkidAnimationRenderer.h"
#import "DHFlameAnimationRenderer.h"
#import "DHAnvilAnimationRenderer.h"
#import "DHFaceExplosionAnimationRenderer.h"

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
    self.settings = [DHObjectAnimationSettings defaultSettings];
    self.settings.animationView = self.animationView;
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
    switch (self.animationType) {
        case DHObjectAnimationTypeShimmer: {
            self.renderer = [[DHShimmerAnimationRenderer alloc] init];
            self.settings.rowCount = 15;
            self.settings.columnCount = 10;
        }
            break;
        case DHObjectAnimationTypeSparkle:
            self.renderer = [[DHSparkleAnimationRenderer alloc] init];
            break;
        case DHObjectAnimationTypeRotation:{
            self.renderer = [[DHRotationAnimationRenderer alloc] init];
            DHRotationAnimationRenderer *rotationRenderer = (DHRotationAnimationRenderer *)self.renderer;
            rotationRenderer.rotationRadius = 300;
            self.settings.duration = 1.f;
            self.settings.timingFunction = DHTimingFunctionEaseInOutBack;
        }
            break;
        case DHObjectAnimationTypeConfetti: {
            self.renderer = [[DHConfettiAnimationRenderer alloc] init];
            self.settings.duration = 1.5;
            self.settings.columnCount = self.settings.targetView.frame.size.width / 10;
            self.settings.rowCount = self.settings.columnCount * self.settings.targetView.frame.size.width / self.settings.targetView.frame.size.height;
            self.settings.timingFunction = DHTimingFunctionEaseOutCubic;
        }
            break;
        case DHObjectAnimationTypeBlinds: {
            self.renderer = [[DHBlindsAnimationRenderer alloc] init];
            self.settings.columnCount = 5;
            self.settings.rowCount = 1;
            self.settings.timingFunction = DHTimingFunctionEaseInOutBack;
        }
            break;
        case DHObjectAnimationTypeFirework: {
            self.renderer = [[DHFireworkAnimationRenderer alloc] init];
            self.settings.duration = 2.f;
        }
            break;
        case DHObjectAnimationTypeBlur: {
            self.renderer = [[DHBlurAnimationRenderer alloc] init];
        }
            break;
        case DHObjectAnimationTypeDrop: {
            self.renderer = [[DHDropAnimationRenderer alloc] init];
            self.settings.timingFunction = DHTimingFunctionEaseOutBounce;
        }
            break;
        case DHObjectAnimationTypePivot: {
            self.renderer = [[DHPivotAnimationRenderer alloc] init];
            self.settings.duration = 1.f;
            self.settings.timingFunction = DHTimingFunctionEaseOutCubic;
        }
            break;
        case DHObjectAnimationTypePop: {
            self.renderer = [[DHPopAnimationRenderer alloc] init];
            self.settings.timingFunction = DHTimingFunctionEaseOutBounce;
        }
            break;
        case DHObjectAnimationTypeScale: {
            self.renderer = [[DHScaleAnimationRenderer alloc] init];
            self.settings.timingFunction = DHTimingFunctionEaseOutBack;
        }
            break;
        case DHObjectAnimationTypeScaleBig: {
            self.renderer = [[DHScaleBigAnimationRenderer alloc] init];
            self.settings.timingFunction = DHTimingFunctionEaseOutBack;
        }
            break;
        case DHObjectAnimationTypeSpin: {
            self.renderer = [[DHSpinAnimationRenderer alloc] init];
            self.settings.timingFunction = DHTimingFunctionEaseInOutBack;
        }
            break;
        case DHObjectAnimationTypeTwirl: {
            self.renderer = [[DHTwirlAnimationRenderer alloc] init];
            self.settings.timingFunction = DHTimingFunctionEaseInOutCubic;
        }
            break;
        case DHObjectAnimationTypeDissolve: {
            self.renderer = [[DHDissolveAnimationRenderer alloc] init];
        }
            break;
        case DHObjectAnimationTypeSkid: {
            self.renderer = [[DHSkidAnimationRenderer alloc] init];
        }
            break;
        case DHObjectAnimationTypeFlame: {
            self.renderer = [[DHFlameAnimationRenderer alloc] init];
            self.settings.timingFunction = DHTimingFunctionEaseOutCubic;
        }
            break;
        case DHObjectAnimationTypeAnvil: {
            self.renderer = [[DHAnvilAnimationRenderer alloc] init];
            self.settings.timingFunction = DHTimingFunctionEaseOutExpo;
        }
            break;
        case DHObjectAnimationTypeFaceExplosion: {
            self.renderer = [[DHFaceExplosionAnimationRenderer alloc] init];
            self.settings.timingFunction = DHTimingFunctionEaseOutCubic;
        }
            break;
        case DHObjectAnimationTypeCompress: {
            self.renderer = [[DHCompressAnimationRenderer alloc] init];
            self.settings.timingFunction = DHTimingFunctionEaseOutCubic;
        }
        default:
            break;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.navigationController.navigationBar.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height);
    } completion:^(BOOL finished) {
        [self.renderer prepareAnimationWithSettings:self.settings];
        [self.renderer startAnimation];
    }];
}

- (void) updateAnimationSettings
{
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
        _fromView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
        _fromView.transform = CGAffineTransformMakeRotation(M_PI / 6);
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
        _toView.transform = CGAffineTransformMakeRotation(M_PI / 6);
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
