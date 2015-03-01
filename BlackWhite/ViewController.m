//
//  ViewController.m
//  BlackWhite
//
//  Created by chentb on 2014/04/30.
//  Copyright (c) 2014年 chentb. All rights reserved.
//

#import "ViewController.h"
#import "GameOverScene.h"
#import "GameKitHelper.h"

@implementation ViewController{
    SKView* skView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//}
//
//- (void)viewWillLayoutSubviews
//{
//    [super viewWillLayoutSubviews];
//    
    // Configure the view.
      skView = (SKView *)self.view;
   // skView.frame = CGRectMake(0,0, skView.frame.size.width, skView.frame.size.height - 50);
    //if (!skView.scene) {
        gViewController = self;
        //skView.showsFPS = YES;
        //skView.showsNodeCount = YES;
    //}
    //game center
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showAuthenticationViewController) name:PresentAuthenticationViewController object:nil];
    [[GameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
    
    // Create and configure the scene.
    MenuScene * scene = [MenuScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.delegate = self;
    // scene.viewController = self;
    //        GameOverScene *scene = [[GameOverScene alloc]initWithSize:skView.frame.size];
    //        scene.isWon = NO;
    
    // Present the scene.
    [skView presentScene:scene];
}

-(void)gotoGameCenter:(id)sender{
    [[GameKitHelper sharedGameKitHelper]
     showGKGameCenterViewController:self];

}

-(void)gotoShare:(id)sender{
//    SKScene* scene = sender;
    NSString *initalTextString = @"I found an Awesome game! Beat Black -> http://itunes.apple.com/app/id" kAppAppleId;
//    UIImage* i = [Utils imageFromNode:scene];
    UIImage* i = [UIImage imageNamed:@"icon_share.png"];
    UIActivityViewController *avc = [[UIActivityViewController alloc]initWithActivityItems:@[i,initalTextString] applicationActivities:nil];
    [self presentViewController:avc
                                  animated:YES completion:nil];
}

- (void)showAuthenticationViewController {
    GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];
    [self presentViewController: gameKitHelper.authenticationViewController
                       animated:YES completion:nil];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}
@end
