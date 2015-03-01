//
//  MyScene.h
//  BlackWhite
//

//  Copyright (c) 2014年 chentb. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GBButton.h"
#import "PlayScene.h"
#import "PlayScene2.h"

@class ViewController;
@protocol MenuSceneDelegate <NSObject>
-(void)gotoGameCenter:(id)sender;
-(void)gotoShare:(id)sender;
@end
@interface MenuScene : SKScene<GBButtonDelegate>
@property(nonatomic,strong) id<MenuSceneDelegate> delegate;
//@property(nonatomic,weak)ViewController* viewController;
@end
