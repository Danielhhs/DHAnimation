//
//  DHTextSquishAnimaitonRenderer.h
//  DHAnimation
//
//  Created by Huang Hongsen on 6/22/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHTextEffectRenderer.h"

@interface DHTextSquishAnimationRenderer : DHTextEffectRenderer

@property (nonatomic) CGFloat squishFactor;     //How much the characters will squish, default value is 0.618
@property (nonatomic) NSTimeInterval cycle; //Time Interval for one bounce cycle, must be less than duration, default value i 0.3 * duration
@property (nonatomic) NSTimeInterval squishTime;    //Time for squish, must be less than cycle, the larger, the squish is more observable, default value is 0.25 * cycle;
@property (nonatomic) NSInteger numberOfCycles;     //Number of bounces you want, default is 5;
@end
