//
//  HelloWorldLayer.m
//  TileGame
//
//  Created by Shingo Tamura on 5/07/12.
//  Copyright GameCurry 2012. All rights reserved.
//

// Import the interfaces
#import "GamePlayRenderingLayer.h"
#import "GamePlayInputLayer.h"
#import "GamePlayStatusLayer.h"
#import "GameCompleteLayer.h"
#import "TitleScreenScene.h"
#import "SimpleAudioEngine.h"
#import "GameOverScene.h"
#import "CCSpotLight.h"
#import "Speedup.h"
#import "Lightup.h"
#import "GoldCart.h"
#import "Gold.h"
#import "Arrow.h"

@interface GamePlayRenderingLayer (PrivateMethods)
-(void)testCollisions:(ccTime)dt;
-(void)win;
-(void)lose;
-(void)addEnemyAtX:(int)x Y:(int)y;
-(BOOL)isProp:(NSString*)prop atTileCoord:(CGPoint)tileCoord forLayer:(CCTMXLayer *)layer;
-(void)preloadAudio;
-(CGPoint)getViewpointPosition:(CGPoint)position;
-(void)pickupPowerups:(CCActor*)subject;
- (void)speedupUsedOnce:(NSNotification *)notification;
- (void)speedupUsedUp:(NSNotification *)notification;
@end

@implementation GamePlayRenderingLayer

@synthesize tileMap = _tileMap;
@synthesize background = _background;
@synthesize player = _player;
@synthesize meta = _meta;
@synthesize hud = _hud;
@synthesize statusLayer = _statusLayer;
@synthesize completeLayer = _completeLayer;
@synthesize moving = _moving;
@synthesize isRetina = _isRetina;
@synthesize mask = _mask;
@synthesize spotlight = _spotlight;
@synthesize tileSizeInPoints = _tileSizeInPoints;
@synthesize heroSprite;

int maxSight = 400;

