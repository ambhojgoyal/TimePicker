Android Kitkat's TimePicker version for iOS

How To Use
---------------

1. Import CustomTimePicker.h

2. Set CustomTimePickerDelegate

3. Implement the Delegate's dismiss method

4. Save/Use the clock's values


  
  ClassUsingTimePicker.h
  ```
  #import "CustomTimePicker.h"
  @interface ClassUsingTimePicker.h : UIViewController <CustomTimePickerDelegate> {
    IBOutlet UIButton *clockButton;
  }
  
  @property (nonatomic, strong) CustomTimePicker *clockView;
  
  -(IBAction)clockButtonPressed:(id)sender;
  
  @end
  ```
  
  ClassUsingTimePicker.m
  ```
  @implementation ClassUsingTimePicker
  
  @synthesize clockView;
  
  // Called when clockButton is pressed
  -(IBAction)clockButtonPressed:(id)sender {
    clockView = [[CustomTimePicker alloc] initWithView:self.view withDarkTheme:false];
    clockView.delegate = self;
    [self.view addSubview:clockView];
  }
  
  // Delegate method called when clockView is dismissed
  -(void)dismissClockViewWithHours:(NSString *)hours andMinutes:(NSString *)minutes andTimeMode:(NSString *)timeMode {
    NSLog(@"%@:%@ %@", hours, minutes, timeMode);
  }
  
  @end
  ```

What the Delegate returns
-------------------------

Implementation of delegate will return 3 strings :

1. Hour String.
2. Minute String.
3. AM/PM String.
