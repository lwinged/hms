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

//#import "HMSMathHelper.h"

@interface HMSMasterViewController () {
    NSArray * _objects;
    NSArray *indices;
    NSArray * _hotels;
    HMSAppDelegate *appDelegate;
    
    NSArray *_countryHotels;
    NSArray *_country;
    NSString *_CountrySelected;
    SBPickerSelector * picker;
    NSString *_lastSelected;
    NSInteger lastIndex;
    
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
    
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:[_hotels valueForKey:@"country"]];
    
   _country = [orderedSet.array sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    _CountrySelected = appDelegate.searchHotel;
    
    lastIndex = [_country indexOfObject:appDelegate.searchHotel];
    
    self.countryButton.title = appDelegate.searchHotel;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"country = %@", appDelegate.searchHotel];
    _countryHotels = [_hotels filteredArrayUsingPredicate:predicate];
    
    _objects = [HMSHelperIndexedList addContentInIndexedList:[HMSHelperIndexedList createDictionnaryForIndexedList:_countryHotels :@"city"]];
    
    indices = [_objects valueForKey:@"headerTitle"];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)changeCountry:(id)sender
{
    picker = [SBPickerSelector picker];
    
    picker.pickerData = [_country mutableCopy]; //picker content
    picker.delegate = self;
    picker.pickerType = SBPickerSelectorTypeText;
    picker.doneButtonTitle = @"Done";
    picker.cancelButtonTitle = @"Cancel";


    [picker.pickerView selectRow:lastIndex inComponent:0 animated:YES];
    _lastSelected = _CountrySelected;
    
    [picker showPickerOver:self];
    
}


-(void) SBPickerSelector:(SBPickerSelector *)selector selectedValue:(NSString *)value index:(NSInteger)idx{
    
    _CountrySelected = [_country objectAtIndex:idx];
    lastIndex = idx;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"country = %@", _CountrySelected];
    _countryHotels = [_hotels filteredArrayUsingPredicate:predicate];
    self.countryButton.title = _CountrySelected;
    
    _objects = [HMSHelperIndexedList addContentInIndexedList:[HMSHelperIndexedList createDictionnaryForIndexedList:_countryHotels :@"city"]];
    
    indices = [_objects valueForKey:@"headerTitle"];
    appDelegate.searchHotel = _CountrySelected;
    
    [self.tableView reloadData];
    
    appDelegate.saved = YES;
    
}


-(void) SBPickerSelector:(SBPickerSelector *)selector cancelPicker:(BOOL)cancel
{
    
    appDelegate.searchHotel = _lastSelected;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"country = %@", _lastSelected];
    _countryHotels = [_hotels filteredArrayUsingPredicate:predicate];
    self.countryButton.title = _lastSelected;
    
    _objects = [HMSHelperIndexedList addContentInIndexedList:[HMSHelperIndexedList createDictionnaryForIndexedList:_countryHotels :@"city"]];
    
    indices = [_objects valueForKey:@"headerTitle"];
    
    [self.tableView reloadData];
}

-(void) SBPickerSelector:(SBPickerSelector *)selector intermediatelySelectedValue:(id)value atIndex:(NSInteger)idx{
    if ([value isMemberOfClass:[NSDate class]]) {
        [self SBPickerSelector:selector dateSelected:value];
    }else{
        [self SBPickerSelector:selector selectedValue:value index:idx];
    }
}

/*
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    
    
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
//         picker.view.frame = CGRectMake(0, 0, 320, 216);
    }
    else {
 
        UIWindow * window = [[UIApplication sharedApplication] keyWindow];

       
               CGAffineTransform transformNorm = CGAffineTransformMakeScale(1.0, 1.0);
                CGAffineTransform transformC = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-90));
        ////y x
        
//
//        picker.view.frame = window.frame;
//        picker.view.contentMode
        
//        CGRect f = CGRectMake(0, 0, window.frame.size.width, window.frame.size.height);
//        picker.view.frame = f;
  
        
            for (UIView *v in picker.view.subviews)
            {
                v.frame = self.view.bounds;
            }
        
        
//           picker.view.frame = CGRectMake(-self.view.center.x/5  , 0 , self.view.frame.size.width, picker.view.frame.size.height);
//         picker.view.transform = CGAffineTransformConcat(transformNorm, transformC);

        
        
        
//        CGAffineTransform transformNorm = CGAffineTransformMakeScale(1.0, 1.0);
//        CGAffineTransform transformC = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-90));
////y x
//        picker.view.frame = CGRectMake(-self.view.center.x/5  ,self.view.frame.size.width/3 - 8 , self.view.frame.size.width, picker.view.frame.size.height);
//        picker.view.transform = CGAffineTransformConcat(transformNorm, transformC);
    }
    
}
 */

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

- (void) reloadDataTableView:(BOOL)animated
{
    _hotels = appDelegate.sharedHotels;
    
    
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:[_hotels valueForKey:@"country"]];
    
    _country = [orderedSet.array sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    _CountrySelected = appDelegate.searchHotel;
    
    lastIndex = [_country indexOfObject:appDelegate.searchHotel];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"country = %@", appDelegate.searchHotel];
    _countryHotels = [_hotels filteredArrayUsingPredicate:predicate];
    
    _objects = [HMSHelperIndexedList addContentInIndexedList:[HMSHelperIndexedList createDictionnaryForIndexedList:_countryHotels :@"city"]];
    
    indices = [_objects valueForKey:@"headerTitle"];
    
    
    [self.tableView reloadData];

    if (animated)
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.tableView.numberOfSections)] withRowAnimation:UITableViewRowAnimationBottom];
}



@end
