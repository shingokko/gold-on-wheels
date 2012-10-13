//
//  GameCompleteLayer.h
//  TileGame
//
//  Created by Shingo Tamura on 12/10/12.
//
//

#import "cocos2d.h"

@class GamePlayRenderingLayer;

@interface GameCompleteLayer : CCLayerColor
{
    GamePlayRenderingLayer *_gameLayer;
    BOOL _isInProgress;
}

-(void) startAnimation;

@property (nonatomic, retain) GamePlayRenderingLayer *gameLayer;
@property (nonatomic, assign) BOOL isInProgress;

@end