//
//  KOAttackNode.m
//  Knockout
//
//  Created by Carlos Paelinck on 6/22/13.
//  Copyright (c) 2013 Carlos Paelinck. All rights reserved.
//

#import "KOAttackNode.h"

@implementation KOAttackNode

+(instancetype)fireAttackNode {
    KOAttackNode *attackNode = [KOAttackNode node];
    SKEmitterNode *emitterNode = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"FlamethrowerParticle" ofType:@"sks"]];
    
    attackNode.size = CGSizeMake(16.0, 16.0);
    attackNode.colorBlendFactor = 1.0;
    attackNode.blendMode = SKBlendModeAlpha;
    attackNode.power = 70;
    attackNode.name = @"Flame Burst";
    attackNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:attackNode.size.width / 2.0];
    attackNode.physicsBody.categoryBitMask = KONodeTypeAttack;
    attackNode.physicsBody.collisionBitMask = KONodeTypeBarrier;
    attackNode.emitterNode = emitterNode;
    
    [attackNode addChild:emitterNode];
    
    return attackNode;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"%@", self.name];
}

@end
