//
//  KOBattleScene.m
//  Knockout
//
//  Created by Carlos Paelinck on 6/12/13.
//  Copyright (c) 2013 Carlos Paelinck. All rights reserved.
//

#import "KOBattleScene.h"

@implementation KOBattleScene


-(id)initWithSize:(CGSize)aSize {
    if (self = [super initWithSize:aSize]) {
        self.backgroundColor = [SKColor colorWithWhite:0.2 alpha:1.0];
        self.physicsWorld.gravity = CGPointZero;
        self.physicsWorld.contactDelegate = self;
        [self createPlayerCharacter:nil];
        [self createOpponents:nil];
    }
    
    return self;
}

-(void)createPlayerCharacter:(id)sender {
    SKTexture *playerTexture = [SKTexture textureWithImageNamed:@"PlayerSprite"];
    SKColor *playerColor = [SKColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0];
    CGSize playerSize = CGSizeMake(32.0, 32.0);
    
    self.playerNode = [[KOCharacterNode alloc] initWithTexture:playerTexture
                                                         color:playerColor
                                                          size:playerSize];
    
    NSArray *playerAttacks = @[  ];
    
    [self.playerNode setCharacterProperties:@{ kCharacterName: @"Carlos",
                                               kCharacterLevel: @13,
                                               kCharacterElement: [KOElements water],
                                               kCharacterAttacks: playerAttacks }];
    
    CGFloat centerScreen = [[UIScreen mainScreen] bounds].size.width;
    self.playerNode.position = CGPointMake(centerScreen / 2.0, 100);
    
    [self.playerNode setPhysicsBodyCategory:KONodeTypePlayer
                                  collision:KONodeTypeBarrier | KONodeTypeOpponent
                                    contact:KONodeTypeAttack];

    [self addChild:self.playerNode];
    
}

-(void)createOpponents:(id)sender {
    SKTexture *opponentTexture = [SKTexture textureWithImageNamed:@"PlayerSprite"];
    SKColor *opponentColor = [SKColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    CGSize opponentSize = CGSizeMake(32.0, 32.0);
    
    KOCharacterNode *opponentNode = [[KOCharacterNode alloc] initWithTexture:opponentTexture
                                                                       color:opponentColor
                                                                        size:opponentSize];
    
    NSArray *opponentAttacks = @[  ];
    
    [opponentNode setCharacterProperties:@{ kCharacterName: @"Opponent",
                                            kCharacterLevel: @10,
                                            kCharacterElement: [KOElements fire],
                                            kCharacterAttacks: opponentAttacks }];
    
    CGFloat centerScreen = [[UIScreen mainScreen] bounds].size.width;
    opponentNode.position = CGPointMake(centerScreen / 2.0, 180);
    
    [opponentNode setPhysicsBodyCategory:KONodeTypeOpponent
                               collision:KONodeTypeBarrier | KONodeTypePlayer
                                 contact:KONodeTypeAttack];
    
    [self addChild:opponentNode];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches count] == 1 && !self.playerNode.isMoving && !self.playerNode.isAttacking) {
        [touches enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            UITouch *touch = (UITouch *)obj;
            CGPoint location = [touch locationInNode:self];
            
            __block BOOL shouldPerformAttack = NO;
            __block KOCharacterNode *targetNode = nil;
            
            [[self nodesAtPoint:[touch locationInNode:self]]
             enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                 KOCharacterNode *node = (KOCharacterNode *)obj;
                 if (node.physicsBody.categoryBitMask & KONodeTypePlayer) {
                     targetNode = node;
                     shouldPerformAttack = YES;
                     *stop = YES;
                 }
             }];
            
            if (shouldPerformAttack)
                [self performAttackFromNode:self.playerNode
                                     toNode:targetNode];
            else
                [self.playerNode moveToPosition:location];
    
        }];
    }
}

-(void)performAttackFromNode:(KOCharacterNode *)nodeA toNode:(KOCharacterNode *)nodeB {
    KOAttackNode *attackNode = [KOAttackNode fireAttackNode];
    nodeA.isAttacking = YES;
    
    CGFloat angle = radiansToPolar(nodeA.zRotation);
    CGFloat distance = 100.0;
    CGPoint endPoint = CGPointMake(nodeA.position.x + distance * cosf(angle),
                                   nodeA.position.y + distance * sinf(angle));
    
    attackNode.physicsBody.contactTestBitMask = nodeB.physicsBody.categoryBitMask;
    attackNode.position = nodeA.position;
    attackNode.zRotation = nodeA.zRotation;
    
    SKPhysicsBody *targetPhysicsBody = [self.physicsWorld bodyAlongRayStart:nodeA.position end:endPoint];
    if (targetPhysicsBody) endPoint = targetPhysicsBody.node.position;
    
   


    [self addChild:attackNode];
    [attackNode runAction:[SKAction sequence:@[
                                               [SKAction moveTo:endPoint duration:1.25],
                                               [SKAction runBlock:^{
                                                    attackNode.emitterNode.particleBirthRate = 0;
                                                }],
                                               [SKAction waitForDuration:1.0]
                                               ]]
               completion:^{
                   [attackNode removeFromParent];
                   nodeA.isAttacking = NO;
               }];
}

-(void)didBeginContact:(SKPhysicsContact *)contact {   
    KOCharacterNode *targetNode;
    KOAttackNode *attackNode;
    
    if (contact.bodyA.contactTestBitMask < contact.bodyB.contactTestBitMask) {
        targetNode = (KOCharacterNode *)contact.bodyA.node;
        attackNode = (KOAttackNode *)contact.bodyB.node;
    } else {
        targetNode = (KOCharacterNode *)contact.bodyB.node;
        attackNode = (KOAttackNode *)contact.bodyA.node;
    }
    
    NSLog(@"targetNode: %@", targetNode);
    NSLog(@"attackNode: %@", attackNode);
}

@end
