//
//  ViewController.h
//  CustomTimePicker
//
//  Created by Amboj Goyal on 21/05/14.
//  Copyright (c) 2014 Amboj Goyal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTimePicker.h"
@interface ViewController : UIViewController<CustomTimePickerDlegate>
@property(nonatomic,strong)UIView *clockView;
@end
