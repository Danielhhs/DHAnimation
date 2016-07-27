//
//  DHMosaicBackMesh.m
//  DHAnimation
//
//  Created by Huang Hongsen on 3/20/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHMosaicBackMesh.h"

@implementation DHMosaicBackMesh

- (void) setupForVertexAtX:(NSInteger)x y:(NSInteger)y index:(NSInteger)index
{
    [super setupForVertexAtX:x y:y index:index];
    GLfloat tmpTexCoords = vertices[index + 0].texCoords.x;
    vertices[index + 0].texCoords.x = vertices[index + 1].texCoords.x;
    vertices[index + 1].texCoords.x = tmpTexCoords;
    vertices[index + 2].texCoords.x = vertices[index + 3].texCoords.x;
    vertices[index + 3].texCoords.x = tmpTexCoords;
}

@end
