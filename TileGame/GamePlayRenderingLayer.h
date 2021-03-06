//
//  HelloWorldLayer.h
//  TileGame
//
//  Created by Shingo Tamura on 5/07/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "CCHero.h"
#import "CommonProtocol.h"
#import "Zombie.h"

@class GamePlayInputLayer;
@class GamePlayStatusLayer;
@class GameCompleteLayer;
@class CCSpotLight;
@class Speedup;
@class Arrow;

@interface GamePlayRenderingLayer : CCLayer <GameplayLayerDelegate>
{
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_background;
    CCTMXLayer *_meta;
    CGSize _tileSizeInPoints;
	
	GamePlayInputLayer *_hud;
    GamePlayStatusLayer *_statusLayer;
    GameCompleteLayer *_completeLayer;
	
    CCRenderTexture *_mask;
    CCSpotLight *_spotlight;
	
	bool _moving;
    bool _isRetina;
    
	CCHero *_player;
    NSMutableArray *_powerups;
	
	CCSpriteBatchNode *_sceneSpriteBatchNode;
	CCSpriteBatchNode *_zombieSpriteBatchNode;
    CCSpriteBatchNode *_cartSpriteBatchNode;
    CCSpriteBatchNode *_goldSpriteBatchNode;
    
    ccTime _tmpPathFindingDelta;
    ccTime _pathFindingThreshold;
}

@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *background;
@property (nonatomic, retain) CCHero *player;
@property (nonatomic, retain) CCTMXLayer *meta;
@property (nonatomic, retain) CCRenderTexture *mask;
@property (nonatomic, retain) CCSpotLight *spotlight;

@property (nonatomic, retain) GamePlayInputLayer *hud;
@property (nonatomic, retain) GamePlayStatusLayer *statusLayer;
@property (nonatomic, retain) GameCompleteLayer *completeLayer;

@property (nonatomic, assign) bool moving;
@property (nonatomic, assign) bool isRetina;
@property (nonatomic, assign) CGPoint prevPos;
@property (nonatomic, assign) CGSize tileSizeInPoints;
@property (nonatomic, retain) GameCharacter *heroSprite;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(void)moveHero:(CGPoint)touchPosition facing:(FacingDirection)direction;
-(void)pickupGold:(CGPoint)position facing:(FacingDirection)direction;
-(void)dropGold:(CGPoint)position facing:(FacingDirection)direction;
-(CGPoint)tileCoordForPositionInPoints:(CGPoint)position;
-(CGPoint)positionInPointsForTileCoord:(CGPoint)tileCoord;
-(CGPoint) computeTileFittingPositionInPoints:(CGPoint)position;
-(CGPoint)tileCoordForPositionInPixels:(CGPoint)positionInPixels;
-(CGPoint)positionInPixelsForTileCoord:(CGPoint)tileCoord;
-(CGPoint) computeTileFittingPositionInPixels:(CGPoint)positionInPixels;
-(void)setPlayerPosition:(CGPoint)position facing:(FacingDirection)direction;
-(void)playerMoveFinished:(id)sender;

- (NSArray *)walkableAdjacentTilesCoordForTileCoord:(CGPoint)tileCoord;
-(BOOL)isWallAtTileCoord:(CGPoint)tileCoord;
-(BOOL)isValidTileCoord:(CGPoint)tileCoord;

@end
