//
//  KOAttacks.m
//  Knockout
//
//  Created by Carlos Paelinck on 6/13/13.
//  Copyright (c) 2013 Carlos Paelinck. All rights reserved.
//

#import "KOAttack.h"

@implementation KOAttack

+(KOAttack *)flamethrower {
    KOAttack *attack = [[KOAttack alloc] init];
    attack.emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"FlamethrowerParticle" ofType:@"sks"]];
    attack.properties = @{kAttackName: @"Flamethrower", kAttackElement: @"Fire", kAttackPower: @75};
    
    return attack;
}

@end
