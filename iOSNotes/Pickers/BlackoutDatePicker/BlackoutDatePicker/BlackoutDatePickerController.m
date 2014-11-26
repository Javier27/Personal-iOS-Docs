//
//  BlackoutDatePickerController.m
//  Birchbox
//
//  Created by Richie Davis on 11/25/14.
//  Copyright (c) 2014 Birchbox Inc. All rights reserved.
//

#import "BlackoutDatePickerController.h"
#import "BlackoutDatePicker.h"

typedef enum {
    PickerViewComponentDay,
    PickerViewComponentMonth,
    PickerViewComponentYear
} PickerViewComponent;

static const NSUInteger kDefaultNumberOfYearsInTheFutureAllowed = 20;

@interface BlackoutDatePickerController ()

@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSDateComponents *selectedDateComponents;
@property (nonatomic, strong) NSDate *minimumDate;
@property (nonatomic, strong) NSDate *maximumDate;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation BlackoutDatePickerController

- (id)initWithDate:(NSDate *)date
{
    self = [super init];
    if (self) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _selectedDateComponents = [self.calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:date];

        NSDateComponents *components = [_selectedDateComponents copy];
        components.year += kDefaultNumberOfYearsInTheFutureAllowed;
        _minimumDate = [NSDate date];
        _maximumDate = [_calendar dateFromComponents:components];
        _dateFormatter = [NSDateFormatter new];
    }

    return self;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case PickerViewComponentDay: {
            NSRange range = [self.calendar rangeOfUnit:NSCalendarUnitDay
                                                inUnit:NSCalendarUnitMonth
                                               forDate:[self.calendar dateFromComponents:self.selectedDateComponents]];
            return range.length;
        }
        case PickerViewComponentMonth: {
            return [self.dateFormatter.monthSymbols count];
        }
        case PickerViewComponentYear: {
            return ([self.calendar component:NSCalendarUnitYear fromDate:self.maximumDate] -
                    [self.calendar component:NSCalendarUnitYear fromDate:self.minimumDate] + 1);
        }
        default: {
            return 0;
        }
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    switch (component) {
        case PickerViewComponentDay:
            return 50.0f;
        case PickerViewComponentMonth:
            return 180.0f;
        case PickerViewComponentYear:
            return 100.0f;
        default:
            return 0.0f;
    }
}

#pragma mark - UIPickerViewDelegate

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title;
    switch (component) {
        case PickerViewComponentDay:
            title = [NSString stringWithFormat:@"%li", row + 1];
            break;
        case PickerViewComponentMonth:
            title = self.dateFormatter.monthSymbols[row];
            break;
        case PickerViewComponentYear:
            title = [NSString stringWithFormat:@"%li", [self.calendar component:NSCalendarUnitYear fromDate:self.minimumDate] + row];
            break;
    }

    if (![self isRowAvailable:row component:component datePicker:(BlackoutDatePicker *)pickerView]) {
        return [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    } else {
        return [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    BlackoutDatePicker *picker = (BlackoutDatePicker *)pickerView;

    picker.userInteractionEnabled = NO;

    switch (component) {
        case PickerViewComponentDay:
            self.selectedDateComponents.day = row + 1;
            break;
        case PickerViewComponentMonth:
            self.selectedDateComponents.month = row + 1;
            break;
        case PickerViewComponentYear:
            self.selectedDateComponents.year = [self.calendar component:NSCalendarUnitYear fromDate:self.minimumDate] + row;
            break;
    }

    [picker reloadAllComponents];
    // check if component is valid, if not then find the closest available date
    BOOL isValidSelection = [self isDateAvailable:[self.calendar dateFromComponents:self.selectedDateComponents] datePicker:picker];

    if (!isValidSelection) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"blackoutDatePickerDelegateInvalidBlackoutDateChosen"
                                                            object:self];
        [self pickClosestAvailableDateForDatePicker:(BlackoutDatePicker *)picker];
        
        picker.selectedDate = [self.calendar dateFromComponents:self.selectedDateComponents];

        [picker selectRow:(self.selectedDateComponents.year - [self.calendar component:NSCalendarUnitYear fromDate:self.minimumDate]) inComponent:PickerViewComponentYear animated:YES];
        [picker selectRow:(self.selectedDateComponents.month - 1) inComponent:PickerViewComponentMonth animated:YES];
        [picker selectRow:(self.selectedDateComponents.day - 1) inComponent:PickerViewComponentDay animated:YES];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"blackoutDatePickerDelegateValidBlackoutDateChosen"
                                                            object:self];
    }

    [self.delegate dateChangedToDate:picker.selectedDate];

    picker.userInteractionEnabled = YES;
}

#pragma mark - UIPickerView Helpers

- (void)updateMaxDate:(NSDate *)date
{
    self.maximumDate = date;
}

- (void)updateMinDate:(NSDate *)date
{
    self.minimumDate = date;
}

- (BOOL)isDateAvailable:(NSDate *)date datePicker:(BlackoutDatePicker *)datePicker
{
    return ([self dateIsInRange:date] && ![datePicker.blackoutDates containsObject:date]);
}
- (BOOL)isRowAvailable:(NSInteger)row component:(NSInteger)component datePicker:(BlackoutDatePicker *)datePicker
{
    switch (component) {
        case PickerViewComponentDay: {
            NSDateComponents *dateComponentsToCompare = [self.selectedDateComponents copy];
            dateComponentsToCompare.day = row + 1;
            NSDate *date = [self.calendar dateFromComponents:dateComponentsToCompare];
            return (![datePicker.blackoutDates containsObject:date] && [self dateIsInRange:date]);
        }
        case PickerViewComponentMonth: {
            return [self monthIsInRange:(row + 1)];
        }
        default: {
            return YES;
        }
    }
}

