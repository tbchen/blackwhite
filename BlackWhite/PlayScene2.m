//
//  PlayScene.m
//  BlackWhite
//
//  Created by chentb on 2014/04/30.
//  Copyright (c) 2014年 chentb. All rights reserved.
//

#import "PlayScene2.h"
#import "GameOverScene.h"
#import "GameKitHelper.h"
@implementation PlayScene2{
    NSMutableArray *_tileArray;
    SKLabelNode *_scoreLabel;
    CFTimeInterval _startTime;
    CFTimeInterval _playedTime;
    CFTimeInterval _preTime;
    int _tileCount;
    int _arcadeTileCount;
    BOOL _isWon;
    BOOL _isStart;
    float _speed;
}
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        _tileArray = [NSMutableArray array];
        //
        //      _currentFirstTileArray = [NSMutableArray array];
        self.backgroundColor = [UIColor greenColor];
        //init tiles
        for (int i=0; i<6; i++) {
            int blackTileIndex = arc4random() % 4;
            for (int j=0; j<4; j++) {
                //yellow tile
                UIColor *tileColor;
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
                //                if (i==1) {
                //                    [_currentFirstTileArray addObject:tile];
                //                }
                [self addChild:tile];
            }
        }
        
        //add score label
        _scoreLabel = [SKLabelNode labelNodeWithFontNamed:kFontName];
        if (gPlayMode == PlayModeArcade) {
            _scoreLabel.text = @"0";
        }else{
            _scoreLabel.text = @"0.000/s";
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
        _preTime=-1;
        
        //
        _isStart = NO;
        
        _arcadeTileCount=0;
        
        
        _speed = kRushInitSpeed;
        
        
    }
    return self;
}

-(void)onClick:(id)sender{
    GBTile* tile = sender;
    if (tile.rowNo == 1 && [tile isBlack]) {
        [tile changeColor];
        [Utils playRightSound:self];
        _isStart =YES;
        _arcadeTileCount++;
        [self changeNo];
    }else if(tile.rowNo == 1 && [tile isWhite]){
        _isWon=NO;
        _isStart = NO;
        [tile flash];
        [Utils playWrongSound:self];
    }
}

-(void)changeNo{
    for (int i=0; i < _tileArray.count; i++) {
        GBTile* tile = _tileArray[i];
        if (tile.rowNo == 1) {
            [self changeTileRowNumber:tile rowNo:0];
            [self changeTileRowNumber:_tileArray[i+1] rowNo:0];
            [self changeTileRowNumber:_tileArray[i+2] rowNo:0];
            [self changeTileRowNumber:_tileArray[i+3] rowNo:0];
            
            [self changeTileRowNumber:_tileArray[i+4] rowNo:1];
            [self changeTileRowNumber:_tileArray[i+5] rowNo:1];
            [self changeTileRowNumber:_tileArray[i+6] rowNo:1];
            [self changeTileRowNumber:_tileArray[i+7] rowNo:1];
            return;
        }
    }
}

-(void)changeTileRowNumber:(id)tile rowNo:(int)rowNo{
    GBTile* gbTile = tile;
    gbTile.rowNo = rowNo;
}

-(void)won{
    //report score
    
    
    //report score to game center
    if (gPlayMode == PlayModeArcade) {
        [[GameKitHelper sharedGameKitHelper]reportScore:_arcadeTileCount forLeaderboardID:kLeaderboardIdArcade];
        gScoreText = [NSString stringWithFormat:@"%d", _arcadeTileCount];
    }else{
        [[GameKitHelper sharedGameKitHelper]reportScore:(int)(_speed * 1000) forLeaderboardID:kLeaderboardIdRush];
        gScoreText = [NSString stringWithFormat:@"%.3f/s", ((int)(_speed * 1000))/1000.0];
    }
    //game over
    //game over
    GameOverScene *gameOverScene = [[GameOverScene alloc]initWithSize:self.size];
    gameOverScene.isWon = _isWon;
    // gameOverScene.viewController=self.viewController;
    SKTransition *t = [SKTransition doorsCloseHorizontalWithDuration:0.3];
    [_tileArray removeAllObjects];
    //_tileArray = nil;
    [self.view presentScene:gameOverScene transition:t];
}

