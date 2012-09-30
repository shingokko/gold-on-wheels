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
}

@property (nonatomic, assign) FacingDirection facingDirection;

@end