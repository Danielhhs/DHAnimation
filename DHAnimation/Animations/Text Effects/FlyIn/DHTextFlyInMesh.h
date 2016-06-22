//
//  DHTextFlyInMesh.h
//  DHAnimation
//
//  Created by Huang Hongsen on 6/21/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHTextSceneMesh.h"
#import "DHConstants.h"

@interface DHTextFlyInMesh : DHTextSceneMesh
@property (nonatomic) DHAnimationEvent event;
@property (nonatomic) DHAnimationDirection direction;

- (instancetype) initWithAttributedText:(NSAttributedString *)attributedText origin:(CGPoint)origin textContainerView:(UIView *)textContainerView containerView:(UIView *)containerView duration:(NSTimeInterval)duration;
@end
