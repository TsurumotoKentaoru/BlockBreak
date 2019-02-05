//
//  PlayViewController.m
//  BlockBreak
//
//  Created by 鶴本賢太朗 on 2016/02/16.
//  Copyright © 2016年 鶴本賢太朗. All rights reserved.
//

#import "PlayViewController.h"
#import "define.h"
@implementation PlayViewController
{
    UIView *m_controlBar;// バー
    UIImageView *m_ball;// ボール
    NSMutableArray *m_blockArray;// ブロックを格納する
    NSTimer *m_gameFrame;// ゲームフレーム
    BallDirection m_nowBallDirection;// 現在のボールの方向
    NSInteger m_breakBlockCount;// 壊したブロックの数
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [self Initialize];// 初期化
    m_gameFrame = [NSTimer scheduledTimerWithTimeInterval:GAMEFRAME target:self selector:@selector(GameFrame) userInfo:nil repeats:YES];
}

// ボールを移動させる
-(void)transformBall
{
    CGRect rect = m_ball.frame;
    switch(m_nowBallDirection)
    {
        case UP_RIGHT:
            rect.origin.x++;
            rect.origin.y--;
            break;
        case UP_LEFT:
            rect.origin.x--;
            rect.origin.y--;
            break;
        case DOWN_RIGHT:
            rect.origin.x++;
            rect.origin.y++;
            break;
        case DOWN_LEFT:
            rect.origin.x--;
            rect.origin.y++;
            break;
        default:
            break;
    }
    m_ball.frame = rect;
}

// ボールの当たり判定を行う
// 当たった場合どこの部分に当たったかを返す
-(BallCollisionObject)checkCollisionBall:(UIView*)gameObject GameObjectType:(GameObjectType)gameObjectType
{
    // ゲームオブジェクトとボールの左と右のx座標
    float objRight,objLeft,ballLeft,ballRight;
    objRight = gameObject.frame.origin.x + gameObject.frame.size.width;
    objLeft = gameObject.frame.origin.x;
    ballRight = m_ball.frame.origin.x + m_ball.frame.size.width;
    ballLeft = m_ball.frame.origin.x;
    
    // ゲームオブジェクトとボールの上と下のy座標
    float objTop,objButtom,ballTop,ballButtom;
    objTop = gameObject.frame.origin.y;
    objButtom = gameObject.frame.origin.y + gameObject.frame.size.height;
    ballTop = m_ball.frame.origin.y;
    ballButtom = m_ball.frame.origin.y + m_ball.frame.size.height;
    
    BOOL isHitX = (objLeft < ballRight && objRight > ballLeft);// x座標で重なっているか
    BOOL isHitY = (objButtom > ballTop && objTop < ballButtom);// y座標で重なっているか
    
    // 衝突している場合
    if(YES == isHitX && true == isHitY)
    {
        // ゲームオブジェクトがバーだった場合
        if(BAR == gameObjectType)
        {
            // バーの左側に当たった
            if(m_ball.frame.origin.x + m_ball.frame.size.width / 2 < m_controlBar.frame.origin.x + m_controlBar.frame.size.width / 2)
                return BAR_LEFT;
            // 右側
            else
                return BAR_RIGHT;
        }
        
        // ゲームオブジェクトがブロックだった場合
        // ブロックはボールがふたつの方向のどちらがよりブロックに重なっているかで当たっている部分を判定する
        else if(BLOCK == gameObjectType)
        {
            // ボールが左方向から来た場合
            if(m_nowBallDirection == DOWN_LEFT || m_nowBallDirection == UP_LEFT)
            {
                // 当たっている部分がブロックの上か左か判定
                if(m_nowBallDirection == DOWN_LEFT)
                {
                    float dx,dy;
                    dx = objRight - ballLeft;
                    dy = ballButtom - objTop;
                    return (dx < dy)? BLOCK_RIGHT:BLOCK_TOP;
                }
                // 当たっている部分がブロックの下か左か判定
                else
                {
                    float dx,dy;
                    dx = objRight - ballLeft;
                    dy = objButtom - ballTop;
                    return (dx < dy)? BLOCK_RIGHT:BLOCK_BUTTOM;
                }
            }
            // ボールが右方向から来た場合
            else
            {
                // 当たっている部分がブロックの上か右か判定
                if(m_nowBallDirection == DOWN_RIGHT)
                {
                    float dx,dy;
                    dx = ballRight - objLeft;
                    dy = ballButtom - objTop;
                    return (dx < dy)? BLOCK_LEFT:BLOCK_TOP;
                }
                // 当たっている部分がブロックの下か右か判定
                else
                {
                    float dx,dy;
                    dx = ballRight - objLeft;
                    dy = objButtom - ballTop;
                    return (dx < dy)? BLOCK_LEFT:BLOCK_BUTTOM;
                }
            }
        }
        else{}
    }
    return NOTHING;// 当たっていない
}

