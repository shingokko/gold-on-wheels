//
//  CCParticleHeroBlood.m
//  TileGame
//
//  Created by Sam Christian Lee on 10/16/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CCParticleHeroBlood.h"

@implementation CCParticleHeroBlood

-(id) init
{
	return [self initWithTotalParticles:50]; //955
}

-(id) initWithTotalParticles:(int)p
{
	if( (self=[super initWithTotalParticles:p]) ) {
		
		// duration
		duration = 0.01f;
		
		self.emitterMode = kCCParticleModeGravity;
		
		// Gravity Mode: gravity
		self.gravity = ccp(-118,-2013);
		
		// Gravity Mode: speed of particles
		self.speed = 0;
		self.speedVar = 440.7;
		
		// Gravity Mode: radial
		self.radialAccel = 100;
		self.radialAccelVar = 100;
		
		// Gravity Mode: tagential
		//self.tangentialAccel = 0;
		//self.tangentialAccelVar = 0;
		
		// angle
		angle = 360;
		angleVar = 360;
		
		// emitter position
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		self.position = ccp(winSize.width/2, winSize.height/2);
		posVar = CGPointZero;
		
		// life of particles
		life = 0;
		lifeVar = 0.724;
		
		// size, in pixels
		startSize = 3;
		startSizeVar = 2.0f;
		endSize = kCCParticleStartSizeEqualToEndSize;
		
		// emits per second
		emissionRate = totalParticles/duration;
		
		// color of particles
		startColor.r = 1.0f;
		startColor.g = 0.0f;
		startColor.b = 0.0f;
		startColor.a = 1.0f;
		startColorVar.r = 0.0f;
		startColorVar.g = 0.0f;
		startColorVar.b = 0.0f;
		startColorVar.a = 0.0f;
		endColor.r = 1;
		endColor.g = 0.0f;
		endColor.b = 0.0f;
		endColor.a = 1.0f;
		endColorVar.r = 0.0f;
		endColorVar.g = 0.0f;
		endColorVar.b = 0.0f;
		endColorVar.a = 0.0f;
		
		//self.texture = [[CCTextureCache sharedTextureCache] addImage: @"blood.png"];
		
		// additive
		self.blendAdditive = NO;
	}
	
	return self;
}

@end
