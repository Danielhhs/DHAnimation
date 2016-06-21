//
//  TextureHelper.h
//  CubeAnimation
//
//  Created by Huang Hongsen on 3/3/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <GLKit/GLKit.h>

#define NUMBER_OF_GLYPHS_PER_LINE 10

@interface TextureHelper : NSObject

+ (GLuint) setupTextureWithView:(UIView *)view;

+ (GLuint) setupTextureWithView:(UIView *)view rotate:(BOOL)rotate;

+ (GLuint) setupTextureWithView:(UIView *)view flipHorizontal:(BOOL)flipHorizontal;

+ (GLuint) setupTextureWithView:(UIView *)view flipHorizontal:(BOOL)flipHorizontal flipVertical:(BOOL)flipVertical;

+ (GLuint) setupTextureWithView:(UIView *)view inRect:(CGRect)rect;

+ (GLuint) setupTextureWithView:(UIView *)view inRect:(CGRect)rect flipHorizontal:(BOOL)flipHorizontal;

+ (GLuint) setupTextureWithView:(UIView *)view inRect:(CGRect)rect flipHorizontal:(BOOL)flipHorizontal flipVertical:(BOOL)flipVertical;

+ (GLuint) setupTextureWithView:(UIView *)view inRect:(CGRect)rect flipHorizontal:(BOOL)flipHorizontal flipVertical:(BOOL)flipVertical rotate:(BOOL)rotate;

+ (GLuint) setupTextureWithImage:(UIImage *)image;

+ (GLuint) setupTextureWithImage:(UIImage *)image flipHorizontal:(BOOL) flipHorizontal;

+ (GLuint) setupTextureWithImage:(UIImage *)image flipHorizontal:(BOOL) flipHorizontal flipVertical:(BOOL) flipVertical;

+ (GLuint) setupTextureWithImage:(UIImage *)image inRect:(CGRect)rect;

+ (GLuint) setupTextureWithImage:(UIImage *)image inRect:(CGRect)rect flipHorizontal:(BOOL) flipHorizontal;

+ (GLuint) setupTextureWithImage:(UIImage *)image inRect:(CGRect)rect flipHorizontal:(BOOL) flipHorizontal flipVertical:(BOOL)flipVertical;

+ (GLuint) setupTextureWithAttributedString:(NSAttributedString *)attrString;

@end
