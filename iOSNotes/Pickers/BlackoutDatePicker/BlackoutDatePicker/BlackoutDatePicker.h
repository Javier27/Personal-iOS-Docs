//
//  BlackoutDatePicker.h
//  Birchbox
//
//  Created by Richie Davis on 11/25/14.
//  Copyright (c) 2014 Birchbox Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BlackoutDatePicker;

typedef enum {
    BlackoutDatePickerSelectionTypeClosest,
    BlackoutDatePickerSelectionTypePast,
    BlackoutDatePickerSelectionTypeFuture
} BlackoutDatePickerSelectionType;

@protocol BlackoutDatePickerDelegateAndDataSource <NSObject>

@required

- (void)updateRowsToSelectedDayUsingPicker:(BlackoutDatePicker *)datePicker;
- (void)messageViewControllerWithDate;
- (void)updateMaxDate:(NSDate *)date;
- (void)updateMinDate:(NSDate *)date;

@end

@interface BlackoutDatePicker : UIPickerView

@property (nonatomic, strong) NSDate *selectedDate;

@property (nonatomic, strong) NSDate *minimumDate;
@property (nonatomic, strong) NSDate *maximumDate;

@property (nonatomic, copy) NSArray *blackoutDates;

@property (nonatomic, strong) UIColor *blackoutTextColor;
@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic) BlackoutDatePickerSelectionType blackoutSelectionType;

@property (nonatomic, assign) id<BlackoutDatePickerDelegateAndDataSource, UIPickerViewDelegate, UIPickerViewDataSource> controller;

@end