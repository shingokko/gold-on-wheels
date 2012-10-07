//
//  TitleScreenScene.m
//  TileGame
//
//  Created by Shingo Tamura on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TitleScreenScene.h"
#import "GamePlayRenderingLayer.h"
#import "SimpleAudioEngine.h"

/*@implementation TitleScreenScene


@end*/


@implementation TitleScreenScene
@synthesize layer = _layer;

- (id)init {
    if ((self = [super init])) {
        self.layer = [TitleScreenLayer node];
        [self addChild:_layer];
    }
    return self;
}

- (void)dealloc {
    [_layer release];
    _layer = nil;
    [super dealloc];
}
@end

@implementation TitleScreenLayer

- (void)startButtonTapped:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"selection.caf"];
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    [[CCDirector sharedDirector] replaceScene:[GamePlayRenderingLayer scene]];
}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	TitleScreenLayer *layer = [TitleScreenLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
	// return the scene
	return scene;
}


-(id) init {
    if ((self=[super initWithColor:ccc4(255, 255, 255, 255)])) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"selection.caf"];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"opening.mp3"];
        
        // Add sprites that make up the title screen
		CCSprite *bg = [CCSprite spriteWithFile:@"title-background.png"];
        bg.tag = 1;
        bg.anchorPoint = CGPointMake(0, 0);
        
		CCSprite *title = [CCSprite spriteWithFile:@"title-caption.png"];
        title.tag = 1;
        
        title.position = ccp(winSize.width * 0.5, winSize.height * 1.2f);
        
        id actionTitleMove = [CCMoveTo actionWithDuration:1.0f position:ccp(winSize.width * 0.5, winSize.height * 0.85)];
        id bounceTitleMove = [CCEaseBounceOut actionWithAction:actionTitleMove];
        
        [self addChild:bg z:0];
        [self addChild:title z:0];
        
        // Add start button
        CCMenuItem *button = [CCMenuItemImage itemFromNormalImage:@"start-button.png" selectedImage:@"start-button-clicked.png" target:self selector:@selector(startButtonTapped:)];
        button.position = ccp(winSize.width * 0.77, winSize.height * 0.2);
        
        CCMenu *starMenu = [CCMenu menuWithItems:button, nil];
        starMenu.position = CGPointZero;
        [self addChild:starMenu];
        
        [title runAction:bounceTitleMove];

    }
    return self;
}

-(void)dealloc {
    [super dealloc];
}
@end
