//
//  Gold.h
//  TileGame
//
//  Created by Shingo Tamura on 6/10/12.
//
//

#import "GameObject.h"

@interface Gold : GameObject {
    BOOL _collected;
    CCAnimation *_shineAnim;
    CCAnimate *_animationHandle;
}

@property (nonatomic, assign) BOOL collected;

-(void)collect;
-(void)uncollect;

@end