//
//  GamePlayerInputLayer.m
//  TileGame
//
//  Created by Shingo Tamura on 8/09/12.
//
//

#import "GamePlayInputLayer.h"
#import "GamePlayRenderingLayer.h"
#import "SneakyJoystick.h"
#import "SneakyJoystickSkinnedJoystickExample.h"
#import "SneakyJoystickSkinnedDPadExample.h"
#import "SneakyButton.h"
#import "SneakyButtonSkinnedBase.h"
#import "ColoredCircleSprite.h"
#import "CCActor.h"
#import "CCHero.h"

@implementation GamePlayInputLayer

@synthesize movingThreshold = _movingThreshold;

- (void) dealloc
{
    [_rightButton release];
    _rightButton = nil;
    
	[super dealloc];
}

-(CGPoint) applyVelocity: (CGPoint)velocity position:(CGPoint)position delta:(ccTime)delta {
	return CGPointMake(position.x + velocity.x * delta, position.y + velocity.y * delta);
}

-(void)applyDirectionalJoystick:(SneakyJoystick*)joystick toNode:(CCHero*)node forTimeDelta:(ccTime)delta
{
	// you can create a velocity specific to the node if you wanted, just supply a different multiplier
	// which will allow you to do a parallax scrolling of sorts
	//CGPoint scaledVelocity = ccpMult(joystick.velocity, 240.0f);
    
    if (joystick.isActive) {
        // apply the scaled velocity to the position over delta
        //[_gameLayer moveHero:node.position];
        //node.position = [self applyVelocity:scaledVelocity position:node.position delta:delta];
        
        _tmpMovingDelta += delta;
        
        if (_tmpMovingDelta >= _movingThreshold) {
            CGPoint newPosition = ccp(node.position.x, node.position.y);
            
            _tmpMovingDelta = 0.0f;
            
            FacingDirection dir;
			
			float degreeOffset = 1.41; // 45 degree angle is squareroot of 2 which is approx 1.41
			
			//Facing direction of hero
            if (joystick.degrees > 22.5f && joystick.degrees < 67.5f) {
                // NE
                dir = kFacingRight;
                newPosition.y += node.speed/degreeOffset;
				newPosition.x += node.speed/degreeOffset;
            }
			else if (joystick.degrees >= 67.5f && joystick.degrees <= 112.5) {
                // N
                dir = kFacingUp;
                newPosition.y += node.speed;
            }
			else if (joystick.degrees > 112.5f && joystick.degrees < 157.5f) {
                // NW
                dir = kFacingLeft;
                newPosition.y += node.speed/degreeOffset;
				newPosition.x -= node.speed/degreeOffset;
            }
			else if (joystick.degrees >= 157.5f && joystick.degrees <= 202.5f) {
                // W
                dir = kFacingLeft;
                newPosition.x -= node.speed;
            }
            else if (joystick.degrees > 202.5f && joystick.degrees < 247.5f) {
                // SW
                dir = kFacingLeft;
                newPosition.x -= node.speed/degreeOffset;
				newPosition.y -= node.speed/degreeOffset;
            }
            else if (joystick.degrees >= 247.5f && joystick.degrees <= 292.5f) {
                // S
                dir = kFacingDown;
                newPosition.y -= node.speed;
            }
			else if (joystick.degrees >= 292.5f && joystick.degrees <= 337.5f) {
                // SE
                dir = kFacingRight;
                newPosition.x += node.speed/degreeOffset;
				newPosition.y -= node.speed/degreeOffset;
            }
            else {
                // E
                dir = kFacingRight;
                newPosition.x += node.speed;
            }            
			
            [_gameLayer moveHero:newPosition facing:dir];
        }
    }
}

