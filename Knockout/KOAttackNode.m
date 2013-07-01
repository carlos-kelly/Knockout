//
//  KOAttackNode.m
//  Knockout
//
//  Created by Carlos Paelinck on 6/22/13.
//  Copyright (c) 2013 Carlos Paelinck. All rights reserved.
//

#import "KOAttackNode.h"

@implementation KOAttackNode

+(instancetype)attackNodeForIdentifier:(NSString *)identifier {
    if ([identifier isEqualToString:KOAttackNodeGrass])
        return [KOAttackNode grassAttackNode];
    
    else if ([identifier isEqualToString:KOAttackNodeFire])
        return [KOAttackNode fireAttackNode];
    
    else if ([identifier isEqualToString:KOAttackNodeWater])
        return [KOAttackNode waterAttackNode];
    
    else if ([identifier isEqualToString:KOAttackNodeElectric])
        return [KOAttackNode electricAttackNode];
    
    else if ([identifier isEqualToString:KOAttackNodeIce])
        return [KOAttackNode iceAttackNode];
    
    else if ([identifier isEqualToString:KOAttackNodeGround])
        return [KOAttackNode groundAttackNode];
    
    else return nil;
}

+(NSDictionary *)attackDataForIdentifier:(NSString *)identifier {
    if ([identifier isEqualToString:KOAttackNodeGrass])
        return @{ kAttackDataName: @"Energy Ball",
                  kAttackDataElement: [KOElements grass] };
    
    else if ([identifier isEqualToString:KOAttackNodeFire])
        return @{ kAttackDataName: @"Flame Burst",
                  kAttackDataElement: [KOElements fire] };
    
    else if ([identifier isEqualToString:KOAttackNodeWater])
        return @{ kAttackDataName: @"Water Pulse",
                  kAttackDataElement: [KOElements water] };
    
    else if ([identifier isEqualToString:KOAttackNodeElectric])
        return @{ kAttackDataName: @"Shock Wave",
                  kAttackDataElement: [KOElements electric] };
    
    else if ([identifier isEqualToString:KOAttackNodeIce])
        return @{ kAttackDataName: @"Icy Wind",
                  kAttackDataElement: [KOElements ice] };
    
    else if ([identifier isEqualToString:KOAttackNodeGround])
        return @{ kAttackDataName: @"Mud Bomb",
                  kAttackDataElement: [KOElements ground] };
    
    else return nil;
}

+(NSArray *)attackIdentifiersForElement:(NSString *)element {
    if ([element isEqualToString:[KOElements fire][kElementName]])
        return @[ KOAttackNodeFire, KOAttackNodeElectric, KOAttackNodeGrass ];
    
    else if ([element isEqualToString:[KOElements grass][kElementName]])
        return @[ KOAttackNodeGrass, KOAttackNodeGround, KOAttackNodeFire ];
    
    else if ([element isEqualToString:[KOElements water][kElementName]])
        return @[ KOAttackNodeWater, KOAttackNodeIce, KOAttackNodeGround ];
    
    else if ([element isEqualToString:[KOElements ice][kElementName]])
        return @[ KOAttackNodeIce, KOAttackNodeElectric, KOAttackNodeWater ];
    
    else if ([element isEqualToString:[KOElements electric][kElementName]])
        return @[ KOAttackNodeElectric, KOAttackNodeIce, KOAttackNodeFire ];
    
    else if ([element isEqualToString:[KOElements ground][kElementName]])
        return @[ KOAttackNodeGround, KOAttackNodeGrass, KOAttackNodeFire ];
                 
    return nil;
}

+(instancetype)grassAttackNode {
    KOAttackNode *attackNode = [KOAttackNode node];
    SKEmitterNode *emitterNode = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"GrassAttackParticle" ofType:@"sks"]];
    NSDictionary *attackData = [KOAttackNode attackDataForIdentifier:KOAttackNodeGrass];
    
    attackNode.size = CGSizeMake(16.0, 16.0);
    attackNode.colorBlendFactor = 1.0;
    attackNode.blendMode = SKBlendModeAlpha;
    attackNode.basePower = 70;
    attackNode.damage = 0.0;
    attackNode.name = attackData[kAttackDataName];
    attackNode.element = attackData[kAttackDataElement];
    attackNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:attackNode.size.width / 2.0];
    attackNode.physicsBody.categoryBitMask = KONodeTypeAttack;
    attackNode.physicsBody.collisionBitMask = KONodeTypeBarrier;
    attackNode.physicsBody.contactTestBitMask = KONodeTypeBarrier;
    attackNode.emitterNode = emitterNode;
    
    [attackNode addChild:emitterNode];
    
    return attackNode;
}

