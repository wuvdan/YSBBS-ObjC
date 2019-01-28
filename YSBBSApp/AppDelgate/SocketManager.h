//
//  SocketManager.h
//  YSBBSApp
//
//  Created by wudan on 2019/1/25.
//  Copyright © 2019 forever.love. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GCDAsyncSocket.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SocketDelegate <NSObject>

@optional
- (void)delegateSocket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag;
@end

@interface SocketManager : NSObject
@property (nonatomic, weak) id<SocketDelegate> delegate;
/**
 *  应用协议中允许发送的最大数据块大小，默认为2147483647
 */
@property (nonatomic, assign) NSUInteger maxFrameSize;
+ (instancetype)share;
- (BOOL)connectWithUrl:(NSString *)url port:(NSInteger)port;
- (void)disConnect;
- (void)sendMsgWithLength:(int)length withsequenceId:(long)sequenceId withcmd:(short)cmd withVersion:(int)Version withRequestId:(int)RequestId withbody:(NSDictionary*)jsonDict;//发送消息
@end



NS_ASSUME_NONNULL_END
