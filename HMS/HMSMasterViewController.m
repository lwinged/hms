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
    UIPickerView * picker;
    NSInteger _lastSelected;
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
    
    if (_lastSelected == NSNotFound)
    {
    _lastSelected = 0;
        NSLog(@"NO");
    }
    _country = [[NSArray alloc] initWithObjects:@"France", @"Chine", @"Vietnam", nil];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"country = %@", [_country objectAtIndex:_lastSelected] ];
    _countryHotels = [_hotels filteredArrayUsingPredicate:predicate];
    
    _objects = [HMSHelperIndexedList addContentInIndexedList:[HMSHelperIndexedList createDictionnaryForIndexedList:_countryHotels :@"city"]];
    
    indices = [_objects valueForKey:@"headerTitle"];
    
    //NSLog(@"%@", [[_hotels objectAtIndex:0] country]);
}

- (IBAction)countryButton:(id)sender {
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 288, 310, 260)];
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    picker.backgroundColor = [UIColor whiteColor];
    picker.layer.cornerRadius = 5;
    [picker selectRow:_lastSelected inComponent:0 animated:YES];
    [self.view addSubview:picker];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 3;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    UITapGestureRecognizer *myGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickerTapped:)];
    NSString * title = nil;
    
    for (NSInteger i = 0; i != _country.count; ++i)
    {
        if (i == row)
        {
            title = [_country objectAtIndex:i];
            _CountrySelected = title;
            [pickerView addGestureRecognizer:myGR];
        }
    }
    
    return title;
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _lastSelected = row;
}

-(void)pickerTapped:(id)sender
{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"country = %@", _CountrySelected];
    _countryHotels = [_hotels filteredArrayUsingPredicate:predicate];
    [_countryButton setTitle:_CountrySelected forState:UIControlStateNormal];
    
    _objects = [HMSHelperIndexedList addContentInIndexedList:[HMSHelperIndexedList createDictionnaryForIndexedList:_countryHotels :@"city"]];
    
    indices = [_objects valueForKey:@"headerTitle"];

    [self.tableView reloadData];
    [picker removeFromSuperview];
    NSLog(@"%@", _countryHotels);
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
