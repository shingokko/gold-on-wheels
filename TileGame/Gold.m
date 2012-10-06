//
//  Gold.m
//  TileGame
//
//  Created by Shingo Tamura on 6/10/12.
//
//

#import "Gold.h"
#import "Arrow.h"

@implementation Gold

@synthesize collected = _collected;

-(void) dealloc {
    [_shineAnim release];
    _shineAnim = nil;
    
    [super dealloc];
}

-(void) loadAnimations {
    NSMutableArray *shineAnimFrames = [NSMutableArray array];
    [shineAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"gold-32-1.png"]];
    [shineAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"gold-32-2.png"]];
    [shineAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"gold-32-3.png"]];
    [shineAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"gold-32-2.png"]];
    
    _shineAnim = [CCAnimation animationWithFrames:shineAnimFrames delay:0.2f];
}

-(void)updateStateWithDeltaTime:(ccTime)deltaTime andGameObject:(GameObject *)gameObject {
}

-(void)startShining {
    if (_shineAnim != nil) {
        if (_animationHandle != nil) {
            [self stopAction:_animationHandle];
            _animationHandle = nil;
        }
        _animationHandle = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:_shineAnim]];
        
        [self runAction:_animationHandle];
        [_animationHandle retain];
    }
}

-(void)stopShining {
    if (_animationHandle != nil) {
        [self stopAction:_animationHandle];
    }
}

-(void)collect {
    _collected = YES;
    self.visible = NO;
    [self stopShining];
}

-(void)uncollect {
    _collected = NO;
    self.visible = YES;
    [self startShining];
}

-(id) init
{
    if( (self=[super init]) )
    {
        _collected = NO;
        [self loadAnimations];
        [self startShining];
    }
    return self;
}

@end