+(instancetype)fireAttackNode {
    KOAttackNode *attackNode = [KOAttackNode node];
    SKEmitterNode *emitterNode = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"FireAttackParticle" ofType:@"sks"]];
    NSDictionary *attackData = [KOAttackNode attackDataForIdentifier:KOAttackNodeFire];
    
    attackNode.size = CGSizeMake(16.0, 16.0);
    attackNode.colorBlendFactor = 1.0;
    attackNode.blendMode = SKBlendModeAlpha;
    attackNode.basePower = 70;
    attackNode.damage = 0.0;
    attackNode.name = attackData[kAttackDataName];
    attackNode.element = attackData[kAttackDataElement];
    attackNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:attackNode.size.width / 2.0];
    attackNode.physicsBody.categoryBitMask = KONodeTypeAttack;
    attackNode.physicsBody.collisionBitMask = KONodeTypeBarrier;
    attackNode.emitterNode = emitterNode;
    
    [attackNode addChild:emitterNode];
    
    return attackNode;
}

+(instancetype)waterAttackNode {
    KOAttackNode *attackNode = [KOAttackNode node];
    SKEmitterNode *emitterNode = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"WaterAttackParticle" ofType:@"sks"]];
    NSDictionary *attackData = [KOAttackNode attackDataForIdentifier:KOAttackNodeWater];
    
    attackNode.size = CGSizeMake(16.0, 16.0);
    attackNode.colorBlendFactor = 1.0;
    attackNode.blendMode = SKBlendModeAlpha;
    attackNode.basePower = 70;
    attackNode.damage = 0.0;
    attackNode.name = attackData[kAttackDataName];
    attackNode.element = attackData[kAttackDataElement];
    attackNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:attackNode.size.width / 2.0];
    attackNode.physicsBody.categoryBitMask = KONodeTypeAttack;
    attackNode.physicsBody.collisionBitMask = KONodeTypeBarrier;
    attackNode.emitterNode = emitterNode;
    
    [attackNode addChild:emitterNode];
    
    return attackNode;
}

+(instancetype)electricAttackNode {
    KOAttackNode *attackNode = [KOAttackNode node];
    SKEmitterNode *emitterNode = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"ElectricAttackParticle" ofType:@"sks"]];
    NSDictionary *attackData = [KOAttackNode attackDataForIdentifier:KOAttackNodeElectric];
    
    attackNode.size = CGSizeMake(16.0, 16.0);
    attackNode.colorBlendFactor = 1.0;
    attackNode.blendMode = SKBlendModeAlpha;
    attackNode.basePower = 70;
    attackNode.damage = 0.0;
    attackNode.name = attackData[kAttackDataName];
    attackNode.element = attackData[kAttackDataElement];
    attackNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:attackNode.size.width / 2.0];
    attackNode.physicsBody.categoryBitMask = KONodeTypeAttack;
    attackNode.physicsBody.collisionBitMask = KONodeTypeBarrier;
    attackNode.emitterNode = emitterNode;
    
    [attackNode addChild:emitterNode];
    
    return attackNode;
}

+(instancetype)iceAttackNode {
    KOAttackNode *attackNode = [KOAttackNode node];
    SKEmitterNode *emitterNode = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"IceAttackParticle" ofType:@"sks"]];
    NSDictionary *attackData = [KOAttackNode attackDataForIdentifier:KOAttackNodeIce];
    
    attackNode.size = CGSizeMake(16.0, 16.0);
    attackNode.colorBlendFactor = 1.0;
    attackNode.blendMode = SKBlendModeAlpha;
    attackNode.basePower = 70;
    attackNode.damage = 0.0;
    attackNode.name = attackData[kAttackDataName];
    attackNode.element = attackData[kAttackDataElement];
    attackNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:attackNode.size.width / 2.0];
    attackNode.physicsBody.categoryBitMask = KONodeTypeAttack;
    attackNode.physicsBody.collisionBitMask = KONodeTypeBarrier;
    attackNode.emitterNode = emitterNode;
    
    [attackNode addChild:emitterNode];
    
    return attackNode;
}

+(instancetype)groundAttackNode {
    KOAttackNode *attackNode = [KOAttackNode node];
    SKEmitterNode *emitterNode = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"GroundAttackParticle" ofType:@"sks"]];
    NSDictionary *attackData = [KOAttackNode attackDataForIdentifier:KOAttackNodeGround];
    
    attackNode.size = CGSizeMake(16.0, 16.0);
    attackNode.colorBlendFactor = 1.0;
    attackNode.blendMode = SKBlendModeAlpha;
    attackNode.basePower = 70;
    attackNode.damage = 0.0;
    attackNode.name = attackData[kAttackDataName];
    attackNode.element = attackData[kAttackDataElement];
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

-(void)setDamageForNodeA:(KOCharacterNode *)nodeA toNodeB:(KOCharacterNode *)nodeB {
    CGFloat attackStat = KOStatForLevel(kBaseStatDefault, nodeA.level);
    CGFloat defenseStat = KOStatForLevel(kBaseStatDefault, nodeB.level);
    CGFloat randomValue = ((arc4random() % 33) + 217);
    CGFloat STAB = [self.element[kElementName] isEqualToString:nodeA.element[kElementName]] ? 1.5 : 1.0;
    CGFloat elementEffectiveness = [nodeB.element[kElementDamageMultiplier][self.element[kElementName]] floatValue];
        
    self.damage = ((((((((nodeA.level * 2 / 5) + 2) * self.basePower * attackStat / 50) / defenseStat) + 2) *
                     randomValue / 100) * STAB * elementEffectiveness) / 1.5);
}

@end
