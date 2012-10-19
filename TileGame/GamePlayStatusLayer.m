//
//  GamePlayGoldLayer.m
//  TileGame
//
//  Created by Shingo Tamura on 11/10/12.
//
//

#import "GamePlayStatusLayer.h"
#import "GoldCart.h"

@implementation GamePlayStatusLayer

@synthesize gameLayer = _gameLayer;
@synthesize goldGauge = _goldGauge;
@synthesize healthGauge = _healthGauge;
@synthesize icon = _icon;

- (void) dealloc
{
	[super dealloc];
}

-(void) showStatus:(GoldCart*)cart amount:(int)amount {
    CGFloat percentage = 100.0f * ((CGFloat)amount / (CGFloat)cart.capacity);
    
    [_goldGauge setPercentage:percentage];
}

-(void) showHealth:(int)amount
{
	CGFloat percentage = 100.0f * ((CGFloat)amount / kHeroInitialHealth);
	[_healthGauge setPercentage:percentage];
}

-(void) initGoldGauge {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    CGFloat queueX = winSize.width;
    CGFloat padding = 8.0f; // 8px
    CGFloat y = winSize.height - 16.0f - padding; // 16.0f = half the height of sprite
    
    _goldGauge = [CCProgressTimer progressWithFile:@"gold-bar.png"];
    _goldGauge.type = kCCProgressTimerTypeHorizontalBarLR;
    _goldGauge.percentage = 0.0f;
    queueX -= ((_goldGauge.contentSize.width / 2.0f) + padding);
    _goldGauge.position = ccp(queueX, y);
    [self addChild:_goldGauge];
    
    _icon = [[CCSprite alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"cart-with-gold-front-1.png"]];
    queueX -= ((_goldGauge.contentSize.width / 2.0f) + (_icon.contentSize.width / 2.0f) + padding);
    _icon.position = ccp(queueX, y);
    [self addChild:_icon];
}

-(void) initHealthGauge {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    CGFloat padding = 8.0f; // 8px
    CGFloat y = winSize.height - 16.0f - padding; // 16.0f = half the height of sprite
    
    _healthGauge = [CCProgressTimer progressWithFile:@"blood-bar.png"];
    _healthGauge.type = kCCProgressTimerTypeHorizontalBarLR;
    _healthGauge.percentage = 0.0f;
    CGFloat queueX = ((_healthGauge.contentSize.width / 2.0f) + padding);
	
    _healthGauge.position = ccp(queueX, y);
    [self addChild:_healthGauge];
    
    _icon = [[CCSprite alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"miner-normal-front-1.png"]];
    queueX = ((_healthGauge.contentSize.width / 2.0f) + (_icon.contentSize.width / 2.0f) + padding);
    _icon.position = ccp(padding, y);
    [self addChild:_icon];
	
	[_healthGauge setPercentage:100];
}

-(void) onEnter
{
    [super onEnter];
    [self initGoldGauge];
	[self initHealthGauge];
}

-(id) init
{
    if ((self = [super init])) { }
    return self;
}

@end
