//
//  GoldCart.m
//  TileGame
//
//  Created by Shingo Tamura on 27/09/12.
//
//

#import "GoldCart.h"

@implementation GoldCart

@synthesize facingDirection = _facingDirection;
@synthesize capacity = _capacity;
@synthesize currentAmount = _currentAmount;

-(void) dealloc {
    [super dealloc];
}

-(void)updateStateWithDeltaTime:(ccTime)deltaTime andGameObject:(GameObject *)gameObject {
    if (gameObject.gameObjectType == kHeroType) {
        
    }
}

-(void)changeState:(ContainerStates)newState {
    
}

-(id) init
{
    if( (self=[super init]) )
    {
        _facingDirection = kFacingDown;
    }
    return self;
}

@end
