//
//  DatePickerController.m
//  BlackoutWeekendsDatepicker
//
//  Created by Richie Davis on 11/22/14.
//  Copyright (c) 2014 Vissix. All rights reserved.
//

#import "DatePickerController.h"
#import "DatePicker.h"

typedef enum {
    PickerViewComponentDay,
    PickerViewComponentMonth,
    PickerViewComponentYear
} PickerViewComponent;

static const NSUInteger kDefaultNumberOfYearsInTheFutureAllowed = 20;

@interface DatePickerController ()

@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSDateComponents *selectedDateComponents;
@property (nonatomic, strong) NSDateComponents *reusableDateComponents1;
@property (nonatomic, strong) NSDateComponents *reusableDateComponents2;
@property (nonatomic, strong) NSDate *minimumDate;
@property (nonatomic, strong) NSDate *maximumDate;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation DatePickerController

- (id)initWithDatePicker:(DatePicker *)datePicker
{
    self = [super init];
    if (self) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _selectedDateComponents = [self.calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:datePicker.selectedDate];

        _reusableDateComponents1 = [_selectedDateComponents copy];
        _reusableDateComponents1.year += kDefaultNumberOfYearsInTheFutureAllowed;
        _minimumDate = [NSDate date];
        _maximumDate = [_calendar dateFromComponents:_reusableDateComponents1];
        _reusableDateComponents2 = [_selectedDateComponents copy];
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
    DatePicker *picker = (DatePicker *)pickerView;
    switch (component) {
        case PickerViewComponentDay: {
            NSRange range = [self.calendar rangeOfUnit:NSCalendarUnitDay
                                                inUnit:NSCalendarUnitMonth
                                               forDate:[self.calendar dateFromComponents:self.selectedDateComponents]];
            switch (picker.pastDisplayType) {
                case DatePickerPastDisplayTypeHide:
                    if (self.selectedDateComponents.month == [self.calendar component:NSCalendarUnitMonth fromDate:self.minimumDate] &&
                        self.selectedDateComponents.year == [self.calendar component:NSCalendarUnitYear fromDate:self.minimumDate]) {
                        return range.length - [self.calendar component:NSCalendarUnitDay fromDate:self.minimumDate] + 1;
                    } else {
                        return range.length;
                    }
                    break;
                case DatePickerPastDisplayTypeShow:
                    return range.length;
                    break;
            }
        }
        case PickerViewComponentMonth: {
            switch (picker.pastDisplayType) {
                case DatePickerPastDisplayTypeHide:
                    if (self.selectedDateComponents.year == [self.calendar component:NSCalendarUnitYear fromDate:self.minimumDate]) {
                        return [self.dateFormatter.monthSymbols count] - [self.calendar component:NSCalendarUnitMonth fromDate:self.minimumDate] + 1;
                    } else {
                        return [self.dateFormatter.monthSymbols count];
                    }
                    break;
                case DatePickerPastDisplayTypeShow:
                    return [self.dateFormatter.monthSymbols count];
                    break;
            }
        }
        case PickerViewComponentYear: {
            return ([self.calendar component:NSCalendarUnitYear fromDate:self.maximumDate] -
                    [self.calendar component:NSCalendarUnitYear fromDate:self.minimumDate] + 1);
        }
    }
    return 0;
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
    DatePicker *picker = (DatePicker *)pickerView;
    NSString *title;
    switch (component) {
        case PickerViewComponentDay:
            title = [NSString stringWithFormat:@"%li", [self getDayFromRow:row month:self.selectedDateComponents.month year:self.selectedDateComponents.year pastDisplayType:picker.pastDisplayType]];
            break;
        case PickerViewComponentMonth:
            title = self.dateFormatter.monthSymbols[[self getMonthFromRow:row year:self.selectedDateComponents.year pastDisplayType:picker.pastDisplayType] - 1];
            break;
        case PickerViewComponentYear:
            title = [NSString stringWithFormat:@"%li", [self getYearFromRow:row pastDisplayType:picker.pastDisplayType]];
            break;
    }

    if (![self isRowAvailable:row component:component datePicker:(DatePicker *)pickerView dateComponentsOrNil:nil]) {
        return [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    } else {
        return [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    DatePicker *picker = (DatePicker *)pickerView;

    picker.userInteractionEnabled = NO;

    switch (component) {
        case PickerViewComponentDay:
            self.selectedDateComponents.day = [self getDayFromRow:[picker selectedRowInComponent:PickerViewComponentDay] month:self.selectedDateComponents.month year:self.selectedDateComponents.year pastDisplayType:picker.pastDisplayType];
            break;
        case PickerViewComponentMonth:
            self.selectedDateComponents.month = [self getMonthFromRow:[picker selectedRowInComponent:PickerViewComponentMonth] year:self.selectedDateComponents.year pastDisplayType:picker.pastDisplayType];
            break;
        case PickerViewComponentYear:
            self.selectedDateComponents.year = [self getYearFromRow:[picker selectedRowInComponent:PickerViewComponentYear] pastDisplayType:picker.pastDisplayType];
            break;
    }

    [picker reloadAllComponents];
    [self resetRowsFromSelectedDateComponentsWithPicker:picker];

    // check if component is valid, if not then find the closest available date
    BOOL isValidSelection = [self isRowAvailable:[pickerView selectedRowInComponent:PickerViewComponentDay]
                                       component:PickerViewComponentDay
                                      datePicker:(DatePicker *)picker
                             dateComponentsOrNil:nil];

    if (!isValidSelection) {
        [self pickClosestAvailableDateForDatePicker:(DatePicker *)picker];
    }

    picker.selectedDate = [self.calendar dateFromComponents:self.selectedDateComponents];

    [picker reloadAllComponents];
    [self resetRowsFromSelectedDateComponentsWithPicker:picker];

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

- (BOOL)isRowAvailable:(NSInteger)row component:(NSInteger)component datePicker:(DatePicker *)datePicker dateComponentsOrNil:(NSDateComponents *)dateComponents
{
    switch (component) {
        case PickerViewComponentDay: {
            NSDateComponents *dateComponentsToCompare = (dateComponents) ? dateComponents : self.selectedDateComponents;
            dateComponentsToCompare.day = [self getDayFromRow:row month:self.selectedDateComponents.month year:self.selectedDateComponents.year pastDisplayType:datePicker.pastDisplayType];
            NSDate *date = [self.calendar dateFromComponents:dateComponentsToCompare];
            return (![datePicker.blackoutDates containsObject:date] && [self dateIsInRange:date]);
        }
        case PickerViewComponentMonth: {
            return [self monthIsInRange:[self getMonthFromRow:row year:self.selectedDateComponents.year pastDisplayType:datePicker.pastDisplayType]];
        }
        default: {
            return YES;
        }
    }
}

- (BOOL)dateIsInRange:(NSDate *)date
{
    return (([date compare:self.minimumDate] == NSOrderedDescending || [self dateIsMinimumDate:date]) &&
            ([date compare:self.maximumDate] == NSOrderedAscending || [self dateIsMaximumDate:date]));
}

- (BOOL)dateIsMinimumDate:(NSDate *)date
{
    self.reusableDateComponents1 = [self.calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:self.minimumDate];
    self.reusableDateComponents2 = [self.calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:date];
    return (self.reusableDateComponents1.day == self.reusableDateComponents2.day &&
            self.reusableDateComponents1.month == self.reusableDateComponents2.month &&
            self.reusableDateComponents1.year == self.reusableDateComponents2.year);
}

- (BOOL)dateIsMaximumDate:(NSDate *)date
{
    self.reusableDateComponents1 = [self.calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:self.maximumDate];
    self.reusableDateComponents2 = [self.calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:date];
    return (self.reusableDateComponents1.day == self.reusableDateComponents2.day &&
            self.reusableDateComponents1.month == self.reusableDateComponents2.month &&
            self.reusableDateComponents1.year == self.reusableDateComponents2.year);
}

- (BOOL)monthIsInRange:(NSInteger)month
{
    NSInteger selectedYear = self.selectedDateComponents.year;
    self.reusableDateComponents1 = [self.calendar components:(NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:self.minimumDate];
    self.reusableDateComponents2 = [self.calendar components:(NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:self.maximumDate];
    return ((selectedYear < self.reusableDateComponents2.year || (selectedYear == self.reusableDateComponents2.year && month <= self.reusableDateComponents2.month)) &&
            (selectedYear > self.reusableDateComponents1.year || (selectedYear == self.reusableDateComponents1.year && month >= self.reusableDateComponents2.month)));
}

- (void)pickClosestAvailableDateForDatePicker:(DatePicker *)datePicker
{
    NSDateComponents *minDateAvailable = [self.selectedDateComponents copy];
    [self decrementDateComponents:minDateAvailable];
    NSDateComponents *maxDateAvailable = [self.selectedDateComponents copy];
    [self incrementDateComponents:maxDateAvailable];

    BOOL minNotFound = YES;
    NSInteger minDateDifference = 1;
    while ([[self.calendar dateFromComponents:minDateAvailable] compare:self.minimumDate] == NSOrderedDescending && minNotFound) {
        minNotFound = ![self isRowAvailable:[self getRowFromDay:minDateAvailable.day month:minDateAvailable.month year:minDateAvailable.year pastDisplayType:datePicker.pastDisplayType] component:PickerViewComponentDay datePicker:datePicker dateComponentsOrNil:minDateAvailable];
        if (minNotFound) {
            minDateDifference++;
            [self decrementDateComponents:minDateAvailable];
        }
    }

    BOOL maxNotFound = YES;
    NSInteger maxDateDifference = 1;
    while ([[self.calendar dateFromComponents:maxDateAvailable] compare:self.maximumDate] == NSOrderedAscending && maxNotFound) {
        maxNotFound = ![self isRowAvailable:[self getRowFromDay:maxDateAvailable.day month:maxDateAvailable.month year:maxDateAvailable.year pastDisplayType:datePicker.pastDisplayType] component:PickerViewComponentDay datePicker:datePicker dateComponentsOrNil:maxDateAvailable];
        if (maxNotFound) {
            maxDateDifference++;
            [self incrementDateComponents:maxDateAvailable];
        }
    }

    minDateDifference = minNotFound ? NSIntegerMax : minDateDifference;
    maxDateDifference = maxNotFound ? NSIntegerMax : maxDateDifference;

    switch (datePicker.blackoutSelectionType) {
        case DatePickerBlackoutSelectionTypeClosest:
            self.selectedDateComponents = (minDateDifference < maxDateDifference) ? minDateAvailable : maxDateAvailable;
            break;
        case DatePickerBlackoutSelectionTypeFuture:
            self.selectedDateComponents = (maxDateDifference != NSIntegerMax) ? maxDateAvailable : minDateAvailable;
            break;
        case DatePickerBlackoutSelectionTypePast:
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

- (NSInteger)getYearFromRow:(NSInteger)row pastDisplayType:(DatePickerPastDisplayType)type
{
    return [self.calendar component:NSCalendarUnitYear fromDate:self.minimumDate] + row;
}

- (NSInteger)getMonthFromRow:(NSInteger)row year:(NSInteger)year pastDisplayType:(DatePickerPastDisplayType)type
{
    switch (type) {
        case DatePickerPastDisplayTypeHide:
            if (self.selectedDateComponents.year == [self.calendar component:NSCalendarUnitYear fromDate:self.minimumDate]) {
                row += ([self.calendar component:NSCalendarUnitMonth fromDate:self.minimumDate]);
            } else {
                row++;
            }
            break;
        case DatePickerPastDisplayTypeShow:
            row++;
            break;
    }
    return row;
}

- (NSInteger)getDayFromRow:(NSInteger)row month:(NSInteger)month year:(NSInteger)year pastDisplayType:(DatePickerPastDisplayType)type
{
    switch (type) {
        case DatePickerPastDisplayTypeHide:
            if (month == [self.calendar component:NSCalendarUnitMonth fromDate:self.minimumDate] &&
                year == [self.calendar component:NSCalendarUnitYear fromDate:self.minimumDate]) {
                row += ([self.calendar component:NSCalendarUnitDay fromDate:self.minimumDate]);
            } else {
                row++;
            }
            break;
        case DatePickerPastDisplayTypeShow:
            row++;
            break;
    }
    return row;
}

- (NSInteger)getRowFromYear:(NSInteger)year pastDisplayType:(DatePickerPastDisplayType)type
{
    return year - [self.calendar component:NSCalendarUnitYear fromDate:self.minimumDate];
}

- (NSInteger)getRowFromMonth:(NSInteger)month year:(NSInteger)year pastDisplayType:(DatePickerPastDisplayType)type
{
    switch (type) {
        case DatePickerPastDisplayTypeHide:
            if (year == [self.calendar component:NSCalendarUnitYear fromDate:self.minimumDate]) {
                return month - [self.calendar component:NSCalendarUnitMonth fromDate:self.minimumDate];
            } else {
                return month - 1;
            }
            break;
        case DatePickerPastDisplayTypeShow:
            return month - 1;
            break;
    }
}

- (NSInteger)getRowFromDay:(NSInteger)day month:(NSInteger)month year:(NSInteger)year pastDisplayType:(DatePickerPastDisplayType)type
{
    switch (type) {
        case DatePickerPastDisplayTypeHide:
            if (month == [self.calendar component:NSCalendarUnitMonth fromDate:self.minimumDate] &&
                year == [self.calendar component:NSCalendarUnitYear fromDate:self.minimumDate]) {
                return day - [self.calendar component:NSCalendarUnitDay fromDate:self.minimumDate];
            } else {
                return day - 1;
            }
            break;
        case DatePickerPastDisplayTypeShow:
            return day - 1;
            break;
    }
}

- (void)scrollToDefaultRowsForPicker:(DatePicker *)datePicker
{
    self.selectedDateComponents = [self.calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:datePicker.selectedDate];
    [self resetRowsFromSelectedDateComponentsWithPicker:datePicker];
}

- (void)resetRowsFromSelectedDateComponentsWithPicker:(DatePicker *)datePicker
{
    [datePicker selectRow:[self getRowFromYear:self.selectedDateComponents.year pastDisplayType:datePicker.pastDisplayType] inComponent:PickerViewComponentYear animated:NO];
    [datePicker selectRow:[self getRowFromMonth:self.selectedDateComponents.month year:self.selectedDateComponents.year pastDisplayType:datePicker.pastDisplayType] inComponent:PickerViewComponentMonth animated:NO];
    [datePicker selectRow:[self getRowFromDay:self.selectedDateComponents.day month:self.selectedDateComponents.month year:self.selectedDateComponents.year pastDisplayType:datePicker.pastDisplayType] inComponent:PickerViewComponentDay animated:NO];
}

@end
