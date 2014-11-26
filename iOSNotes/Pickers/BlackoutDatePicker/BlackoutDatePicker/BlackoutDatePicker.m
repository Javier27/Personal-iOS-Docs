//
//  BlackoutDatePicker.m
//  Birchbox
//
//  Created by Richie Davis on 11/25/14.
//  Copyright (c) 2014 Birchbox Inc. All rights reserved.
//

#import "BlackoutDatePicker.h"

@implementation BlackoutDatePicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _blackoutTextColor = [UIColor lightGrayColor];
        _textColor = [UIColor blackColor];
        _minimumDate = [NSDate date];

        _blackoutSelectionType = BlackoutDatePickerSelectionTypePast;

        _selectedDate = [NSDate date];
    }
    return self;
}

- (void)setController:(id<BlackoutDatePickerDelegateAndDataSource, UIPickerViewDelegate, UIPickerViewDataSource>)controller
{
    if (controller) {
        _controller = nil;
        self.delegate = controller;
        self.dataSource = controller;
        _controller = controller;
    }
}

- (void)setDelegate:(id<UIPickerViewDelegate>)delegate
{
    if (!self.controller) {
        [super setDelegate:delegate];
    }
}

- (void)setDataSource:(id<UIPickerViewDataSource>)dataSource
{
    if (!self.controller) {
        [super setDataSource:dataSource];
    }
}

- (void)setMaximumDate:(NSDate *)maximumDate
{
    _maximumDate = maximumDate;
    if (maximumDate) {
        [self.controller updateMaxDate:maximumDate];
    }
}

- (void)setMinimumDate:(NSDate *)minimumDate
{
    _minimumDate = minimumDate;
    if (minimumDate) {
        [self.controller updateMinDate:minimumDate];
    }
}

- (void)dealloc
{
    self.controller = nil;
    self.delegate = nil;
    self.dataSource = nil;
}

@end
