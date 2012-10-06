//
//  CCArrow.h
//  TileGame
//
//  Created by Shingo Tamura on 6/10/12.
//
//

#import "GameObject.h"

@interface Arrow : GameObject {
    CCAnimation *_pointAnim;
    CCAnimate *_animationHandle;
}

-(void)show;
-(void)hide;

@end