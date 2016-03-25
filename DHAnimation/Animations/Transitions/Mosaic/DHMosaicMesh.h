//
//  DHMosaicMesh.h
//  DHAnimation
//
//  Created by Huang Hongsen on 3/20/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "SceneMesh.h"

@interface DHMosaicMesh : SceneMesh

- (void) updateWithIndicesItemsStartedRotation:(NSArray *)items incrementedRotation:(CGFloat)increment;

@end
