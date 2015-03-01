//
//  Utils.h
//  BlackWhite
//
//  Created by chentb on 14-5-3.
//  Copyright (c) 2014年 chentb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface Utils : NSObject
+(void)loadSound;
+(void)playRightSound:(SKNode*)node;
+(void)playWrongSound:(SKNode*)node;
+(UIImage *)imageFromNode:(SKNode *)node;
@end
