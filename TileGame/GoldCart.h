//
//  GoldCart.h
//  TileGame
//
//  Created by Shingo Tamura on 27/09/12.
//
//

#import "GameObject.h"
#import "CommonProtocol.h"

@class Arrow;
@class CCHero;

@interface GoldCart : GameObject {
    FacingDirection _facingDirection;
    int _capacity;
    int _currentAmount;
    BOOL _readyForLoading;
    Arrow *_arrow;
}

-(void)updateStateWithDeltaTime:(ccTime)deltaTime andGameObject:(CCHero *)target;
-(int)loadGold;
-(BOOL)isFull;

@property (nonatomic, assign) FacingDirection facingDirection;
@property (nonatomic, assign) int capacity;
@property (nonatomic, assign) BOOL readyForLoading;

@end