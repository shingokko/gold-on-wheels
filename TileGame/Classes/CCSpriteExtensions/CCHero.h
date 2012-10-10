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
    // normal state
    CCAnimation *_normalFrontAnim;
    CCAnimation *_normalBackAnim;
    CCAnimation *_normalSideAnim;
    // with gold
    CCAnimation *_withGoldFrontAnim;
    CCAnimation *_withGoldBackAnim;
    CCAnimation *_withGoldSideAnim;

    Gold *_goldInPossession;
}

@property (nonatomic, retain) CCAnimation *normalFrontAnim;
@property (nonatomic, retain) CCAnimation *normalBackAnim;
@property (nonatomic, retain) CCAnimation *normalSideAnim;
@property (nonatomic, retain) CCAnimation *withGoldFrontAnim;
@property (nonatomic, retain) CCAnimation *withGoldBackAnim;
@property (nonatomic, retain) CCAnimation *withGoldSideAnim;
@property (nonatomic, retain) Gold *goldInPossession;
@property (nonatomic, assign) FacingDirection facingDirection;

-(void) adjustAnimation:(FacingDirection)direction;

@end
