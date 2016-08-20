//
//  DHFoldSceneMesh.h
//  DHAnimation
//
//  Created by Huang Hongsen on 8/10/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <DHAnimationFramework/DHAnimationFramework.h>

@interface DHFoldSceneMesh : DHSplitTextureSceneMesh

- (instancetype) initWithView:(UIView *)view containerView:(UIView *)containerView headerHeight:(GLfloat)headerHeight animationDirection:(DHAnimationDirection)direction columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount columnMajored:(BOOL)columnMajored;

@end
