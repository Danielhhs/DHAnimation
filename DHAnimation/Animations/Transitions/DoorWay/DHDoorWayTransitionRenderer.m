//
//  DoorWayRenderer.m
//  DoorWayAnimation
//
//  Created by Huang Hongsen on 3/4/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHDoorWayTransitionRenderer.h"
#import "OpenGLHelper.h"
#import "TextureHelper.h"
#import "DHTimingFunctionHelper.h"

@interface DHDoorWayTransitionRenderer() {
    GLuint srcColumnWidthLoc;
}
@property (nonatomic, strong) DHSceneMesh *sourceMesh;
@property (nonatomic, strong) DHSceneMesh *destinamtionMesh;
@end

@implementation DHDoorWayTransitionRenderer

#pragma mark - Initialization
- (instancetype) init
{
    self = [super init];
    if (self) {
        self.srcVertexShaderFileName = @"DoorWaySourceVertex.glsl";
        self.srcFragmentShaderFileName = @"DoorWaySourceFragment.glsl";
        self.dstVertexShaderFileName = @"DoorWayDestinationVertex.glsl";
        self.dstFragmentShaderFileName = @"DoorWayDestinationFragment.glsl";
        
    }
    return self;
}

#pragma mark - Override
- (DHSceneMesh *) srcMesh
{
    return self.sourceMesh;
}

- (DHSceneMesh *) dstMesh
{
    return self.destinamtionMesh;
}

- (void) setupGL
{
    [super setupGL];
    glUseProgram(srcProgram);
    srcColumnWidthLoc = glGetUniformLocation(srcProgram, "u_columnWidth");
}

- (void) setupMeshWithFromView:(UIView *)fromView toView:(UIView *)toView
{
    self.sourceMesh = [DHSceneMeshFactory sceneMeshForView:fromView columnCount:2 rowCount:1 splitTexturesOnEachGrid:YES columnMajored:YES rotateTexture:YES];
    [self.srcMesh generateMeshData];
    self.destinamtionMesh = [DHSceneMeshFactory sceneMeshForView:toView columnCount:1 rowCount:1 splitTexturesOnEachGrid:YES columnMajored:YES rotateTexture:YES];
    [self.dstMesh generateMeshData];
}

- (void)setupUniformsForSourceProgram
{
    glUniform1f(srcColumnWidthLoc, self.animationView.bounds.size.width / 2);
}

- (NSArray *) allowedDirections
{
    return nil;
}
@end
