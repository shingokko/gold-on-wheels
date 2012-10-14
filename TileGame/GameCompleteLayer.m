//
//  GameCompleteLayer.m
//  TileGame
//
//  Created by Shingo Tamura on 12/10/12.
//
//

#import "GameCompleteLayer.h"

@implementation GameCompleteLayer
@synthesize gameLayer = _gameLayer;
@synthesize isInProgress = _isInProgress;

-(void) animationDone {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"animationDone" object:self ];
    self.isInProgress = NO;
}

-(void) startAnimation {
    self.isInProgress = YES;
        
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CGSize pixelSize = [[CCDirector sharedDirector] winSizeInPixels];
    
    // Title
    CCSprite *title;
    if (pixelSize.width == 1136 || pixelSize.width == 960) {
        title = [CCSprite spriteWithFile:@"you-win-retina.png"];
    }
    else {
        title = [CCSprite spriteWithFile:@"you-win.png"];
    }
    title.position = ccp(winSize.width * 0.5, winSize.height * 3.0f);
    title.scale = 5.0f;
    title.opacity = 0.0f;
    
    id actionTitleFade = [CCFadeTo actionWithDuration:1.5f opacity:255.0f];
    id actionTitleMove = [CCMoveTo actionWithDuration:1.5f position:ccp(winSize.width * 0.5, winSize.height * 0.5)];
    id actionTitleScale = [CCScaleTo actionWithDuration:1.5f scale:1.0f];
    id bounceTitleMove = [CCEaseBounceOut actionWithAction:actionTitleMove];
    
    [self addChild:title z:2];
    
    id actionLayer = [CCFadeIn actionWithDuration:0.3];
    [self runAction:actionLayer];
    
    [title runAction:actionTitleFade];
    [title runAction:actionTitleScale];
    [title runAction:bounceTitleMove];
    
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:10], [CCCallFunc actionWithTarget:self selector:@selector(animationDone)], nil]];
}

-(id) init
{
    if ((self=[super initWithColor:ccc4(255, 255, 255, 0)])) {
        self.isInProgress = NO;
    }
    return self;
}

@end