-(void)startFlash:(id)sender{
    [_tileArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        GBTile* tile = obj;
        [tile setUserInteractionEnabled:NO];
    }];
}

-(void)doneFlash:(id)sender{
    //game over
    [self moveBackDone:sender];
}

-(void)lost:(id)sender{
    [_tileArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        GBTile* tile = obj;
        [tile moveBack:sender];
        [tile setUserInteractionEnabled:NO];
    }];
    
}

-(void)moveBackDone:(id)sender{
    [self won];
}

-(void)update:(CFTimeInterval)currentTime {
    if(!_isStart){
        return;
    }
    
    
    
    if (_preTime != -1) {
        if (gPlayMode == PlayModeRush) {
            _speed += 0.1 * (currentTime - _preTime);
        }
        
        //move tiles
        BOOL __block isRemoved = NO;
        // float __block y;
        [_tileArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            GBTile* tile = obj;
            tile.position = CGPointMake(tile.position.x, tile.position.y - (currentTime - _preTime) * tile.size.height*_speed);
            if (tile.position.y < -tile.size.height) {
                //remove old
                [_tileArray removeObject:tile];
                [tile removeFromParent];
                isRemoved = YES;
                //       y = tile.position.y;
                
            }
            
            
        }];
        
        /* Called before each frame is rendered */
        if (_startTime == -1) {
            _startTime = currentTime;
        }
        _playedTime = currentTime - _startTime;
        if (gPlayMode==PlayModeArcade) {
            _scoreLabel.text = [NSString stringWithFormat:@"%d", _arcadeTileCount];
        }else if(gPlayMode == PlayModeRush){
            _scoreLabel.text = [NSString stringWithFormat:@"%.3f/s", ((int)(_speed * 1000))/1000.0];
        }
        
        //        [_tileArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //            GBTile* tile = obj;
        //            if ([tile isBlack] && tile.position.y < -tile.size.height/2) {
        //                _isWon = YES;
        //                _isStart=NO;
        //                [self lost:tile];
        //                self.paused = YES;
        //                *stop = YES;
        //            }
        //        }];
        
        for (int i=0; i<_tileArray.count; i++) {
            GBTile* tile = _tileArray[i];
            if ([tile isBlack] && tile.position.y < -tile.size.height/2) {
                _isWon = YES;
                _isStart=NO;
                [self lost:tile];
                //   self.paused = YES;
                [Utils playWrongSound:self];
                return;
            }
        }
        
        GBTile* lastTile = [_tileArray lastObject];
        if (isRemoved) {
            //add new tiles
            int blackTileIndex = arc4random() % 4;
            UIColor *tileColor;
            for (int i=0; i<4; i++) {
                if (i== blackTileIndex) {
                    tileColor =kBlackTileColor;
                }else{
                    tileColor = kWhitleTileColor;
                }
                GBTile* tile = [GBTile tileWithColor: tileColor size:CGSizeMake(self.size.width/4, self.size.height/4)];
                tile.position = CGPointMake(self.size.width/4 * i + self.size.width/8, lastTile.position.y + lastTile.size.height);
                tile.delegate=self;
                tile.rowNo = 4;
                //tile.canDelete = canDelete;
                [_tileArray addObject:tile];
                [self addChild:tile];
            }        }
        
    }
    
    
    //    if(self.playMode == PlayModeZen && _playedTime >= kZenTimeSeconds){
    //        [self won];
    //        _isWon = YES;
    //        NSLog(@"zen won ......");
    //    }
    
    _preTime = currentTime;
}


@end
