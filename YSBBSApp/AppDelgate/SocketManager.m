//
//  SocketManager.m
//  YSBBSApp
//
//  Created by wudan on 2019/1/25.
//  Copyright © 2019 forever.love. All rights reserved.
//

#import "SocketManager.h"

#import "SocketUtils.h"

#define kMaxReconnection_time 5//异常中断时，重连次数
/*
 socket断开连接后，为了不给服务器造成连接压力，必须控制重新连接的频率。否则一旦服务器出现异常，而客户端又不断向服务器发送连接请求，势必会给服务器雪上加霜，甚至出现崩溃的情况！所以限制重连次数
 */

@interface SocketManager ()<GCDAsyncSocketDelegate>
{
    GCDAsyncSocket *gcdSocket;
    int _reconnection_time;//重连次数
    NSTimer*_timer;
}
@property (nonatomic, strong) NSMutableData *readBuf;// 缓冲区
@property (nonatomic, retain) NSTimer        *connectTimer; // 心跳包计时器
@property (nonatomic, copy) NSString *url; //!< 接口
@property (nonatomic, assign) NSInteger port; //!< 端口号
@end

@implementation SocketManager

+ (instancetype)share {
    static dispatch_once_t onceToken;
    static SocketManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
        [instance initSocket];
    });
    return instance;
}

- (void)initSocket {
    gcdSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
}

// 建立连接
- (BOOL)connectWithUrl:(NSString *)url port:(NSInteger)port {
    
    if ([url hasPrefix:@"http://"]) {
        url=  [url stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    } else if ([url hasPrefix:@"https://"]) {
       url=  [url stringByReplacingOccurrencesOfString:@"https://" withString:@""];
    }
    
    self.url = url;
    self.port = port;
    
    return  [gcdSocket connectToHost:url onPort:port error:nil];
}

// 主动断开连接
- (void)disConnect {
    [gcdSocket disconnect];
    gcdSocket = nil;
    [_timer invalidate];
    _timer = nil;
    [self.connectTimer invalidate];
    self.connectTimer = nil;
}

// 发送消息
- (void)sendMsgWithLength:(int)length withsequenceId:(long)sequenceId withcmd:(short)cmd withVersion:(int)Version withRequestId:(int)RequestId withbody:(NSDictionary*)jsonDict {
    NSString* Terminal = @"1002";//4字节
    NSMutableData*Data = [[NSMutableData alloc]init];
    NSError *error = nil;
    if ([jsonDict isKindOfClass:[NSDictionary class]] ) {
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:&error];
        
        if ([jsonData length] > 0 &&error == nil) {
            [Data appendData:[SocketUtils bytesFromUInt32:(length+(int)jsonData.length)]];
        } else {
            [Data appendData:[SocketUtils bytesFromUInt32:length]];//4个字节
        }
        [Data appendData:[SocketUtils bytesFromUInt64:sequenceId]];//8个字节.token
        [Data appendData:[SocketUtils bytesFromUInt16:cmd]];//2字节
        [Data appendData:[SocketUtils bytesFromUInt32:Version]]; //4字节
        [Data appendData:[SocketUtils dataFromString:Terminal]];//4字节
        [Data appendData:[SocketUtils bytesFromUInt32:RequestId]];//4字节，标签
        [Data appendData:jsonData];
    } else {
        [Data appendData:[SocketUtils bytesFromUInt32:length]];//4个字节
        [Data appendData:[SocketUtils bytesFromUInt64:sequenceId]];//8个字节.token
        [Data appendData:[SocketUtils bytesFromUInt16:cmd]];//2字节
        [Data appendData:[SocketUtils bytesFromUInt32:Version]]; //4字节
        [Data appendData:[SocketUtils dataFromString:Terminal]];//4字节
        [Data appendData:[SocketUtils bytesFromUInt32:RequestId]];//4字节，标签
    }
    
    [gcdSocket writeData:Data withTimeout:-1 tag:0];
}
#pragma mark - GCDAsynSocket Delegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"socket---连接成功");
    // 存储接收数据的缓存区，处理数据的粘包和断包
    _readBuf = [[NSMutableData alloc] init];
    [gcdSocket readDataWithTimeout:-1 tag:0];
    self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(longConnectToSocket) userInfo:nil repeats:YES];
    [self.connectTimer fire];
}
// 心跳连接
-(void)longConnectToSocket{
    NSLog(@"socket---ping");
    [[SocketManager share] sendMsgWithLength:26 withsequenceId:0 withcmd:11004 withVersion:1 withRequestId: 0 withbody:nil];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"发送指令");
}

