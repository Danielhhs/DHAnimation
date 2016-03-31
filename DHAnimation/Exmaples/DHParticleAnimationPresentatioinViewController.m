//
//  DHParticleAnimationPresentatioinViewController.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/27/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHParticleAnimationPresentatioinViewController.h"
#import "DHAnimationSettings.h"
#import "AnimationSettingViewController.h"
#import "DHShimmerRenderer.h"
@interface DHParticleAnimationPresentatioinViewController ()
@property (nonatomic, strong) DHAnimationSettings *settings;
@property (nonatomic, strong) DHShimmerRenderer *renderer;
@property (nonatomic, strong) UIImageView *fromView;
@end

@implementation DHParticleAnimationPresentatioinViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.settings = [DHAnimationSettings defaultSettings];
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
        [self.renderer performAnimationWithSettings:self.settings];
    }];
}

- (void) updateAnimationSettings
{
    self.settings.containerView = self.view;
    self.settings.fromView = self.fromView;
    self.settings.duration = 5;
    __weak DHParticleAnimationPresentatioinViewController *weakSelf = self;
    self.settings.completion = ^{
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.navigationController.navigationBar.transform = CGAffineTransformIdentity;
        } completion:nil];
    };
}

- (UIImageView *)fromView
{
    if (!_fromView) {
        _fromView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _fromView.image = [self randomImage];
    }
    return _fromView;
}

- (UIImage *)randomImage
{
//    int randomNumber = arc4random() % 10;
//    return [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", randomNumber]];
    return [UIImage imageNamed:@"star_white.png"];
}

@end
