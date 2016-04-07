//
//  DHParticleAnimationPresentatioinViewController.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/27/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHObjectAnimationPresentatioinViewController.h"
#import "DHTransitionSettings.h"
#import "AnimationSettingViewController.h"
#import "DHShimmerRenderer.h"
@interface DHObjectAnimationPresentatioinViewController ()
@property (nonatomic, strong) DHTransitionSettings *settings;
@property (nonatomic, strong) DHShimmerRenderer *renderer;
@property (nonatomic, strong) UIImageView *fromView;
@end

@implementation DHObjectAnimationPresentatioinViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.settings = [DHTransitionSettings defaultSettings];
    UIBarButtonItem *animationSettingButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(showSettingsPanel)];
    UIBarButtonItem *startAnimationButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(performAnimation)];
    [self.navigationItem setRightBarButtonItems:@[animationSettingButton, startAnimationButton]];
    
}

- (void) showSettingsPanel
{
    AnimationSettingViewController *settingsController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@                                                          "AnimationSettingViewController"];
    settingsController.settings = self.settings;
    [self.navigationController pushViewController:settingsController animated:YES];
}

- (void) performAnimation
{
    [self updateAnimationSettings];
    self.renderer = [[DHShimmerRenderer alloc] init];
    [UIView animateWithDuration:0.5 animations:^{
        self.navigationController.navigationBar.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height);
    } completion:^(BOOL finished) {
        __weak DHObjectAnimationPresentatioinViewController *weakSelf = self;
        [self.renderer startAnimationForView:self.fromView inContainerView:self.view completion:^{
            [UIView animateWithDuration:0.5 animations:^{
                weakSelf.navigationController.navigationBar.transform = CGAffineTransformIdentity;
            } completion:nil];
        }];
    }];
}

- (void) updateAnimationSettings
{
    self.settings.containerView = self.view;
    self.settings.fromView = self.fromView;
    self.settings.duration = 5;
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

- (UIImage *)randomImage
{
    int randomNumber = arc4random() % 10;
    return [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", randomNumber]];
}

@end
