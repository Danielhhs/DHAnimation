//
//  DHPageCurlTransitionRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 6/14/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHPageCurlTransitionRenderer.h"

@implementation DHPageCurlTransitionRenderer

- (instancetype) init
{
    self = [super init];
    if (self) {
        self.srcVertexShaderFileName = @"PageCurlSourceVertex.glsl";
        self.srcFragmentShaderFileName = @"PageCurlSourceFragment.glsl";
        self.dstVertexShaderFileName = @"PageCurlDestinationVertex.glsl";
        self.dstFragmentShaderFileName = @"PageCurlDestinationFragment.glsl";
    }
    return self;
}

@end
