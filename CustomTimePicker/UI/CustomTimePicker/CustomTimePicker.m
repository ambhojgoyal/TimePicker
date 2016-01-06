//
//  CustomTimePicker.m
//  CustomTimePicker
//
//  Created by Amboj Goyal on 21/05/14.
//  Copyright (c) 2014 Amboj Goyal. All rights reserved.
//

#import "CustomTimePicker.h"
#define   DEGREES_TO_RADIANS(degrees)  ((3.14159265359 * degrees)/ 180)

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]


#define MAINCIRCLE_LINE_WIDTH 1.0f
#define kMainCircleRadius  12.0
#define kSmallCircleRadius  3.0
#define kConnectingLineLength  60.0
#define kColonWidth 3.0f
#define kColonHeight 4.0f
#define kColonOrigin 4.0f
@interface CustomTimePicker()

-(void)rotateHand:(UIView *)view rotationDegree:(float)degree;

@end


@implementation CustomTimePicker
@synthesize delegate;


UIColor * clockBackgroundColor;
UIColor * viewBackgroundColor;
UIColor * clockPointerColor;
UIColor * textColor;
UIColor * selectedTimeColor;

UIView *hoursCircle ;
UIView *minutesCircle ;
UIView *clockHandView;
UIView *lineView = nil;
UIView *selectedTimeView = nil;

CAShapeLayer *mask;

BOOL isTimevalueClicked;
BOOL isDarkThemeSelected;
BOOL isMinuteClockDisplayed;

UIButton *amButton = nil;
UIButton *pmButton = nil;
UIButton *doneButton = nil;
UIButton * hoursButton = nil;
UIButton * minuteButton = nil;

UIView * seperatorLineView = nil;

UIButton * timeModeLabel = nil;

int previousIndex = 110;
int currentIndex = 0;
int clockHandIndex = 110;

NSString *seperatorImageName = nil;


//- (id)initWithFrame:(CGRect)frame withThemeDarkTheme:(BOOL)isDarkTheme {
- (id)initWithView:(UIView *)view withDarkTheme:(BOOL)isDarkTheme{
    self = [super initWithFrame:CGRectMake(20, 40, view.bounds.size.width-40, view.bounds.size.height-80)];
    if (self) {
        self.opaque = NO;
        
        isTimevalueClicked = FALSE;
        isMinuteClockDisplayed = FALSE;
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rotateHand:)];
        panGesture.delegate = self;
        [panGesture setMaximumNumberOfTouches:1];
        [self addGestureRecognizer:panGesture];
        
        isDarkThemeSelected = isDarkTheme;
        if (isDarkTheme) {
            clockBackgroundColor = UIColorFromRGB(0x363636);
            viewBackgroundColor = UIColorFromRGB(0x404040);
            clockPointerColor = UIColorFromRGB(0x8C3A3A);
            textColor = [UIColor whiteColor];
            selectedTimeColor =UIColorFromRGB(0x8C3A3A);
            seperatorImageName = @"seperatorImage_Dark";
        }else{
            clockBackgroundColor = [UIColor whiteColor];
            viewBackgroundColor = UIColorFromRGB(0xF2F2F2);
            clockPointerColor = UIColorFromRGB(0x1FB2E7);  //0xD4F0FB  // 0xCAE6E6
            selectedTimeColor = UIColorFromRGB(0x1FB2E7);
            textColor = UIColorFromRGB(0x8C8C8C);
            seperatorImageName = @"seperator_LightTheme";
        }
        [self setBackgroundColor:viewBackgroundColor];
        [self createClockView];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
        [clockHandView addGestureRecognizer:tapGesture];
    }
    return self;
}

#pragma mark - Private Methods Implementation.
- (void)rotateHand:(UIView *)view rotationDegree:(float)degree{
    [UIView animateWithDuration:1.0
                          delay:0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         view.transform = CGAffineTransformMakeRotation((degree)*(M_PI/180));
                         int finalValue =0;
                         if (isTimevalueClicked) {
                             finalValue =(int)(clockHandIndex - previousIndex);
                         }else{
                             finalValue = (int)(currentIndex - previousIndex);
                         }
                         
                         if (isMinuteClockDisplayed) {
                             finalValue = finalValue*5;
                             if (finalValue == 60)
                                 [minuteButton setTitle:@"00" forState:UIControlStateNormal];
                             else
                                 [minuteButton setTitle:[NSString stringWithFormat:@"%02d", finalValue] forState:UIControlStateNormal];
                         }else{
                             if (finalValue == 0) {
                                 [hoursButton setTitle:@"12" forState:UIControlStateNormal];
                             }
                             [hoursButton setTitle:[NSString stringWithFormat:@"%02d", finalValue] forState:UIControlStateNormal];
                         }
                         
                     } completion:^(BOOL finished) {
                         if (!isMinuteClockDisplayed) {
                             [self showMinutesClock];
                         }
                         isTimevalueClicked = FALSE;
                     }];
}

