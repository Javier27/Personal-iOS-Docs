//
//  ViewController.m
//  BlackoutWeekendsDatepicker
//
//  Created by Richie Davis on 11/21/14.
//  Copyright (c) 2014 Vissix. All rights reserved.
//

#import "ViewController.h"
#import "DatePicker.h"
#import "DatePickerController.h"

@interface ViewController () <DatePickerControllerDelegate>

@property (strong, nonatomic) UITextField *dateField;

@property (strong, nonatomic) DatePicker *datePicker;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.datePicker = [DatePicker new];
    self.datePicker.controllerDelegate = self;

    UIToolbar *toolBar = [UIToolbar new];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    [toolBar sizeToFit];
    NSMutableArray *toolBarItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *toolBarFlexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [toolBarItems addObject:toolBarFlexSpace];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStylePlain target:self action:@selector(dateSelected)];
    [toolBarItems addObject:doneButton];
    [toolBar setItems:toolBarItems animated:YES];

    self.dateFormatter = [NSDateFormatter new];
    self.dateFormatter.dateFormat = @"MM-dd-yyyy";

    self.datePicker.blackoutDates = @[ [self.dateFormatter dateFromString:@"11-26-2014"],
                                       [self.dateFormatter dateFromString:@"11-27-2014"],
                                       [self.dateFormatter dateFromString:@"11-28-2014"]
                                       ];

    self.dateField = [[UITextField alloc] initWithFrame:CGRectMake(100, 200, 150, 50)];
    [self.dateField setBackgroundColor:[UIColor blackColor]];
    [self.dateField setTextColor:[UIColor whiteColor]];
    [self.dateField setTextAlignment:NSTextAlignmentCenter];
    self.dateField.text = @"PICK A DATE!";
    self.dateField.inputView = self.datePicker;
    self.dateField.inputAccessoryView = toolBar;
    [self.view addSubview:self.dateField];
}

- (void)dateChangedToDate:(NSDate *)date
{
    self.dateField.text = [self.dateFormatter stringFromDate:date];
}

- (void)dateSelected
{
    [self.dateField endEditing:YES];
}

@end
