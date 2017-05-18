//
//  ViewController.m
//  Animation
//
//  Created by yiqiwang(王一棋) on 2017/5/16.
//  Copyright © 2017年 melody5417. All rights reserved.
//

#import "ViewController.h"
#import "BackgroundView.h"
#import "AnimationView.h"

@interface ViewController ()
@property (weak) IBOutlet AnimationView *animationView;
@end

@implementation ViewController


- (IBAction)show:(id)sender {
    [self.animationView show];
}

- (IBAction)hide:(id)sender {
    [self.animationView hide];
}

- (IBAction)stop:(id)sender {
    [self.animationView stopAllAnimations];
}

@end
