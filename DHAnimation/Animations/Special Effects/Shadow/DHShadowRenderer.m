//
//  DHShadowRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 8/26/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHShadowRenderer.h"
@interface DHShadowRenderer() {
    GLuint depthMapFBO, depthMap;
}
@end

@implementation DHShadowRenderer

- (NSString *) vertexShaderName
{
    return @"ShadowObjectVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ShadowObjectFragment.glsl";
}

- (void) setupGL
{
    [super setupGL];
    
    [self setupShadowMap];
}

- (void) setupShadowMap
{
    glGenFramebuffers(1, &depthMapFBO);
    
    glGenTextures(1, &depthMap);
    glBindTexture(GL_TEXTURE_2D, depthMap);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT, self.targetView.frame.size.width, self.targetView.frame.size.height, 0, GL_DEPTH_COMPONENT, GL_FLOAT, NULL);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
}

- (void) drawFrame
{
    glViewport(0, 0, self.targetView.frame.size.width, self.targetView.frame.size.height);
    glBindFramebuffer(GL_FRAMEBUFFER, depthMapFBO);
    glClear(GL_DEPTH_BUFFER_BIT);
    
}

@end
