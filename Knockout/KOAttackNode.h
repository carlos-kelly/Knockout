//
//  KOAttackNode.h
//  Knockout
//
//  Created by Carlos Paelinck on 6/22/13.
//  Copyright (c) 2013 Carlos Paelinck. All rights reserved.
//

@import SpriteKit;

#import "KOCharacterNode.h"

#define KOAttackNodeGrass @"grassAttackNode"
#define KOAttackNodeFire @"fireAttackNode"
#define KOAttackNodeWater @"waterAttackNode"
#define KOAttackNodeElectric @"electricAttackNode"
#define KOAttackNodeIce @"iceAttackNode"
#define KOAttackNodeGround @"groundAttackNode"
#define KOAttackNodeRock @"rockAttackNode"

#define kAttackDataName @"kAttackDataName"
#define kAttackDataElement @"kAttackDataElement"

@interface KOAttackNode : SKSpriteNode

@property (nonatomic) NSInteger basePower;
@property (nonatomic) CGFloat damage;
@property (nonatomic) NSString *name;
@property (nonatomic) KOElement *element;
@property (nonatomic) SKEmitterNode *emitterNode;

+(instancetype)grassAttackNode;
+(instancetype)fireAttackNode;
+(instancetype)waterAttackNode;
+(instancetype)electricAttackNode;
+(instancetype)iceAttackNode;
+(instancetype)groundAttackNode;
+(instancetype)rockAttackNode;
+(instancetype)attackNodeForIdentifier:(NSString *)identifier;
+(NSArray *)attackIdentifiersForElement:(NSString *)element;
+(NSDictionary *)attackDataForIdentifier:(NSString *)identifier;
-(void)setDamageForNodeA:(KOCharacterNode *)nodeA toNodeB:(KOCharacterNode *)nodeB;
@end
