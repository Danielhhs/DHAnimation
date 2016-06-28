//
//  DHCameraShakeEffect.h
//  DHAnimation
//
//  Created by Huang Hongsen on 6/28/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface DHCameraShakeEffect : NSObject

+ (GLKMatrix4) shakeCameraWithElapsedTime:(NSTimeInterval)elapsedTime duration:(NSTimeInterval)duration shakingFactor:(GLfloat)shakingFactor;

@end
