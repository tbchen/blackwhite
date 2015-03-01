//
//  GBButton.m
//  BlackWhite
//
//  Created by chentb on 2014/04/30.
//  Copyright (c) 2014年 chentb. All rights reserved.
//

#import "GBButton.h"

@implementation GBButton{
    SKLabelNode* _textLabel;
}
- (instancetype)initWithColor:(SKColor *)color size:(CGSize)size text:(NSString*)text{
    self = [super initWithColor:color size:size];
    if (self) {
        _textLabel = [SKLabelNode labelNodeWithFontNamed:kFontName];
        _textLabel.text = text;
        _textLabel.fontColor = color == [SKColor whiteColor] ? [SKColor blackColor] : [SKColor whiteColor];
        [self addChild:_textLabel];
        
        [self setUserInteractionEnabled:YES];
    }
    return self;
}
+ (instancetype)buttonWithColor:(SKColor *)color size:(CGSize)size text:(NSString*)text{
    GBButton* button = [[GBButton alloc]initWithColor:color size:size text:text];
    return button;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.delegate onClick:self];
}
-(void)setFontSize:(CGFloat)size{
    _textLabel.fontSize=size;
}
-(void)setTextPosition:(CGPoint)position{
    _textLabel.position = CGPointMake(position.x,position.y);
}
@end