#pragma mark - Custom Action Methods

-(void)timeClicked:(id)sender{
    clockHandIndex=110;
    UIButton *selectedButton = (UIButton *)sender;
    currentIndex = (int)selectedButton.tag;
    CGFloat degreesToRotate = (currentIndex - previousIndex)*30;
    clockHandIndex = currentIndex;
    [self rotateHand:clockHandView rotationDegree:degreesToRotate];
    
}
-(void)changeTimeSystem:(id)sender{
    
    UIButton *timeButton = (UIButton *)sender;
    if (timeButton.tag == 185) {
        [timeModeLabel setTitle:@"AM" forState:UIControlStateNormal];
        [timeButton setBackgroundColor:clockPointerColor];
        UIButton *pmButton = (UIButton *)[self viewWithTag:581];
        [pmButton setBackgroundColor:clockBackgroundColor];
    }else if(timeButton.tag == 581)   {
        [timeModeLabel setTitle:@"PM" forState:UIControlStateNormal];
        [timeButton setBackgroundColor:clockPointerColor];
        UIButton *amButton = (UIButton *)[self viewWithTag:185];
        [amButton setBackgroundColor:clockBackgroundColor];
    }else if (timeButton.tag == 85){
        if ([timeButton.titleLabel.text rangeOfString:@"AM"].length>0) {
            [timeModeLabel setTitle:@"PM" forState:UIControlStateNormal];
            [amButton setBackgroundColor:clockBackgroundColor];
            [pmButton setBackgroundColor:clockPointerColor];
            
            
        }else{
            [timeModeLabel setTitle:@"AM" forState:UIControlStateNormal];
            [pmButton setBackgroundColor:clockBackgroundColor];
            [amButton setBackgroundColor:clockPointerColor];
        }
    }
    
}
-(void)timeSelectionComplete:(id)sender{
    [self removeFromSuperview];
    previousIndex = 110;
    currentIndex = 0;
    clockHandIndex = 110;
    
    [delegate dismissClockViewWithHours:hoursButton.titleLabel.text andMinutes:minuteButton.titleLabel.text andTimeMode:timeModeLabel.titleLabel.text];
}
-(void)showHourClock{
    [hoursButton setTitleColor:selectedTimeColor forState:UIControlStateNormal];
    [minuteButton setTitleColor:textColor forState:UIControlStateNormal];
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         hoursCircle.transform = CGAffineTransformIdentity;
                         [hoursCircle setAlpha:1];
                         minutesCircle.transform = CGAffineTransformIdentity;
                         [minutesCircle setAlpha:0];
                         int degreeToRotate = [hoursButton.titleLabel.text intValue] *30;
                         clockHandView.transform = CGAffineTransformMakeRotation((degreeToRotate)*(M_PI/180));
                         
                     }completion:^(BOOL finished) {
                         isMinuteClockDisplayed = FALSE;
                         
                     }];
    
    hoursButton.transform = CGAffineTransformMakeScale(0.5,0.5);
    [UIView beginAnimations:@"fadeInNewView" context:NULL];
    [UIView setAnimationDuration:1.0];
    hoursButton.transform = CGAffineTransformMakeScale(1,1);
    [UIView commitAnimations];
    
}
-(void)showMinutesClock{
    
    [hoursButton setTitleColor:textColor forState:UIControlStateNormal];
    [minuteButton setTitleColor:selectedTimeColor forState:UIControlStateNormal];
    [UIView animateWithDuration:0.8
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         hoursCircle.transform = CGAffineTransformMakeScale(1.2, 1.2);
                         [hoursCircle setAlpha:0];
                         minutesCircle.transform = CGAffineTransformMakeScale(1.28, 1.28);
                         [minutesCircle setAlpha:1.0];
                         float degreeToRotate = (float)([minuteButton.titleLabel.text floatValue]/5);
                         clockHandView.transform = CGAffineTransformMakeRotation((degreeToRotate*30)*(M_PI/180));
                     }completion:^(BOOL finished) {
                         isMinuteClockDisplayed = TRUE;
                     }];
    minuteButton.transform = CGAffineTransformMakeScale(0.5,0.5);
    [UIView beginAnimations:@"fadeInNewView" context:NULL];
    [UIView setAnimationDuration:1.0];
    minuteButton.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
    
}