- (void) dealloc
{
	self.tileMap = nil;
    self.background = nil;
	self.player = nil;
    self.meta = nil;
    self.completeLayer = nil;
    self.statusLayer = nil;
    self.hud = nil;
	self.mask = nil;
    
	[_tileMap release];
	[_background release];
	[_meta release];
	[_hud release];
    [_statusLayer release];
    [_completeLayer release];
	[heroSprite release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

	[super dealloc];
}

#pragma mark Views & Positions

-(CGPoint)getViewpointPosition:(CGPoint)position {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    // We want the player to be always at the centre of the screen so
    // just use the position that's been passed here
    int x = position.x;
    int y = position.y;
    
    CGPoint actualPosition = ccp(x, y);
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    
    return ccpSub(centerOfView, actualPosition);
}

- (CGPoint)convertPixelsToPoints:(CGPoint)pixels {
    if (self.isRetina) {
        return ccp(pixels.x / 2.0f, pixels.y / 2.0f);
    }
    else {
        return ccp(pixels.x, pixels.y);
    }
}

- (CGPoint)convertPointsToPixels:(CGPoint)points {
    if (self.isRetina) {
        return ccp(points.x * 2.0f, points.y * 2.0f);
    }
    else {
        return ccp(points.x, points.y);
    }
}

// Gets tile coordinates for the given position in pixels. Use actual tile size
- (CGPoint)tileCoordForPositionInPixels:(CGPoint)positionInPixels {
    // Tile coordinates in int
    int x = positionInPixels.x / _tileMap.tileSize.width;
    int y = ((_tileMap.mapSize.height * _tileMap.tileSize.height) - positionInPixels.y) / _tileMap.tileSize.height;
    
    return ccp(x, y);
}

// Gets tile coordinates for the given position in points. The position must be
// in points.
- (CGPoint)tileCoordForPositionInPoints:(CGPoint)positionInPoints {
    // Tile coordinates in int
    int x = positionInPoints.x / _tileSizeInPoints.width;
    int y = ((_tileMap.mapSize.height * _tileSizeInPoints.height) - positionInPoints.y) / _tileSizeInPoints.height;
    
    return ccp(x, y);
}

-(CGPoint)positionInPixelsForTileCoord:(CGPoint)tileCoord {
    CGFloat x = (tileCoord.x * _tileMap.tileSize.width) + _tileMap.tileSize.width / 2.0f;
    CGFloat y = (_tileMap.mapSize.height * _tileMap.tileSize.height) - (tileCoord.y * _tileMap.tileSize.height) - _tileMap.tileSize.height / 2.0f;
    
    return ccp(x, y);
}

-(CGPoint)positionInPointsForTileCoord:(CGPoint)tileCoord {
    CGFloat x = (tileCoord.x * _tileSizeInPoints.width) + _tileSizeInPoints.width / 2.0f;
    CGFloat y = (_tileMap.mapSize.height * _tileSizeInPoints.height) - (tileCoord.y * _tileSizeInPoints.height) - _tileSizeInPoints.height / 2.0f;

    return ccp(x, y);
}

// Compute a position (in points) that fits to the corresponding tile
-(CGPoint) computeTileFittingPositionInPoints:(CGPoint)positionInPoints {
    CGPoint tilePos = [self tileCoordForPositionInPoints:positionInPoints];
    
    CGFloat x = (tilePos.x * _tileSizeInPoints.width) + (_tileSizeInPoints.width / 2.0f);
    CGFloat y = (_tileMap.mapSize.height * _tileSizeInPoints.height) - (tilePos.y * _tileSizeInPoints.height) - (_tileSizeInPoints.height / 2.0f);
    
    return ccp(x, y);
}

// Compute a position (in pixels) that fits to the corresponding tile
-(CGPoint) computeTileFittingPositionInPixels:(CGPoint)positionInPixels {
    CGPoint tilePos = [self tileCoordForPositionInPixels:positionInPixels];
    
    CGFloat x = (tilePos.x * _tileMap.tileSize.width) + (_tileMap.tileSize.width / 2.0f);
    CGFloat y = (_tileMap.mapSize.height * _tileMap.tileSize.height) - (tilePos.y * _tileMap.tileSize.height) - (_tileMap.tileSize.height / 2.0f);
    
    return ccp(x, y);
}

#pragma mark Hero

-(void) handlePushedToExit:(id)sender {
    if ([_completeLayer isInProgress]) {
        return;
    }
    
    [[SimpleAudioEngine sharedEngine]  stopBackgroundMusic];
    [_hud setIsTouchEnabled:NO];
    
    // update path finding
    CCArray* zombies = [_zombieSpriteBatchNode children];
    
    for (GameCharacter *zombie in zombies) {
        [zombie changeState:kStateIdle];
    }
    
    CCArray* carts = [_cartSpriteBatchNode children];
    
    for (GameObject *cart in carts) {
        [cart changeState:kStateIdle];
    }

    [_player changeState:kStateIdle];
    
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"win!.mp3" loop:NO];
    
    [_completeLayer startAnimation];
}

- (void) win:(NSNotification *) notification
{
    TitleScreenScene *titleScene = [TitleScreenScene node];
    [[CCDirector sharedDirector] replaceScene:titleScene];
}

- (void)lose {
    GameOverScene *gameOverScene = [GameOverScene node];
    [gameOverScene.layer.label setString:@"You Lose!"];
    [[CCDirector sharedDirector] replaceScene:gameOverScene];
}

- (void) playerMoveFinished:(id)sender {
    [self pickupPowerups:_player];
    _moving = NO;
}

-(NSDictionary*)getTileMetaData:(CGPoint)position {
    CGPoint tileCoord = [self tileCoordForPositionInPoints:position];
    int metaGid = [_meta tileGIDAt:tileCoord];
    
    if (metaGid) {
        NSDictionary* meta = [_tileMap propertiesForGID:metaGid];
        return meta;
    }
    return nil;
}

-(BOOL)isCollectableTile:(CGPoint)position forMeta:(NSDictionary*)meta {
    if (!meta) {
        meta = [self getTileMetaData:position];
    }
    
    if (meta) {
        NSString *collision = [meta valueForKey:@"Collectable"];
        if (collision && [collision compare:@"True"] == NSOrderedSame) {
            return YES;
        }
    }
    return NO;
}

-(BOOL)isCollidableTile:(CGPoint)position {
    return [self isCollidableTile:position forMeta:nil];
}

