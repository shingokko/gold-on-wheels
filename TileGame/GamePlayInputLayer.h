//
//  GamePlayerInputLayer.h
//  TileGame
//
//  Created by Shingo Tamura on 8/09/12.
//
//

#import "cocos2d.h"
#import "CommonProtocol.h"

@class SneakyJoystick;
@class SneakyButton;
@class GamePlayRenderingLayer;

@interface GamePlayInputLayer : CCLayer
{
    CCLabelTTF *_label;
    GamePlayRenderingLayer *_gameLayer;
    
	SneakyJoystick *_leftJoystick;
    SneakyButton *_rightButton;
    ButtonStates _buttonState;
    
    ccTime _tmpMovingDelta;
    ccTime _tmpAttackingDelta;
    ccTime _movingThreshold;
    ccTime _attackingThreshold;
}

-(void)melonCountChanged:(int)melonCount;

@property (nonatomic, assign) GamePlayRenderingLayer *gameLayer;
@property (nonatomic, assign) ccTime movingThreshold;
@end

