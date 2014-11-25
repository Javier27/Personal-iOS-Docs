//
//  DatePicker.m
//  BlackoutWeekendsDatepicker
//
//  Created by Richie Davis on 11/22/14.
//  Copyright (c) 2014 Vissix. All rights reserved.
//

#import "DatePicker.h"

@interface DatePicker ()

@property (nonatomic, strong) DatePickerController *datePickerController;
@property (nonatomic) BOOL controllerIsDelegate;
@property (nonatomic) BOOL controllerIsDataSource;

@end

@implementation DatePicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _blackoutTextColor = [UIColor lightGrayColor];
        _textColor = [UIColor blackColor];
        _minimumDate = [NSDate date];

        _blackoutSelectionType = DatePickerBlackoutSelectionTypePast;
        _pastDisplayType = DatePickerPastDisplayTypeHide;

        _selectedDate = [NSDate date];

        _datePickerController = [[DatePickerController alloc] initWithDatePicker:self];
        [super setDelegate:self.datePickerController];
        [super setDataSource:self.datePickerController];
        _controllerIsDelegate = YES;
        _controllerIsDataSource = YES;
    }
    return self;
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    if (self.controllerIsDataSource && self.controllerIsDelegate) {
        [self.datePickerController scrollToDefaultRowsForPicker:self];
    }
}

- (void)setControllerDelegate:(id<DatePickerControllerDelegate>)controllerDelegate
{
    self.datePickerController.delegate = controllerDelegate;
}

- (void)setDelegate:(id<UIPickerViewDelegate>)delegate
{
    self.controllerIsDelegate = NO;
    [super setDelegate:delegate];
    if (!self.controllerIsDataSource) {
        self.datePickerController = nil;
    }
}

- (void)setDataSource:(id<UIPickerViewDataSource>)dataSource
{
    self.controllerIsDataSource = NO;
    [super setDataSource:dataSource];
    if (!self.controllerIsDelegate) {
        self.datePickerController = nil;
    }
}

- (void)setMaximumDate:(NSDate *)maximumDate
{
    _maximumDate = maximumDate;
    if (maximumDate) {
        [self.datePickerController updateMaxDate:maximumDate];
    }
}

- (void)setMinimumDate:(NSDate *)minimumDate
{
    _minimumDate = minimumDate;
    if (minimumDate) {
        [self.datePickerController updateMinDate:minimumDate];
    }
}

- (void)dealloc
{
    self.datePickerController = nil;
    self.delegate = nil;
    self.dataSource = nil;
}
@end