#pragma mark - Gesture Handling Methods

- (void)rotateHand:(UIPanGestureRecognizer *)recognizer {
    UIView * currentView ;
    if (isMinuteClockDisplayed) {
        currentView = minutesCircle;
    }else{
        currentView = hoursCircle;
    }
    CGPoint translation = [recognizer locationInView:currentView];
    CGFloat angleInRadians = atan2f(translation.y - currentView.frame.size.height/2, translation.x - currentView.frame.size.width/2);
    if (isMinuteClockDisplayed) {
        float minutesFloat =(atan2f((translation.x - currentView.frame.size.height/2), (translation.y - currentView.frame.size.width/2)) * -(180/M_PI) + 180)/6;
        float roundedUp = lroundf(minutesFloat);
        if (roundedUp == 60)
            roundedUp = 00;
        [minuteButton setTitle:[NSString stringWithFormat:@"%02d", (int)roundedUp] forState:UIControlStateNormal];
    }else{
        //Calculate Hours.
        NSUInteger hours = (atan2f((translation.x - currentView.frame.size.height/2), (translation.y - currentView.frame.size.width/2)) * -(180/M_PI) + 180)/30;
        if (hours == 0)
            hours = 12;
        [hoursButton setTitle:[NSString stringWithFormat:@"%02d", (int)hours] forState:UIControlStateNormal];
    }
    float angle =angleInRadians + M_PI/2;
    
    clockHandView.transform = CGAffineTransformMakeRotation(angle);
    if(recognizer.state == UIGestureRecognizerStateEnded){
        //Code that manages when hour selection is done.
        if (!isMinuteClockDisplayed)
            [self showMinutesClock];
    }
}
-(void) tapGestureHandler:(UITapGestureRecognizer *)sender {
    isTimevalueClicked = TRUE;
    CGPoint point = [sender locationInView:sender.view];
    if (point.y>170 && point.y<190) {
        int previousvalue = (int)(clockHandIndex-previousIndex)*30;
        clockHandIndex = clockHandIndex+6;
        if (clockHandIndex>122) {
            clockHandIndex = clockHandIndex-122+previousIndex;
        }
        [self rotateHand:clockHandView rotationDegree:180+previousvalue];
    }
}


