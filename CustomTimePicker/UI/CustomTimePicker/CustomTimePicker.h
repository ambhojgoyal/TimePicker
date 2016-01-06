//
//  CustomTimePicker.h
//  CustomTimePicker
//
//  Created by Amboj Goyal on 21/05/14.
//  Copyright (c) 2014 Amboj Goyal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol CustomTimePickerDelegate <NSObject>

-(void)dismissClockViewWithHours:(NSString *)hours andMinutes:(NSString *)minutes andTimeMode:(NSString *)timeMode;

@end


@interface CustomTimePicker : UIView <UIGestureRecognizerDelegate>

@property (nonatomic,unsafe_unretained) id<CustomTimePickerDelegate> delegate;

- (id)initWithView:(UIView *)view withDarkTheme:(BOOL)isDarkTheme ;

@end
