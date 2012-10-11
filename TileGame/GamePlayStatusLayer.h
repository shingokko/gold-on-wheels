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

@property (nonatomic, assign) GamePlayRenderingLayer *gameLayer;
@property (nonatomic, assign) CCProgressTimer *goldGauge;
@property (nonatomic, assign) CCSprite *icon;


@end