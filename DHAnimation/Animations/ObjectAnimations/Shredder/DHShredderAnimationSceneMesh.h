//
//  DHShredderMesh.h
//  DHAnimation
//
//  Created by Huang Hongsen on 7/31/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHSceneMesh.h"

@interface DHShredderAnimationSceneMesh : DHSceneMesh

typedef struct{
    GLKVector3 position;
    GLKVector2 texCoords;
    GLfloat radius;
    GLfloat columnCenter;
    GLfloat shredderedZOffset;
}DHShredderSceneMeshAttributes;

@property (nonatomic) NSInteger numberOfColumns;

- (instancetype) initWithTargetView:(UIView *)targetView containerView:(UIView *)containerView columnCount:(NSInteger)columnCount;
@end
