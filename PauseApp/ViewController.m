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
    [self.countdownLabel setText:[[NSNumber numberWithInt:(int)self.setTimeSlider.value] stringValue]];
    
	// Do any additional setup after loading the view, typically from a nib.
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
    localNotification.alertBody = @"Time to take a Pause!";
    localNotification.alertAction = NSLocalizedString(@"View Details", nil);
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}


- (IBAction)sliderValueChanged:(id)sender {
    [self.countdownLabel setText:[[NSNumber numberWithInt:self.setTimeSlider.value] stringValue]];
}

- (void)updateTimeLeft:(NSTimer*)timer
{
    if (self.alertTime.timeIntervalSinceNow <= 0)
        [timer invalidate];
    [self.countdownLabel setText:[[NSNumber numberWithInt:(int)self.alertTime.timeIntervalSinceNow] stringValue]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
