//
//  DHTextFadeMesh.h
//  DHAnimation
//
//  Created by Huang Hongsen on 8/8/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <DHAnimationFramework/DHAnimationFramework.h>

@interface DHTextFadeMesh : DHTextSceneMesh

@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) GLfloat singleCharacterFadingTimeRatio;

@end