- (BOOL)dateIsInRange:(NSDate *)date
{
    return !([self dateIsLessThanMinimum:date] || [self dateIsGreaterThanMaximim:date]);
}

- (BOOL)dateIsLessThanMinimum:(NSDate *)date
{
    return [date compare:self.minimumDate] == NSOrderedAscending && ![self dateIsMinimumDate:date];
}

- (BOOL)dateIsGreaterThanMaximim:(NSDate *)date
{
    return [date compare:self.maximumDate] == NSOrderedDescending && ![self dateIsMaximumDate:date];
}

- (BOOL)dateIsMinimumDate:(NSDate *)date
{
    NSDateComponents *minComponents = [self.calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:self.minimumDate];
    NSDateComponents *dateComponents = [self.calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:date];
    return (minComponents.day == dateComponents.day &&
            minComponents.month == dateComponents.month &&
            minComponents.year == dateComponents.year);
}

- (BOOL)dateIsMaximumDate:(NSDate *)date
{
    NSDateComponents *maxComponents = [self.calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:self.maximumDate];
    NSDateComponents *dateComponents = [self.calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:date];
    return (maxComponents.day == dateComponents.day &&
            maxComponents.month == dateComponents.month &&
            maxComponents.year == dateComponents.year);
}

- (BOOL)monthIsInRange:(NSInteger)month
{
    NSInteger selectedYear = self.selectedDateComponents.year;
    NSDateComponents *minComponents = [self.calendar components:(NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:self.minimumDate];
    NSDateComponents *maxComponents = [self.calendar components:(NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:self.maximumDate];
    return ((selectedYear < maxComponents.year || (selectedYear == maxComponents.year && month <= maxComponents.month)) &&
            (selectedYear > minComponents.year || (selectedYear == minComponents.year && month >= minComponents.month)));
}

- (void)pickClosestAvailableDateForDatePicker:(BlackoutDatePicker *)datePicker
{
    NSDateComponents *minDateAvailable = [self.selectedDateComponents copy];
    [self decrementDateComponents:minDateAvailable];
    NSDateComponents *maxDateAvailable = [self.selectedDateComponents copy];
    [self incrementDateComponents:maxDateAvailable];

    BOOL minNotFound = YES;
    NSInteger minDateDifference = 1;
    while (![self dateIsLessThanMinimum:[self.calendar dateFromComponents:minDateAvailable]] && minNotFound) {
        minNotFound = ![self isDateAvailable:[self.calendar dateFromComponents:minDateAvailable] datePicker:datePicker];
        if (minNotFound) {
            minDateDifference++;
            [self decrementDateComponents:minDateAvailable];
        }
    }

    BOOL maxNotFound = YES;
    NSInteger maxDateDifference = 1;
    while (![self dateIsGreaterThanMaximim:[self.calendar dateFromComponents:maxDateAvailable]] && maxNotFound) {
        maxNotFound = ![self isDateAvailable:[self.calendar dateFromComponents:maxDateAvailable] datePicker:datePicker];
        if (maxNotFound) {
            maxDateDifference++;
            [self incrementDateComponents:maxDateAvailable];
        }
    }

    minDateDifference = minNotFound ? NSIntegerMax : minDateDifference;
    maxDateDifference = maxNotFound ? NSIntegerMax : maxDateDifference;

    switch (datePicker.blackoutSelectionType) {
        case BlackoutDatePickerSelectionTypeClosest:
            self.selectedDateComponents = (minDateDifference < maxDateDifference) ? minDateAvailable : maxDateAvailable;
            break;
        case BlackoutDatePickerSelectionTypeFuture:
            self.selectedDateComponents = (maxDateDifference != NSIntegerMax) ? maxDateAvailable : minDateAvailable;
            break;
        case BlackoutDatePickerSelectionTypePast:
            self.selectedDateComponents = (minDateDifference != NSIntegerMax) ? minDateAvailable : maxDateAvailable;
            break;
    }
}

- (void)decrementDateComponents:(NSDateComponents *)dateComponents
{
    if (dateComponents.day == 1) {
        if (dateComponents.month == 1) {
            dateComponents.year--;
        }
        dateComponents.month = (dateComponents.month == 1) ? 12 : dateComponents.month - 1;
        NSRange range = [self.calendar rangeOfUnit:NSCalendarUnitDay
                                            inUnit:NSCalendarUnitMonth
                                           forDate:[self.calendar dateFromComponents:dateComponents]];
        dateComponents.day = range.length;
    } else {
        dateComponents.day--;
    }
}

- (void)incrementDateComponents:(NSDateComponents *)dateComponents
{
    NSRange range = [self.calendar rangeOfUnit:NSCalendarUnitDay
                                        inUnit:NSCalendarUnitMonth
                                       forDate:[self.calendar dateFromComponents:dateComponents]];
    if (dateComponents.day == range.length) {
        if (dateComponents.month == 12) {
            dateComponents.year++;
        }
        dateComponents.month = (dateComponents.month == 12) ? 1 : dateComponents.month + 1;
        dateComponents.day = 1;
    } else {
        dateComponents.day++;
    }
}

@end