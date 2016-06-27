//
//  DHTextSquishAnimaitonRenderer.h
//  DHAnimation
//
//  Created by Huang Hongsen on 6/22/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHTextEffectRenderer.h"

@interface DHTextSquishAnimationRenderer : DHTextEffectRenderer

@property (nonatomic) CGFloat squishFactor;
@property (nonatomic) NSTimeInterval cycle; //Time Interval for one bounce cycle, must be less than duration
@property (nonatomic) NSTimeInterval squishTime;    //Time for squish, must be less than cycle, the larger, the squish is more observable;
@end
