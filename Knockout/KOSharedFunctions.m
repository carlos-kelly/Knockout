//
//  KOMathFunctions.m
//  Knockout
//
//  Created by Carlos Paelinck on 6/13/13.
//  Copyright (c) 2013 Carlos Paelinck. All rights reserved.
//

#import "KOSharedFunctions.h"

@implementation KOSharedFunctions

CGFloat distanceBetweenPoints(CGPoint firstPoint, CGPoint secondPoint) {
    return hypotf(secondPoint.x - firstPoint.x, secondPoint.y - firstPoint.y);
}

CGFloat radiansBetweenPoints(CGPoint firstPoint, CGPoint secondPoint) {
    return atan2f(secondPoint.y - firstPoint.y, secondPoint.x - firstPoint.x);
}

CGFloat radiansToPolar(CGFloat radians) {
    return radians + M_PI_2;
}

CGFloat statForLevel(NSInteger baseStat, NSInteger level) {
    return ((((31.0 + (2.0 * (CGFloat)baseStat) + (252.0 / 4.0) + 100.0) * (CGFloat)level) / 100.0) + 5.0);
}

CGFloat hitPointsForLevel(NSInteger baseStat, NSInteger level) {
    return ((((31.0 + (2.0 * (CGFloat)baseStat) + (252.0 / 4.0) + 100.0) * (CGFloat)level) / 100.0) + 10.0);
}

void runAttackEmitter(SKEmitterNode *node, NSTimeInterval duration) {
    [node runAction:[SKAction sequence:@[[SKAction waitForDuration:duration],
                                         [SKAction runBlock:^{
                                            node.particleBirthRate = 0;
                                            }],
                                         [SKAction waitForDuration:node.particleLifetime + node.particleLifetimeRange],
                                         [SKAction removeFromParent]
                                         ]]];
}

@end
