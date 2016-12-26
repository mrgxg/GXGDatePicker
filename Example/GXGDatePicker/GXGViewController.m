//
//  GXGViewController.m
//  GXGDatePicker
//
//  Created by 龚雪刚 on 12/21/2016.
//  Copyright (c) 2016 龚雪刚. All rights reserved.
//

#import "GXGViewController.h"
#import "GXGDatePicker.h"

@interface GXGViewController ()

@end

@implementation GXGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)startAction:(UIButton *)sender {
    GXGDatePicker *picker = [[GXGDatePicker alloc] init];
    picker.datePickerMode = GXGDatePickerModeHourMinute;
//    picker.isShowAsCycle = YES;
    picker.maximumDate = [[NSDate date] dateByAddingTimeInterval:5*60*60];
    picker.minimumDate = [[NSDate date] dateByAddingTimeInterval:-3*60*60];
    picker.mCurrentDate = [NSDate date];
//    picker.timeZone = [NSTimeZone systemTimeZone];
    [picker showDatePicker:^(NSDate * _Nullable selectedDate) {
        NSLog(@"slectDate = %@",selectedDate);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
