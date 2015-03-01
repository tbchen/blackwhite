//
//  Constants.h
//  BlackWhite
//
//  Created by chentb on 2014/05/01.
//  Copyright (c) 2014年 chentb. All rights reserved.
//
#ifndef BlackWhite_Constants_h
#define BlackWhite_Constants_h

#import "ViewController.h"
#define kWhitleTileColor [UIColor colorWithRed:1 green:1 blue:1 alpha:1]
#define kBlackTileColor [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1]
#define kYellowTileColor [UIColor colorWithRed:253.0/255.0 green:174/255.0 blue:39/255.0 alpha:1]
#define kGrayTileColor [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1]
#define kRedColor [UIColor colorWithRed:251.0/255.0 green:42/255.0 blue:53/255.0 alpha:1]
#define kGreenColor [UIColor colorWithRed:137.0/255.0 green:197/255.0 blue:6/255.0 alpha:1]
#define kZiseColor [UIColor colorWithRed:152.0/255.0 green:75/255.0 blue:193/255.0 alpha:1]

#define kFontName @"Copperplate-Bold"
#define kClassicTileNumber 50 //50
#define kZenTimeSeconds 30 //30
#define kRushInitSpeed 3
#define kRushStepSpeed 0.01

#define kLeaderboardIdClassic @""
#define kLeaderboardIdZen @""
#define kLeaderboardIdArcade @""
#define kLeaderboardIdRush @""

#define kModeNameClassic @"Classic"
#define kModeNameZen @"Zen"
#define kModeNameArcade @"Arcade"
#define kModeNameRush @"Rush"

#define kRightSound @"right.wav"
#define kWrongSound @"wrong.wav"

#define kAppAppleId @""// apple id

#define kAppName @"Beat Black";

typedef NS_ENUM(NSInteger, PlayMode) {
    PlayModeClassic,
    PlayModeArcade,
    PlayModeZen,
    PlayModeRush
};

//global var
//skView 's controller
ViewController* gViewController;
//playmode
PlayMode gPlayMode;
//score
NSString* gScoreText;
#endif
