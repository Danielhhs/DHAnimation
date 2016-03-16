//
//  DoorWayRenderer.m
//  DoorWayAnimation
//
//  Created by Huang Hongsen on 3/4/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DoorWayRenderer.h"
#import "OpenGLHelper.h"
#import "TextureHelper.h"
#import "DoorWaySourceMesh.h"
#import "DHTimingFunctionHelper.h"

@interface DoorWayRenderer() {
    GLuint srcColumnWidthLoc;
}
@property (nonatomic, strong) DoorWaySourceMesh *sourceMesh;
@property (nonatomic, strong) SceneMesh *destinamtionMesh;
@end

@implementation DoorWayRenderer

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
- (SceneMesh *) srcMesh
{
    return self.sourceMesh;
}

- (SceneMesh *) dstMesh
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
    self.sourceMesh = [[DoorWaySourceMesh alloc] initWithView:fromView columnCount:2 rowCount:1 splitTexturesOnEachGrid:YES columnMajored:YES];
    self.destinamtionMesh = [[SceneMesh alloc] initWithView:toView columnCount:1 rowCount:1 splitTexturesOnEachGrid:YES columnMajored:YES];
}

- (void)setupUniformsForSourceProgram
{
    glUniform1f(srcColumnWidthLoc, self.animationView.bounds.size.width / 2);
}
@end
