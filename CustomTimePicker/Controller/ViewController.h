//
//  ViewController.h
//  CustomTimePicker
//
//  Created by Amboj Goyal on 21/05/14.
//  Copyright (c) 2014 Amboj Goyal. All rights reserved.
//

#import "CustomTimePicker.h"

@interface ViewController : UIViewController<CustomTimePickerDelegate>

@property (nonatomic,strong) CustomTimePicker *clockView;

@end
