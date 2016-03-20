//
//  DHMosaicRenderer.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/18/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHMosaicRenderer.h"

@implementation DHMosaicRenderer

- (instancetype) init
{
    self = [super init];
    if (self) {
        self.srcVertexShaderFileName = @"MosaicSourceVertex.glsl";
        self.srcFragmentShaderFileName = @"MosaicSourceFragment.glsl";
        self.dstVertexShaderFileName = @"MosaicDestinationVertex.glsl";
        self.dstFragmentShaderFileName = @"MosaicDestinationFragment.glsl";
    }
    return self;
}

@end
