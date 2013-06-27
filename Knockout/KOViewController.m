//
//  KOViewController.m
//  Knockout
//
//  Created by Carlos Paelinck on 6/12/13.
//  Copyright (c) 2013 Carlos Paelinck. All rights reserved.
//

#import "KOViewController.h"
//#import "KOMyScene.h
#import "KOBattleScene.h"

@implementation KOViewController

-(void)viewDidLoad {
    [super viewDidLoad];

    // Configure the view.
    SKView *skView = (SKView *)self.sceneView;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    
    // Create and configure the scene.
    KOBattleScene *scene = [KOBattleScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.attackSegmentedControl = self.attackSegmentedControl;
    scene.playerNameLabel = self.playerNameLabel;
    scene.playerHealthBar = self.playerHealthBar;
    scene.playerElementImageView = self.playerElementImageView;
    
    // Present the scene.
    [skView presentScene:scene];
}

-(BOOL)shouldAutorotate {
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
