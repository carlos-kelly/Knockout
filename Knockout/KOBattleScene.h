//
//  KOBattleScene.h
//  Knockout
//
//  Created by Carlos Paelinck on 6/12/13.
//  Copyright (c) 2013 Carlos Paelinck. All rights reserved.
//

@import SpriteKit;

#import "KOCharacterNode.h"
#import "KOAttackNode.h"

#define MAX_OPPONENT_NODES 3

@interface KOBattleScene : SKScene <SKPhysicsContactDelegate>

@property (nonatomic) NSMutableArray *opponentNodes;
@property (nonatomic) NSMutableArray *layers;
@property (nonatomic) KOCharacterNode *playerNode;
@property (nonatomic) KOGameMapRef gameMapRef;
@property (nonatomic) SKNode *worldNode;
@property (weak, nonatomic) UISegmentedControl *attackSegmentedControl;
@property (weak, nonatomic) UIImageView *playerElementImageView;
@property (weak, nonatomic) UILabel *playerNameLabel;
@property (weak, nonatomic) UIProgressView *playerHealthBar;

-(void)createPlayerCharacter;
-(void)createOpponentAtPosition:(CGPoint)position;
-(void)createOpponents;
-(void)createGameMap;

-(void)centerOnNode:(SKNode *)node;
-(void)addNode:(SKNode *)node toLayer:(KOWorldLayer)worldLayer;

-(BOOL)playerNodeWithinRangeOfOpponentNode:(KOCharacterNode *)opponentNode;
-(NSString *)preferredAttackIdentifierFromNode:(KOCharacterNode *)nodeA toNode:(KOCharacterNode *)nodeB;
-(void)performAttack:(KOAttackNode *)attackNode fromNode:(KOCharacterNode *)characterNode afterDelay:(NSTimeInterval)delay;

-(void)attackSegmentedControlDidChangeSelection:(id)sender;

@end