-(BOOL)isCollidableTile:(CGPoint)position forMeta:(NSDictionary*)meta {
    if (!meta) {
        meta = [self getTileMetaData:position];
    }

    if (meta) {
        NSString *collision = [meta valueForKey:@"Collidable"];
        if (collision && [collision compare:@"True"] == NSOrderedSame) {
            return YES;
        }
    }
    
    return NO;
}

-(NSString*)getRailTileName:(CGPoint)position {
    return [self getRailTileName:position forMeta:nil];
}

-(NSString*)getRailTileName:(CGPoint)position forMeta:(NSDictionary*)meta {
    if (!meta) {
        meta = [self getTileMetaData:position];
    }
    
    if (meta) {
        return [self getRailTileNameForMeta:meta];
    }
    
    return nil;
}

-(NSString*)getRailTileNameForMeta:(NSDictionary*)meta {
    if (meta) {
        NSString *properties = [meta valueForKey:@"Rail"];
        if (properties && [properties compare:@"Straight"] == NSOrderedSame) {
            return @"Straight";
        }
        else if (properties && [properties compare:@"Curved"] == NSOrderedSame) {
            return @"Curved";
        }
        else if (properties && [properties compare:@"Exit"] == NSOrderedSame) {
            return @"Exit";
        }

    }
    
    return nil;
}

-(BOOL)isRailTile:(CGPoint)tileCoord {
    
    int metaGid = [_meta tileGIDAt:tileCoord];
    
    if (metaGid) {
        NSDictionary* meta = [_tileMap propertiesForGID:metaGid];
        NSString* railTileName = [self getRailTileNameForMeta:meta];
        
        if (railTileName == @"Straight") {
            return YES;
        }
        else if (railTileName == @"Curved") {
            return YES;
        }
    }
    return NO;
}

-(CGPoint)findNextRailPosition:(CGPoint)subjectPos playerFacing:(FacingDirection)direction {
    CGPoint tilePos = [self tileCoordForPositionInPoints:subjectPos];
        
    // Find the final destination of the cart based on the next destination
    CGPoint tilePos1, tilePos2, tilePos3;
    BOOL neighbor1, neighbor2, neighbor3;
    
    switch (direction) {
        case kFacingUp:
            tilePos1 = ccp(tilePos.x-1.0f, tilePos.y);
            tilePos2 = ccp(tilePos.x, tilePos.y-1.0f);
            tilePos3 = ccp(tilePos.x+1.0f, tilePos.y);
            break;
            
        case kFacingDown:
            tilePos1 = ccp(tilePos.x+1.0f, tilePos.y);
            tilePos2 = ccp(tilePos.x, tilePos.y+1.0f);
            tilePos3 = ccp(tilePos.x-1.0f, tilePos.y);
            break;
            
        case kFacingRight:
            tilePos1 = ccp(tilePos.x, tilePos.y-1.0f);
            tilePos2 = ccp(tilePos.x+1.0f, tilePos.y);
            tilePos3 = ccp(tilePos.x, tilePos.y+1.0f);
            break;
            
        case kFacingLeft:
            tilePos1 = ccp(tilePos.x, tilePos.y+1.0f);
            tilePos2 = ccp(tilePos.x-1.0f, tilePos.y);
            tilePos3 = ccp(tilePos.x, tilePos.y-1.0f);
            break;
    }

    neighbor1 = [self isRailTile:tilePos1];
    neighbor3 = [self isRailTile:tilePos3];
    neighbor2 = [self isRailTile:tilePos2];
    
    if (neighbor1) {
        return [self positionInPointsForTileCoord:tilePos1];
    }
    if (neighbor2) {
        return [self positionInPointsForTileCoord:tilePos2];
    }
    if (neighbor3) {
        return [self positionInPointsForTileCoord:tilePos3];
    }
    return ccp(-1000.0f, -1000.0f);
}

