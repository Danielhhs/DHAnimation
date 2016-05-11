//
//  DHConsecutiveTextureSceneMesh.m
//  DHAnimation
//
//  Created by Huang Hongsen on 5/11/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHConsecutiveTextureSceneMesh.h"

@implementation DHConsecutiveTextureSceneMesh
- (void) generateVerticesAndIndicesForView:(UIView *)view containerView:(UIView *)containerView columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount columnMajored:(BOOL)columnMajored rotateTexture:(BOOL)rotateTexture
{
    self.vertexCount = (rowCount + 1) * (columnCount + 1);
    self.indexCount = rowCount * columnCount * 6;
    self.verticesSize = self.vertexCount * sizeof(SceneMeshVertex);
    self.indicesSize = self.indexCount * sizeof(GLuint);
    
    vertices = malloc(self.verticesSize);
    indices = malloc(self.indicesSize);
    if (columnMajored) {
        [self generateColumnMajoredVerticesForView:view columnCount:columnCount rowCount:rowCount];
    } else {
        [self generateRowMajoredVerticesForView:view columnCount:columnCount rowCount:rowCount];
    }
}

- (void)generateColumnMajoredVerticesForView:(UIView *)view columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount
{
    CGFloat ux = 1.f / columnCount;
    CGFloat uy = 1.f / rowCount;
    for (int x = 0; x <= columnCount; x++) {
        CGFloat vx = x * ux;
        for (int y = 0; y <= rowCount; y++) {
            CGFloat vy = uy * y;
            vertices[x * (rowCount + 1) + y].position.x = self.originX + vx * view.bounds.size.width;
            vertices[x * (rowCount + 1) + y].position.y = self.originY + vy * view.bounds.size.height;
            vertices[x * (rowCount + 1) + y].position.z = 0;
            vertices[x * (rowCount + 1) + y].texCoords = GLKVector2Make(vx, 1 - vy);
            vertices[x * (rowCount + 1) + y].normal = GLKVector3Make(0, 0, 1);
            vertices[x * (rowCount + 1) + y].rotation = 0;
            vertices[x * (rowCount + 1) + y].columnStartPosition = vertices[x * (rowCount + 1) + y].position;
        }
    }
    for (NSInteger x = 0; x < columnCount; x++) {
        for (NSInteger y = 0; y < rowCount; y++) {
            NSInteger index = x * rowCount + y;
            NSInteger i = x * (rowCount + 1) + y;
            indices[index * 6 + 0] = (GLuint)i;
            indices[index * 6 + 1] = (GLuint)i + 1;
            indices[index * 6 + 2] = (GLuint)(i + rowCount + 1);
            indices[index * 6 + 3] = (GLuint)(i + rowCount + 1);
            indices[index * 6 + 4] = (GLuint)(i + 1);
            indices[index * 6 + 5] = (GLuint)(i + rowCount + 2);
        }
    }
}

- (void)generateRowMajoredVerticesForView:(UIView *)view columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount
{
    CGFloat ux = 1.f / columnCount;
    CGFloat uy = 1.f / rowCount;
    for (int y = 0; y <= rowCount; y++) {
        CGFloat vy = y * uy;
        for (int x = 0; x <= columnCount; x++) {
            CGFloat vx = ux * x;
            vertices[y * (columnCount + 1) + x].position.x = self.originX + vx * view.bounds.size.width;
            vertices[y * (columnCount + 1) + x].position.y = self.originY + vy * view.bounds.size.height;
            vertices[y * (columnCount + 1) + x].position.z = 0;
            vertices[y * (columnCount + 1) + x].texCoords = GLKVector2Make(vx, 1 - vy);
            vertices[y * (columnCount + 1) + x].normal = GLKVector3Make(0, 0, 1);
            vertices[y * (columnCount + 1) + x].rotation = 0;
        }
    }
    for (NSInteger y = 0; y < rowCount; y++) {
        for (NSInteger x = 0; x < columnCount; x++) {
            NSInteger index = y * columnCount + x;
            NSInteger i = y * (columnCount + 1) + x;
            indices[index * 6 + 0] = (GLuint)i;
            indices[index * 6 + 1] = (GLuint)(i + columnCount + 1);
            indices[index * 6 + 2] = (GLuint)i + 1;
            indices[index * 6 + 3] = (GLuint)i + 1;
            indices[index * 6 + 4] = (GLuint)(i + columnCount + 1);
            indices[index * 6 + 5] = (GLuint)(i + columnCount + 2);
        }
    }
}
@end
