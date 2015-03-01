//
//  Utils.m
//  BlackWhite
//
//  Created by chentb on 14-5-3.
//  Copyright (c) 2014年 chentb. All rights reserved.
//

#import "Utils.h"
static SKAction* _rightSoundAction;
static SKAction* _wrongSoundAction;
@implementation Utils
+(void)loadSound{
    _rightSoundAction = [SKAction playSoundFileNamed:kRightSound waitForCompletion:NO];
    _wrongSoundAction = [SKAction playSoundFileNamed:kWrongSound waitForCompletion:NO];
}
+(void)playRightSound:(SKNode*)node{
    [node runAction:_rightSoundAction];
}
+(void)playWrongSound:(SKNode*)node{
    [node runAction:_wrongSoundAction];
}
//not use
+(void)setIsSoundOn:(BOOL)isSoundOn{
    
}
//not use
+(BOOL)isSoundOn{
    return YES;
}
+(UIImage *)imageFromNode:(SKNode *)node {
    SKView *view = node.scene.view;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGRect nodeFrame = [node calculateAccumulatedFrame];
    
    // render SKView into UIImage
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0.0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *sceneSnapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // crop to the requested node (making sure to flip the y-coordinate)
    CGFloat originY = sceneSnapshot.size.height*scale - nodeFrame.origin.y*scale - nodeFrame.size.height*scale;
    CGRect cropRect = CGRectMake(nodeFrame.origin.x * scale, originY, nodeFrame.size.width*scale, nodeFrame.size.height*scale);
    CGImageRef croppedSnapshot = CGImageCreateWithImageInRect(sceneSnapshot.CGImage, cropRect);
    UIImage *nodeSnapshot = [UIImage imageWithCGImage:croppedSnapshot];
    CGImageRelease(croppedSnapshot);
    
    return nodeSnapshot;
}
@end
