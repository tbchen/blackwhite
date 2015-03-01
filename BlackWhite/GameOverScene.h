//
//  GameOverScene.h
//  BlackWhite
//
//  Created by chentb on 2014/05/01.
//  Copyright (c) 2014年 chentb. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GBLabel.h"
@class ViewController;
@interface GameOverScene : SKScene<GBLabelDelegate>
@property(nonatomic)BOOL isWon;
//@property(nonatomic,weak)ViewController* viewController;
@end
