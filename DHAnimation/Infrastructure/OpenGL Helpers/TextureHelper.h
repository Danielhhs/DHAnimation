//
//  TextureHelper.h
//  CubeAnimation
//
//  Created by Huang Hongsen on 3/3/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface TextureHelper : NSObject

+ (GLuint) setupTextureWithView:(UIView *)view;

+ (GLuint) setupTextureWithView:(UIView *)view inRect:(CGRect)rect;

+ (GLuint) setupTextureWithImage:(UIImage *)image;

+ (GLuint) setupTextureWithImage:(UIImage *)image inRect:(CGRect)rect;

@end
