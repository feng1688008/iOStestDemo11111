//
//  LHFViewController.m
//  TCPDemo
//
//  Created by 李洪峰 on 15/11/4.
//  Copyright (c) 2015年 LHF. All rights reserved.
//

#import "LHFViewController.h"
#import "AsyncSocket.h"

@interface LHFViewController ()
@end

@implementation LHFViewController
{
    AsyncSocket *_otherSocket;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _socketArray = [[NSMutableArray alloc] init];

    //客户端服务端初始化
    _sendSocket = [[AsyncSocket alloc]initWithDelegate:self];
    _receiveSocket = [[AsyncSocket alloc]initWithDelegate:self];
    //服务器会设置当前服务程序使用哪一个借口进行访问,客户端只能被动的的连接接口;
    //同一个设备不同进程里面,都是一个 ip, 通过设置不同的端口来区分.
    //端口一般不超过2个字节,要大于1024才有效.
    //监听在端口5678上来的消息
//123123123123
    [_receiveSocket acceptOnPort:5678 error:nil];
}
-(void)dealloc
{
    _otherSocket = nil;
}
//监听到了客户端来连接
-(void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket
{
    //需要保存newSocket防止被释放
//    [_socketArray addObject:newSocket];
    _otherSocket = newSocket;
    
    //newSocket 新过来的
    //-1表示永远监听下去
    //让客户端永远监听下去
    
    [_otherSocket readDataWithTimeout:-1 tag:0];
}

//接受客户端发来的消息
-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    //data 就是发送过来的内容
    NSString *string  = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"客户端发来的消息----%@",string);
    _textView.text = [NSString stringWithFormat:@"%@对你说:%@",sock.connectedHost,string];

    //让客户端继续监听下去
    [sock readDataWithTimeout:-1 tag:0];
}

- (IBAction)connectClick:(id)sender
{
    NSLog(@"连接主机地址");
    if (_IPTextTF.text.length == 0) {
        return;
    }
    //如果正在连接其他客户端 就让他先断开
    if (_sendSocket.isConnected) {
        [_sendSocket disconnect];//断开连接
    }
    //如果30秒没连接成功 就不连接了.
    //给客户端30秒时间来连接服务器
    [_sendSocket connectToHost:_IPTextTF.text onPort:5678 withTimeout:30 error:nil];
}
- (IBAction)sendClick:(id)sender
{
    if (_contentTF.text.length == 0) {
        return;
    }
    
    NSData *data = [_contentTF.text dataUsingEncoding:NSUTF8StringEncoding];
    
    //发送消息内容
    [_sendSocket writeData:data withTimeout:30 tag:0];
    
    _textView.text = [NSString stringWithFormat:@"%@--说:%@",_IPTextTF.text,_contentTF.text];
    NSLog(@"发送给服务器-----%@",_textView.text);
}

-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"连接成功");
}

-(void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"断开连接");
}
@end
