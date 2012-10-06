//
//  CCArrow.m
//  TileGame
//
//  Created by Shingo Tamura on 6/10/12.
//
//

#import "Arrow.h"

@implementation Arrow

-(void) dealloc {
    [super dealloc];
}

-(void)show {
    if (!self.visible) {
        self.visible = YES;
        
        if (_animationHandle != nil) {
            [self stopAction:_animationHandle];
            _animationHandle = nil;
        }
        
        CGPoint base = ccp(self.contentSize.width / 2.0f, self.contentSize.height * 1.1);
        self.position = base;
        CGPoint dest = ccp(self.contentSize.width / 2.0f, self.contentSize.height / 1.1f);
        id moveDown = [CCMoveTo actionWithDuration:0.4f position:dest];
        id moveBackUp = [CCMoveTo actionWithDuration:0.2f position:base];
        id sequence = [CCSequence actions:moveDown, moveBackUp, nil];
        _animationHandle = [CCRepeatForever actionWithAction:sequence];
        
        [self runAction:_animationHandle];
        [_animationHandle retain];
    }
}

-(void)hide {
    if (self.visible) {
        self.visible = NO;
        
        if (_animationHandle != nil) {
            [self stopAction:_animationHandle];
        }
    }
}

-(id) init
{
    if( (self=[super init]) )
    {
        self.visible = NO;
    }
    return self;
}

@end
