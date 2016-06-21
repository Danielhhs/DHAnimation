//
//  DHTextFlyInMesh.h
//  DHAnimation
//
//  Created by Huang Hongsen on 6/21/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHTextSceneMesh.h"

@interface DHTextFlyInMesh : DHTextSceneMesh
- (instancetype) initWithAttributedText:(NSAttributedString *)attributedText origin:(CGPoint)origin textContainerView:(UIView *)textContainerView containerView:(UIView *)containerView lifeTime:(NSTimeInterval)lifeTime;
@end
