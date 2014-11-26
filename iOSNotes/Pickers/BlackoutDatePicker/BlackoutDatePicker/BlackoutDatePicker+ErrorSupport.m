//
//  BlackoutDatePicker+ErrorSupport.m
//  BlackoutDatePicker
//
//  Created by Richie Davis on 11/25/14.
//  Copyright (c) 2014 Vissix. All rights reserved.
//

#import "BlackoutDatePicker+ErrorSupport.h"

@interface BlackoutDatePicker_ErrorSupport ()

@property (nonatomic, strong) BlackoutDatePicker *datePicker;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic) BOOL labelShowing;

@end

@implementation BlackoutDatePicker_ErrorSupport

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _datePicker = [BlackoutDatePicker new];
        _datePicker.backgroundColor = [UIColor whiteColor];

        self.invalidDateMessage = [NSAttributedString new];

        frame.size.height = _datePicker.frame.size.height;
        self.frame = frame;
        [self addSubview:_datePicker];

        frame = _datePicker.frame;
        frame.size.height = 40;

        _errorLabel = [[UILabel alloc] initWithFrame:frame];
        _errorLabel.textAlignment = NSTextAlignmentCenter;;
        _labelShowing = NO;
        [self insertSubview:_errorLabel belowSubview:_datePicker];
    }
    return self;
}

- (void)dealloc
{
    self.datePicker = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setController:(id<BlackoutDatePickerDelegateAndDataSource, UIPickerViewDelegate, UIPickerViewDataSource>)controller
{
    if (self.datePicker.controller) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:@"blackoutDatePickerDelegateInvalidBlackoutDateChosen"
                                                      object:self.datePicker.controller];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:@"blackoutDatePickerDelegateValidBlackoutDateChosen"
                                                      object:self.datePicker.controller];
    }
    self.datePicker.controller = controller;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showErrorMessage)
                                                 name:@"blackoutDatePickerDelegateInvalidBlackoutDateChosen"
                                               object:controller];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(removeErrorMessage)
                                                 name:@"blackoutDatePickerDelegateValidBlackoutDateChosen"
                                               object:controller];
}

- (void)setDelegate:(id<UIPickerViewDelegate>)delegate
{
    self.datePicker.delegate = delegate;
}

- (void)setDataSource:(id<UIPickerViewDataSource>)dataSource
{
    self.datePicker.dataSource = dataSource;
}

- (void)setBlackoutSelectionType:(BlackoutDatePickerSelectionType)blackoutSelectionType
{
    self.datePicker.blackoutSelectionType = blackoutSelectionType;
}

- (void)setTextColor:(UIColor *)textColor
{
    self.datePicker.textColor = textColor;
}

- (void)setBlackoutTextColor:(UIColor *)blackoutTextColor
{
    self.datePicker.blackoutTextColor = blackoutTextColor;
}

- (void)setBlackoutDates:(NSArray *)blackoutDates
{
    self.datePicker.blackoutDates = blackoutDates;
}

- (void)setSelectedDate:(NSDate *)selectedDate
{
    self.datePicker.selectedDate = selectedDate;
}

- (void)setMaximumDate:(NSDate *)maximumDate
{
    self.datePicker.maximumDate = maximumDate;
}

- (void)setMinimumDate:(NSDate *)minimumDate
{
    self.datePicker.minimumDate = minimumDate;
}

- (void)setInvalidDateMessage:(NSAttributedString *)invalidDateMessage
{
    self.errorLabel.attributedText = invalidDateMessage;
    _invalidDateMessage = invalidDateMessage;
}

- (void)setInvalidDateMessageBackgroundColor:(UIColor *)invalidDateMessageBackgroundColor
{
    self.errorLabel.backgroundColor = invalidDateMessageBackgroundColor;
    _invalidDateMessageBackgroundColor = invalidDateMessageBackgroundColor;
}

- (id<BlackoutDatePickerDelegateAndDataSource, UIPickerViewDelegate, UIPickerViewDataSource>)controller
{
    return self.datePicker.controller;
}

- (id<UIPickerViewDelegate>)delegate
{
    return self.datePicker.delegate;
}

- (id<UIPickerViewDataSource>)dataSource
{
    return self.datePicker.dataSource;
}

- (BlackoutDatePickerSelectionType)blackoutSelectionType
{
    return self.datePicker.blackoutSelectionType;
}

- (UIColor *)textColor
{
    return self.datePicker.textColor;
}

- (UIColor *)blackoutTextColor
{
    return self.datePicker.blackoutTextColor;
}

- (NSArray *)blackoutDates
{
    return self.datePicker.blackoutDates;
}

- (NSDate *)selectedDate
{
    return self.datePicker.selectedDate;
}

- (NSDate *)maximumDate
{
    return self.datePicker.maximumDate;
}

- (NSDate *)minimumDate
{
    return self.datePicker.minimumDate;
}

- (void)showErrorMessage
{
    if (!self.labelShowing && self.invalidDateMessage) {
        [UIView animateWithDuration:0.3 animations:^{
            self.labelShowing = YES;
            CGRect frame = self.superview.frame;
            frame.origin.y -= 40;
            self.superview.frame = frame;


            frame = self.datePicker.frame;
            frame.origin.y += 40;
            self.datePicker.frame = frame;
        }];
    }
}

- (void)removeErrorMessage
{
    if (self.labelShowing && self.invalidDateMessage) {
        [UIView animateWithDuration:0.3 animations:^{
            self.labelShowing = NO;
            CGRect frame = self.superview.frame;
            frame.origin.y += 40;
            self.superview.frame = frame;


            frame = self.datePicker.frame;
            frame.origin.y -= 40;
            self.datePicker.frame = frame;
        }];
    }
}

@end
