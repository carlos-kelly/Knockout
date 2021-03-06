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
    return @{ kElementName: @"Fire",
              kElementTintColor: [UIColor colorWithRed:1.0 green:0.208 blue:0.0 alpha:1.0],
              kElementDamageMultiplier: @{ @"Fire" : @0.5, @"Water": @2.0, @"Grass": @0.5, @"Electric": @1.0, @"Ground": @2.0, @"Ice": @0.5, @"Rock" : @2.0} };
}

+(KOElement *)water {
    return @{ kElementName: @"Water",
              kElementTintColor: [SKColor colorWithRed:0.4 green:0.8 blue:1.0 alpha:1.0],
              kElementDamageMultiplier: @{ @"Fire" : @0.5, @"Water": @0.5, @"Grass": @2.0, @"Electric": @2.0, @"Ground": @1.0, @"Ice": @0.5, @"Rock" : @1.0} };
}

+(KOElement *)grass {
    return @{ kElementName: @"Grass",
              kElementTintColor: [SKColor colorWithRed:0.0 green:0.89 blue:0.0 alpha:1.0],
              kElementDamageMultiplier: @{ @"Fire" : @2.0, @"Water": @0.5, @"Grass": @0.5, @"Electric": @0.5, @"Ground": @0.5, @"Ice": @2.0, @"Rock" : @1.0} };
}

+(KOElement *)electric {
    return @{ kElementName: @"Electric",
              kElementTintColor: [SKColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:1.0],
              kElementDamageMultiplier: @{ @"Fire" : @1.0, @"Water": @1.0, @"Grass": @1.0, @"Electric": @0.5, @"Ground": @2.0, @"Ice": @1.0, @"Rock" : @1.0} };
}

+(KOElement *)ice {
    return @{ kElementName: @"Ice",
              kElementTintColor: [SKColor colorWithRed:0.724 green:0.955 blue:1.0 alpha:1.0],
              kElementDamageMultiplier: @{ @"Fire" : @2.0, @"Water": @1.0, @"Grass": @1.0, @"Electric": @1.0, @"Ground": @1.0, @"Ice": @0.5, @"Rock" : @2.0} };
}

+(KOElement *)ground {
    return @{ kElementName: @"Ground",
              kElementTintColor: [SKColor colorWithRed:0.684 green:0.535 blue:0.394 alpha:1.0],
              kElementDamageMultiplier: @{ @"Fire" : @1.0, @"Water": @2.0, @"Grass": @2.0, @"Electric": @0.0, @"Ground": @1.0, @"Ice": @2.0, @"Rock" : @0.5} };
}

+(KOElement *)rock {
    return @{ kElementName: @"Rock",
              kElementTintColor: [SKColor colorWithRed:0.492 green:0.347 blue:0.255 alpha:1.0],
              kElementDamageMultiplier: @{ @"Fire" : @0.5, @"Water": @2.0, @"Grass": @2.0, @"Electric": @1.0, @"Ground": @2.0, @"Ice": @2.0, @"Rock" : @1.0} };
}


@end
