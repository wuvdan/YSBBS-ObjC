//
//  SocketRocketManager.h
//  WebSocket
//
//  Created by huangqizai on 2018/6/26.
//  Copyright © 2018年 FYCK. All rights reserved.
//

//#import <Foundation/Foundation.h>
//
//@interface SocketRocketManager : NSObject
//
//@end


#import <Foundation/Foundation.h>
#import <SocketRocket.h>

extern NSString * const kNeedPayOrderNote;
extern NSString * const kWebSocketDidOpenNote;
extern NSString * const kWebSocketDidCloseNote;
extern NSString * const kWebSocketdidReceiveMessageNote;

@interface SocketRocketManager : NSObject

// 获取连接状态
@property (nonatomic,assign,readonly) SRReadyState socketReadyState;

+ (SocketRocketManager *)instance;

- (void)SRWebSocketOpenWithURLString:(NSString *)urlString;//开启连接
- (void)SRWebSocketClose;//关闭连接
- (void)sendData:(id)data;//发送数据

@end
