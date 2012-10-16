//
//  GoldCart.m
//  TileGame
//
//  Created by Shingo Tamura on 27/09/12.
//
//

#import "GoldCart.h"
#import "Arrow.h"
#import "CCHero.h"

@implementation GoldCart

@synthesize facingDirection = _facingDirection;
@synthesize capacity = _capacity;
@synthesize readyForLoading = _readyForLoading;
@synthesize withGoldFrontAnim = _withGoldFrontAnim;
@synthesize withGoldSideAnim = _withGoldSideAnim;

-(void) dealloc {
    [_withGoldFrontAnim release];
    [_withGoldSideAnim release];  
    [_arrow release];
    
    _withGoldFrontAnim = nil;
    _withGoldSideAnim = nil;
    _arrow = nil;

    [super dealloc];
}

-(BOOL)isFull {
    return _currentAmount >= _capacity;
}

-(void) loadWithGoldAnimations {
    NSMutableArray *frontAnimFrames = [NSMutableArray array];
    [frontAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"cart-with-gold-front-1.png"]];
    [frontAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"cart-with-gold-front-2.png"]];
    [frontAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"cart-with-gold-front-3.png"]];
    
    NSMutableArray *sideAnimFrames = [NSMutableArray array];
    [sideAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"cart-with-gold-side-1.png"]];
    [sideAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"cart-with-gold-side-2.png"]];
    [sideAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"cart-with-gold-side-3.png"]];
    
    // set up walking animations
    _withGoldFrontAnim = [[CCAnimation animationWithFrames:frontAnimFrames delay:0.3f] retain];
    _withGoldSideAnim = [[CCAnimation animationWithFrames:sideAnimFrames delay:0.3f] retain];
}

-(void)updateStateWithDeltaTime:(ccTime)deltaTime andGameObject:(CCHero *)target {
    if ([self isFull]) {
        return;
    }
    
    if (target.goldInPossession == nil) {
        [_arrow hide];
        _readyForLoading = NO;
    }
    else {
        if (CGRectIntersectsRect(self.boundingBox, target.boundingBox)) {
            [_arrow show];
            _readyForLoading = YES;
        }
        else {
            [_arrow hide];
            _readyForLoading = NO;
        }
    }
}

-(int)loadGold {
    if ([self isFull]) {
        return _currentAmount;
    }
    
    _currentAmount += 1;
    if (_currentAmount == 1) {
        [self adjustAnimation:_facingDirection];
    }
    
    // build data to send in notification
    NSNumber *amountInNsNumber = [NSNumber numberWithInt:_currentAmount];
    NSDictionary* data = [NSDictionary dictionaryWithObject:amountInNsNumber forKey:@"currentAmount"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cartLoaded" object:self userInfo:data];
    
    if (_currentAmount == _capacity) {
        _readyForLoading = NO;
        [_arrow hide];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cartFull" object:self ];
    }
    
    return _currentAmount;
}

-(id)getAnimation:(FacingDirection)direction {
    id action = nil;
    
    switch (direction) {
        case kFacingDown:
        case kFacingUp:
            action = [[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:_withGoldFrontAnim restoreOriginalFrame:YES]] retain];
            break;
        case kFacingLeft:
        case kFacingRight:
            action = [[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:_withGoldSideAnim restoreOriginalFrame:YES]] retain];
            break;
    }
    _facingDirection = direction;
    
    return action;
}

-(void) adjustAnimation:(FacingDirection)direction {
    
    id action = [self getAnimation:direction];
    
    if (action == nil) {
        [self stopAllActions];
    }
    else {
        [self runAction:action];
    }
}

-(id) init
{
    if( (self=[super init]) )
    {
        _facingDirection = kFacingDown;
        _readyForLoading = NO;
        _arrow = [[[Arrow alloc] initWithSpriteFrameName:@"arrow-down.png"] retain];
        _currentAmount = 0;
        _capacity = 5;
        
        [self loadWithGoldAnimations];
        
        [self addChild:_arrow];
    }
    return self;
}

@end
