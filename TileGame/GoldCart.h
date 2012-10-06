//
//  GoldCart.h
//  TileGame
//
//  Created by Shingo Tamura on 27/09/12.
//
//

#import "GameObject.h"
#import "CommonProtocol.h"

@interface GoldCart : GameObject {
    FacingDirection _facingDirection;
    int _capacity;
    int _currentAmount;
}

-(void)changeState:(ContainerStates)newState;

@property (nonatomic, assign) FacingDirection facingDirection;
@property (nonatomic, assign) int capacity;
@property (nonatomic, assign) int currentAmount;

@end