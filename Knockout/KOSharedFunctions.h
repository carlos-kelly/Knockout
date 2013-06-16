//
//  KOMathFunctions.h
//  Knockout
//
//  Created by Carlos Paelinck on 6/13/13.
//  Copyright (c) 2013 Carlos Paelinck. All rights reserved.
//

@import UIKit;
@import SpriteKit;

@interface KOSharedFunctions : NSObject

typedef enum : uint8_t {
    KONodeTypePlayer = 0x1 << 0,
    KONodeTypeOpponent = 0x1 << 1,
    KONodeTypeBarrier = 0x1 << 2,
    KONodeTypeAttack = 0x1 << 3
    
} KONodeType;

CGFloat distanceBetweenPoints(CGPoint firstPoint, CGPoint secondPoint);
CGFloat radiansBetweenPoints(CGPoint firstPoint, CGPoint secondPoint);
CGFloat radiansToPolar(CGFloat radians);
CGFloat statForLevel(NSInteger baseStat, NSInteger level);
CGFloat hitPointsForLevel(NSInteger baseStat, NSInteger level);

void runAttackEmitter(SKEmitterNode *node, NSTimeInterval duration);

@end
