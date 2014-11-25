//
//  DatePickerController.h
//  BlackoutWeekendsDatepicker
//
//  Created by Richie Davis on 11/22/14.
//  Copyright (c) 2014 Vissix. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DatePicker;

typedef enum {
    DatePickerBlackoutSelectionTypeClosest,
    DatePickerBlackoutSelectionTypePast,
    DatePickerBlackoutSelectionTypeFuture
} DatePickerBlackoutSelectionType;

typedef enum {
    DatePickerPastDisplayTypeShow,
    DatePickerPastDisplayTypeHide
} DatePickerPastDisplayType;

@protocol DatePickerControllerDelegate

- (void)dateChangedToDate:(NSDate *)date;

@end

@interface DatePickerController : NSObject <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, assign) id<DatePickerControllerDelegate> delegate;

- (void)updateMaxDate:(NSDate *)date;
- (void)updateMinDate:(NSDate *)date;

- (id)initWithDatePicker:(DatePicker *)datePicker;

- (void)scrollToDefaultRowsForPicker:(DatePicker *)datePicker;

@end
