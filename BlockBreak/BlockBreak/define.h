//
//  define.h
//  BlockBreak
//
//  Created by 鶴本賢太朗 on 2016/02/17.
//  Copyright © 2016年 鶴本賢太朗. All rights reserved.
//

#ifndef define_h
#define define_h

// 縦×横でブロック数を決定
#define BLOCKCOUNT_WIDTH 8
#define BLOCKCOUNT_HEIGHT 4
#define BALLSIZE 30
#define GAMEFRAME 0.005
// ボールの向き情報
typedef enum BallDirection
{
    UP_RIGHT,
    UP_LEFT,
    DOWN_RIGHT,
    DOWN_LEFT
}BallDirection;

// ボールがゲームオブジェクトのどこの部分に当たったかの情報
typedef enum BallCollisionObject
{
    WALL_RIGHT,
    WALL_TOP,
    WALL_LEFT,
    BLOCK_TOP,
    BLOCK_BUTTOM,
    BLOCK_RIGHT,
    BLOCK_LEFT,
    BAR_RIGHT,
    BAR_LEFT,
    NOTHING // 何も当たっていない
}BallCollisionObject;

// ゲームオブジェクトの種類
typedef enum GameObjectType
{
    BLOCK,
    BAR,
    BALL,
}GameObjectType;
#endif /* define_h */
