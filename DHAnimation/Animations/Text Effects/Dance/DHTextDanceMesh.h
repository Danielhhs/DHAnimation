//
//  DHTextDanceMesh.h
//  DHAnimation
//
//  Created by Huang Hongsen on 6/23/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHTextSceneMesh.h"
#import "DHConstants.h"
@interface DHTextDanceMesh : DHTextSceneMesh

@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) DHAnimationDirection direction;
@property (nonatomic) GLfloat singleCharacterDurationRatio;

@end
