//
//  BlackoutDatePickerController.h
//  Birchbox
//
//  Created by Richie Davis on 11/25/14.
//  Copyright (c) 2014 Birchbox Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlackoutDatePicker.h"

@protocol BlackoutDatePickerControllerDelegate

- (void)dateChangedToDate:(NSDate *)date;

@end

@interface BlackoutDatePickerController : NSObject <BlackoutDatePickerDelegateAndDataSource, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, assign) id<BlackoutDatePickerControllerDelegate> delegate;

- (void)updateMaxDate:(NSDate *)date;
- (void)updateMinDate:(NSDate *)date;

- (id)initWithDate:(NSDate *)date;

- (void)updateRowsToSelectedDayUsingPicker:(BlackoutDatePicker *)datePicker;
- (void)messageViewControllerWithDate;

@end
