//
//  ViewController.m
//  PauseApp
//
//  Created by Gjermund Bjaanes on 28.09.13.
//  Copyright (c) 2013 Gjermund Bjaanes. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (weak, nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UISlider *setTimeSlider;
@property (strong, nonatomic) NSDate *alertTime;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.countdownLabel setText:[self secondsToNicelyFormattedString:(int)self.setTimeSlider.value]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateTimeLeft:self.timer];
}

- (IBAction)startTimer:(id)sender {
    self.alertTime = [NSDate dateWithTimeIntervalSinceNow:self.setTimeSlider.value];
    if (self.timer) [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self selector:@selector(updateTimeLeft:)
                                                userInfo:nil repeats:YES];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = self.alertTime;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertBody = @"Time to take a break!";
    localNotification.alertAction = NSLocalizedString(@"View Details", nil);
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}


- (IBAction)sliderValueChanged:(id)sender {
    [self.countdownLabel setText:[self secondsToNicelyFormattedString:self.setTimeSlider.value]];
}

- (void)updateTimeLeft:(NSTimer*)timer
{
    if (self.alertTime.timeIntervalSinceNow <= 0) {
        [self.countdownLabel setText:[self secondsToNicelyFormattedString:0]];
        [timer invalidate];
    } else {
        [self.countdownLabel setText:[self secondsToNicelyFormattedString:(int)self.alertTime.timeIntervalSinceNow]];
    }
    
}

- (NSString *)secondsToNicelyFormattedString:(int)seconds
{
    int min = seconds/60;
    int sec = seconds%60;
    
    NSString *nicelyFormattedString = [[NSString alloc] initWithFormat:@"%d:%d", min, sec];
    
    return nicelyFormattedString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