-(void)setPlayerPosition:(CGPoint)position facing:(FacingDirection)direction {
    if (_moving) {
        return;
    }
    
    CGPoint tileCoord = [self tileCoordForPositionInPoints:position];
    
    int metaGid = [_meta tileGIDAt:tileCoord];
    if (metaGid) {
        NSDictionary *properties = [_tileMap propertiesForGID:metaGid];
        if (properties) {
            if ([self isCollidableTile:position forMeta:properties]) {
                return;
            }
        }
    }
    
    CCArray* carts = [_cartSpriteBatchNode children];
    BOOL cartWillHitSomething = NO;
    for (GoldCart *cart in carts) {
        CGRect targetRect = CGRectMake(cart.position.x - (cart.contentSize.width/2), cart.position.y - (cart.contentSize.height/2), cart.contentSize.width, cart.contentSize.height);
            
        if (CGRectContainsPoint(targetRect, position)) {
            CCLOG(@"Collision between a cart and the miner has been detected.");
            CGPoint dest = ccp(cart.position.x, cart.position.y);
            CGPoint diff = ccp(abs(abs(_player.position.x) - abs(position.x)), abs(abs(_player.position.y) - abs(position.y)));
            switch (direction) {
                case kFacingUp:
                    dest.y += diff.y;
                    break;
                    
                case kFacingDown:
                    dest.y -= diff.y;
                    break;
                    
                case kFacingRight:
                    dest.x += diff.x;
                    break;
                    
                case kFacingLeft:
                    dest.x -= diff.x;
                    break;
            }
            
            if ([self isCollidableTile:dest]) {
                cartWillHitSomething = YES;
            }
            else {
                // If there are no collidables so far, check if the cart will still be on rails
                NSString* railTileName = [self getRailTileName:dest];
                
                if (railTileName == @"Straight") {
                    id actionCartMove = [CCMoveTo actionWithDuration:0.2f position:dest];
                    [cart runAction:[CCSequence actions:actionCartMove, nil]];
                }
                else if (railTileName == @"Curved") {
                    CGPoint finalDest = [self findNextRailPosition:dest playerFacing:direction];
                    
                    if (!(finalDest.x == -1000.0f && finalDest.y == -1000.0f)) {
                        ccBezierConfig bezier;
                        bezier.controlPoint_1 = cart.position;
                        bezier.controlPoint_2 = dest;
                        bezier.endPosition = finalDest;
                        id actionCartMove = [CCBezierTo actionWithDuration:0.4f bezier:bezier];
                        [cart runAction:[CCSequence actions:actionCartMove, nil]];
                    }
                }
                else if (railTileName == @"Exit") {
                    if ([cart isFull]) {
                        id actionCartMove = [CCMoveTo actionWithDuration:0.2f position:dest];
                        id actionCartMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(handlePushedToExit:)];
                        [cart runAction:[CCSequence actions:actionCartMove, actionCartMoveDone, nil]];
                    }
                    else {
                        cartWillHitSomething = NO;
                    }
                }
                else {
                    cartWillHitSomething = YES;
                }
            }
        }
    }
    
    // The destination of the cart is a collidable tile, so stop the hero
    if (cartWillHitSomething) {
        return;
    }
    
    id actionMove = [CCMoveTo actionWithDuration:0.2f position:position];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(playerMoveFinished:)];
    CGPoint viewPointPosition = [self getViewpointPosition:position];
    id actionViewpointMove = [CCMoveTo actionWithDuration:0.2f position:viewPointPosition];
    id actionMaskMove = [CCMoveTo actionWithDuration:0.2f position:position];
    
    _moving = YES;
    [_player runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    [_mask runAction:[CCSequence actions:actionMaskMove, nil]];
    [self runAction:[CCSequence actions:actionViewpointMove, nil]];
    [_player adjustAnimation:direction];
}

-(BOOL)canPickupGold:(Gold*)targetGold atPosition:(CGPoint)positionInPoints facing:(FacingDirection)direction {
    if (targetGold.collected) {
        // Already collected
        return NO;
    }
    else {
        CGPoint tileCoord = [self tileCoordForPositionInPoints:positionInPoints];
        CGPoint tilePos = [self positionInPointsForTileCoord:tileCoord];
        CGRect rect = CGRectMake(tilePos.x, tilePos.y, _tileSizeInPoints.width, _tileSizeInPoints.height);
        
        CGRect targetBox = targetGold.boundingBox;
        if (CGRectIntersectsRect(targetBox, rect)) {
            return YES;
        }
        else {
            return NO;
        }
    }    
}

