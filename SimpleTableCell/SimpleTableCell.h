//
//  SimpleTableCell.h
//  SimpleTable
//
//  Created by Simon Ng on 28/4/12.
//  Copyright (c) 2012 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleTableCell : UITableViewCell {
    UIImageView *pImage;
}

@property (nonatomic, retain) IBOutlet UIImageView *pImageView;

@end
