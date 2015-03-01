//
//  GameOverScene.m
//  BlackWhite
//
//  Created by chentb on 2014/05/01.
//  Copyright (c) 2014年 chentb. All rights reserved.
//

#import "GameOverScene.h"
#import "GBButton.h"
#import "MenuScene.h"
#import "PlayScene.h"
#import "PlayScene2.h"
#import "GameKitHelper.h"

@implementation GameOverScene{
    SKLabelNode* _modeName;
    SKLabelNode* _result;
    SKLabelNode* _bestScore;
    GBLabel* _shareButton;
    GBLabel* _exitButton;
    GBLabel* _againButton;
}
-(instancetype)initWithSize:(CGSize)size{
    self = [super initWithSize:size];
    if (self) {
        //title
        SKLabelNode* appName = [SKLabelNode labelNodeWithFontNamed:kFontName];
        appName.text = @"Don't Tap The White Tile 1";
        appName.fontSize = 20;
        appName.position = CGPointMake(self.size.width/2,self.size.height - 30);
        [self addChild:appName];

        //mode name
        _modeName = [SKLabelNode labelNodeWithFontNamed:kFontName];
        _modeName.text = @"Classic Mode";
        _modeName.fontSize = 30;
        _modeName.position = CGPointMake(self.size.width/2,self.size.height/4 * 3.2);
        [self addChild:_modeName];
        
        //result(failed) or score(won)
        _result = [SKLabelNode labelNodeWithFontNamed:kFontName];
        _result.text = @"Failed!";
        _result.fontSize = 50;
        _result.position = CGPointMake(self.size.width/2,self.size.height/2);
        [self addChild:_result];
       
        //best score
        _bestScore = [SKLabelNode labelNodeWithFontNamed:kFontName];
        _bestScore.text = @"BEST 0000\"";
        _bestScore.fontSize = 30;
        _bestScore.position = CGPointMake(self.size.width/2,self.size.height/2 * 0.9);
        [self addChild:_bestScore];
        
        //facebook share button
        float buttonSize = 25;
        float buttonPosition;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            buttonPosition = 150;
        }else{
            buttonPosition = 90;
        }
            
        _shareButton = [GBLabel labelNodeWithFontNamed:kFontName];
        _shareButton.text = @"Share";
        _shareButton.fontSize = buttonSize;
        //        _shareButton.fontColor = [UIColor blackColor];
        _shareButton.position = CGPointMake(self.size.width/6,buttonPosition);
        _shareButton.delegate = self;
        [self addChild:_shareButton];
        
        //exit
        _exitButton = [GBLabel labelNodeWithFontNamed:kFontName];
        _exitButton.text = @"Exit";
        _exitButton.fontSize = buttonSize;
//        _bestScore.fontColor = [UIColor blackColor];
        _exitButton.position = CGPointMake(self.size.width/2,buttonPosition);
        _exitButton.delegate = self;
        [self addChild:_exitButton];
        
        //again
        _againButton = [GBLabel labelNodeWithFontNamed:kFontName];
        _againButton.text = @"Again";
        _againButton.fontSize = buttonSize;
//        _bestScore.fontColor = [UIColor blackColor];
        _againButton.position = CGPointMake(self.size.width/6*5,buttonPosition);
        _againButton.delegate = self;
        [self addChild:_againButton];
        
    }
    return self;
}

-(void)onClick:(id)sender{
    if (sender == _shareButton) {
        //facebook todo
        //    SKScene* scene = sender;
        NSString *initalTextString =
        @"I am playing the Awesome game! Beat Black -> http://itunes.apple.com/app/id" kAppAppleId;
        UIImage* i = [Utils imageFromNode:self];
       // UIImage* i = [UIImage imageNamed:@"icon_share.jpg"];
        UIActivityViewController *avc = [[UIActivityViewController alloc]initWithActivityItems:@[i,initalTextString] applicationActivities:nil];
        [gViewController presentViewController:avc
                           animated:YES completion:nil];
    }else if(sender == _exitButton){
        MenuScene *menuScene = [[MenuScene alloc]initWithSize:self.size];
       // menuScene.viewController=self.viewController;
        menuScene.delegate = gViewController;
        SKTransition *t = [SKTransition doorsCloseHorizontalWithDuration:0.3];
        [self.view presentScene:menuScene transition:t];
    }else if (sender == _againButton){
        if (gPlayMode == PlayModeClassic || gPlayMode == PlayModeZen) {
            PlayScene *scene = [[PlayScene alloc]initWithSize:self.size];
            SKTransition *t = [SKTransition doorsOpenHorizontalWithDuration:0.3];
            [self.view presentScene:scene transition:t];
        }else{
            PlayScene2 *scene = [[PlayScene2 alloc]initWithSize:self.size];
            SKTransition *t = [SKTransition doorsOpenHorizontalWithDuration:0.3];
            [self.view presentScene:scene transition:t];
        }

    }
}

-(void)setIsWon:(BOOL)isWon{
    _isWon = isWon;
    if (gPlayMode == PlayModeClassic) {
        _bestScore.text = [NSString stringWithFormat:@"Best %.3f\"", [[GameKitHelper sharedGameKitHelper]getBestScore:kLeaderboardIdClassic]/1000.0];
        _modeName.text = kModeNameClassic @" Mode";
        if (isWon) {
            self.backgroundColor=kGreenColor;
            // _result.text = gScoreText;
            _result.fontSize = 50;
            _result.text = gScoreText;
        }else{
            self.backgroundColor=kRedColor;
        }
    }else if(gPlayMode == PlayModeZen){
        _bestScore.text = [NSString stringWithFormat:@"Best %d", [[GameKitHelper sharedGameKitHelper]getBestScore:kLeaderboardIdZen]];
        _modeName.text = kModeNameZen @" Mode";
        if (isWon) {
            self.backgroundColor=kGreenColor;
            // _result.text = gScoreText;
            _result.fontSize = 50;
            _result.text = gScoreText;
        }else{
            self.backgroundColor=kRedColor;
        }
    }else {
        if (gPlayMode == PlayModeArcade) {
            _bestScore.text = [NSString stringWithFormat:@"Best %d", [[GameKitHelper sharedGameKitHelper]getBestScore:kLeaderboardIdArcade]];
            
            _modeName.text = kModeNameArcade @" Mode";
        }else{
        _bestScore.text = [NSString stringWithFormat:@"Best %.3f/s", [[GameKitHelper sharedGameKitHelper]getBestScore:kLeaderboardIdRush]/1000.0];
            
            _modeName.text = kModeNameRush @" Mode";
        }

        if (isWon) {
            self.backgroundColor=kZiseColor;
            // _result.text = gScoreText;
            _result.fontSize = 50;
            
            _result.text = gScoreText;

        }else{
            self.backgroundColor=kRedColor;
            _result.fontSize = 50;
           
            _result.text = gScoreText;
        }
    }
}
@end
