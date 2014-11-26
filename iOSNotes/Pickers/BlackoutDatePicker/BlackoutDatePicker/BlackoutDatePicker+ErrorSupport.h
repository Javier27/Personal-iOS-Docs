//
//  BlackoutDatePicker+ErrorSupport.h
//  BlackoutDatePicker
//
//  Created by Richie Davis on 11/25/14.
//  Copyright (c) 2014 Vissix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlackoutDatePicker.h"

@interface BlackoutDatePicker_ErrorSupport : UIView

@property (nonatomic, strong) NSDate *selectedDate;

@property (nonatomic, strong) NSDate *minimumDate;
@property (nonatomic, strong) NSDate *maximumDate;

@property (nonatomic, copy) NSArray *blackoutDates;

@property (nonatomic, strong) UIColor *blackoutTextColor;
@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic) BlackoutDatePickerSelectionType blackoutSelectionType;

@property (nonatomic, assign) id<BlackoutDatePickerDelegateAndDataSource, UIPickerViewDelegate, UIPickerViewDataSource> controller;
@property (nonatomic, assign) id<UIPickerViewDelegate> delegate;
@property (nonatomic, assign) id<UIPickerViewDataSource> dataSource;

@property (nonatomic, strong) NSAttributedString *invalidDateMessage;
@property (nonatomic, strong) UIColor *invalidDateMessageBackgroundColor;

@end