-(void)dropGold:(CGPoint)position facing:(FacingDirection)direction {
    // If player doesn't currently hold gold, quit here
    if (_player.goldInPossession == nil) {
        return;
    }

    CGPoint tileCoord = [self tileCoordForPositionInPoints:position];
    CGPoint tilePos = [self positionInPointsForTileCoord:tileCoord];
    
    CCArray* carts = [_cartSpriteBatchNode children];
    
    for (GoldCart *cart in carts) {
        if (cart.readyForLoading && CGRectIntersectsRect(_player.boundingBox, cart.boundingBox)) {
            int currentAmount = [cart loadGold];
            [cart setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"cart-with-gold-front.png"]];
            _player.goldInPossession = nil; // unreference
            [[SimpleAudioEngine sharedEngine] playEffect:@"gold.caf"];
            [_player changeState:kStateWalking];
            CCLOG(@"Load: %d / %d", currentAmount, cart.capacity);
        }
    }

    if (_player.goldInPossession != nil) {
        _player.goldInPossession.position = ccp(tilePos.x, tilePos.y);
        [_player.goldInPossession uncollect];
        [_player changeState:kStateWalking];
        _player.goldInPossession = nil; // unreference
        [[SimpleAudioEngine sharedEngine] playEffect:@"miss.caf"];
    }
}

-(void)pickupGold:(CGPoint)position facing:(FacingDirection)direction {
    // If player already has a gold in hand, quit here
    if (_player.goldInPossession != nil) {
        return;
    }
    
    CCArray* golds = [_goldSpriteBatchNode children];
    
    for (Gold* gold in golds) {
        if ([self canPickupGold:gold atPosition:position facing:direction]) {
            _player.goldInPossession = gold;
            [gold collect];
            [_player changeState:kStateCarryingGold];
            [[SimpleAudioEngine sharedEngine] playEffect:@"pickup.caf"];
            break;
        }
    }
}

-(void)moveHero:(CGPoint)touchLocation facing:(FacingDirection)direction {
    CGPoint playerPos = touchLocation;
    
    if (playerPos.x <= (_tileMap.mapSize.width * _tileSizeInPoints.width) &&
        playerPos.y <= (_tileMap.mapSize.height * _tileSizeInPoints.height) &&
        playerPos.y >= 0 &&
        playerPos.x >= 0)
    {
        [self setPlayerPosition:playerPos facing:direction];
    }
}

#pragma mark Powerups

- (void)pickupPowerups:(CCActor*)subject {
    NSMutableArray *powerupsToDelete = [[NSMutableArray alloc] init];
    
    CGRect subjectRect = CGRectMake(
                                       subject.position.x - (subject.contentSize.width/2),
                                       subject.position.y - (subject.contentSize.height/2),
                                       subject.contentSize.width,
                                       subject.contentSize.height);
    
    for (Powerup *target in _powerups) {
        CGRect targetRect = CGRectMake(
                                       target.position.x - (target.contentSize.width/2),
                                       target.position.y - (target.contentSize.height/2),
                                       target.contentSize.width,
                                       target.contentSize.height);
        
        if (CGRectIntersectsRect(subjectRect, targetRect)) {
            [target use:subject];
            [powerupsToDelete addObject:target];
            [[SimpleAudioEngine sharedEngine] playEffect:@"powerup.caf"];
        }
    }
    // remove all the projectiles that hit.
    for (CCSprite *powerup in powerupsToDelete) {
        [_powerups removeObject:powerup];
        [self removeChild:powerup cleanup:YES];
    }
    [powerupsToDelete release];
}

- (void) speedupUsedOnce:(NSNotification *) notification
{
    Powerup* powerup = (Powerup*)notification.object;
    if (powerup.key == @"Lightup") {
        // player's light should be updated now
        _spotlight.spotLightRadius = _player.light;
    }
    else if (powerup.key == @"Speedup") {
        // update moving threshold according to player's current speed
        _hud.movingThreshold = 0.2;
    }
}

- (void) speedupUsedUp:(NSNotification *) notification
{
    CCLOG(@"Speedup used up");
}

