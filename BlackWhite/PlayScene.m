//
//  PlayScene.m
//  BlackWhite
//
//  Created by chentb on 2014/04/30.
//  Copyright (c) 2014年 chentb. All rights reserved.
//

#import "PlayScene.h"
#import "GameOverScene.h"
#import "GameKitHelper.h"
@implementation PlayScene{
    NSMutableArray *_tileArray;
    SKLabelNode *_scoreLabel;
    CFTimeInterval _startTime;
    CFTimeInterval _playedTime;
    int _tileCount;
    int _zenTileCount;
    BOOL _isWon;
    BOOL _isStart;
}
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        _tileArray = [NSMutableArray array];
        self.backgroundColor = kGreenColor;
        //init tiles
        for (int i=0; i<5; i++) {
            int blackTileIndex = arc4random() % 4;
            for (int j=0; j<4; j++) {
                //yellow tile
                UIColor *tileColor;
                //BOOL canDelete = NO;
                if (i==0) {
                    tileColor = kYellowTileColor;
                //normal tile
                }else{
                    if (j== blackTileIndex) {
                        tileColor =kBlackTileColor;
                    }else{
                        tileColor = kWhitleTileColor;
                    }
                }
                GBTile* tile = [GBTile tileWithColor: tileColor size:CGSizeMake(self.size.width/4, self.size.height/4)];
                tile.position = CGPointMake(self.size.width/4 * j + self.size.width/8, self.size.height/4 * i + self.size.height/8);
                tile.delegate=self;
                tile.rowNo = i;
                if (i==1 && j==blackTileIndex) {
                    [tile setText:@"Start"];
                }
                [_tileArray addObject:tile];
                [self addChild:tile];
            }
        }
        
        //add score label
        _scoreLabel = [SKLabelNode labelNodeWithFontNamed:kFontName];
        if (gPlayMode == PlayModeClassic) {
            _scoreLabel.text = @"0.000\"";
        }else{
            _scoreLabel.text = [NSString stringWithFormat:@"%d.000\"", kZenTimeSeconds ];
        }
        
        _scoreLabel.fontColor = [UIColor redColor];
        _scoreLabel.zPosition = 100;
        _scoreLabel.position = CGPointMake(self.size.width/2, self.size.height - 30);
        [self addChild:_scoreLabel];
        
        //
        _startTime = -1;
        
        //
        _tileCount = kClassicTileNumber;
        
        //
        _isWon=NO;
        
        //
        _isStart = NO;

    }
    return self;
}

-(void)onClick:(id)sender{
    GBTile* tile = sender;
    if (tile.rowNo == 1 && [tile isBlack]) {
        [Utils playRightSound:self];
        //NSLog(@"yes!!!");
        _isStart = YES;
        _tileCount--;
        _zenTileCount++;
        if (gPlayMode == PlayModeClassic && _tileCount<=0) {
            [self won];
        }
        [_tileArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            GBTile* t = obj;
            [t move:_tileArray];
        }];
        //add new tiles
        int blackTileIndex = arc4random() % 4;
        UIColor *tileColor;
        BOOL canDelete = NO;
        if (gPlayMode == PlayModeClassic && _tileCount<=3) {
            return;
        }
        for (int i=0; i<4; i++) {
            if (i== blackTileIndex) {
                tileColor =kBlackTileColor;
                canDelete = YES;
            }else{
                tileColor = kWhitleTileColor;
            }
            GBTile* tile = [GBTile tileWithColor: tileColor size:CGSizeMake(self.size.width/4, self.size.height/4)];
            tile.position = CGPointMake(self.size.width/4 * i + self.size.width/8, self.size.height/4 * 4 + self.size.height/8);
            tile.delegate=self;
            tile.rowNo = 4;
            //tile.canDelete = canDelete;
            [_tileArray addObject:tile];
            [self addChild:tile];
        }
    }else if(tile.rowNo == 1 && [tile isWhite]){
        [tile flash];
        [Utils playWrongSound:self];
        _isStart=NO;
    }
}

-(void)won{
    //report score to game center
    if (gPlayMode == PlayModeClassic) {
        NSLog(@"%d",(int)(_playedTime * 1000));
        [[GameKitHelper sharedGameKitHelper]reportScore:(int)(_playedTime*1000) forLeaderboardID:kLeaderboardIdClassic];
        //report score to local
        gScoreText = _scoreLabel.text;
    }else if(gPlayMode == PlayModeZen){
        [[GameKitHelper sharedGameKitHelper]reportScore:_zenTileCount forLeaderboardID:kLeaderboardIdZen];
        //report score to local
        gScoreText = [NSString stringWithFormat:@"%d",_zenTileCount];
    }
    //game over
    GameOverScene *gameOverScene = [[GameOverScene alloc]initWithSize:self.size];
    gameOverScene.isWon = YES;
    //gameOverScene.viewController=self.viewController;
//    SKTransition *t = [SKTransition doorsCloseHorizontalWithDuration:0.3];
    SKTransition *reveal = [SKTransition moveInWithDirection:SKTransitionDirectionUp duration:0.2];
    [self.view presentScene:gameOverScene transition:reveal];
}

-(void)startFlash:(id)sender{
    [_tileArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        GBTile* tile = obj;
        [tile setUserInteractionEnabled:NO];
    }];
}

-(void)doneFlash:(id)sender{
    //game over
    GameOverScene *gameOverScene = [[GameOverScene alloc]initWithSize:self.size];
    gameOverScene.isWon = NO;
    SKTransition *t = [SKTransition doorsCloseHorizontalWithDuration:0.3];
    [self.view presentScene:gameOverScene transition:t];
}

-(void)update:(CFTimeInterval)currentTime {
    if (!_isStart) {
        return;
    }

    if(gPlayMode == PlayModeZen && _playedTime >= kZenTimeSeconds){
        [self won];
        _isWon = YES;
        _isStart=NO;
        NSLog(@"zen won ......");
    }
    /* Called before each frame is rendered */
    if (_startTime == -1) {
        _startTime = currentTime;
    }
    _playedTime = currentTime - _startTime;
    if (gPlayMode==PlayModeClassic) {
        _scoreLabel.text = [NSString stringWithFormat:@"%.3f\"", ((int)(_playedTime*1000))/1000.0];
    }else if(gPlayMode == PlayModeZen){
        _scoreLabel.text = [NSString stringWithFormat:@"%.3f\"", kZenTimeSeconds - _playedTime];
    }
}


@end
