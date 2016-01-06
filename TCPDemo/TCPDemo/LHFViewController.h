//
//  LHFViewController.h
//  TCPDemo
//
//  Created by 李洪峰 on 15/11/4.
//  Copyright (c) 2015年 LHF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncSocket.h"

@interface LHFViewController : UIViewController <AsyncSocketDelegate>
{
    AsyncSocket *_sendSocket;//客户端
    AsyncSocket *_receiveSocket;//服务端
    NSMutableArray *_socketArray;
}

@property (weak, nonatomic) IBOutlet UITextField *IPTextTF;
@property (weak, nonatomic) IBOutlet UITextField *contentTF;
@property (weak, nonatomic) IBOutlet UIButton *conectBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
