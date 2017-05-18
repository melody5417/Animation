//
//  BackgroundView.m
//  Animation
//
//  Created by yiqiwang(王一棋) on 2017/5/16.
//  Copyright © 2017年 melody5417. All rights reserved.
//

#import "BackgroundView.h"
#import <Carbon/Carbon.h>

@implementation BackgroundView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

    if (self.backgroundColor) {
        [self.backgroundColor setFill];
        NSRectFillUsingOperation(dirtyRect, NSCompositingOperationSourceOver);
    }
}

@end
