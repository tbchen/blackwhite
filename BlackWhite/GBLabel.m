//
//  GBLabel.m
//  BlackWhite
//
//  Created by chentb on 2014/05/01.
//  Copyright (c) 2014年 chentb. All rights reserved.
//

#import "GBLabel.h"

@implementation GBLabel
-(instancetype)initWithFontNamed:(NSString *)fontName{
    self = [super initWithFontNamed:fontName];
    if (self) {
        [self setUserInteractionEnabled:YES];
    }
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.delegate onClick:self];
}
@end
