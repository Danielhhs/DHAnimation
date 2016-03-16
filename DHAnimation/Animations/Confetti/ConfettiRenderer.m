//
//  ConfettiRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/16/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "ConfettiRenderer.h"

@implementation ConfettiRenderer

#pragma mark - Initialization
- (instancetype) init
{
    self = [super init];
    if (self) {
        self.srcVertexShaderFileName = @"ConfettiSourceVertex.glsl";
        self.srcFragmentShaderFileName = @"ConfettiSourceFragment.glsl";
        self.dstVertexShaderFileName = @"ConfettiDestinationVertex.glsl";
        self.dstFragmentShaderFileName = @"ConfettiDestinationFragment.glsl";
    }
    return self;
}

#pragma mark - Drawing
- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT);
    [self setupMvpMatrixWithView:view];
    
    glUseProgram(dstProgram);
    [self.dstMesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, dstTexture);
    glUniform1i(dstSamplerLoc, 0);
    [self.dstMesh drawEntireMesh];
    
    glUseProgram(srcProgram);
    [self.srcMesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, srcTexture);
    glUniform1i(srcSamplerLoc, 0);
    [self.srcMesh drawEntireMesh];
}

#pragma mark - Override
- (void) setupMeshWithFromView:(UIView *)fromView toView:(UIView *)toView
{
    self.srcMesh = [[SceneMesh alloc] initWithView:fromView columnCount:fromView.bounds.size.width / 6 rowCount:fromView.bounds.size.height / 6 splitTexturesOnEachGrid:YES columnMajored:YES];
    self.dstMesh = [[SceneMesh alloc] initWithView:toView columnCount:1 rowCount:1 splitTexturesOnEachGrid:NO columnMajored:YES];
}
@end
