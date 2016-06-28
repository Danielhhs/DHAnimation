//
//  DHTextDanceAnimationRenderer.h
//  DHAnimation
//
//  Created by Huang Hongsen on 6/23/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHTextEffectRenderer.h"

@interface DHTextDanceAnimationRenderer : DHTextEffectRenderer
@property (nonatomic) CGFloat squishFactor;     //How much the characters will squish, default value is 0.8
@property (nonatomic) GLfloat amplitude;       //Jumping amplitude; default to be 75;
@property (nonatomic) GLfloat cycleLength;      //Horizontal length for a cycle; default to be 100;
@property (nonatomic) NSTimeInterval squishTimeRatio;    //Squish time in a cycle compared to single cycle duration, default to be 0.15;
@property (nonatomic) NSTimeInterval singleCharacterDuration;   //Duration for a single character, default value is 0.8 * duration;
@end
