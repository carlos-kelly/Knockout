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
        self.opponentNodesCount = 0;
    }
    
    return self;
}

-(void)createPlayerCharacter {
    SKTexture *playerTexture = [SKTexture textureWithImageNamed:@"PlayerSprite"];
    KOElement *playerElement = [KOElements water];
    CGSize playerSize = CGSizeMake(32.0, 32.0);
    
    self.playerNode = [[KOCharacterNode alloc] initWithTexture:playerTexture
                                                         color:playerElement[kElementTintColor]
                                                          size:playerSize];
    
    NSArray *playerAttacks = @[
                               KOAttackNodeWater,
                               KOAttackNodeFire,
                               KOAttackNodeGrass,
                               KOAttackNodeElectric
                               ];
    
    self.attackSegmentedControl.tintColor = [KOAttackNode attackDataForIdentifier:playerAttacks[0]][kAttackDataElement][kElementTintColor];
        
    [self.playerNode setCharacterProperties:@{ kCharacterName: @"Carlos",
                                               kCharacterLevel: @10,
                                               kCharacterElement: playerElement,
                                               kCharacterAttacks: playerAttacks }];
        
    self.playerNode.position = CGPointMake(CGRectGetMidX(self.frame), 48);
    
    [self.playerNode setPhysicsBodyCategory:KONodeTypePlayer
                                  collision:KONodeTypeBarrier | KONodeTypeOpponent
                                    contact:KONodeTypeAttack];

    [self addChild:self.playerNode];
    
}

-(void)update:(NSTimeInterval)currentTime {
    if (self.opponentNodesCount < MAX_OPPONENT_NODES)
        [self createOpponent];
}

-(void)createOpponent {
    SKTexture *opponentTexture = [SKTexture textureWithImageNamed:@"PlayerSprite"];
    KOElement *opponentElement = [KOElements normal];
    CGSize opponentSize = CGSizeMake(32.0, 32.0);
    CGFloat randomValue = ((arc4random() % 200) + 140);
    
    KOCharacterNode *opponentNode = [[KOCharacterNode alloc] initWithTexture:opponentTexture
                                                                       color:opponentElement[kElementTintColor]
                                                                        size:opponentSize];
    
    NSArray *opponentAttacks = @[ KOAttackNodeWater,
                                  KOAttackNodeFire,
                                  KOAttackNodeGrass,
                                  KOAttackNodeElectric ];
    
    [opponentNode setCharacterProperties:@{ kCharacterName: @"Opponent",
                                            kCharacterLevel: @10,
                                            kCharacterElement: opponentElement,
                                            kCharacterAttacks: opponentAttacks }];
    
    opponentNode.position = CGPointMake(randomValue, 128);
    
    [opponentNode setPhysicsBodyCategory:KONodeTypeOpponent
                               collision:KONodeTypeBarrier | KONodeTypePlayer | KONodeTypeOpponent
                                 contact:KONodeTypeAttack];
    
    [self addChild:opponentNode];
    
    self.opponentNodesCount++;
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
                [self performAttackFromNode:targetNode];
            else
                [self.playerNode moveToPosition:location];
    
        }];
    }
}

-(void)performAttackFromNode:(KOCharacterNode *)characterNode {
    KOAttackNode *attackNode = [KOAttackNode attackNodeForIdentifier:characterNode.attacks[self.attackSegmentedControl.selectedSegmentIndex]];
    characterNode.isAttacking = YES;
    
    CGFloat angle = radiansToPolar(characterNode.zRotation);
    CGFloat distance = 100.0;
    CGPoint endPoint = CGPointMake(characterNode.position.x + distance * cosf(angle),
                                   characterNode.position.y + distance * sinf(angle));
    
    attackNode.position = characterNode.position;
    attackNode.zRotation = characterNode.zRotation;
    
    SKPhysicsBody *targetPhysicsBody = [self.physicsWorld bodyAlongRayStart:characterNode.position end:endPoint];
    
    if (targetPhysicsBody) {
        endPoint = targetPhysicsBody.node.position;
        attackNode.physicsBody.contactTestBitMask = targetPhysicsBody.categoryBitMask;
        [attackNode setDamageForNodeA:characterNode toNodeB:(KOCharacterNode *)targetPhysicsBody.node];
    }

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
                   characterNode.isAttacking = NO;
               }];
}

-(void)attackSegmentedControlDidChangeSelection:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    segmentedControl.tintColor = [KOAttackNode attackDataForIdentifier:self.playerNode.attacks[segmentedControl.selectedSegmentIndex]][kAttackDataElement][kElementTintColor];
}

-(void)didMoveToView:(SKView *)view {
    [self createPlayerCharacter];
    [self createOpponent];    
    [self.attackSegmentedControl addTarget:self
                                    action:@selector(attackSegmentedControlDidChangeSelection:)
                          forControlEvents:UIControlEventValueChanged];
}

-(void)didBeginContact:(SKPhysicsContact *)contact {   
    KOCharacterNode *targetNode;
    KOAttackNode *attackNode;
        
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        targetNode = (KOCharacterNode *)contact.bodyA.node;
        attackNode = (KOAttackNode *)contact.bodyB.node;
    } else {
        targetNode = (KOCharacterNode *)contact.bodyB.node;
        attackNode = (KOAttackNode *)contact.bodyA.node;
    }
    
    if (targetNode.physicsBody.categoryBitMask & attackNode.physicsBody.contactTestBitMask) {
        NSLog(@"targetNode: %@", targetNode);
        NSLog(@"attackNode: %@", attackNode);
        NSLog(@"attackNode.damage: %f", attackNode.damage);
        [targetNode applyDamage:attackNode.damage];
    }
}

@end
