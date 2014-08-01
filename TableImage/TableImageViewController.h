//
//  TableImageViewController.h
//  TableImage
//
//  Created by NTL BUSINESS APP on 7/31/14.
//  Copyright (c) 2014 YourCompany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON.h"
#import "SimpleTableCell.h"

@interface TableImageViewController : UIViewController {
    NSMutableData *responseData;
    NSMutableArray *pArrMessage,*pArrImagepath;
    SimpleTableCell * cell;

    IBOutlet UITableView *pTbleImg;

}

@property (nonatomic, retain) IBOutlet UIImageView *pImageView;
@end
