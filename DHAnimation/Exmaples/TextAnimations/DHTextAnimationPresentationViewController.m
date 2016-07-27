//
//  DHTextAnimationPresentationViewController.m
//  DHAnimation
//
//  Created by Huang Hongsen on 6/20/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHTextAnimationPresentationViewController.h"
#import <GLKit/GLKit.h>
#import "DHTextEffectRenderer.h"
#import "DHTextAnimationSettings.h"
#import "DHTextAnimationSettingsViewController.h"
@interface DHTextAnimationPresentationViewController ()
@property (nonatomic, strong) GLKView *animationView;
@property (nonatomic, strong) DHTextEffectRenderer *renderer;
@property (nonatomic, strong) DHTextAnimationSettings *settings;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) UILabel *label;
@end

@implementation DHTextAnimationPresentationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.animationView = [[GLKView alloc] initWithFrame:self.view.bounds context:[[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3]];
    [self.view addSubview:self.animationView];
    UIBarButtonItem *animationSettingButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(showSettingsPanel)];
    UIBarButtonItem *startAnimationButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(performAnimation)];
    [self.navigationItem setRightBarButtonItems:@[animationSettingButton, startAnimationButton]];
    
    self.settings = [DHTextAnimationSettings defaultSettingForAnimationType:self.animationType];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(100, 310, 0, 0)];
    self.label.numberOfLines = 2;
//    self.label.backgroundColor = [UIColor yellowColor];
    self.label.attributedText = [[NSAttributedString alloc] initWithString:@"Just Animate" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:55], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.label sizeToFit];
    // Do any additional setup after loading the view.
}

- (void) performAnimation
{
    
    if (self.settings.event == DHAnimationEventBuiltOut) {
        [self.view addSubview:self.label];
    } else {
        [self.label removeFromSuperview];
    }
    self.renderer = [DHConstants textRendererForType:self.animationType];
    self.settings.animationView = self.animationView;
    self.settings.containerView = self.view;
    self.settings.attributedText = self.label.attributedText;
    self.settings.textContainerView = self.label;
    self.settings.origin = CGPointMake(self.label.frame.origin.x, self.label.frame.origin.y - 13);
    __weak DHTextAnimationPresentationViewController *weakSelf = self;
    self.settings.completion = ^{
        if (weakSelf.settings.event == DHAnimationEventBuiltIn) {
            [weakSelf.view addSubview:weakSelf.label];
        }
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.navigationController.navigationBar.transform = CGAffineTransformIdentity;
        } completion:nil];
    };
    if (self.settings.event == DHAnimationEventBuiltOut) {
        self.settings.beforeAnimationAction = ^{
            [weakSelf.label removeFromSuperview];
        };
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.navigationController.navigationBar.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height);
    } completion:^(BOOL finished) {
        [self.renderer prepareAnimationWithSettings:self.settings];
        [self.renderer startAnimation];
    }];
}

- (void) showSettingsPanel
{
    DHTextAnimationSettingsViewController *settingsController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DHTextAnimationSettingsViewController"];
    settingsController.settings = self.settings;
    [self.navigationController pushViewController:settingsController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