#pragma mark - Custom UI Methods
-(void)createClockView{
    
    hoursCircle = [[UIView alloc] initWithFrame:CGRectMake(0,50,200, 200)];
    hoursCircle.alpha = 0.8;
    hoursCircle.layer.cornerRadius = hoursCircle.frame.size.width/2;
    hoursCircle.backgroundColor = clockBackgroundColor;
    hoursCircle.center = CGPointMake(self.frame.size.width/2, self.center.y-50);
    [self addSubview:hoursCircle];
    //Adding the Hours Number on hours Circle.
    [self addNumbers:TRUE];
    
    minutesCircle = [[UIView alloc] initWithFrame:CGRectMake(50,50,150, 150)];
    minutesCircle.alpha = 0.0;
    minutesCircle.layer.cornerRadius = minutesCircle.frame.size.width/2;
    minutesCircle.backgroundColor =clockBackgroundColor;
    minutesCircle.center = hoursCircle.center;
    [self addSubview:minutesCircle];
    //Adding the Minutes Number on Minutes Circle.
    [self addNumbers:FALSE];
    
    //View to Display the Selected Time.
    selectedTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, hoursCircle.frame.origin.y -20)];
    selectedTimeView.backgroundColor = clockBackgroundColor;
    
    hoursButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.origin.x +50 , selectedTimeView.frame.size.height/2 -25, 50, 50)];
    [hoursButton setTitle:@"12" forState:UIControlStateNormal];
    [hoursButton setTitleColor:selectedTimeColor forState:UIControlStateNormal];
    [hoursButton.titleLabel setFont:[UIFont boldSystemFontOfSize:45]];
    [hoursButton setBackgroundColor:[UIColor clearColor]];
    [hoursButton addTarget:self action:@selector(showHourClock) forControlEvents:UIControlEventTouchUpInside];
    [selectedTimeView addSubview:hoursButton];
    
    //Creating Seperator Label.
    
    seperatorLineView = [[UIView alloc] initWithFrame:CGRectMake(hoursButton.frame.origin.x + hoursButton.frame.size.width+10 ,hoursButton.frame.origin.y+10 , 10,30)];
    [seperatorLineView setBackgroundColor:[UIColor clearColor]];
    [selectedTimeView addSubview:seperatorLineView];
    [self addTimeSeperatorWith:CGRectMake(kColonOrigin,6,kColonWidth,kColonHeight )];
    [self addTimeSeperatorWith:CGRectMake(kColonOrigin,22,kColonWidth,kColonHeight)];
    
    //Creating Minute Label.
    
    minuteButton = [[UIButton alloc] initWithFrame:CGRectMake(seperatorLineView.frame.origin.x +seperatorLineView.frame.size.width+10 , hoursButton.frame.origin.y, 50, 50)];
    [minuteButton setTitle:@"00" forState:UIControlStateNormal];
    [minuteButton setTitleColor:textColor forState:UIControlStateNormal];
    [minuteButton.titleLabel setFont:[UIFont boldSystemFontOfSize:45]];
    [minuteButton setBackgroundColor:[UIColor clearColor]];
    [minuteButton addTarget:self action:@selector(showMinutesClock) forControlEvents:UIControlEventTouchUpInside];
    [selectedTimeView addSubview:minuteButton];
    
    //Creating TimeSystem Label.
    
    timeModeLabel = [[UIButton alloc] initWithFrame:CGRectMake(minuteButton.frame.origin.x + minuteButton.frame.size.width+10, hoursButton.frame.origin.y+20, 50, 30)];
    [timeModeLabel setTitle:@"AM" forState:UIControlStateNormal];
    [timeModeLabel setTitleColor:textColor forState:UIControlStateNormal];
    [timeModeLabel.titleLabel setFont:[UIFont boldSystemFontOfSize:22]];
    [timeModeLabel setBackgroundColor:[UIColor clearColor]];
    [timeModeLabel setTag:85];
    [timeModeLabel addTarget:self action:@selector(changeTimeSystem:) forControlEvents:UIControlEventTouchUpInside];
    [selectedTimeView addSubview:timeModeLabel];
    [self addSubview:selectedTimeView];
    
    //Creating AM button.
    amButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [amButton setFrame:CGRectMake(hoursCircle.frame.origin.x ,hoursCircle.frame.origin.y + hoursCircle.frame.size.height + 10, 40, 40)];
    [amButton setTag:185];
    [amButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [amButton addTarget:self action:@selector(changeTimeSystem:) forControlEvents:UIControlEventTouchUpInside];
    [amButton setTitle:@"AM" forState:UIControlStateNormal];
    [amButton setTitleColor:textColor forState:UIControlStateNormal];
    [amButton setBackgroundColor:clockPointerColor];
    [amButton.layer setCornerRadius:amButton.frame.size.height/2];
    [self addSubview:amButton];
    
    
    //Creating PM button.
    pmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pmButton setFrame:CGRectMake(hoursCircle.frame.origin.x + hoursCircle.frame.size.width -30,amButton.frame.origin.y, 40, 40)];
    [pmButton setTag:581];
    [pmButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [pmButton addTarget:self action:@selector(changeTimeSystem:) forControlEvents:UIControlEventTouchUpInside];
    [pmButton setTitle:@"PM" forState:UIControlStateNormal];
    [pmButton setTitleColor:textColor forState:UIControlStateNormal];
    [pmButton setBackgroundColor:clockBackgroundColor];
    [pmButton.layer setCornerRadius:pmButton.frame.size.height/2];
    
    [self addSubview:pmButton];
    
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0,amButton.frame.origin.y + amButton.frame.size.height + 10,self.frame.size.width , 1)];
    [lineView setBackgroundColor:textColor];
    [self addSubview:lineView];
    
    
    doneButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 50, lineView.frame.origin.y +( self.frame.size.height-lineView.frame.origin.y)/2-25, 100, 50)];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setTitleColor:textColor forState:UIControlStateNormal];
    [doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [doneButton addTarget:self action:@selector(timeSelectionComplete:) forControlEvents:UIControlEventTouchUpInside];
    [doneButton.layer setCornerRadius:5.0];
    [self addSubview:doneButton];
    
    //Creating Clock Hand View.
    
    clockHandView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-15, hoursCircle.frame.origin.y+5, 30, 190)];
    [clockHandView.layer setCornerRadius:5.0];
    [clockHandView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:clockHandView];
    
    //Creating the clock Hand.
    [self drawClockHand];
}
-(void)addTimeSeperatorWith:(CGRect)rect{
    UIBezierPath *selectorCirclePath = [UIBezierPath bezierPathWithRect:rect];
  
    CAShapeLayer *selectorCircleLayer = [CAShapeLayer layer];
    selectorCircleLayer.path = selectorCirclePath.CGPath;
    [selectorCircleLayer setStrokeColor:textColor.CGColor];
    selectorCircleLayer.lineWidth = MAINCIRCLE_LINE_WIDTH;
    [selectorCircleLayer setFillColor:textColor.CGColor];
    [seperatorLineView.layer addSublayer:selectorCircleLayer];
}

