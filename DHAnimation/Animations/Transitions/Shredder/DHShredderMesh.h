//
//  ShredderMesh.h
//  ShrederAnimation
//
//  Created by Huang Hongsen on 12/21/15.
//  Copyright © 2015 cn.daniel. All rights reserved.
//

#import "SceneMesh.h"
#define SHREDDER_HEIGHT 300
@interface DHShredderMesh : SceneMesh
- (instancetype) initWithScreenWidth:(size_t)screenWidth screenHeight:(size_t)screenHeight;
- (GLuint) vertexArrayObejct;
@end
