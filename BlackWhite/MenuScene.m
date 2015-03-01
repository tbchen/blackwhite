//
//  MyScene.m
//  BlackWhite
//
//  Created by chentb on 2014/04/30.
//  Copyright (c) 2014年 chentb. All rights reserved.
//

#import "MenuScene.h"
#import "GameKitHelper.h"

@implementation MenuScene{
    GBButton* _classicButton;
    GBButton* _arcadeButton;
    GBButton* _zenButton;
    GBButton* _rushButton;
    GBButton* _shareButton;
    GBButton* _leaderboardButton;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        CGSize buttonSize = CGSizeMake(size.width/2, size.height/3);
        //Classic
        _classicButton =[GBButton buttonWithColor:[UIColor whiteColor] size:buttonSize text:kModeNameClassic];
        _classicButton.position = CGPointMake(size.width/4, size.height/6*5);
        _classicButton.delegate = self;
        [self addChild:_classicButton];
        //Arcade
        _arcadeButton =[GBButton buttonWithColor:[UIColor blackColor] size:buttonSize text:kModeNameArcade];
        _arcadeButton.position = CGPointMake(size.width/4*3, size.height/6*5);
        _arcadeButton.delegate = self;
        [self addChild:_arcadeButton];
        //Zen
        _zenButton =[GBButton buttonWithColor:[UIColor blackColor] size:buttonSize text:kModeNameZen];
        _zenButton.position = CGPointMake(size.width/4, size.height/6*3);
        _zenButton.delegate = self;
        [self addChild:_zenButton];
        //Rush
        _rushButton =[GBButton buttonWithColor:[UIColor whiteColor] size:buttonSize text:kModeNameRush];
        _rushButton.position = CGPointMake(size.width/4*3, size.height/6*3);
        _rushButton.delegate = self;
        [self addChild:_rushButton];
        //Share
        _shareButton =[GBButton buttonWithColor:[UIColor whiteColor] size:buttonSize text:@"Tell a friend"];
        _shareButton.position = CGPointMake(size.width/4, size.height/6);
        _shareButton.delegate = self;
      //  [_shareButton setTextPosition:CGPointMake(0, 20)];
        [_shareButton setFontSize:21];
        [self addChild:_shareButton];
        //More
        _leaderboardButton =[GBButton buttonWithColor:[UIColor blackColor] size:buttonSize text:@"Leaderboard"];
        _leaderboardButton.position = CGPointMake(size.width/4*3, size.height/6);
        _leaderboardButton.delegate = self;
      //  [_leaderboardButton setTextPosition:CGPointMake(0, 20)];
        [_leaderboardButton setFontSize:21];
        [self addChild:_leaderboardButton];
    }
    return self;
}

-(void)onClick:(id)sender{
    if (sender == _classicButton) {
        gPlayMode =PlayModeClassic;
        [self moveToPlayScene];
    }else if(sender == _arcadeButton){
        gPlayMode =PlayModeArcade;
        [self moveToPlayScene2];
    }else if(sender == _zenButton){
        gPlayMode =PlayModeZen;
        [self moveToPlayScene];
    }else if(sender == _rushButton){
        gPlayMode=PlayModeRush;
        [self moveToPlayScene2];
    }else if(sender == _shareButton){
        [self.delegate gotoShare:self];
    }else if(sender == _leaderboardButton){
        [self.delegate gotoGameCenter:self];
    }
}

-(void)moveToPlayScene{
    PlayScene *playScene = [[PlayScene alloc]initWithSize:self.size];
    SKTransition *t = [SKTransition doorsOpenHorizontalWithDuration:0.3];
    [self.view presentScene:playScene transition:t];
}

-(void)moveToPlayScene2{
    PlayScene2 *playScene = [[PlayScene2 alloc]initWithSize:self.size];
    SKTransition *t = [SKTransition doorsOpenHorizontalWithDuration:0.3];
    [self.view presentScene:playScene transition:t];
}

-(void)willMoveFromView:(SKView *)view{
    ViewController* v = gViewController;
}

@end
