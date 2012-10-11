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

-(void) dealloc {    
    [_arrow release];
    _arrow = nil;

    [super dealloc];
}

-(BOOL)isFull {
    return _currentAmount >= _capacity;
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

-(id) init
{
    if( (self=[super init]) )
    {
        _facingDirection = kFacingDown;
        _readyForLoading = NO;
        _arrow = [[Arrow alloc] initWithSpriteFrameName:@"arrow-down.png"];
        _currentAmount = 0;
        _capacity = 5;
        [self addChild:_arrow];
    }
    return self;
}

@end
