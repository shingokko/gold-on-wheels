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
}

-(void) startAnimation;

@property (nonatomic, assign) GamePlayRenderingLayer *gameLayer;

@end