-(void)addNumbers:(BOOL)isHour{
    double perAngle = 2 * M_PI / 12;
    CGFloat x_point;
    CGFloat y_point;
    for (int i = 1; i < 13; i++) {
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        [bt setFrame:CGRectMake(0,0, 30, 30)];
        [bt setTag:110+i];
        
        [bt setBackgroundColor:[UIColor clearColor]];
        [bt.layer setCornerRadius:bt.frame.size.width/2];
        if (!isHour) {
            [bt.titleLabel setFont:[UIFont boldSystemFontOfSize:10.0]];
            x_point = minutesCircle.frame.size.width/2 + 64*sin(perAngle*i);
            y_point = minutesCircle.frame.size.height/2 - 64*cos(perAngle*i);
            if (i*5 == 60) {
            [bt setTitle:@"00" forState:UIControlStateNormal];
            }else
            [bt setTitle:[NSString stringWithFormat:@"%02d",5*i] forState:UIControlStateNormal];
            [minutesCircle addSubview:bt];
            [bt setTitleColor:textColor forState:UIControlStateNormal];
        }else{
            [bt.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
            x_point = hoursCircle.frame.size.width/2 + sin(perAngle*i)*83;
            y_point = hoursCircle.frame.size.height/2 -cos(perAngle*i)*83;
            [bt setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
            [bt setTitleColor:textColor forState:UIControlStateNormal];
            [hoursCircle addSubview:bt];
        }
        
        [bt setCenter:CGPointMake(x_point, y_point)];
        [bt addTarget:self action:@selector(timeClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self bringSubviewToFront:bt];
        
        
    }
    
    
}
- (void)drawClockHand{
    // Define shape
    NSEnumerator *enumerator = [mask.sublayers reverseObjectEnumerator];
    for(CALayer *layer in enumerator) {
        [layer removeFromSuperlayer];
    }
    
    // Shape layer mask
    mask = [CAShapeLayer layer];
    [mask setFillRule:kCAFillRuleEvenOdd];
    [mask setFillColor:[[UIColor colorWithHue:0.0f saturation:0.0f brightness:0.0f alpha:0.9f] CGColor]];
    [mask setBackgroundColor:[[UIColor clearColor] CGColor]];
    [clockHandView.layer addSublayer:mask];
    UIBezierPath *centerCirclePath = [UIBezierPath bezierPath];
    
    CGPoint centerCirclePoint =  CGPointMake(clockHandView.frame.size.width/2, clockHandView.frame.size.height/2);
    centerCirclePath = [UIBezierPath bezierPathWithArcCenter:centerCirclePoint
                                                     radius:kSmallCircleRadius
                                                 startAngle:0 endAngle:DEGREES_TO_RADIANS(360)
                                                  clockwise:NO];
    
    [centerCirclePath moveToPoint:centerCirclePoint];
    CGPoint line_Point = CGPointMake(centerCirclePoint.x,centerCirclePoint.y -70);
    [centerCirclePath addLineToPoint:line_Point];
    UIBezierPath *selectorCirclePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(line_Point.x-1.0f, line_Point.y-kMainCircleRadius)
                                                                  radius:kMainCircleRadius
                                                              startAngle:0
                                                                endAngle:DEGREES_TO_RADIANS(360)
                                                               clockwise:NO];
    CAShapeLayer *selectorCircleLayer = [CAShapeLayer layer];
    selectorCircleLayer.path = selectorCirclePath.CGPath;
    [selectorCircleLayer setStrokeColor:clockPointerColor.CGColor];
    selectorCircleLayer.lineWidth = MAINCIRCLE_LINE_WIDTH;
    [selectorCircleLayer setFillColor:clockPointerColor.CGColor];
    selectorCircleLayer.opacity = 0.5f;
    
    //Small Circle Layer
    CAShapeLayer *centerCircleLayer = [CAShapeLayer layer];
    centerCircleLayer.path = centerCirclePath.CGPath;
    [centerCircleLayer setStrokeColor:clockPointerColor.CGColor];
    centerCircleLayer.lineWidth = 1.0f;
    [centerCircleLayer setFillColor:clockPointerColor.CGColor];
    centerCircleLayer.opacity = 0.5f;
    [mask addSublayer:selectorCircleLayer];
    [mask addSublayer:centerCircleLayer];
}
@end