-(void)applyCollectionButton:(SneakyButton*)button toNode:(CCHero*)node forTimeDelta:(ccTime)delta
{
    // If button is currently pressed/active...
    if (button.active) {
        
        // And previous state of button is either released or static...
        if (_buttonState == kStateReleased || _buttonState == kStateStatic) {
            // Then notify hero
            [_gameLayer pickupGold:node.position facing:node.facingDirection];
        }
        
        // Whatever the current state is, set it to pressed
        _buttonState = kStatePressed;
    }
    else {
        // button is currently not pressed
        
        // If previous state of button is 'pressed'...
        if (_buttonState == kStatePressed) {
            // Notify that button's been just released
            _buttonState = kStateReleased;
            [_gameLayer dropGold:node.position facing:node.facingDirection];
        }
        else if (_buttonState == kStateReleased) {
            // previously state was 'released', set it to 'static' now
            _buttonState = kStateStatic;
        }
    }
}


-(void)update:(ccTime)deltaTime {
    // need to add [glView setMultipleTouchEnabled:YES]; to AppDelegate.m to enable multi-touch
    [self applyDirectionalJoystick:_leftJoystick toNode:_gameLayer.player forTimeDelta:deltaTime];
    [self applyCollectionButton:_rightButton toNode:_gameLayer.player forTimeDelta:deltaTime];
}

-(void) onEnter
{
    CCLOG(@"HelloWorldHud onEnter.");
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:2 swallowsTouches:YES];
    [super onEnter];
}
-(void) onExit
{
    CCLOG(@"HelloWorldHud onExit.");
    [[CCTouchDispatcher sharedDispatcher] removeDelegate: self];
    [super onExit];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"HelloWorldHud touched.");
	return NO;
}

-(void)initJoystickAndButtons {
    // initialize a joystick
    SneakyJoystickSkinnedBase *leftJoy = [[[SneakyJoystickSkinnedBase alloc] init] autorelease];
    leftJoy.position = ccp(64, 64);
    leftJoy.backgroundSprite = [CCSprite spriteWithFile:@"wheel.png"];
    leftJoy.thumbSprite = [CCSprite spriteWithFile:@"lever.png"];
    leftJoy.joystick = [[SneakyJoystick alloc] initWithRect:CGRectMake(0,0,128,128)];
    _leftJoystick = [leftJoy.joystick retain];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    SneakyButtonSkinnedBase *rightButton = [[[SneakyButtonSkinnedBase alloc] init] autorelease];
    rightButton.position = ccp(winSize.width-64.0f, 64.0f);
    
    //hook images to button control
    rightButton.defaultSprite = [CCSprite spriteWithFile:@"released.png"];
    rightButton.activatedSprite = [CCSprite spriteWithFile:@"grabbed.png"];
    rightButton.pressSprite = [CCSprite spriteWithFile:@"grabbed.png"];
    rightButton.button = [[SneakyButton alloc] initWithRect:CGRectMake(0, 0, 128, 128)];
    [rightButton.button setRadius:128.0f];
    _rightButton = [rightButton.button retain];
    _rightButton.isHoldable = YES;
    
    [self addChild:leftJoy z:2];
    [self addChild:rightButton z:2];
}

-(id) init
{
    if ((self = [super init])) {
        self.isTouchEnabled = YES;
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        _label = [CCLabelTTF labelWithString:@"0" dimensions:CGSizeMake(50, 30)
                                   alignment:UITextAlignmentRight fontName:@"Verdana-Bold"
                                    fontSize:26.0];
        
        _label.color = ccc3(255,255,255);
        int margin = 10;
        _label.position = ccp((winSize.width/2) - (_label.contentSize.width/2)
                              - margin, _label.contentSize.height/2 + margin);
        
        [self addChild:_label];
        
        [self initJoystickAndButtons];
        [self scheduleUpdate];
        
        _movingThreshold = 0.2f;
        _attackingThreshold = 0.8f;
        
        _tmpAttackingDelta = _attackingThreshold;
        _tmpMovingDelta = _movingThreshold;
    }
    return self;
}

- (void)melonCountChanged:(int)melonCount {
    [_label setString:[NSString stringWithFormat:@"%d", melonCount]];
}

@synthesize gameLayer = _gameLayer;

@end
