//
//  DatePicker.h
//  BlackoutWeekendsDatepicker
//
//  Created by Richie Davis on 11/22/14.
//  Copyright (c) 2014 Vissix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerController.h"

@protocol DatePickerDelegate

@end

@interface DatePicker : UIPickerView

@property (nonatomic, assign) id<DatePickerControllerDelegate> controllerDelegate;

@property (nonatomic, strong) NSDate *selectedDate;

@property (nonatomic, strong) NSDate *minimumDate;
@property (nonatomic, strong) NSDate *maximumDate;

@property (nonatomic, copy) NSArray *blackoutDates;

@property (nonatomic, strong) UIColor *blackoutTextColor;
@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic) DatePickerBlackoutSelectionType blackoutSelectionType;
@property (nonatomic) DatePickerPastDisplayType pastDisplayType;

@end
