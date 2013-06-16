//
//  KOElements.m
//  Knockout
//
//  Created by Carlos Paelinck on 6/13/13.
//  Copyright (c) 2013 Carlos Paelinck. All rights reserved.
//

#import "KOElements.h"

@implementation KOElements

+(KOElement *)fire {
    return @{kElementName: @"Fire",
              kDamageMultiplier: @{ @"Fire" : @0.5, @"Water": @2.0, @"Grass": @0.5, @"Electric": @1.0, @"Ground": @2.0, @"Ice": @0.5, @"Normal": @1.0}};
}

+(KOElement *)water {
    return @{kElementName: @"Water", kDamageMultiplier: @{ @"Fire" : @0.5, @"Water": @0.5, @"Grass": @2.0, @"Electric": @2.0, @"Ground": @1.0, @"Ice": @0.5, @"Normal": @1.0}};
}

+(KOElement *)grass {
    return @{kElementName: @"Grass", kDamageMultiplier: @{ @"Fire" : @2.0, @"Water": @0.5, @"Grass": @0.5, @"Electric": @0.5, @"Ground": @0.5, @"Ice": @2.0, @"Normal": @1.0}};
}

+(KOElement *)normal {
    return @{kElementName: @"Normal", kDamageMultiplier: @{ @"Fire" : @1.5, @"Water": @1.5, @"Grass": @1.5, @"Electric": @01.0, @"Ground": @1.0, @"Ice": @1.0, @"Normal": @1.0}};
}


@end
