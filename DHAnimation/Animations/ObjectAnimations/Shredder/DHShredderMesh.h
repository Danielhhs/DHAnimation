//
//  ShredderMesh.h
//  ShrederAnimation
//
//  Created by Huang Hongsen on 12/21/15.
//  Copyright © 2015 cn.daniel. All rights reserved.
//

#import "DHSceneMesh.h"
#define SHREDDER_HEIGHT 300
@interface DHShredderMesh : DHSceneMesh
- (instancetype) initWithView:(UIView *)targetView containerView:(UIView *)containerView shredderHeight:(GLfloat)height;
- (GLuint) vertexArrayObejct;
- (GLfloat) shredderHeight;
@end
