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
@interface DHObjectAnimationPresentatioinViewController ()
@property (nonatomic, strong) DHObjectAnimationSettings *settings;
@property (nonatomic, strong) DHShimmerRenderer *renderer;
@property (nonatomic, strong) UIImageView *fromView;
@property (nonatomic, strong) UIImageView *toView;
@end

@implementation DHObjectAnimationPresentatioinViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.settings = [DHObjectAnimationSettings defaultSettings];
    UIBarButtonItem *animationSettingButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(showSettingsPanel)];
    UIBarButtonItem *startAnimationButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(performAnimation)];
    [self.navigationItem setRightBarButtonItems:@[animationSettingButton, startAnimationButton]];
    
}

- (void) showSettingsPanel
{
//    AnimationSettingViewController *settingsController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@                                                          "AnimationSettingViewController"];
//    settingsController.settings = self.settings;
//    [self.navigationController pushViewController:settingsController animated:YES];
}

- (void) performAnimation
{
    [self updateAnimationSettings];
    self.renderer = [[DHShimmerRenderer alloc] init];
    [UIView animateWithDuration:0.5 animations:^{
        self.navigationController.navigationBar.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height);
    } completion:^(BOOL finished) {
        [self.renderer performAnimationWithSettings:self.settings];
    }];
}

- (void) updateAnimationSettings
{
    self.settings.containerView = self.view;
    self.settings.animateInView = self.fromView;
    self.settings.animateOutView = self.toView;
    self.settings.duration = 2;
    self.settings.event = AnimationEventBuiltOut;
    __weak DHObjectAnimationPresentatioinViewController *weakSelf = self;
    self.settings.completion = ^{
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