//
//  CCHero.m
//  TileGame
//
//  Created by Shingo Tamura on 15/09/12.
//
//

#import "CCHero.h"
#import "CCParticleHeroBlood.h"
#import "GamePlayRenderingLayer.h"

CCParticleHeroBlood *heroBloodParticle;

@implementation CCHero

@synthesize normalFrontAnim = _normalFrontAnim;
@synthesize normalBackAnim = _normalBackAnim;
@synthesize normalSideAnim = _normalSideAnim;
@synthesize withGoldFrontAnim = _withGoldFrontAnim;
@synthesize withGoldBackAnim = _withGoldBackAnim;
@synthesize withGoldSideAnim = _withGoldSideAnim;

@synthesize facingDirection = _facingDirection;
@synthesize goldInPossession = _goldInPossession;

-(void) dealloc {
    [_normalFrontAnim release];
    [_normalBackAnim release];
    [_normalSideAnim release];
    
    [_withGoldFrontAnim release];
    [_withGoldBackAnim release];
    [_withGoldSideAnim release];
    
    _normalFrontAnim = nil;
    _normalBackAnim = nil;
    _normalSideAnim = nil;
    
    _withGoldFrontAnim = nil;
    _withGoldBackAnim = nil;
    _withGoldSideAnim = nil;
    
    [super dealloc];
}

