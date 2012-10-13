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
@synthesize icon = _icon;

- (void) dealloc
{
	[super dealloc];
}

-(void) showStatus:(GoldCart*)cart amount:(int)amount {
    CGFloat percentage = 100.0f * ((CGFloat)amount / (CGFloat)cart.capacity);
    
    [_goldGauge setPercentage:percentage];
}

-(void) onEnter
{
    [super onEnter];
    [self initGoldGauge];
}

-(void) initGoldGauge {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CGSize pixelWinSize = [[CCDirector sharedDirector] winSizeInPixels];
    
    CGFloat queueX = winSize.width;
    CGFloat padding = 8.0f; // 8px
    CGFloat y = winSize.height - 16.0f - padding; // 16.0f = half the height of sprite
    
    if (pixelWinSize.width == 1136 || pixelWinSize.width == 960) {
        _goldGauge = [CCProgressTimer progressWithFile:@"gold-bar-retina.png"];
    }
    else {
        _goldGauge = [CCProgressTimer progressWithFile:@"gold-bar.png"];
    }
    _goldGauge.type = kCCProgressTimerTypeHorizontalBarLR;
    _goldGauge.percentage = 0.0f;
    queueX -= ((_goldGauge.contentSize.width / 2.0f) + padding);
    _goldGauge.position = ccp(queueX, y);
    [self addChild:_goldGauge];
    
    _icon = [[CCSprite alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"cart-with-gold-front.png"]];
    queueX -= ((_goldGauge.contentSize.width / 2.0f) + (_icon.contentSize.width / 2.0f) + padding);
    _icon.position = ccp(queueX, y);
    [self addChild:_icon];
}

-(id) init
{
    if ((self = [super init])) { }
    return self;
}

@end
