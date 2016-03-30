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
#import "DHAnimationRenderer.h"
@interface DHParticleAnimationPresentatioinViewController ()
@property (nonatomic, strong) DHAnimationSettings *settings;
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
    [UIView animateWithDuration:0.5 animations:^{
        self.navigationController.navigationBar.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height);
    } completion:^(BOOL finished) {
    }];
}

- (void) updateAnimationSettings
{
    self.settings.containerView = self.view;
    __weak DHParticleAnimationPresentatioinViewController *weakSelf = self;
    self.settings.completion = ^{
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.navigationController.navigationBar.transform = CGAffineTransformIdentity;
        } completion:nil];
    };
}
@end
