//
//  GameKitHelper.m
//  CircuitRacer
//
//  Created by Main Account on 9/23/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import "GameKitHelper.h"

NSString *const PresentAuthenticationViewController =
@"present_authentication_view_controller";
NSString *const bestKey = @"best";
@interface GameKitHelper()<GKGameCenterControllerDelegate>
@end

@implementation GameKitHelper {
    BOOL _enableGameCenter;
}

+ (instancetype)sharedGameKitHelper
{
    static GameKitHelper *sharedGameKitHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGameKitHelper = [[GameKitHelper alloc] init];
    });
    return sharedGameKitHelper;
}

- (id)init
{
    self = [super init];
    if (self) {
        _enableGameCenter = YES;
    }
    return self;
}

- (void)authenticateLocalPlayer
{
    //1
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    //2
    localPlayer.authenticateHandler  =
    ^(UIViewController *viewController, NSError *error) {
        //3
        [self setLastError:error];
        
        if(viewController != nil) {
            //4
            [self setAuthenticationViewController:viewController];
        } else if([GKLocalPlayer localPlayer].isAuthenticated) {
            //5
            _enableGameCenter = YES;
        } else {
            //6
            _enableGameCenter = NO;
        }
    };
}

- (void)setAuthenticationViewController:
(UIViewController *)authenticationViewController
{
    if (authenticationViewController != nil) {
        _authenticationViewController = authenticationViewController;
        [[NSNotificationCenter defaultCenter]
         postNotificationName:PresentAuthenticationViewController
         object:self];
    }
}

- (void)setLastError:(NSError *)error
{
    _lastError = [error copy];
    if (_lastError) {
        NSLog(@"GameKitHelper ERROR: %@",
              [[_lastError userInfo] description]);
    }
}

- (void)reportAchievements:(NSArray *)achievements
{
    if (!_enableGameCenter) {
        NSLog(@"Local play is not authenticated");
    }
    [GKAchievement reportAchievements:achievements
                withCompletionHandler:^(NSError *error ){
                    [self setLastError:error];
                }];
}

- (void)showGKGameCenterViewController:
(UIViewController *)viewController
{
    if (!_enableGameCenter) {
        NSLog(@"Local play is not authenticated");
    }
    //1
    GKGameCenterViewController *gameCenterViewController =
    [[GKGameCenterViewController alloc] init];
    
    //2
    gameCenterViewController.gameCenterDelegate = self;
    
    //3
    gameCenterViewController.viewState =
    GKGameCenterViewControllerStateDefault;
    
    //4
    [viewController presentViewController:gameCenterViewController
                                 animated:YES
                               completion:nil];
}

- (void)gameCenterViewControllerDidFinish:
(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES
                                                 completion:nil];
}

- (void)reportScore:(int)score
   forLeaderboardID:(NSString *)leaderboardID
{
    // Report score to game center
    if (!_enableGameCenter) {
        NSLog(@"Local play is not authenticated");
    }
//    //1
    GKScore *scoreReporter =
    [[GKScore alloc]
     initWithLeaderboardIdentifier:leaderboardID];
    scoreReporter.value = score;
    scoreReporter.context = 0;
    
    NSArray *scores = @[scoreReporter];
    
    //2
    [GKScore reportScores:scores
    withCompletionHandler:^(NSError *error) {
        [self setLastError:error];
    }];

    // Save score to local
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int best = [defaults integerForKey:leaderboardID];
    
    if ([kLeaderboardIdClassic isEqual:leaderboardID]) {//small to big
        if (best == 0 || best > score) {
            [defaults setInteger:score forKey:leaderboardID];
            BOOL successful = [defaults synchronize];
            if (successful) {
                // NSLog(@"%@", @"データの保存に成功しました。");
            }
        }
    }else{
        if (best < score) {//big to small
            [defaults setInteger:score forKey:leaderboardID];
            BOOL successful = [defaults synchronize];
            if (successful) {
                // NSLog(@"%@", @"データの保存に成功しました。");
            }
        }
    }
    
}

- (int)getBestScore:(NSString*)leaderboardID{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int best = [defaults integerForKey:leaderboardID];
    return best;
}
@end
