//
//  DHObjectAnimationSettingsViewController.m
//  DHAnimation
//
//  Created by Huang Hongsen on 4/9/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHObjectAnimationSettingsViewController.h"
#import "DHTimingFunctionHelper.h"

@interface DHObjectAnimationSettingsViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UISlider *durationSlider;
@property (weak, nonatomic) IBOutlet UIPickerView *timingFunctionPicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *animationDirectionSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *animationEventSegment;

@end

@implementation DHObjectAnimationSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timingFunctionPicker.delegate = self;
    self.timingFunctionPicker.dataSource = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateSettings];
}

- (void) setSettings:(DHObjectAnimationSettings *)settings
{
    _settings = settings;
    [self updateSettings];
}

- (void) updateSettings
{
    self.durationSlider.value = self.settings.duration;
    self.animationDirectionSegment.selectedSegmentIndex = self.settings.direction;
    self.animationEventSegment.selectedSegmentIndex = self.settings.event;
    [self.timingFunctionPicker selectRow:self.settings.timingFunction inComponent:0 animated:NO];
}

- (IBAction)durationChanged:(id)sender {
    self.settings.duration = self.durationSlider.value;
}

- (IBAction)animationDirectionChanged:(id)sender {
    self.settings.direction = self.animationDirectionSegment.selectedSegmentIndex;
}

- (IBAction)animationEventChanged:(id)sender {
    self.settings.event = self.animationEventSegment.selectedSegmentIndex;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [DHTimingFunctionHelper timingFunctionCount];
}

#pragma mark - UIPickerViewDelegate
- (UIView *) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.bounds.size.width, 30)];
    label.text = [DHTimingFunctionHelper functionNameForTimingFunction:row];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:15];
    return label;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.settings.timingFunction = row;
}
@end
