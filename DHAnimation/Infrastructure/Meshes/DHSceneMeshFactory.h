//
//  DHSceneMeshFactory.h
//  DHAnimation
//
//  Created by Huang Hongsen on 5/11/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHSceneMesh.h"
@interface DHSceneMeshFactory : NSObject

+ (DHSceneMesh *)sceneMeshForView:(UIView *)view columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount splitTexturesOnEachGrid:(BOOL)splitTexture columnMajored:(BOOL)columnMajored rotateTexture:(BOOL)rotateTexture;
+ (DHSceneMesh *)sceneMeshForView:(UIView *)view containerView:(UIView *)containerView columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount splitTexturesOnEachGrid:(BOOL)splitTexture columnMajored:(BOOL)columnMajored rotateTexture:(BOOL)rotateTexture;

@end
