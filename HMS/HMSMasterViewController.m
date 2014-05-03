//
//  HMSMasterViewController.m
//  HMS
//
//  Created by flav on 19/03/2014.
//  Copyright (c) 2014 flav. All rights reserved.
//

#import "HMSMasterViewController.h"
#import "HMSDetailViewController.h"
#import "HMSHelperIndexedList.h"
#import "HMSHotel.h"
#import "HMSAppDelegate.h"

@interface HMSMasterViewController () {
    NSArray * _objects;
    NSArray *indices;
    NSArray * _hotels;
    
    NSArray *_countryHotels;
    NSArray *_country;
    NSString *_CountrySelected;
    SBPickerSelector * picker;
    NSString *_lastSelected;
    NSInteger lastIndex;
    HMSAppDelegate *appDelegate;
}
@end

@implementation HMSMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Search";
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    _hotels = appDelegate.sharedHotels;
    
    _country = [[NSArray alloc] initWithObjects:@"France", @"US", @"Chine", @"Vietnam", nil];
    
    _CountrySelected = @"France";
    
    lastIndex = 0;
    
    [_countryButton setTitle:appDelegate.searchHotel forState:UIControlStateNormal];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"country = %@", appDelegate.searchHotel];
    _countryHotels = [_hotels filteredArrayUsingPredicate:predicate];
    
    _objects = [HMSHelperIndexedList addContentInIndexedList:[HMSHelperIndexedList createDictionnaryForIndexedList:_countryHotels :@"city"]];
    
    indices = [_objects valueForKey:@"headerTitle"];
    
    //NSLog(@"%@", [[_hotels objectAtIndex:0] country]);
}

- (IBAction)countryButton:(id)sender {
    picker = [SBPickerSelector picker];
    
    picker.pickerData = [_country mutableCopy]; //picker content
    picker.delegate = self;
    picker.pickerType = SBPickerSelectorTypeText;
    picker.doneButtonTitle = @"Done";
    picker.cancelButtonTitle = @"Cancel";
    CGPoint point = [self.view convertPoint:[sender frame].origin fromView:[sender superview]];
    CGRect frame = [sender frame];
    frame.origin = point;
    [picker.pickerView selectRow:lastIndex inComponent:0 animated:YES];
    _lastSelected = _CountrySelected;
    [picker showPickerIpadFromRect:frame inView:self.view];
}

-(void) SBPickerSelector:(SBPickerSelector *)selector selectedValue:(NSString *)value index:(NSInteger)idx{
    
    _CountrySelected = [_country objectAtIndex:idx];
    lastIndex = idx;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"country = %@", _CountrySelected];
    _countryHotels = [_hotels filteredArrayUsingPredicate:predicate];
    [_countryButton setTitle:_CountrySelected forState:UIControlStateNormal];
    
    _objects = [HMSHelperIndexedList addContentInIndexedList:[HMSHelperIndexedList createDictionnaryForIndexedList:_countryHotels :@"city"]];
    
    indices = [_objects valueForKey:@"headerTitle"];
    appDelegate.searchHotel = _CountrySelected;
    
    [self.tableView reloadData];
}

-(void) SBPickerSelector:(SBPickerSelector *)selector dateSelected:(NSDate *)date{
    
}
          

-(void) SBPickerSelector:(SBPickerSelector *)selector cancelPicker:(BOOL)cancel{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"country = %@", _lastSelected];
    _countryHotels = [_hotels filteredArrayUsingPredicate:predicate];
    [_countryButton setTitle:_lastSelected forState:UIControlStateNormal];
    
    _objects = [HMSHelperIndexedList addContentInIndexedList:[HMSHelperIndexedList createDictionnaryForIndexedList:_countryHotels :@"city"]];
    
    indices = [_objects valueForKey:@"headerTitle"];
    
    [self.tableView reloadData];
    NSLog(@"press cancel");
}

-(void) SBPickerSelector:(SBPickerSelector *)selector intermediatelySelectedValue:(id)value atIndex:(NSInteger)idx{
    if ([value isMemberOfClass:[NSDate class]]) {
        [self SBPickerSelector:selector dateSelected:value];
    }else{
        [self SBPickerSelector:selector selectedValue:value index:idx];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _objects.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[_objects objectAtIndex:section] objectForKey:@"rowValues"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    cell.textLabel.text = [[[_objects objectAtIndex:indexPath.section] objectForKey:@"rowValues"]
    objectAtIndex:indexPath.row];
    
    return cell;
}


- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
	return [[_objects objectAtIndex:section] objectForKey:@"headerTitle"];
    
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [_objects valueForKey:@"headerTitle"];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [indices indexOfObject:title];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

        NSString * city = [[[_objects objectAtIndex:indexPath.section] objectForKey:@"rowValues"]
         objectAtIndex:indexPath.row];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"city", city];
        NSArray *filteredArray = [_hotels filteredArrayUsingPredicate:predicate];
        
        [[segue destinationViewController] setTitle:city];
        
        [[segue destinationViewController] setDetailItem:filteredArray];
    }
}



@end
