//
//  HMSHotelViewController.h
//  HMS
//
//  Created by flav on 21/03/2014.
//  Copyright (c) 2014 flav. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>

#import "MWPhotoBrowser.h"

@interface HMSHotelViewController : UIViewController <MKMapViewDelegate,MWPhotoBrowserDelegate>

@property (strong, nonatomic) id detailItem;
//@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
//@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
//@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;


@end
