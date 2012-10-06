/*
 *  CommonProtocol.h
 *  TileGame
 *
 *  Created by Sam Christian Lee on 9/22/12.
 *  Copyright 2012 GameCurry. All rights reserved.
 *
 */

typedef enum {
    kFacingDown,
    kFacingUp,
    kFacingLeft,
    kFacingRight,
} FacingDirection;

typedef enum {
    kStateSpawning,
    kStateIdle,
    kStateCrouching,
    kStateStandingUp,
    kStateWalking,
    kStateAttacking,
    kStateJumping,
    kStateBreathing,
    kStateTakingDamage,
    kStateDead,
    kStateTraveling,
    kStateRotating, 
    kStateDrilling,
    kStateAfterJumping,
} CharacterStates;

typedef enum {
    kStateStatic,
    kStatePressed,
    kStateReleased,
} ButtonStates;

typedef enum {
    kStateEmpy,
    kStateFilled,
} ContainerStates;

typedef enum {
	kObjectTypeNone,
	kHeroType,
    kEnemyTypeZombie,
    kObjectTypeGoldCart,
    kObjectTypeGold,
} GameObjectType;

@protocol GameplayLayerDelegate

-(void)createObjectOfType:(GameObjectType)objectType 
               withHealth:(int)initialHealth
               atLocation:(CGPoint)spawnLocation 
               withZValue:(int)ZValue;

@end