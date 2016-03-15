//
//  ShredderPaperBackPieceSceneMesh.m
//  ShrederAnimation
//
//  Created by Huang Hongsen on 12/21/15.
//  Copyright © 2015 cn.daniel. All rights reserved.
//

#import "ShredderPaperBackPieceSceneMesh.h"

@implementation ShredderPaperBackPieceSceneMesh

- (CGFloat) generateRadiusForScreenHeight:(CGFloat)screenHeight
{
    CGFloat amplitude = screenHeight / 0.4;
    CGFloat shredderCurlRadius = screenHeight / 0.3;
    int min = -50;
    int max = 50;
    int randomNumber = min + rand() % (max-min);
    double factor = (double) randomNumber / (max - min);
    return shredderCurlRadius + factor * amplitude;
}

@end
