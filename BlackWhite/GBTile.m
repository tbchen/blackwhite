//
//  GBTitle.m
//  BlackWhite
//
//  Created by chentb on 2014/04/30.
//  Copyright (c) 2014年 chentb. All rights reserved.
//

#import "GBTile.h"

@implementation GBTile{
    SKLabelNode* _textLabel;
    //SKAction* _action;
}
- (instancetype)initWithColor:(SKColor *)color size:(CGSize)size{
    self = [super initWithColor:[UIColor blackColor] size:size];
    if (self) {
        //add content
        CGSize contentSize = CGSizeMake(size.width-1, size.height-1);
        _contentSprite = [SKSpriteNode spriteNodeWithColor:color size:contentSize];
        _contentSprite.position = CGPointMake(0.5 , 0.5);
        [self addChild:_contentSprite];
        
        //debug
        //_textLabel = [SKLabelNode labelNodeWithFontNamed:kFontName];
        //_textLabel.text = color == [SKColor whiteColor] ? @"白" : @"黒";
        //_textLabel.fontColor =  color == [SKColor whiteColor] ? [SKColor blackColor]:[SKColor whiteColor];
        //[self addChild:_textLabel];
        [self setUserInteractionEnabled:YES];
        
        //action
        //_action = [SKAction moveByX:0 y:-self.size.height duration:0.5];
    }
    return self;
}
-(void)setText:(NSString*)text{
    _textLabel = [SKLabelNode labelNodeWithFontNamed:kFontName];
    _textLabel.text = text;
    _textLabel.fontSize = 20;
    [self addChild:_textLabel];
}

+ (instancetype)tileWithColor:(SKColor *)color size:(CGSize)size{
    GBTile* tile = [[GBTile alloc]initWithColor:color size:size];
    return tile;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.delegate onClick:self];
    
    if (_textLabel) {
        [_textLabel removeFromParent];
    }
}

- (void)move:(NSMutableArray*)tileArray{
    SKAction *action = [SKAction moveByX:0 y:-self.size.height duration:0.1];
    [self runAction:action];
    self.rowNo --;
    if (self.rowNo == 0 && [self isBlack]) {
        _contentSprite.color = kGrayTileColor;
        //        _content
        SKAction *s1 = [SKAction scaleBy:0.5 duration:0];
        SKAction *s2 = [SKAction scaleTo:1 duration:0.2];
        [_contentSprite runAction:[SKAction sequence:@[s1,s2]]];
    }
    if (self.rowNo < -1) {
        [tileArray removeObject:self];
        [self removeFromParent];
    }

}

- (void)moveBack:(id)sender{
    GBTile* senderTile = sender;
    SKAction *action = [SKAction moveByX:0 y:self.size.height*0.8 duration:0.3];
    SKAction *actionflash = [SKAction repeatAction:
                               [SKAction sequence:@[
                                                    [SKAction colorizeWithColor:kGrayTileColor colorBlendFactor:1.0 duration:0.15],
                                                    [SKAction colorizeWithColor:kWhitleTileColor colorBlendFactor:1.0 duration:0.15],
                                                    ]
                                ] count:3];
    [self runAction: action completion:^{
        [senderTile.contentSprite runAction:actionflash completion:^{
            if (sender == self) {
                [self.delegate moveBackDone:self];
            }
        }];
        
    }];
}

-(void)changeColor{
    _contentSprite.color = kGrayTileColor;
    //        _content
    SKAction *s1 = [SKAction scaleBy:0.5 duration:0];
    SKAction *s2 = [SKAction scaleTo:1 duration:0.2];
    [_contentSprite runAction:[SKAction sequence:@[s1,s2]]];
}

-(void)flash{
    [self.delegate startFlash:self];
    [_contentSprite runAction:[SKAction repeatAction:
        [SKAction sequence:@[
            [SKAction colorizeWithColor:[SKColor redColor] colorBlendFactor:1.0 duration:0.15],
            [SKAction colorizeWithColor:[SKColor whiteColor] colorBlendFactor:1.0 duration:0.15],
        ]
    ] count:3] completion:^{
        [self.delegate doneFlash:self];
    }];
}

- (BOOL)isBlack{
    return [_contentSprite.color isEqual:kBlackTileColor];
}

- (BOOL)isWhite{
    return [_contentSprite.color isEqual: kWhitleTileColor];
}

@end
