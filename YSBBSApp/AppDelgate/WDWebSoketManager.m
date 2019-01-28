//
//  WDWebSoketManager.m
//  YSBBSApp
//
//  Created by wudan on 2019/1/25.
//  Copyright © 2019 forever.love. All rights reserved.
//

#import "WDWebSoketManager.h"
#import <SocketRocket.h>

#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

@interface WDWebSoketManager () <SRWebSocketDelegate>

@property (nonatomic, strong) SRWebSocket *socket;
@property (nonatomic, weak) NSTimer * heartBeat;
@property (nonatomic, assign) NSTimeInterval reConnectTime;
@property (nonatomic, copy) NSString *urlString;



@end

@implementation WDWebSoketManager

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    static WDWebSoketManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[WDWebSoketManager alloc] init];
    });
    return manager;
}

- (void)contactToSeverWithUrlAddress:(NSString *)urlAddress {
    self.urlString = urlAddress;
    SRWebSocket *socket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlAddress]]];
    socket.delegate = self;
    [socket open];
    self.socket = socket;
}

- (void)closeContat {
    //    NSLog(@"************************** socket 关闭链连接************************** ");
    //    if (self.socket){
    //        [self.socket close];
    //        self.socket = nil;
    //        //断开连接时销毁心跳
    //        [self destoryHeartBeat];
    //    }
    
}

- (void)destoryHeartBeat {
    dispatch_main_async_safe(^{
        if (self.heartBeat) {
            if ([self.heartBeat respondsToSelector:@selector(isValid)]){
                if ([self.heartBeat isValid]){
                    [self.heartBeat invalidate];
                    self.heartBeat = nil;
                }
            }
        }
    })
}

//初始化心跳
- (void)initHeartBeat {
    //    dispatch_main_async_safe(^{
    //        [self destoryHeartBeat];
    //        //心跳设置为3分钟，NAT超时一般为5分钟
    //        self.heartBeat = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(sentheart) userInfo:nil repeats:YES];
    //        //和服务端约定好发送什么作为心跳标识，尽可能的减小心跳包大小
    //        [[NSRunLoop currentRunLoop] addTimer:self.heartBeat forMode:NSRunLoopCommonModes];
    //    })
}

-(void)sentheart{
    [self senderMessager:@"heart"];
}

- (void)ping {
    if (self.socket.readyState == SR_OPEN) {
        [self.socket sendPing:nil];
    }
}

- (void)senderMessager:(NSString *)messager {
    NSLog(@"发送消息：%@", messager);
    [self.socket send:messager];
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    self.reConnectTime = 0;
    if (webSocket == self.socket) {
        [self initHeartBeat];
        NSLog(@"************************** socket 连接成功************************** ");
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    if (webSocket == self.socket) {
        NSLog(@"************************** socket 连接失败************************** ");
        self.socket = nil;
        [self reConnectToSever];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    if (webSocket == self.socket) {
        NSLog(@"************************** socket 连接断开************************** ");
        NSLog(@"被关闭连接，code:%ld,reason:%@,wasClean:%d",(long)code,reason,wasClean);
        [self closeContat];
    }
}

-(void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    NSString *reply = [[NSString alloc] initWithData:pongPayload encoding:NSUTF8StringEncoding];
    NSLog(@"reply===%@",reply);
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message  {
    if (webSocket == self.socket) {
        NSLog(@"接受的消息:%@",message);
        NSLog(@"************************** socket 收到数据了************************** ");
        if (self.delegate && [self.delegate respondsToSelector:@selector(getMassageFromSeverWithInfo:)]) {
            [self.delegate getMassageFromSeverWithInfo:message];
        }
    }
}

#pragma mark - **************** private mothodes
//重连机制
- (void)reConnectToSever {
    [self closeContat];
    
    //超过一分钟就不再重连 所以只会重连5次 2^5 = 64
    if (self.reConnectTime > 64) {
        //您的网络状况不是很好，请检查网络后重试
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.reConnectTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.socket = nil;
        [self contactToSeverWithUrlAddress:self.urlString];
        NSLog(@"重连");
    });
    
    //重连时间2的指数级增长
    if (self.reConnectTime == 0) {
        self.reConnectTime = 2;
    }else{
        self.reConnectTime *= 2;
    }
}

@end