// ボールの方向を変える
-(void)changeBallDirection:(BallCollisionObject)objectNumber
{
    switch(objectNumber)
    {
            // 壁の場合
        case WALL_TOP:
            if(UP_RIGHT == m_nowBallDirection)
            {
                m_nowBallDirection = DOWN_RIGHT;
                break;
            }
            else
            {
                m_nowBallDirection = DOWN_LEFT;
                break;
            }
        case WALL_RIGHT:
            if(UP_RIGHT == m_nowBallDirection)
            {
                m_nowBallDirection = UP_LEFT;
                break;
            }
            else
            {
                m_nowBallDirection = DOWN_LEFT;
                break;
            }
        case WALL_LEFT:
            if(UP_LEFT == m_nowBallDirection)
            {
                m_nowBallDirection = UP_RIGHT;
                break;
            }
            else
            {
                m_nowBallDirection = DOWN_RIGHT;
                break;
            }
            
            // ブロックの場合
        case BLOCK_TOP:
            if(DOWN_RIGHT == m_nowBallDirection)
            {
                m_nowBallDirection = UP_RIGHT;
                break;
            }
            else
            {
                m_nowBallDirection = UP_LEFT;
                break;
            }
        case BLOCK_RIGHT:
            if(UP_LEFT == m_nowBallDirection)
            {
                m_nowBallDirection = UP_RIGHT;
                break;
            }
            else
            {
                m_nowBallDirection = DOWN_RIGHT;
                break;
            }
        case BLOCK_LEFT:
            if(UP_RIGHT == m_nowBallDirection)
            {
                m_nowBallDirection = UP_LEFT;
                break;
            }
            else
            {
                m_nowBallDirection = DOWN_LEFT;
                break;
            }
        case BLOCK_BUTTOM:
            if(UP_RIGHT == m_nowBallDirection)
            {
                m_nowBallDirection = DOWN_RIGHT;
                break;
            }
            else
            {
                m_nowBallDirection = DOWN_LEFT;
                break;
            }
            // バーの場合
        case BAR_RIGHT:
        {
            m_nowBallDirection = UP_RIGHT;
            break;
        }
        case BAR_LEFT:
        {
            m_nowBallDirection = UP_LEFT;
            break;
        }
        default:
            break;
    }
}

// ボールが当たった場合のボールの方向を変更する
-(void)Update
{
    for(int i = 0; i < [m_blockArray count]; i++)
    {
        UIView *blockView = [m_blockArray objectAtIndex:i];
        BallCollisionObject collisionObject = [self checkCollisionBall:blockView GameObjectType:BLOCK];
        //ブロックに当たった場合
        if(NOTHING != collisionObject && false == blockView.hidden)
        {
            blockView.hidden = YES;
            m_breakBlockCount++;// 壊したブロック数を+1する
            [self changeBallDirection:collisionObject];
            break;
        }
    }
    
    BallCollisionObject collisionObject = [self checkCollisionBall:m_controlBar GameObjectType:BAR];
    // バーに当たった場合
    if(NOTHING != collisionObject)
        [self changeBallDirection:collisionObject];
    
    float ballLeft,ballRight,ballTop,ballButtom;
    ballRight = m_ball.frame.origin.x + m_ball.frame.size.width;
    ballLeft = m_ball.frame.origin.x;
    ballTop = m_ball.frame.origin.y;
    ballButtom = m_ball.frame.origin.y + m_ball.frame.size.height;
    
    // 左の壁に当たった場合
    if(ballLeft <= 0)
    {
        [self changeBallDirection:WALL_LEFT];
    }
    // 右の壁に当たった場合
    if(ballRight >= self.view.frame.size.width)
    {
        [self changeBallDirection:WALL_RIGHT];
    }
    // 上の壁に当たった場合
    if(ballTop <= 0)
    {
        [self changeBallDirection:WALL_TOP];
    }
}

