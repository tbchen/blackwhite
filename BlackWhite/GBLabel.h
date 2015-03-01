//
//  GBLabel.h
//  BlackWhite
//
//  Created by chentb on 2014/05/01.
//  Copyright (c) 2014年 chentb. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@protocol GBLabelDelegate <NSObject>
-(void)onClick:(id)sender;
@end
@interface GBLabel : SKLabelNode
@property(nonatomic,weak) id<GBLabelDelegate> delegate;
@end
