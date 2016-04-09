//
//  AnimationSettingViewController.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/9/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHTransitionSettingViewController.h"
#import "DHTimingFunctionHelper.h"

@interface DHTransitionSettingViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UISlider *durationSlider;
@property (weak, nonatomic) IBOutlet UIPickerView *timingFunctionPicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *directionSegment;
@property (weak, nonatomic) IBOutlet UISlider *columnCountSlider;
@property (weak, nonatomic) IBOutlet UISlider *rowCountSlider;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayoutConstraint;
@end

@implementation DHTransitionSettingViewController
- (void) viewDidLoad
{
    [super viewDidLoad];
    self.timingFunctionPicker.dataSource = self;
    self.timingFunctionPicker.delegate = self;
}


#pragma mark - Update Settings
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateSettings];
}

- (void) setSettings:(DHTransitionSettings *)settings
{
    _settings = settings;
    [self updateSettings];
}

- (void) updateSettings
{
    self.durationSlider.value = self.settings.duration;
    self.directionSegment.selectedSegmentIndex = self.settings.animationDirection;
    [self.timingFunctionPicker selectRow:self.settings.timingFunction inComponent:0 animated:NO];
    self.columnCountSlider.value = self.settings.columnCount;
    self.rowCountSlider.value = self.settings.rowCount;
}

#pragma mark - Event Handling
- (IBAction)durationChanged:(id)sender {
    self.settings.duration = self.durationSlider.value;
}

- (IBAction)directionChanged:(id)sender {
    self.settings.animationDirection = self.directionSegment.selectedSegmentIndex;
}

- (IBAction)columnCountChanged:(id)sender {
    self.settings.columnCount = self.columnCountSlider.value;
}

- (IBAction)rowCountChanged:(id)sender {
    self.settings.rowCount = self.rowCountSlider.value;
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
