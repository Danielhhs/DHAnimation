//
//  DHResolvingDoorRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/24/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHResolvingDoorRenderer.h"

@implementation DHResolvingDoorRenderer

#pragma mark - Initialization
- (instancetype) init
{
    self = [super init];
    if (self) {
        self.srcVertexShaderFileName = @"ResolvingDoorSourceVertex.glsl";
        self.srcFragmentShaderFileName = @"ResolvingDoorSourceFragment.glsl";
        self.dstVertexShaderFileName = @"ResolvingDoorDestinationVertex.glsl";
        self.dstFragmentShaderFileName = @"ResolvingDoorDestinationFragment.glsl";
    }
    return self;
}

#pragma mark - Override
- (void) setupDrawingContext
{
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}
@end
