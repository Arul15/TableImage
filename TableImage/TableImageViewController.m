//
//  TableImageViewController.m
//  TableImage
//
//  Created by NTL BUSINESS APP on 7/31/14.
//  Copyright (c) 2014 YourCompany. All rights reserved.
//

#import "TableImageViewController.h"

@interface TableImageViewController ()

@end

@implementation TableImageViewController
@synthesize pImageView;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    responseData = [NSMutableData data];
    NSString *urlRequest =[NSString stringWithFormat:@"http://www.6crores.com/_Groups_6/MobileMatrimonyMatches.php?UserID=A600506"];
    
    NSLog(@"urlRequest Value %@",urlRequest);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlRequest]];
    // [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [NSURLConnection connectionWithRequest:request delegate:self];

    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"parrmassea count %lu",(unsigned long)[pArrImagepath count]);

    return [pArrImagepath count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"YOUR PARTNERS:";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    cell =  (SimpleTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (cell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }

//for image convert to data
    
   /* NSString *pStrImage = [pArrImagepath objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:pStrImage];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    UIImage *tmpImage = [[UIImage alloc] initWithData:data];
    
    cell.pImageView.image = tmpImage;*/
//    pImageView.contentMode = UIViewContentModeScaleAspectFit;
//    [cell addSubview:pImageView];
    
    
    //cancel loading previous image for cell
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cell.pImageView];
    NSURL *pUrl = [NSURL URLWithString:[pArrImagepath objectAtIndex:indexPath.row]];

   CALayer * l = [cell.pImageView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:30.0];
    
    // You can even add a border
    [l setBorderWidth:1.0];
    [l setBorderColor:[[UIColor grayColor] CGColor]];
    
    cell.pImageView.imageURL = pUrl;
    
    
  /*  if (cell.pImageView.image == NULL) {
        
        cell.pImageView.image = [UIImage imageNamed:@"empty_profile1.jpg"];
        
    } else {
        
        
    }*/


    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    @try {
        [responseData setLength:0];
    }
    @catch (NSException *exception) {
        NSLog(@"Execption Erro : %@",exception);
    }
    @finally {
        
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

//some sort of error, you can print the error or put in some other handling here, possibly even try again but you will risk an infinite loop then unless you impose some sort of limit
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Clear the activeDownload property to allow later attempts
    responseData = nil;
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:error.description
                                                   delegate:nil
                                          cancelButtonTitle:@"Close"
                                          otherButtonTitles:nil];
	[alert show];
    //[alert release];
    
    /*HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    [HUD hide:YES afterDelay:1];*/
    
}


//connection has finished, thse requestData object should contain the entirety of the response at this point
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //[connection release];
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    
    
    NSMutableDictionary *pDictValue = [responseString JSONValue];
    
    
    
    pArrMessage = [[NSMutableArray alloc] init];
    pArrImagepath = [[NSMutableArray alloc]init];
    pArrMessage = [pDictValue objectForKey:@"Message"];

    for (int i = 0; i < [pArrMessage count]; i++) {
        NSMutableDictionary*pDictValue = [pArrMessage objectAtIndex:i];

        NSString *pImagepath = [pDictValue objectForKey:@"ImagePath"];
        [pArrImagepath addObject:pImagepath];
    }
    
    [pTbleImg reloadData];
  /*  if ([responseString isEqualToString:@""]) {
        
        [Utils alert:@"You are not registred in Matrimony" title:@"Message!"];
        
    }
    NSLog(@"responseString datas is here %@",responseString);
    
    pArrMatriMonyList = [[NSMutableArray alloc] init];
    pArrImage = [[NSMutableArray alloc] init];
    pArrAge = [[NSMutableArray alloc] init];
    pArrCity = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *pDictValue = [responseString JSONValue];
    
    @try {
        
        if (iTag == 6) {
            
            pStrInbox = [pDictValue objectForKey:@"Inbox"];
            pStrReply = [pDictValue objectForKey:@"Reply"];
            pStrReject = [pDictValue objectForKey:@"Reject"];
            pStrWaiting = [pDictValue objectForKey:@"Waiting"];
            
            pLblInbox.text = pStrInbox;
            pLblReject.text = pStrReject;
            pLblResponse.text = pStrReply;
            pLblWaiting.text = pStrWaiting;
            
            pViewMessages.hidden = NO;
            
        } else {
            
            pArrMessage = [pDictValue objectForKey:@"Message"];
            
            if ([pArrMessage count] == 1) {
                
                NSDictionary   *mijnDict = [pArrMessage objectAtIndex:0];
                
                pStrName = [mijnDict objectForKey:@"Name"];
                NSString *pStrImageName = [mijnDict objectForKey:@"ImagePath"];
                NSLog(@"pStrImageName !!!!!!!!! %@",pStrImageName);
                pStrAge = [mijnDict objectForKey:@"Age"];
                pStrCity = [mijnDict objectForKey:@"City"];
                
                [pArrAge addObject:pStrAge];
                
                [pArrCity addObject:pStrCity];
                [pArrImage addObject:pStrImageName];
                [pArrMatriMonyList addObject:pStrName];
                
                
            } else {
                
                for (int i = 0; i < [pArrMessage count]; i++) {
                    
                    NSDictionary   *mijnDict = [pArrMessage objectAtIndex:i];
                    
                    pStrName = [mijnDict objectForKey:@"Name"];
                    
                    if ([pStrName isEqualToString:@""]) {
                        pStrName = @"No Name";
                    } else {
                        
                    }
                    
                    NSString *pStrImageName = [mijnDict objectForKey:@"ImagePath"];
                    
                    pStrAge = [mijnDict objectForKey:@"Age"];
                    
                    pStrCity = [mijnDict objectForKey:@"City"];
                    
                    [pArrAge addObject:pStrAge];
                    [pArrCity addObject:pStrCity];
                    [pArrImage addObject:pStrImageName];
                    [pArrMatriMonyList addObject:pStrName];
                    
                }
                
            }
            
            [pTblMatrimonyList reloadData];
            
        }
        
        
    }
    
    @catch (NSException *exception) {
        
        NSLog(@"exception error %@",exception);
        
    }
    @finally {
        
    }
    
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    [HUD hide:YES afterDelay:1];*/
    
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