-(void) loadNormalAnimations {
    NSMutableArray *frontAnimFrames = [NSMutableArray array];
    [frontAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-normal-front-1.png"]];
    [frontAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-normal-front-2.png"]];
    [frontAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-normal-front-1.png"]];
    [frontAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-normal-front-3.png"]];
    
    NSMutableArray *backAnimFrames = [NSMutableArray array];
    [backAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-normal-back-1.png"]];
    [backAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-normal-back-2.png"]];
    [backAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-normal-back-1.png"]];
    [backAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-normal-back-3.png"]];
    
    NSMutableArray *sideAnimFrames = [NSMutableArray array];
    [sideAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-normal-side-1.png"]];
    [sideAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-normal-side-2.png"]];
    [sideAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-normal-side-1.png"]];
    [sideAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-normal-side-3.png"]];
    
    // set up walking animations
    _normalFrontAnim = [[CCAnimation animationWithFrames:frontAnimFrames delay:0.3f] retain];
    _normalBackAnim = [[CCAnimation animationWithFrames:backAnimFrames delay:0.3f] retain];
    _normalSideAnim = [[CCAnimation animationWithFrames:sideAnimFrames delay:0.3f] retain];
}

-(void) loadWithGoldAnimations {
    NSMutableArray *frontAnimFrames = [NSMutableArray array];
    [frontAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-with-gold-front-1.png"]];
    [frontAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-with-gold-front-2.png"]];
    [frontAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-with-gold-front-1.png"]];
    [frontAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-with-gold-front-3.png"]];
    
    NSMutableArray *backAnimFrames = [NSMutableArray array];
    [backAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-with-gold-back-1.png"]];
    [backAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-with-gold-back-2.png"]];
    [backAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-with-gold-back-1.png"]];
    [backAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-with-gold-back-3.png"]];
    
    NSMutableArray *sideAnimFrames = [NSMutableArray array];
    [sideAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-with-gold-side-1.png"]];
    [sideAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-with-gold-side-2.png"]];
    [sideAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-with-gold-side-1.png"]];
    [sideAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-with-gold-side-3.png"]];
    
    // set up walking animations
    _withGoldFrontAnim = [[CCAnimation animationWithFrames:frontAnimFrames delay:0.3f] retain];
    _withGoldBackAnim = [[CCAnimation animationWithFrames:backAnimFrames delay:0.3f] retain];
    _withGoldSideAnim = [[CCAnimation animationWithFrames:sideAnimFrames delay:0.3f] retain];
}

-(void) gettingBitten
{	
	if (!waitForHitToClear)
	{
		self.characterHealth = self.characterHealth - 20.0f;
		CCLOG(@"Hero getting bitten with life: %d", self.characterHealth);
		GamePlayRenderingLayer *layer = (GamePlayRenderingLayer *)[[self parent] parent];
		
		if (heroBloodParticle !=nil) { [self removeChild:heroBloodParticle cleanup:YES]; }
		heroBloodParticle = [[CCParticleHeroBlood alloc]init];
		heroBloodParticle.texture = [[CCTextureCache sharedTextureCache] addImage:@"blood.png"];
		heroBloodParticle.position = self.position;
		[layer addChild:heroBloodParticle z:9];
		heroBloodParticle.autoRemoveOnFinish = YES;
		waitForHitToClear=1;
		heroBloodParticle = nil;
	}
	
	if (waitForHitToClear) 
	{
		timer++; 
		if (timer==5) 
		{
			timer=0; 
			waitForHitToClear=0;
		}
	}
}

-(void)changeState:(CharacterStates)newState {
    if (newState == kStateIdle) {
        [self stopAllActions];
    }
    
    if (characterState == newState) {
        // no change to state, quit here
        return;
    }
    
	[self setCharacterState:newState];
	
	id action = nil;
	
	switch (newState) {
        case kStateIdle:
			break;
        case kStateWalking:
			action = [self getAnimation:_facingDirection forState:newState];
			if (action == nil) {
				[self stopAllActions];
			}
			else {
				[self runAction:action];
			}
            break;
        case kStateAttacking:
			break;
        case kStateTakingDamage:
			[self gettingBitten];
			//set to walking after bite!
			[self changeState:kStateWalking];
			break;
        case kStateDead:
            break;
        default:
            break;
    }
	
}

-(void)updateStateWithEnemies:(ccTime)deltaTime andListOfGameObjects:(CCArray*)listOfGameObjects
{
	//if (self.characterState == kStateDead) 
	//  return; // Nothing to do if the Viking is dead
    
    //if ((self.characterState == kStateTakingDamage) && ([self numberOfRunningActions] > 0))
	//  return; // Currently playing the taking damage animation
    
    // Check for collisions
    // Change this to keep the object count from querying it each time
    CGRect myBoundingBox = [self adjustedBoundingBox];
    for (GameCharacter *character in listOfGameObjects) {
        CGRect characterBox = [character adjustedBoundingBox];
        if (CGRectIntersectsRect(myBoundingBox, characterBox)) {
            // Remove the PhaserBullet from the scene
            if ([character gameObjectType] == kEnemyTypeZombie) {
                [self changeState:kStateTakingDamage];
            }
        }
    }    
}

-(id)getAnimation:(FacingDirection)direction forState:(CharacterStates)state {
    
    id action = nil;
    
    switch (direction) {
        case kFacingDown:
            _facingDirection = direction;
            
            if (state == kStateWalking) {
                action = [[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:_normalFrontAnim restoreOriginalFrame:YES]] retain];
            }
            else if (state == kStateCarryingGold) {
                action = [[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:_withGoldFrontAnim restoreOriginalFrame:YES]] retain];
            }
            break;
        case kFacingUp:
            _facingDirection = direction;
            
            if (state == kStateWalking) {
                action = [[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:_normalBackAnim restoreOriginalFrame:YES]] retain];
            }
            else if (state == kStateCarryingGold) {
                action = [[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:_withGoldBackAnim restoreOriginalFrame:YES]] retain];
            }
            break;
        case kFacingLeft:
            if (self.flipX) {
                self.flipX = NO;
            }
			
            _facingDirection = direction;
            
            if (state == kStateWalking) {
                action = [[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:_normalSideAnim restoreOriginalFrame:YES]] retain];
            }
            else if (state == kStateCarryingGold) {
                action = [[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:_withGoldSideAnim restoreOriginalFrame:YES]] retain];
            }
            break;
			
        default:
            if (!self.flipX) {
                self.flipX = YES;
            }
			
            _facingDirection = direction;
            
            if (state == kStateWalking) {
                action = [[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:_normalSideAnim restoreOriginalFrame:YES]] retain];
            }
            else if (state == kStateCarryingGold) {
                action = [[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:_withGoldSideAnim restoreOriginalFrame:YES]] retain];
            }
            break;
    }
    
    return action;
}

-(void) adjustAnimation:(FacingDirection)direction {
    if (_facingDirection == direction) {
        return;
    }
    
    id action = [self getAnimation:direction forState:characterState];
        
    if (action == nil) {
        [self stopAllActions];
    }
    else {
        [self runAction:action];
    }
}

-(id) init
{
    if( (self=[super init]) )
    {
        _facingDirection = kFacingDown;
		self.gameObjectType = kHeroType;
        characterState = kStateWalking;
        
		timer = 0;
		waitForHitToClear = 0;
		
        [self loadNormalAnimations];
        [self loadWithGoldAnimations];
    }
    return self;
}

@end
