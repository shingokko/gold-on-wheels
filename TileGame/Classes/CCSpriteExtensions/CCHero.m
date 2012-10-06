//
//  CCHero.m
//  TileGame
//
//  Created by Shingo Tamura on 15/09/12.
//
//

#import "CCHero.h"

@implementation CCHero

@synthesize frontAnim = _frontAnim;
@synthesize backAnim = _backAnim;
@synthesize sideAnim = _sideAnim;
@synthesize facingDirection = _facingDirection;
@synthesize goldInPossession = _goldInPossession;

-(void) dealloc {
    [_frontAnim release];
    [_backAnim release];
    [_sideAnim release];
    
    _frontAnim = nil;
    _backAnim = nil;
    _sideAnim = nil;
    
    [super dealloc];
}

-(void) loadAnimations {
    NSMutableArray *frontAnimFrames = [NSMutableArray array];
    [frontAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-front-1.png"]];
    [frontAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-front-2.png"]];
    [frontAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-front-1.png"]];
    [frontAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-front-3.png"]];
    
    NSMutableArray *backAnimFrames = [NSMutableArray array];
    [backAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-back-1.png"]];
    [backAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-back-2.png"]];
    [backAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-back-1.png"]];
    [backAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-back-3.png"]];
    
    NSMutableArray *sideAnimFrames = [NSMutableArray array];
    [sideAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-side-1.png"]];
    [sideAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-side-2.png"]];
    [sideAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-side-1.png"]];
    [sideAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-side-3.png"]];
    
    // set up walking animations
    _frontAnim = [[CCAnimation animationWithFrames:frontAnimFrames delay:0.3f] retain];
    _backAnim = [[CCAnimation animationWithFrames:backAnimFrames delay:0.3f] retain];
    _sideAnim = [[CCAnimation animationWithFrames:sideAnimFrames delay:0.3f] retain];
}

-(void) adjustAnimation:(FacingDirection)direction {
    id action = nil;
    
    switch (direction) {
        case kFacingDown:
            if (_facingDirection != direction) {
                _facingDirection = direction;
                action = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:_frontAnim restoreOriginalFrame:YES]];
            }
            break;
        case kFacingUp:
            if (_facingDirection != direction) {
                _facingDirection = direction;
                action = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:_backAnim restoreOriginalFrame:YES]];
            }
            break;
        case kFacingLeft:
            if (self.flipX) {
                self.flipX = NO;
            }
			
            if (_facingDirection != direction) {
                _facingDirection = direction;
                action = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:_sideAnim restoreOriginalFrame:YES]];
            }
            break;
			
        default:
            if (!self.flipX) {
                self.flipX = YES;
            }
			
            if (_facingDirection != direction) {
                _facingDirection = direction;
                action = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:_sideAnim restoreOriginalFrame:YES]];
            }
            break;
    }
    
    if (action != nil) {
        [self runAction:action];
    }
}

-(id) init
{
    if( (self=[super init]) )
    {
        _facingDirection = kFacingDown;
		self.gameObjectType = kHeroType;
        
        [self loadAnimations];
    }
    return self;
}

@end
