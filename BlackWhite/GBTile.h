//
//  GBTitle.h
//  BlackWhite
//
//  Created by chentb on 2014/04/30.
//  Copyright (c) 2014年 chentb. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@protocol GBTileDelegate <NSObject>
-(void)onClick:(id)sender;
-(void)startFlash:(id)sender;
-(void)doneFlash:(id)sender;
-(void)moveBackDone:(id)sender;
@end
@interface GBTile : SKSpriteNode
+ (instancetype)tileWithColor:(SKColor *)color size:(CGSize)size;
@property(nonatomic)SKSpriteNode* contentSprite;
@property(nonatomic,weak) id<GBTileDelegate> delegate;
@property(nonatomic) int rowNo;
-(void)setText:(NSString*)text;
- (void)move:(NSMutableArray*)tileArray;
- (void)moveBack:(id)sender;
- (void)flash;
- (BOOL)isBlack;
- (BOOL)isWhite;

-(void)changeColor;
@end
