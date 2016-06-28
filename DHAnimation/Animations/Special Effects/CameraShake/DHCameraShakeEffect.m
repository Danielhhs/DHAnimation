//
//  DHCameraShakeEffect.m
//  DHAnimation
//
//  Created by Huang Hongsen on 6/28/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHCameraShakeEffect.h"

@implementation DHCameraShakeEffect

+ (GLKMatrix4) shakeCameraWithElapsedTime:(NSTimeInterval)elapsedTime duration:(NSTimeInterval)duration shakingFactor:(GLfloat)shakingFactor
{
    GLfloat percent = elapsedTime / duration;
    GLKMatrix4 viewMatrix;
    
    if (percent < 0.25) {
        percent = percent / 0.25;
        viewMatrix = GLKMatrix4MakeLookAt(0, 0, 1, [DHCameraShakeEffect shakeValueForPercent:percent shakingFactor:shakingFactor], 0, 0, 0, 1, 0);
    } else if (percent < 0.5) {
        percent = (percent - 0.25) / 0.25;
        viewMatrix = GLKMatrix4MakeLookAt(0, 0, 1, -[DHCameraShakeEffect shakeValueForPercent:percent shakingFactor:shakingFactor], 0, 0, 0, 1, 0);
    } else if (percent < 0.75) {
        percent = (percent - 0.5) / 0.25;
        viewMatrix = GLKMatrix4MakeLookAt(0, 0, 1, 0, [DHCameraShakeEffect shakeValueForPercent:percent shakingFactor:shakingFactor], 0, 0, 1, 0);
    } else {
        percent = (percent - 0.75) / 0.25;
        viewMatrix = GLKMatrix4MakeLookAt(0, 0, 1, 0, -[DHCameraShakeEffect shakeValueForPercent:percent shakingFactor:shakingFactor], 0, 0, 1, 0);
    }
    
    return viewMatrix;
}

+ (GLfloat) shakeValueForPercent:(GLfloat)percent  shakingFactor:(GLfloat)shakingFactor
{
    float value = 0;
    if (percent < 0.5) {
        value = shakingFactor * 2 * percent;
    } else {
        value = -2 * shakingFactor * percent + 2 * shakingFactor;
    }
    return value;
}
@end