// 收到消息
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSLog(@"socket---收到消息");
    NSLog(@"socket---收到消息-%@", [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil]);
    [self didReadData:data withTag:tag];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    NSLog(@"socket---断开连接");
    if(_reconnection_time >= 0 && _reconnection_time <= kMaxReconnection_time) {
        [_timer invalidate];
        _timer = nil;
        int time = 2;//设置重连时间
        _timer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(reconnection) userInfo:nil repeats:NO];
        _reconnection_time ++;
    } else {
        _reconnection_time = 0;
    }
}

// 重连
- (void)reconnection {
    NSLog(@"socket---重新连接");
    [gcdSocket connectToHost:self.url onPort:self.port error:nil];
}


- (void)didReadData:(NSData *)data withTag:(long)tag{
    NSLog(@"socket---收到数据");
    //    //将接收到的数据保存到缓存数据中
    [_readBuf appendData:data];
    while (_readBuf.length >= 22)//因为头部固定22个字节，数据长度至少要大于22个字节，我们才能得到完整的消息描述信息
    {
        NSData *head = [_readBuf subdataWithRange:NSMakeRange(0, 22)];//取得头部数据
        NSData *lengthData = [head subdataWithRange:NSMakeRange(0, 4)];//取得长度数据
        NSInteger length = CFSwapInt32BigToHost(*(int*)([lengthData bytes]));
        if (length <= 22) {
            NSLog(@"####包长度不够返回了#####");
            return;
        }
        NSInteger complateDataLength = length ;//算出一个包完整的长度(内容长度＋头长度)
        //        NSLog(@"完整长度complateDataLength&%ld-----缓存区长度_readBuf&%lu",(long)complateDataLength,(unsigned long)_readBuf.length);
        
        if (_readBuf.length >= complateDataLength)//如果缓存中数据够一个整包的长度
        {
            if (_readBuf.length > complateDataLength) {
                NSLog(@"超出一个包 complateDataLength&%ld-----缓存区长度_readBuf&%lu",(long)complateDataLength,(unsigned long)_readBuf.length);
            }
            NSLog(@"一个包");
            NSData *data = [_readBuf subdataWithRange:NSMakeRange(0, complateDataLength)];//截取一个包的长度(处理粘包)
            [self handleTcpResponseData:data withTag:tag];//处理包数据
            //从缓存中截掉处理完的数据,继续循环
            _readBuf = [NSMutableData dataWithData:[_readBuf subdataWithRange:NSMakeRange(complateDataLength, _readBuf.length - complateDataLength)]];
        }
        else//如果缓存中的数据长度不够一个包的长度，则包不完整(处理半包，继续读取)
        {
            NSLog(@"不够一个包！！！！！  complateDataLength&%ld-----缓存区长度_readBuf&%lu",(long)complateDataLength,(unsigned long)_readBuf.length);
            [gcdSocket readDataWithTimeout:-1 tag:tag];
            //            [gcdSocket readDataWithTimeout:-1 buffer:_readBuf bufferOffset:_readBuf.length tag:tag];//继续读取数据
            break;
        }
    }
    [gcdSocket readDataWithTimeout:-1 tag:tag];
    //缓存中数据都处理完了，继续读取新数据
    //    [gcdSocket readDataWithTimeout:-1 buffer:_readBuf bufferOffset:_readBuf.length tag:tag];//继续读取数据
}

- (void)handleTcpResponseData:(NSData*)data withTag:(long)tag{
    // 处理接收到服务器的数据data
    if (_delegate && [_delegate respondsToSelector:@selector(delegateSocket:didReadData:withTag:)]) {
        [_delegate delegateSocket:gcdSocket didReadData:data withTag:tag];
    }
    
}



- (void)hasReadData:(NSData *)data  withTag:(long)tag{
    // 处理接收到服务器的数据data
    if (_delegate && [_delegate respondsToSelector:@selector(delegateSocket:didReadData:withTag:)]) {
        [_delegate delegateSocket:gcdSocket didReadData:data withTag:tag];
    }
}


@end
