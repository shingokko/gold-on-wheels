//
//  CCHero.h
//  TileGame
//
//  Created by Shingo Tamura on 15/09/12.
//
//

#import "CCActor.h"
#import "CommonProtocol.h"

@class Gold;

@interface CCHero : CCActor
{
    FacingDirection _facingDirection;
    CCAnimation *_frontAnim;
    CCAnimation *_backAnim;
    CCAnimation *_sideAnim;
    Gold *_goldInPossession;
}

@property (nonatomic, retain) CCAnimation *frontAnim;
@property (nonatomic, retain) CCAnimation *backAnim;
@property (nonatomic, retain) CCAnimation *sideAnim;
@property (nonatomic, retain) Gold *goldInPossession;
@property (nonatomic, assign) FacingDirection facingDirection;

-(void) adjustAnimation:(FacingDirection)direction;

@end
