//
//  ConfettiSceneMesh.h
//  ShrederAnimation
//
//  Created by Huang Hongsen on 12/21/15.
//  Copyright © 2015 cn.daniel. All rights reserved.
//

#import "SceneMesh.h"

@interface DHShredderConfettiSceneMesh : SceneMesh
- (instancetype) initWithScreenWidth:(size_t)screenWidth
                        screenHeight:(size_t)screenHeight
                      numberOfPieces:(NSInteger)numberOfPieces
                               index:(NSInteger)index;
- (GLuint) vertexArrayObject;
- (void) updateWithPercentage:(CGFloat)percentage timeInterval:(NSTimeInterval)timeInterval;
- (CGFloat) fallingDistance;
@end
