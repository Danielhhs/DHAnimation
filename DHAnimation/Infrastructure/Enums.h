//
//  Enums.h
//  DHAnimation
//
//  Created by Huang Hongsen on 3/8/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AnimationType) {
    AnimationTypeDoorWay = 0,
    AnimationTypeCube = 1,
    AnimationTypeTwist = 2,
    AnimationTypeClothLine = 3,
};

typedef NS_ENUM(NSInteger, AnimationDirection) {
    AnimationDirectionLeftToRight = 0,
    AnimationDirectionRightToLeft = 1,
    AnimationDirectionTopToBottom = 2,
    AnimationDirectionBottomToTop = 3,
};

@interface Enums : NSObject

@end