#pragma mark GoldCartEvents

-(void) handleUpdateCart:(NSNotification *) notification {
    NSDictionary *data = [notification userInfo];
    NSUInteger amount = [[data objectForKey:@"currentAmount"] intValue];
    GoldCart* cart = (GoldCart*)notification.object;

    [_statusLayer showStatus:cart amount:amount];
}

-(void) handleFullCart:(NSNotification *) notification {
    CCLOG(@"Cart is full!");
}

#pragma mark PathFinding

-(BOOL)isValidTileCoord:(CGPoint)tileCoord {
    if (tileCoord.x < 0 || tileCoord.y < 0 || 
        tileCoord.x >= _tileMap.mapSize.width ||
        tileCoord.y >= _tileMap.mapSize.height) {
        return FALSE;
    } else {
        return TRUE;
    }
}

-(BOOL)isProp:(NSString*)prop atTileCoord:(CGPoint)tileCoord forLayer:(CCTMXLayer *)layer {
    if (![self isValidTileCoord:tileCoord]) return NO;
    int gid = [layer tileGIDAt:tileCoord];
    NSDictionary * properties = [_tileMap propertiesForGID:gid];
    if (properties == nil) return NO;    
    return [properties objectForKey:prop] != nil;
}

-(BOOL)isWallAtTileCoord:(CGPoint)tileCoord {
    return [self isProp:@"Collidable" atTileCoord:tileCoord forLayer:_meta];
}

