//
//  DHShimmerBackgroundMesh.h
//  Shimmer
//
//  Created by Huang Hongsen on 4/7/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHSplitTextureSceneMesh.h"
#import "DHConstants.h"
@interface DHShimmerBackgroundMesh : DHSplitTextureSceneMesh

@property (nonatomic, strong) NSArray *offsetData;

- (void) updateWithOffsetData:(NSArray *)offsetData event:(DHAnimationEvent)event;
@end
