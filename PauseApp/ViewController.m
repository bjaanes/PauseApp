//
//  ViewController.m
//  Take A Break
//
//  Created by Gjermund Bjaanes on 28.09.13.
//  Copyright (c) 2013 Gjermund Bjaanes. All rights reserved.
//

#import "ViewController.h"



@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (weak, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSDate *alertTime;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (weak, nonatomic) IBOutlet UIButton *startStopButton;
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateTimeLeft:self.timer];
}

- (IBAction)startTimer:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"Start"]) {
        // Time to start it all!
        // clean-up just in case
        if (self.timer) [self.timer invalidate];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        // Set up timer
        self.alertTime = [NSDate dateWithTimeIntervalSinceNow:[self.timePicker countDownDuration]];
        //self.alertTime = [NSDate dateWithTimeIntervalSinceNow:7];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(updateTimeLeft:)
                                                    userInfo:nil
                                                     repeats:YES];
        [self updateTimeLeft:self.timer];
        
        // Set up and schedule a local notification
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = self.alertTime;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.alertBody = @"Time to take a break!";
        localNotification.alertAction = NSLocalizedString(@"View Details", nil); //??
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        //localNotification.
        
        [sender setTitle:@"Stop" forState:UIControlStateNormal];
    } else {
        // Time to stop it all!
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [self.timer invalidate];
        self.timer = nil;
        [self updateTimeLeft:self.timer];
        [sender setTitle:@"Start" forState:UIControlStateNormal];
    }
}

- (void)updateTimeLeft:(NSTimer*)timer // need timer beacuse of NSTimer selector
{
    if (timer == nil) {
        [self.countdownLabel setText:[self secondsToNicelyFormattedString:0]];
    }
    else if (self.alertTime.timeIntervalSinceNow <= 0) {
        [self.countdownLabel setText:[self secondsToNicelyFormattedString:0]];
        [timer invalidate];
        [self.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
    }
    else {
        [self.countdownLabel setText:
         [self secondsToNicelyFormattedString:(int)self.alertTime.timeIntervalSinceNow]];
    }
    
}

- (NSString *)secondsToNicelyFormattedString:(int)seconds
{
    int min = seconds/60;
    int sec = seconds%60;
    
    NSString *nicelyFormattedString = [[NSString alloc] initWithFormat:@"%02d:%02d", min, sec];
    
    return nicelyFormattedString;
}

@end
