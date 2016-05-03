//
//  DHReflectionRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/23/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHReflectionTransitionRenderer.h"

#define MAX_ROTATION M_PI_4

@interface DHReflectionTransitionRenderer () {
    GLuint srcScreenWidthLoc, dstScreenWidthLoc;
    GLuint srcRotatePositionLoc, dstRotatePositionLoc;
    GLuint srcModelViewMatrixLoc, dstModelViewMatrixLoc;
}

@end

@implementation DHReflectionTransitionRenderer
#pragma mark - Initialization
- (instancetype) init
{
    self = [super init];
    if (self) {
        self.srcVertexShaderFileName = @"ReflectionSourceVertex.glsl";
        self.srcFragmentShaderFileName = @"ReflectionSourceFragment.glsl";
        self.dstVertexShaderFileName = @"ReflectionDestinationVertex.glsl";
        self.dstFragmentShaderFileName = @"ReflectionDestinationFragment.glsl";
    }
    return self;
}

#pragma mark - Override
- (void) setupGL
{
    [super setupGL];
    glUseProgram(srcProgram);
    srcScreenWidthLoc = glGetUniformLocation(srcProgram, "u_screenWidth");
    srcRotatePositionLoc = glGetUniformLocation(srcProgram, "u_rotatePosition");
    srcModelViewMatrixLoc = glGetUniformLocation(srcProgram, "u_modelViewMatrix");
    
    glUseProgram(dstProgram);
    dstScreenWidthLoc = glGetUniformLocation(dstProgram, "u_screenWidth");
    dstRotatePositionLoc = glGetUniformLocation(dstProgram, "u_rotatePosition");
    dstModelViewMatrixLoc = glGetUniformLocation(dstProgram, "u_modelViewMatrix");
}

- (void) setupUniformsForSourceProgram
{
    glUniform1f(srcScreenWidthLoc, self.animationView.bounds.size.width);
    glUniform1f(srcRotatePositionLoc, self.animationView.bounds.size.width * 0.618);
}

- (void) setupUniformsForDestinationProgram
{
    glUniform1f(dstScreenWidthLoc, self.animationView.bounds.size.width);
    glUniform1f(dstRotatePositionLoc, self.animationView.bounds.size.width * 0.618);
}

- (void) setupMvpMatrixWithView:(UIView *)view
{
    GLfloat xOffset = 0.f;
    if (self.direction == DHAnimationDirectionLeftToRight) {
        xOffset = view.bounds.size.width * self.percent;
    }
    float zOffset = 0.f;
    if (self.direction != DHAnimationDirectionLeftToRight) {
        zOffset = view.bounds.size.width * self.percent;
    }
    GLKMatrix4 modelMatrix = GLKMatrix4MakeTranslation(-view.bounds.size.width / 2 + xOffset, -view.bounds.size.height / 2, -view.bounds.size.height / 2 / tan(M_PI / 24) + zOffset - sin(self.percent * M_PI) * 300);
    
    int direction = 1;
    if (self.direction == DHAnimationDirectionLeftToRight) {
        direction = -1;
    }
    GLKMatrix4 viewMatrix = GLKMatrix4MakeLookAt(0, 0, 0, direction * sin(self.percent * M_PI_2), 0, -cos(self.percent * M_PI_2), 0, 1, 0);
    GLfloat aspect = view.bounds.size.width / view.bounds.size.height;
    GLKMatrix4 projectioin = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(15), aspect, 1, 10000);
    GLKMatrix4 modelViewMatrix = GLKMatrix4Multiply(modelMatrix, viewMatrix);
    GLKMatrix4 mvpMatrix = GLKMatrix4Multiply(projectioin, modelViewMatrix);
    
    glUseProgram(srcProgram);
    glUniformMatrix4fv(srcMvpLoc, 1, GL_FALSE, mvpMatrix.m);
    glUniformMatrix4fv(srcModelViewMatrixLoc, 1, GL_FALSE, modelViewMatrix.m);
    
    glUseProgram(dstProgram);
    glUniformMatrix4fv(dstMvpLoc, 1, GL_FALSE, mvpMatrix.m);
    glUniformMatrix4fv(dstModelViewMatrixLoc, 1, GL_FALSE, modelViewMatrix.m);
}

- (NSArray *) allowedDirections
{
    return @[@(DHAllowedAnimationDirectionLeft), @(DHAllowedAnimationDirectionRight)];
}
@end
