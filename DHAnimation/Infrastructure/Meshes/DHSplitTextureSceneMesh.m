//
//  DHSplitTextureSceneMesh.m
//  DHAnimation
//
//  Created by Huang Hongsen on 5/11/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHSplitTextureSceneMesh.h"

@implementation DHSplitTextureSceneMesh
- (void) generateVerticesAndIndicesForView:(UIView *)view containerView:(UIView *)containerView columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount columnMajored:(BOOL)columnMajor rotateTexture:(BOOL)rotateTexture
{
    self.vertexCount = columnCount * rowCount * 4;
    self.indexCount = columnCount * rowCount * 6;
    self.verticesSize = self.vertexCount * sizeof(SceneMeshVertex);
    self.indicesSize = self.indexCount * sizeof(GLuint);
    
    vertices = malloc(self.verticesSize);
    indices = malloc(self.indicesSize);
    
    if (columnMajor) {
        [self generateColumnMajoredVerticesForSplitTextureForView:view columnCount:columnCount rowCount:rowCount rotateTexture:rotateTexture];
    } else {
        [self generateRowMajoredVerticesForSplitTextureForView:view columnCount:columnCount rowCount:rowCount rotateTexture:rotateTexture];
    }
    
    if (rotateTexture == NO) {
        float angle = atan(view.transform.c / view.transform.a);
        GLKMatrix4 transformMatrix = GLKMatrix4MakeTranslation(-(self.originX + view.bounds.size.width / 2), -(containerView.frame.size.height - CGRectGetMaxY(view.frame) + view.bounds.size.height / 2), 0);
        GLKMatrix4 rotationMatrix = GLKMatrix4MakeRotation(angle, 0, 0, 1);
        transformMatrix = GLKMatrix4Multiply(rotationMatrix, transformMatrix);
        GLKMatrix4 translateBackMatrix = GLKMatrix4MakeTranslation(self.originX + view.frame.size.width / 2, containerView.frame.size.height - CGRectGetMaxY(view.frame) + view.frame.size.height / 2, 0);
        transformMatrix = GLKMatrix4Multiply(translateBackMatrix, transformMatrix);
        
        for (int i = 0; i < self.vertexCount; i++) {
            GLKVector4 rotatedPos = GLKVector4Make(vertices[i].position.x, vertices[i].position.y, vertices[i].position.z, 1);
            rotatedPos = GLKMatrix4MultiplyVector4(transformMatrix, rotatedPos);
            vertices[i].position = GLKVector3Make(rotatedPos.x, rotatedPos.y, rotatedPos.z );
        }
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


- (void) generateColumnMajoredVerticesForSplitTextureForView:(UIView *)view columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount rotateTexture:(BOOL)rotateTexture
{
    CGRect rect = view.bounds;
    if (rotateTexture) {
        rect = view.frame;
    }
    NSInteger index = 0;
    CGFloat ux = 1.f / columnCount;
    CGFloat uy = 1.f / rowCount;
    for (int x = 0; x < columnCount; x++) {
        CGFloat vx = ux * x;
        for (int y = 0; y < rowCount; y++) {
            CGFloat vy = uy * y;
            index = (x * rowCount + y) * 4;
            vertices[index + 0].position = GLKVector3Make(self.originX + vx * rect.size.width, self.originY + vy * rect.size.height, 0);
            vertices[index + 0].texCoords = GLKVector2Make(vx, 1 - vy);
            
            vertices[index + 1].position = GLKVector3Make(self.originX + (vx + ux) * rect.size.width, self.originY + vy * rect.size.height, 0);
            vertices[index + 1].texCoords = GLKVector2Make(vx + ux, 1 - vy);
            
            vertices[index + 2].position = GLKVector3Make(self.originX + vx * rect.size.width, self.originY + (vy + uy) * rect.size.height, 0);
            vertices[index + 2].texCoords = GLKVector2Make(vx, 1 - (vy + uy));
            
            vertices[index + 3].position = GLKVector3Make(self.originX + (vx + ux) * rect.size.width, self.originY + (vy + uy) * rect.size.height, 0);
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


- (void) generateRowMajoredVerticesForSplitTextureForView:(UIView *)view columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount rotateTexture:(BOOL)rotateTexture
{
    CGRect rect = view.bounds;
    if (rotateTexture) {
        rect = view.frame;
    }
    NSInteger index = 0;
    CGFloat ux = 1.f / columnCount;
    CGFloat uy = 1.f / rowCount;
    for (int y = 0; y < rowCount; y++) {
        CGFloat vy = uy * y;
        for (int x = 0; x < columnCount; x++) {
            CGFloat vx = ux * x;
            index = (y * columnCount + x) * 4;
            vertices[index + 0].position = GLKVector3Make(self.originX + vx * rect.size.width, self.originY + vy * rect.size.height, 0);
            vertices[index + 0].texCoords = GLKVector2Make(vx, 1 - vy);
            
            vertices[index + 1].position = GLKVector3Make(self.originX + (vx + ux) * rect.size.width, self.originY + vy * rect.size.height, 0);
            vertices[index + 1].texCoords = GLKVector2Make(vx + ux, 1 - vy);
            
            vertices[index + 2].position = GLKVector3Make(self.originX + vx * rect.size.width, self.originY + (vy + uy) * rect.size.height, 0);
            vertices[index + 2].texCoords = GLKVector2Make(vx, 1 - (vy + uy));
            
            vertices[index + 3].position = GLKVector3Make(self.originX + (vx + ux) * rect.size.width, self.originY + (vy + uy) * rect.size.height, 0);
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
