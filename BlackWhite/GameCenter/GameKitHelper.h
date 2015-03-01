//
//  GameKitHelper.h
//  CircuitRacer
//
//  Created by Main Account on 9/23/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

//@import GameKit;
#import <GameKit/GameKit.h>

extern NSString *const PresentAuthenticationViewController;

@interface GameKitHelper : NSObject

@property (nonatomic, readonly)
UIViewController *authenticationViewController;
@property (nonatomic, readonly) NSError *lastError;

+ (instancetype)sharedGameKitHelper;
- (void)authenticateLocalPlayer;
- (void)reportAchievements:(NSArray *)achievements;
- (void)showGKGameCenterViewController:
(UIViewController *)viewController;
- (void)reportScore:(int)score
   forLeaderboardID:(NSString*)leaderboardID;
-(int)getBestScore:(NSString*)leaderboardID;
@end
