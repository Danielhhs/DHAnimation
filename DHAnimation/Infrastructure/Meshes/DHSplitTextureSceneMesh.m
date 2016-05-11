//
//  DHSplitTextureSceneMesh.m
//  DHAnimation
//
//  Created by Huang Hongsen on 5/11/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHSplitTextureSceneMesh.h"

@implementation DHSplitTextureSceneMesh
- (void) generateVerticesAndIndicesForView:(UIView *)view columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount columnMajored:(BOOL)columnMajor rotateTexture:(BOOL)rotateTexture
{
    self.vertexCount = columnCount * rowCount * 4;
    self.indexCount = columnCount * rowCount * 6;
    self.verticesSize = self.vertexCount * sizeof(SceneMeshVertex);
    self.indicesSize = self.indexCount * sizeof(GLuint);
    
    vertices = malloc(self.verticesSize);
    indices = malloc(self.indicesSize);
    
    if (columnMajor) {
        [self generateColumnMajoredVerticesForSplitTextureForView:view columnCount:columnCount rowCount:rowCount];
    } else {
        [self generateRowMajoredVerticesForSplitTextureForView:view columnCount:columnCount rowCount:rowCount];
    }
    
    int index = 0;
    for (int x = 0; x < columnCount; x++) {
        for (int y = 0; y < rowCount; y++) {
            index = x * (int)rowCount + y;
            indices[index * 6 + 0] = index * 4;
            indices[index * 6 + 1] = index * 4 + 1;
            indices[index * 6 + 2] = index * 4 + 2;
            indices[index * 6 + 3] = index * 4 + 2;
            indices[index * 6 + 4] = index * 4 + 1;
            indices[index * 6 + 5] = index * 4 + 3;
        }
    }
}


- (void) generateColumnMajoredVerticesForSplitTextureForView:(UIView *)view columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount
{
    NSInteger index = 0;
    CGFloat ux = 1.f / columnCount;
    CGFloat uy = 1.f / rowCount;
    for (int x = 0; x < columnCount; x++) {
        CGFloat vx = ux * x;
        for (int y = 0; y < rowCount; y++) {
            CGFloat vy = uy * y;
            index = (x * rowCount + y) * 4;
            vertices[index + 0].position = GLKVector3Make(self.originX + vx * view.bounds.size.width, self.originY + vy * view.bounds.size.height, 0);
            vertices[index + 0].texCoords = GLKVector2Make(vx, 1 - vy);
            
            vertices[index + 1].position = GLKVector3Make(self.originX + (vx + ux) * view.bounds.size.width, self.originY + vy * view.bounds.size.height, 0);
            vertices[index + 1].texCoords = GLKVector2Make(vx + ux, 1 - vy);
            
            vertices[index + 2].position = GLKVector3Make(self.originX + vx * view.bounds.size.width, self.originY + (vy + uy) * view.bounds.size.height, 0);
            vertices[index + 2].texCoords = GLKVector2Make(vx, 1 - (vy + uy));
            
            vertices[index + 3].position = GLKVector3Make(self.originX + (vx + ux) * view.bounds.size.width, self.originY + (vy + uy) * view.bounds.size.height, 0);
            vertices[index + 3].texCoords = GLKVector2Make(vx + ux, 1 - (vy + uy));
            
            vertices[index + 0].columnStartPosition = vertices[index + 0].position;
            vertices[index + 1].columnStartPosition = vertices[index + 0].position;
            vertices[index + 2].columnStartPosition = vertices[index + 0].position;
            vertices[index + 3].columnStartPosition = vertices[index + 0].position;
            [self setupForVertexAtX:x y:y index:index];
            
            vertices[index + 0].normal = GLKVector3Make(0, 0, 1);
            vertices[index + 1].normal = GLKVector3Make(0, 0, 1);
            vertices[index + 2].normal = GLKVector3Make(0, 0, 1);
            vertices[index + 3].normal = GLKVector3Make(0, 0, 1);
        }
    }
}


- (void) generateRowMajoredVerticesForSplitTextureForView:(UIView *)view columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount
{
    NSInteger index = 0;
    CGFloat ux = 1.f / columnCount;
    CGFloat uy = 1.f / rowCount;
    for (int y = 0; y < rowCount; y++) {
        CGFloat vy = uy * y;
        for (int x = 0; x < columnCount; x++) {
            CGFloat vx = ux * x;
            index = (y * columnCount + x) * 4;
            vertices[index + 0].position = GLKVector3Make(self.originX + vx * view.bounds.size.width, self.originY + vy * view.bounds.size.height, 0);
            vertices[index + 0].texCoords = GLKVector2Make(vx, 1 - vy);
            
            vertices[index + 1].position = GLKVector3Make(self.originX + (vx + ux) * view.bounds.size.width, self.originY + vy * view.bounds.size.height, 0);
            vertices[index + 1].texCoords = GLKVector2Make(vx + ux, 1 - vy);
            
            vertices[index + 2].position = GLKVector3Make(self.originX + vx * view.bounds.size.width, self.originY + (vy + uy) * view.bounds.size.height, 0);
            vertices[index + 2].texCoords = GLKVector2Make(vx, 1 - (vy + uy));
            
            vertices[index + 3].position = GLKVector3Make(self.originX + (vx + ux) * view.bounds.size.width, self.originY + (vy + uy) * view.bounds.size.height, 0);
            vertices[index + 3].texCoords = GLKVector2Make(vx + ux, 1 - (vy + uy));
            
            vertices[index + 0].columnStartPosition = vertices[index + 0].position;
            vertices[index + 1].columnStartPosition = vertices[index + 0].position;
            vertices[index + 2].columnStartPosition = vertices[index + 0].position;
            vertices[index + 3].columnStartPosition = vertices[index + 0].position;
            [self setupForVertexAtX:x y:y index:index];
            vertices[index + 0].normal = GLKVector3Make(0, 0, 1);
            vertices[index + 1].normal = GLKVector3Make(0, 0, 1);
            vertices[index + 2].normal = GLKVector3Make(0, 0, 1);
            vertices[index + 3].normal = GLKVector3Make(0, 0, 1);
        }
    }
}
@end
