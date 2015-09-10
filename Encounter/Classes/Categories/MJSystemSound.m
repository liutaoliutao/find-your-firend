
//
//  MJSystemSound.m
//  Encounter
//
//  Created by 李明军 on 2/7/15.
//  Copyright (c) 2015年 AiTa. All rights reserved.
//

/**
 1.声音格式是MP3或m4r的需要转成caf格式（可先转成aif , aiff，然后修改后缀）
 2.路径在/System/Library/Audio/UISounds 里，需要更改的可以根据以下列表进行替换
 3详细列表：
 信息
 ReceivedMessage.caf--收到信息，仅在短信界面打开时播放。
 sms-received1.caf-------三全音
 sms-received2.caf-------管钟琴
 sms-received3.caf-------玻璃
 sms-received4.caf-------圆号
 sms-received5.caf-------铃声
 sms-received6.caf-------电子乐
 SentMessage.caf--------发送信息
 
 邮件
 mail-sent.caf----发送邮件
 new-mail.caf-----收到新邮件
 
 电话
 dtmf-0.caf----------拨号面板0按键
 dtmf-1.caf----------拨号面板1按键
 dtmf-2.caf----------拨号面板2按键
 dtmf-3.caf----------拨号面板3按键
 dtmf-4.caf----------拨号面板4按键
 dtmf-5.caf----------拨号面板5按键
 dtmf-6.caf----------拨号面板6按键
 dtmf-7.caf----------拨号面板7按键
 dtmf-8.caf----------拨号面板8按键
 dtmf-9.caf----------拨号面板9按键
 dtmf-pound.caf---拨号面板＃按键
 dtmf-star.caf------拨号面板*按键
 Voicemail.caf-----新语音邮件
 
 输入设备声音提示
 Tock.caf-----------------------点击键盘
 begin_record.caf-----------开始录音
 begin_video_record.caf--开始录像
 photoShutter.caf------------快门声
 end_record.caf--------------结束录音
 end_video_record.caf-----结束录像
 
 其他
 beep-beep.caf--充电、注销及连接电脑
 lock.caf------------锁定手机
 shake.caf---------“这个还没搞清楚”
 unlock.caf--------滑动解锁
 low_power.caf--低电量提示
 
 语音控制
 jbl_ambiguous.caf--找到多个匹配
 jbl_begin.caf------等待用户的输入
 jbl_cancel.caf-----取消
 jbl_confirm.caf----执行
 jbl_no_match.caf---没有找到匹配
 
 日历
 alarm.caf--日历提醒
 
 iPod Touch 1G
 sq_alarm.caf 
 sq_beep-beep.caf 
 sq_lock.caf 
 sq_tock.caf
 */


#import "MJSystemSound.h"

@implementation MJSystemSound

- (id)initSystemShake
{
    self = [super init];
    if (self) {
        sound = kSystemSoundID_Vibrate;//震动
    }
    return self;
}

- (id)initSystemSoundWithName:(NSString *)soundName SoundType:(NSString *)soundType
{
    self = [super init];
    if (self) {
        NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",soundName,soundType];
        //[[NSBundle bundleWithIdentifier:@"com.apple.UIKit" ]pathForResource:soundName ofType:soundType];//得到苹果框架资源UIKit.framework ，从中取出所要播放的系统声音的路径
        //[[NSBundle mainBundle] URLForResource: @"tap" withExtension: @"aif"];  获取自定义的声音
        if (path) {
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&sound);
            
            if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
                sound = nil;
            }
        }
    }
    return self;
}

- (void)play
{
    AudioServicesPlaySystemSound(sound);
}

@end