-(NSArray *)walkableAdjacentTilesCoordForTileCoord:(CGPoint)tileCoord
{
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:8];
    
    BOOL t = NO;
    BOOL l = NO;
    BOOL b = NO;
    BOOL r = NO;
	
	// Top
	CGPoint p = CGPointMake(tileCoord.x, tileCoord.y - 1);
	if ([self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
        t = YES;
	}
	
	// Left
	p = CGPointMake(tileCoord.x - 1, tileCoord.y);
	if ([self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
        l = YES;
	}
	
	// Bottom
	p = CGPointMake(tileCoord.x, tileCoord.y + 1);
	if ([self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
        b = YES;
	}
	
	// Right
	p = CGPointMake(tileCoord.x + 1, tileCoord.y);
	if ([self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
        r = YES;
	}
    
    
	// Top Left
	p = CGPointMake(tileCoord.x - 1, tileCoord.y - 1);
	if (t && l && [self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
	}
	
	// Bottom Left
	p = CGPointMake(tileCoord.x - 1, tileCoord.y + 1);
	if (b && l && [self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
	}
	
	// Top Right
	p = CGPointMake(tileCoord.x + 1, tileCoord.y - 1);
	if (t && r && [self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
	}
	
	// Bottom Right
	p = CGPointMake(tileCoord.x + 1, tileCoord.y + 1);
	if (b && r && [self isValidTileCoord:p] && ![self isWallAtTileCoord:p]) {
		[tmp addObject:[NSValue valueWithCGPoint:p]];
	}
	
	return [NSArray arrayWithArray:tmp];
}

#pragma mark Adding characters to the scene

-(void)createObjectOfType:(GameObjectType)objectType withHealth:(int)initialHealth atLocation:(CGPoint)spawnLocationInPixels withZValue:(int)zValue {
    
    if (kEnemyTypeZombie == objectType) {
		CCLOG(@"Creating a zombie...");
        
		Zombie *zombie = [[Zombie alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"zombie-front-1.png"]];
		[zombie setCharacterHealth:initialHealth];
        CGPoint spawnPoint = [self convertPixelsToPoints:spawnLocationInPixels];
		[zombie setPosition:spawnPoint];
		[_zombieSpriteBatchNode addChild:zombie z:zValue];
		[zombie setDelegate:self];
        [zombie release];
    }
    else if (kObjectTypeGoldCart == objectType) {
		CCLOG(@"Creating a gold cart...");
        
		GoldCart *cart = [[GoldCart alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"cart-front.png"]];
        CGPoint spawnPoint = [self convertPixelsToPoints:[self computeTileFittingPositionInPixels:spawnLocationInPixels]];
		[cart setPosition:spawnPoint];
		[_cartSpriteBatchNode addChild:cart z:zValue];
        [cart release];
    }
    else if (kObjectTypeGold == objectType) {
		CCLOG(@"Creating a gold...");
        
		Gold *gold = [[Gold alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"gold-1.png"]];
        CGPoint spawnPoint = [self convertPixelsToPoints:[self computeTileFittingPositionInPixels:spawnLocationInPixels]];
		[gold setPosition:spawnPoint];
		[_goldSpriteBatchNode addChild:gold z:zValue];
        [gold release];
    }
}

-(void)addEnemyAtX:(int)x Y:(int)y
{	
	[self createObjectOfType:kEnemyTypeZombie withHealth:100 atLocation:ccp(x, y) withZValue:2];
}

-(void)addCartAtX:(int)x andY:(int)y
{
	[self createObjectOfType:kObjectTypeGoldCart withHealth:0 atLocation:ccp(x, y) withZValue:0];
}

-(void)addGoldAtX:(int)x andY:(int)y
{
	[self createObjectOfType:kObjectTypeGold withHealth:0 atLocation:ccp(x, y) withZValue:-1];
}

#pragma mark Setting Up Scene

-(void) preloadAudio {
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"run.caf"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"pickup.caf"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"powerup.caf"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"hit.caf"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"move.caf"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"broken.caf"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"great.caf"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"selection.caf"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"shoot.caf"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"gold.caf"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"miss.caf"];
    
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"mysterious-cave.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"win!.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"lose!.mp3"];
}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GamePlayRenderingLayer *renderingLayer = [GamePlayRenderingLayer node];
	
	// add layer as a child to scene
	[scene addChild: renderingLayer];
	
    GamePlayInputLayer *inputLayer = [GamePlayInputLayer node];
    [scene addChild: inputLayer];
    renderingLayer.hud = inputLayer;
    inputLayer.gameLayer = renderingLayer;
	
    GamePlayStatusLayer *statusDisplayLayer = [GamePlayStatusLayer node];
    [scene addChild: statusDisplayLayer];
    renderingLayer.statusLayer = statusDisplayLayer;
    statusDisplayLayer.gameLayer = renderingLayer;
	
    GameCompleteLayer *gameCompleteLayer = [GameCompleteLayer node];
    [scene addChild: gameCompleteLayer];
    renderingLayer.completeLayer = gameCompleteLayer;
    gameCompleteLayer.gameLayer = renderingLayer;

	// return the scene
	return scene;
}

-(void) loadSprites
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"miner.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"zombie.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"cart.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"gold.plist"];
    
    _sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"miner.png"];
    _zombieSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"zombie.png"];
    _cartSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"cart.png"];
    _goldSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"gold.png"];
    
    [self addChild:_sceneSpriteBatchNode z:0];
    [self addChild:_zombieSpriteBatchNode z:0];
    [self addChild:_cartSpriteBatchNode z:0];
    [self addChild:_goldSpriteBatchNode z:0];
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        CGSize pixelWinSize = [[CCDirector sharedDirector] winSizeInPixels];
        if (pixelWinSize.width == 1136 || pixelWinSize.width == 960) {
            self.isRetina = YES;
        }
        else {
            self.isRetina = NO;
        }
        
        [self preloadAudio];
        
        if (self.isRetina) {
            self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"gold-on-wheels-hd.tmx"];
        }
        else {
            self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"gold-on-wheels.tmx"];
        }
        
        // Set the tile size in points (this is universal across normal and retina displays)
        self.tileSizeInPoints = CGSizeMake(32.0f, 32.0f);
        
        self.meta = [_tileMap layerNamed:@"Meta"];
        _meta.visible = NO;
		[self addChild:_tileMap z:-1];
		
        // Adding player
        CCTMXObjectGroup *objects = [_tileMap objectGroupNamed:@"Objects"];
        NSAssert(objects != nil, @"'Objects' object group not found");
        
        // by putting the object group into a NSMutableDictionary you get access to a lot of useful properties
        NSMutableDictionary *spawnPoint = [objects objectNamed:@"SpawnPoint"];
        NSAssert(spawnPoint != nil, @"SpawnPoint object not found");
        int x = [[spawnPoint valueForKey:@"x"] intValue];
        int y = [[spawnPoint valueForKey:@"y"] intValue];
        
        [self loadSprites];
        
		self.player = [[CCHero alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-normal-front-1.png"]];
		CGPoint initialPosition = [self convertPixelsToPoints:[self computeTileFittingPositionInPixels:ccp(x, y)]];
        _player.position = ccp(initialPosition.x, initialPosition.y);
        
        _player.speed = 20.0f;
        
        // Light is in pixels
        _player.light = self.isRetina ? 240.0f : 120.0f;
        
        _hud.movingThreshold = _player.speed;
        
		_powerups = [[NSMutableArray alloc] init];
		
        NSMutableDictionary *objectTile;
        for (objectTile in [objects objects]) {
            x = [[objectTile valueForKey:@"x"] intValue];
            y = [[objectTile valueForKey:@"y"] intValue];

            if ([[objectTile valueForKey:@"Enemy"] intValue] == 1) {
                // enemy
                [self addEnemyAtX:x Y:y];
            }
            else if ([[objectTile valueForKey:@"Cart"] intValue] == 1) {
                // gold cart
                [self addCartAtX:x andY:y];
            }
            else if ([[objectTile valueForKey:@"Gold"] intValue] == 1) {
                // gold
                [self addGoldAtX:x andY:y];
            }
            else {
                int type = [[objectTile valueForKey:@"PowerupType"] intValue];
                Powerup* powerup = nil;
                
                switch (type) {
                    case 1:
                        powerup = [[Speedup alloc] initWithFile:@"boot.png"];
                        break;
                    case 2:
                        powerup = [[Lightup alloc] initWithFile:@"lamp.png"];
                        break;
                    default:
                        break;
                }
                
                if (powerup != nil) {
                    // Fit object to tile grid
                    CGPoint objTilePos = [self convertPixelsToPoints:[self computeTileFittingPositionInPixels:ccp(x, y)]];
                    powerup.position = ccp(objTilePos.x, objTilePos.y);
                    [self addChild:powerup];
                    [_powerups addObject:powerup];
                }
            }
        }

		// Spotlight
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        // Mask is in pixels so don't use _tileSizeInPoints
		_mask = [CCRenderTexture renderTextureWithWidth:winSize.width+_tileMap.tileSize.width height:winSize.height+_tileMap.tileSize.height]; // screen size + tile size
		_mask.position = _player.position;
		[[_mask sprite] setBlendFunc: (ccBlendFunc) { GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA }];
		[self addChild:_mask z:1];
		_spotlight = [CCSpotLight initWithRenderTexture:_mask spotLightRadius:_player.light renderColor:ccc4(0, 0, 0, 255)];
		[self addChild:_spotlight z:2 tag:999];
		
        [_sceneSpriteBatchNode addChild:_player z:kHeroSpriteZValue tag:kHeroSpriteTagValue];
        self.position = [self getViewpointPosition:_player.position];
        
        _tmpPathFindingDelta = 0.0f;
        _pathFindingThreshold = 1.0f;
        
		//Observer notifications
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(speedupUsedOnce:) name:@"usedOnce" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(speedupUsedUp:) name:@"usedUp" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFullCart:) name:@"cartFull" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdateCart:) name:@"cartLoaded" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(win:) name:@"animationDone" object:nil];
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"mysterious-cave.mp3"];
        
		//Schedule updates
		[self scheduleUpdate];
	}
	return self;
}

-(void)update:(ccTime)delta
{
    [_player updateStateWithDeltaTime:delta andGameObject:nil];
    
    _tmpPathFindingDelta += delta;
    
    if (_tmpPathFindingDelta >= _pathFindingThreshold) {
        _tmpPathFindingDelta = 0.5f;
        
        // update path finding
        CCArray* zombies = [_zombieSpriteBatchNode children];
        
        for (GameCharacter *zombie in zombies) {
            [zombie updateStateWithDeltaTime:delta andGameObject:_player];
        }
        
        CCArray* carts = [_cartSpriteBatchNode children];
        
        for (GameObject *cart in carts) {
            [cart updateStateWithDeltaTime:delta andGameObject:_player];
        }
    }
}


@end
