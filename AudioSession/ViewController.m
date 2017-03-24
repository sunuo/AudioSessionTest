//
//  ViewController.m
//  AudioSession
//
//  Created by xukaitiankevin on 2017/3/16.
//  Copyright © 2017年 xukaitiankevin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *play;

@property (weak, nonatomic) IBOutlet UIButton *stop;

@end

@implementation ViewController

-(void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interrupt:) name:AVAudioSessionInterruptionNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleBackGround:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleForeGround:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
}

-(void)interrupt:(id)sender
{
    NSLog(@"%@ %@",NSStringFromSelector(_cmd),((NSNotification*)sender).userInfo);
//    2017-03-16 13:49:06.344554 AudioSession[9916:2498032] interruptBegin: {
//        AVAudioSessionInterruptionTypeKey = 1;
//    }
//    2017-03-16 13:49:22.450911 AudioSession[9916:2498032] interruptBegin: {
//        AVAudioSessionInterruptionOptionKey = 0;
//        AVAudioSessionInterruptionTypeKey = 0;
//    }
    
    NSDictionary* dic = ((NSNotification*)sender).userInfo;
    if (dic&&[dic isKindOfClass:[NSDictionary class]]&&[dic valueForKey:AVAudioSessionInterruptionTypeKey]) {
        if ([[dic valueForKey:AVAudioSessionInterruptionTypeKey] intValue]==AVAudioSessionInterruptionTypeEnded) {
            [self setDefaultAudiosession];
            if (self.test_0) {
                [self.test_0 setVolume:0.5];
                [self.test_0 play];
                
            }
            if (self.test_1) {
                [self.test_1 setVolume:0.5];
                [self.test_1 play];
            }
            [self stopSilence];
        }
        else
        {
            if (self.test_0) {
                [self.test_0 pause];
                
            }
            if (self.test_1) {
                [self.test_1 pause];
            }
            [self setBackgroundMixAudioSession];
            [self startSilence];
            
        }
    }
    
}

-(void)handleBackGround:(id)sender
{
    [self startSilence];
}

-(void)handleForeGround:(id)sender
{
    [self stopSilence];
}

- (void) startSilence
{
    NSLog(@"start silence");
    if (!self.silence) {
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"silence" ofType: @"wav"];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
        self.silence = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error: nil];
        self.silence.numberOfLoops = -1;
        [self.silence setVolume:0.5];
    }

    [self.silence prepareToPlay];
    [self.silence play];
}

- (void) stopSilence
{
    NSLog(@"stop silence");
    if (self.silence) {
        [self.silence stop];
    }
    self.silence=nil;
}

-(void)setDefaultAudiosession
{
    AVAudioSession *session=[AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback withOptions:0 error:nil];
    [session setActive:YES error:nil];

}

-(void)setBackgroundMixAudioSession
{
    AVAudioSession *session=[AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
}

-(void)closeAudioSession
{
    AVAudioSession *session=[AVAudioSession sharedInstance];
    [session setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:NULL];

}

- (IBAction)playclick:(id)sender {
    
    [self stopSilence];
    
    [self setDefaultAudiosession];
    
    // Do any additional setup after loading the view, typically from a nib.
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"test_0" ofType: @"mp3"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    self.test_0 = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error: nil];
    self.test_0.numberOfLoops = -1;
    [self.test_0 setVolume:0.5];
    
    
    soundFilePath = [[NSBundle mainBundle] pathForResource: @"test_1" ofType: @"mp3"];
    fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    self.test_1 = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error: nil];
    self.test_1.numberOfLoops = -1;
    [self.test_1 setVolume:0.5];
    
    
    [self.test_0 prepareToPlay];
    [self.test_0 play];
    
    [self.test_1 prepareToPlay];
    [self.test_1 play];
    
//    [self pauseForTenSeconds];
    
}

-(void)pauseForTenSeconds
{//为了研究音频暂停后  APP是否还会在后台运行 - 答案 不会  |  静音同理
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(pause) withObject:nil afterDelay:10];
}

-(void)pause
{
    NSLog(@"pause");
    
    if (_test_0) {
//        [_test_0 setVolume:0];
        [_test_0 pause];
        
    }
    
    if (_test_1) {
//        [_test_1 setVolume:0];
        [_test_1 pause];
    
    }
}


- (IBAction)pauseclick:(id)sender {

    if (_test_0) {
        [_test_0 stop];
        _test_0=nil;
    }
    
    if (_test_1) {
        [_test_1 stop];
        _test_1=nil;
    }

    [self closeAudioSession];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
