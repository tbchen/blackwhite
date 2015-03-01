//
//  GBButton.h
//  BlackWhite
//
//  Created by chentb on 2014/04/30.
//  Copyright (c) 2014年 chentb. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
//typedef void (^OnClick)(void);
@protocol GBButtonDelegate <NSObject>
-(void)onClick:(id)sender;
@end
@interface GBButton : SKSpriteNode
@property(nonatomic,weak) id<GBButtonDelegate> delegate;
+ (instancetype)buttonWithColor:(SKColor *)color size:(CGSize)size text:(NSString*)text;
-(void)setFontSize:(CGFloat)size;
-(void)setTextPosition:(CGPoint)position;
@end
