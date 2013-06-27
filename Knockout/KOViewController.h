//
//  KOViewController.h
//  Knockout
//

//  Copyright (c) 2013 Carlos Paelinck. All rights reserved.
//

@import UIKit;
@import SpriteKit;

@interface KOViewController : UIViewController

@property (strong, nonatomic) IBOutlet SKView *sceneView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *attackSegmentedControl;
@property (strong, nonatomic) IBOutlet UIImageView *playerElementImageView;
@property (strong, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *playerHealthBar;

@end
