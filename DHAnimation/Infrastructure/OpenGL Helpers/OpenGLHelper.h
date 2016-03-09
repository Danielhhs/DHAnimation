//
//  ProgramLoader.h
//  StartAgain
//
//  Created by Huang Hongsen on 5/11/15.
//  Copyright (c) 2015 com.microstrategy. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface OpenGLHelper : NSObject

+ (GLuint) loadProgramWithVertexShaderSrc:(NSString *)vertexShaderSrc
                        fragmentShaderSrc:(NSString *)fragmentShaderSrc;
+ (GLuint) setupTextureWithView:(UIView *)view
                   textureWidth:(size_t)textureWidth
                  textureHeight:(size_t)textureHeight
                    screenScale:(CGFloat)screenScale;   //Flip Vertical is YES

+ (GLuint) setupTextureWithView:(UIView *)view
                   textureWidth:(size_t)textureWidth
                  textureHeight:(size_t)textureHeight
                    screenScale:(CGFloat)screenScale
                   flipVertical:(BOOL)flipVertical;

+ (GLuint) setupTextureWithImage:(UIImage *)image
                    textureWidth:(size_t)textureWidth
                   textureHeight:(size_t)textureHeight
                     screenScale:(CGFloat)screenScale;

+ (UIImage *) highResolutionSnapshotForView:(UIView *)view;
@end
