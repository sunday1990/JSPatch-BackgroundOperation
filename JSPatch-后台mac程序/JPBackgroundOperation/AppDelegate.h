//
//  AppDelegate.h
//  JPBackgroundOperation
//
//  Created by Xu Lian on 2013-07-19.
//  Copyright (c) 2013 Beyondcow. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    NSDataDetector *dataDetector;
}
@property (assign) IBOutlet NSWindow *window;

/**
 容器TextView
 */
@property (assign) IBOutlet NSTextView *textView;

/**
 版本号输入框
 */
@property (weak) IBOutlet NSTextField *versionNumField;

/**
 文件路径输入框
 */
@property (weak) IBOutlet NSTextField *FilesPathTf;

/**
 加密后的结果显示框
 */
@property (weak) IBOutlet NSTextField *resultTextField;

/**
 文件原内容显示框
 */
@property (weak) IBOutlet NSTextField *originalContentTF;
/**
 文件上传状态指示label
 */
@property (weak) IBOutlet NSTextField *statusLabel;

/**
 开始加密

 @param sender
 */
- (IBAction)parseFiles:(NSButton *)sender;

/**
 上传结果

 @param sender <#sender description#>
 */
- (IBAction)commitBtn:(NSButton *)sender;

/**
 重置

 @param sender
 */
- (IBAction)reset:(NSButton *)sender;

/**
 选择测试服务器

 @param sender
 */
- (IBAction)selectedTs:(NSButton *)sender;

/**
 选择正式服务器

 @param sender <#sender description#>
 */
- (IBAction)selected3w:(NSButton *)sender;


@end
