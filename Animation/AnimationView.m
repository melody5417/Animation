//
//  AnimationView.m
//  Animation
//
//  Created by yiqiwang(王一棋) on 2017/5/16.
//  Copyright © 2017年 melody5417. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AnimationView.h"
#import "BackgroundView.h"

#define AnimationDuration 5.00

@interface AnimationView ()<CAAnimationDelegate>
@property (nonatomic, strong) CALayer *imageLayer;
@property (nonatomic, strong) BackgroundView *backgroundView;
@property (nonatomic, strong) CABasicAnimation *fadeInAnimation;
@property (nonatomic, strong) CABasicAnimation *fadeOutAnimation;
@property (nonatomic, strong) CAAnimationGroup *zoomOutGroup;
@property (nonatomic, strong) CAAnimationGroup *zoomInGroup;
@end

@implementation AnimationView

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        self.wantsLayer = YES;
        self.layerContentsRedrawPolicy = NSViewLayerContentsRedrawOnSetNeedsDisplay;

        self.backgroundView = [[BackgroundView alloc] initWithFrame:self.bounds];
        [self.backgroundView setWantsLayer:YES];
        [self.backgroundView setBackgroundColor:[NSColor greenColor]];
        [self.backgroundView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
        [self addSubview:self.backgroundView];

        self.imageLayer = [CALayer layer];
        self.imageLayer.frame = NSMakeRect(0, 0, 20, 20);
        self.imageLayer.anchorPoint = CGPointMake(0, 0);

        NSImage *previewImage = [NSImage imageNamed:@"租赁房屋"];
        NSRect imageRect = NSMakeRect(0, 0, 20, 20);
        CGImageRef cgImage = [previewImage CGImageForProposedRect:&imageRect context:NULL hints:nil];
        self.imageLayer.contents = (__bridge id _Nullable)(cgImage);
        [self.layer addSublayer:self.imageLayer];

    }
    return self;
}

#pragma mark - public

- (void)show {
    [self stopAllAnimations];
    [self.backgroundView.layer addAnimation:self.fadeOutAnimation forKey:@"fadeout"];
    [self.imageLayer addAnimation:self.zoomOutGroup forKey:@"zoomoutgroup"];
}

- (void)hide {
    [self stopAllAnimations];
    [self.backgroundView.layer addAnimation:self.fadeInAnimation forKey:@"fadein"];
    [self.imageLayer addAnimation:self.zoomInGroup forKey:@"zoomingroup"];
}

- (void)stopAllAnimations {
    [self.imageLayer removeAllAnimations];
    [self.backgroundView.layer removeAllAnimations];
}

#pragma mark - draw

- (void)drawRect:(NSRect)dirtyRect {
    [[[NSColor redColor] colorWithAlphaComponent:0.2] setFill];
    NSRectFillUsingOperation(self.bounds, NSCompositingOperationSourceOver);
}

#pragma mark - animation

- (CABasicAnimation *)fadeInAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = AnimationDuration;
    animation.autoreverses = NO;
    animation.repeatCount = 1;
    animation.fromValue = [NSNumber numberWithFloat:1];
    animation.toValue = [NSNumber numberWithFloat:0];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    return animation;
}

- (CABasicAnimation *)fadeOutAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = AnimationDuration;
    animation.autoreverses = NO;
    animation.repeatCount = 1;
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue = [NSNumber numberWithFloat:1];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    return animation;
}

- (CAAnimationGroup *)zoomOutGroup {
    CABasicAnimation *positionAnima = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnima.fromValue = [NSValue valueWithPoint:self.imageLayer.position];
    positionAnima.toValue = [NSValue valueWithPoint:NSMakePoint(0, 0)];
    positionAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    CABasicAnimation *zoomAnima = [CABasicAnimation animationWithKeyPath:@"bounds"];
    zoomAnima.fromValue = [NSValue valueWithRect:self.imageLayer.bounds];
    zoomAnima.toValue = [NSValue valueWithRect:self.bounds];
    zoomAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    CAAnimationGroup *animaGroup = [CAAnimationGroup animation];
    animaGroup.duration = AnimationDuration;
    animaGroup.delegate = self;
    animaGroup.fillMode = kCAFillModeForwards;
    animaGroup.removedOnCompletion = NO;
    animaGroup.animations = @[positionAnima,zoomAnima];
    [animaGroup setValue:@"zoomOut" forKey:@"AnimationKey"];

    return animaGroup;
}

- (CAAnimationGroup *)zoomInGroup {
    CABasicAnimation *positionAnima = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnima.fromValue = [NSValue valueWithPoint:NSMakePoint(0, 0)];
    positionAnima.toValue = [NSValue valueWithPoint:self.imageLayer.position];
    positionAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    CABasicAnimation *zoomAnima = [CABasicAnimation animationWithKeyPath:@"bounds"];
    zoomAnima.fromValue = [NSValue valueWithRect:self.bounds];
    zoomAnima.toValue = [NSValue valueWithRect:self.imageLayer.bounds];
    zoomAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    CAAnimationGroup *animaGroup = [CAAnimationGroup animation];
    animaGroup.duration = AnimationDuration;
    animaGroup.fillMode = kCAFillModeForwards;
    animaGroup.delegate = self;
    animaGroup.removedOnCompletion = NO;
    animaGroup.animations = @[positionAnima,zoomAnima];
    [animaGroup setValue:@"zoomIn" forKey:@"AnimationKey"];

    return animaGroup;
}


#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim {
    NSLog(@"%s %@", __FUNCTION__, [anim valueForKey:@"AnimationKey"]);

    if ([[anim valueForKey:@"AnimationKey"] isEqualToString:@"zoomOut"]) {
        NSLog(@"zoomOut 动画开始");

    }
    else if ([[anim valueForKey:@"AnimationKey"] isEqualToString:@"zoomIn"]) {
        NSLog(@"zoomIn 动画开始");

    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSLog(@"%s %@", __FUNCTION__, [anim valueForKey:@"AnimationKey"]);

    if ([[anim valueForKey:@"AnimationKey"] isEqualToString:@"zoomOut"]) {
        NSLog(@"zoomOut 动画结束");

    }
    else if ([[anim valueForKey:@"AnimationKey"] isEqualToString:@"zoomIn"]) {
        NSLog(@"zoomIn 动画结束");

    }
}



@end
