//
//  DHSceneMeshFactory.m
//  DHAnimation
//
//  Created by Huang Hongsen on 5/11/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHSceneMeshFactory.h"
#import "DHSplitTextureSceneMesh.h"
#import "DHConsecutiveTextureSceneMesh.h"

@implementation DHSceneMeshFactory

+ (DHSceneMesh *) sceneMeshForView:(UIView *)view columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount splitTexturesOnEachGrid:(BOOL)splitTexture columnMajored:(BOOL)columnMajored rotateTexture:(BOOL)rotateTexture
{
    return [DHSceneMeshFactory sceneMeshForView:view containerView:nil columnCount:columnCount rowCount:rowCount splitTexturesOnEachGrid:splitTexture columnMajored:columnMajored rotateTexture:rotateTexture];
}

+ (DHSceneMesh *) sceneMeshForView:(UIView *)view containerView:(UIView *)containerView columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount splitTexturesOnEachGrid:(BOOL)splitTexture columnMajored:(BOOL)columnMajored rotateTexture:(BOOL)rotateTexture
{
    DHSceneMesh *mesh;
    if (splitTexture) {
        mesh = [[DHSplitTextureSceneMesh alloc] initWithView:view containerView:containerView columnCount:columnCount rowCount:rowCount splitTexturesOnEachGrid:splitTexture columnMajored:columnMajored rotateTexture:rotateTexture];
    } else {
        mesh = [[DHConsecutiveTextureSceneMesh alloc] initWithView:view containerView:containerView columnCount:columnCount rowCount:rowCount splitTexturesOnEachGrid:splitTexture columnMajored:columnMajored rotateTexture:rotateTexture];
    }
    return mesh;
}

@end