// クリアしたかゲームオーバーかチェックする
-(void)checkGameClearORGameOver
{
    // クリアしたかどうか
    if(m_breakBlockCount == [m_blockArray count])
    {
        [self performSegueWithIdentifier:@"PushClear" sender:nil];
        [m_gameFrame invalidate];
    }
    
    // ゲームオーバーかどうか
    if(m_ball.frame.origin.y >= self.view.frame.size.height)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

// ゲームの１フレーム
-(void)GameFrame
{
    [self transformBall];// ボールの移動
    [self Update];// ボールが当たった場合のボールの方向を変更する
    [self checkGameClearORGameOver];// クリアしたかゲームオーバーかチェックする
}

// バーを移動させる
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if(touch.view == m_controlBar)
    {
        CGPoint prePosition = [touch previousLocationInView:m_controlBar];
        CGPoint nowPosition = [touch locationInView:m_controlBar];
        CGRect newControlBarPos = m_controlBar.frame;
        newControlBarPos.origin.x += nowPosition.x - prePosition.x;
        
        // バーが画面からはみ出ないようにする
        if(newControlBarPos.origin.x + m_controlBar.frame.size.width >= self.view.frame.size.width || newControlBarPos.origin.x <= 0)
            return;
        
        m_controlBar.frame = newControlBarPos;
    }
}

// ポーズボタン押下
- (IBAction)Pause:(UIButton*)sender
{
    if(true == [m_gameFrame isValid])
    {
        [m_gameFrame invalidate];
        [sender setTitle:@"再開" forState:UIControlStateNormal];
    }
    else
    {
        m_gameFrame = [NSTimer scheduledTimerWithTimeInterval:GAMEFRAME target:self selector:@selector(GameFrame) userInfo:nil repeats:YES];
        [sender setTitle:@"ポーズ" forState:UIControlStateNormal];
    }
}

// ブロック、コントロールバー、ボールを生成する
-(void)Initialize
{
    m_blockArray = [NSMutableArray array];
    m_nowBallDirection = UP_RIGHT;// 最初は右上にボールを飛ばす
    m_breakBlockCount = 0;
    float blockViewLength = self.view.frame.size.width / BLOCKCOUNT_WIDTH;// ブロックのviewの一辺の長さ
    
    for(int i = 0; i < BLOCKCOUNT_WIDTH * BLOCKCOUNT_HEIGHT; i++)
    {
        float oriX,oriY;// ブロックを生成する位置(x,y)
        
        // 一行目のブロックの位置を計算
        if(i < BLOCKCOUNT_WIDTH)
        {
            oriX = i * blockViewLength;
            oriY = i / BLOCKCOUNT_WIDTH * blockViewLength;
        }
        // 二行目以降のブロックの位置を計算
        else
        {
            oriX = (i % BLOCKCOUNT_WIDTH) * blockViewLength;
            oriY = i / BLOCKCOUNT_WIDTH * blockViewLength;
        }
        UIView* blockView = [[UIView alloc] initWithFrame:CGRectMake(oriX, oriY, blockViewLength, blockViewLength)];
        blockView.backgroundColor = [UIColor redColor];
        blockView.transform = CGAffineTransformMakeScale(0.9, 0.5);// 縮小して隙間を開ける
        [m_blockArray addObject:blockView];
        [self.view addSubview:blockView];
    }
    
    CGFloat selfViewWidth,selViewHeigth;
    selfViewWidth = self.view.frame.size.width;
    selViewHeigth = self.view.frame.size.height;
    
    m_controlBar = [[UIView alloc] initWithFrame:CGRectMake(selfViewWidth / 8 * 3, selViewHeigth / 4 * 3, selfViewWidth / 4, 20)];
    m_controlBar.backgroundColor = [UIColor blueColor];
    m_ball = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GoldBall"]];
    m_ball.frame = CGRectMake(selfViewWidth / 2, selViewHeigth / 4 * 3 - 20, BALLSIZE, BALLSIZE);
    
    [self.view addSubview:m_controlBar];
    [self.view addSubview:m_ball];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
