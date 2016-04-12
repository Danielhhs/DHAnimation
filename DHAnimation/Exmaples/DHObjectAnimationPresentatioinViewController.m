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
#import "DHShimmerRenderer.h"
#import "DHSparkleRenderer.h"
#import "DHObjectAnimationSettingsViewController.h"
#import "DHRotationRenderer.h"
@interface DHObjectAnimationPresentatioinViewController ()
@property (nonatomic, strong) DHObjectAnimationSettings *settings;
@property (nonatomic, strong) DHObjectAnimationRenderer *renderer;
@property (nonatomic, strong) UIImageView *fromView;
@property (nonatomic, strong) UIImageView *toView;
@end

@implementation DHObjectAnimationPresentatioinViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.settings = [DHObjectAnimationSettings defaultSettings];
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
        case ObjectAnimationTypeShimmer: {
            self.renderer = [[DHShimmerRenderer alloc] init];
            self.settings.rowCount = 15;
            self.settings.columnCount = 10;
        }
            break;
        case ObjectAnimationTypeSparkle:
            self.renderer = [[DHSparkleRenderer alloc] init];
            break;
        case ObjectAnimationTypeRotation:{
            self.renderer = [[DHRotationRenderer alloc] init];
            DHRotationRenderer *rotationRenderer = (DHRotationRenderer *)self.renderer;
            rotationRenderer.rotationRadius = 300;
            self.settings.duration = 1.f;
            self.settings.timingFunction = DHTimingFunctionEaseInOutBack;
        }
            break;
        default:
            break;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.navigationController.navigationBar.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height);
    } completion:^(BOOL finished) {
        [self.renderer performAnimationWithSettings:self.settings];
    }];
}

- (void) updateAnimationSettings
{
    [self.fromView removeFromSuperview];
    [self.toView removeFromSuperview];
    if (self.settings.event == AnimationEventBuiltOut) {
        [self.view addSubview:self.toView];
    }
    self.fromView.image = [self randomImage];
    self.settings.containerView = self.view;
    self.settings.targetView = self.fromView;
    __weak DHObjectAnimationPresentatioinViewController *weakSelf = self;
    self.settings.completion = ^{
        if (weakSelf.settings.event == AnimationEventBuiltIn) {
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
        _fromView.image = [self randomImage];
    }
    return _fromView;
}

- (UIImageView *) toView
{
    if (!_toView) {
        _toView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
        _toView.image = [self randomImage];
    }
    return _toView;
}

- (UIImage *)randomImage
{
    int randomNumber = arc4random() % 10;
    return [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", randomNumber]];
}

@end
