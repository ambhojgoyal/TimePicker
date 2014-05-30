//
//  ViewController.m
//  CustomTimePicker
//
//  Created by Amboj Goyal on 21/05/14.
//  Copyright (c) 2014 Amboj Goyal. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
CustomTimePicker *clockView;
UIButton *initiateClock = nil;
UILabel * hourLabel = nil;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    initiateClock = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [initiateClock setFrame:CGRectMake(100, 100, 100, 50)];
    
    [initiateClock setTitle:@"Set Time" forState:UIControlStateNormal];
    [initiateClock setBackgroundColor:[UIColor lightGrayColor]];
    [initiateClock addTarget:self action:@selector(showClockView) forControlEvents:UIControlEventTouchDown];
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    [self.view addSubview:initiateClock];
    
}
-(void)showClockView{
    [initiateClock setHidden:TRUE];
    [hourLabel removeFromSuperview];
    hourLabel = nil;
    clockView = [[CustomTimePicker alloc] initWithView:self.view withDarkTheme:false];
    clockView.delegate = self;
    [self.view addSubview:clockView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dismissClockViewWithHours:(NSString *)hours andMinutes:(NSString *)minutes andTimeMode:(NSString *)timeMode{
    
    hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 200, 50)];
    
    [hourLabel setText:[NSString stringWithFormat:@"%@:%@  %@",hours,minutes,timeMode]];
    
    [hourLabel setFont:[UIFont boldSystemFontOfSize:30]];
    
    [self.view addSubview:hourLabel];
    
    [initiateClock setHidden:FALSE];
}

@end
