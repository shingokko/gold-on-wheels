//
//  GamePlayGoldLayer.h
//  TileGame
//
//  Created by Shingo Tamura on 11/10/12.
//
//

#import "cocos2d.h"
#import "CommonProtocol.h"

@class GoldCart;
@class GamePlayRenderingLayer;

@interface GamePlayStatusLayer : CCLayer
{
    GamePlayRenderingLayer *_gameLayer;
    CCSprite *_icon;
    CCProgressTimer *_goldGauge;
}

-(void) showStatus:(GoldCart*)cart amount:(int)amount;

@property (nonatomic, retain) GamePlayRenderingLayer *gameLayer;
@property (nonatomic, retain) CCProgressTimer *goldGauge;
@property (nonatomic, retain) CCSprite *icon;


@end