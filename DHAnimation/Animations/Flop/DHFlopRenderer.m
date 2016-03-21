//
//  DHFlopRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/21/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHFlopRenderer.h"
@interface DHFlopRenderer() {
    GLuint srcScreenHeightLoc, dstScreenHeightLoc;
    GLuint srcCylinderRadiusLoc, dstCylinderRadiusLoc;
    GLuint srcTargetCenterLoc, dstTargetCenterLoc;
}
@property (nonatomic) GLKVector3 targetCylinderCenter;
@property (nonatomic) GLfloat cylinderRadius;
@end

#define CENTER_ANGLE (90.f / 180.f * M_PI)

@implementation DHFlopRenderer
#pragma mark - Initialization
- (instancetype) init
{
    self = [super init];
    if (self) {
        self.srcVertexShaderFileName = @"FlopSourceVertex.glsl";
        self.srcFragmentShaderFileName = @"FlopSourceFragment.glsl";
        self.dstVertexShaderFileName = @"FlopDestinationVertex.glsl";
        self.dstFragmentShaderFileName = @"FlopDestinationFragment.glsl";
    }
    return self;
}

#pragma mark - Override
- (void) setupGL
{
    [super setupGL];
    glUseProgram(srcProgram);
    srcScreenHeightLoc = glGetUniformLocation(srcProgram, "u_screenHeight");
    srcCylinderRadiusLoc = glGetUniformLocation(srcProgram, "u_cylinderRadius");
    srcTargetCenterLoc = glGetUniformLocation(srcProgram, "u_targetCenter");
    
    glUseProgram(dstProgram);
    dstScreenHeightLoc = glGetUniformLocation(dstProgram, "u_screenHeight");
    dstCylinderRadiusLoc = glGetUniformLocation(dstProgram, "u_cylinderRadius");
    dstTargetCenterLoc = glGetUniformLocation(dstProgram, "u_targetCenter");
}

- (void) setupMeshWithFromView:(UIView *)fromView toView:(UIView *)toView
{
    self.srcMesh = [[SceneMesh alloc] initWithView:fromView columnCount:1 rowCount:fromView.bounds.size.height splitTexturesOnEachGrid:NO columnMajored:NO];
    self.dstMesh = [[SceneMesh alloc] initWithView:toView columnCount:1 rowCount:toView.bounds.size.height splitTexturesOnEachGrid:NO columnMajored:NO];
    self.cylinderRadius = fromView.bounds.size.height / 2 / CENTER_ANGLE;
    self.targetCylinderCenter = GLKVector3Make(0, fromView.bounds.size.height / 2 + self.cylinderRadius * sinf(CENTER_ANGLE / 2), -self.cylinderRadius * (cosf(CENTER_ANGLE / 2)));
}

- (void) setupUniformsForSourceProgram
{
    glUniform1f(srcScreenHeightLoc, self.animationView.bounds.size.height);
    glUniform1f(srcCylinderRadiusLoc, self.cylinderRadius);
    glUniform3fv(srcTargetCenterLoc, 1, self.targetCylinderCenter.v);
}

- (void) setupUniformsForDestinationProgram
{
    glUniform1f(dstScreenHeightLoc, self.animationView.bounds.size.height);
    glUniform1f(dstCylinderRadiusLoc, self.cylinderRadius);
    glUniform3fv(dstTargetCenterLoc, 1, self.targetCylinderCenter.v);
}

- (void) setupMvpMatrixWithView:(UIView *)view
{
    GLKMatrix4 modelView = GLKMatrix4MakeTranslation(-view.bounds.size.width / 2, -view.bounds.size.height / 2, -view.bounds.size.height / 2 / tan(M_PI / 24));
    modelView = GLKMatrix4Rotate(modelView, M_PI_2, 0, 1, 0);
    GLfloat aspect = view.bounds.size.width / view.bounds.size.height;
    GLKMatrix4 projectioin = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(15), aspect, 1, 10000);
    GLKMatrix4 mvpMatrix = GLKMatrix4Multiply(projectioin, modelView);
    
    glUseProgram(srcProgram);
    glUniformMatrix4fv(srcMvpLoc, 1, GL_FALSE, mvpMatrix.m);
    
    glUseProgram(dstProgram);
    glUniformMatrix4fv(dstMvpLoc, 1, GL_FALSE, mvpMatrix.m);
}

@end
