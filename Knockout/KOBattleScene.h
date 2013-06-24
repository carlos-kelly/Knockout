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

#define MAX_OPPONENT_NODES 5

@interface KOBattleScene : SKScene <SKPhysicsContactDelegate>

@property (nonatomic) NSInteger opponentNodesCount;
@property (nonatomic) KOCharacterNode *playerNode;
@property (nonatomic) UISegmentedControl *attackSegmentedControl;

-(void)createPlayerCharacter;
-(void)createOpponent;
-(void)performAttackFromNode:(KOCharacterNode *)characterNode;
-(void)attackSegmentedControlDidChangeSelection:(id)sender;

@end
