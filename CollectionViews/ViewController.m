//
//  ViewController.m
//  CollectionViews
//
//  Created by Jaideep Shah on 8/21/14.
//  Copyright (c) 2014 Jaideep Shah. All rights reserved.
//

#import "ViewController.h"
#import "Cell.h"
#import  <Opentok/Opentok.h>

@interface ViewController () <OTSessionDelegate, OTSubscriberKitDelegate, OTPublisherDelegate> {
    
        OTSession* _session;
        OTPublisher* _publisher;
        NSMutableArray * subscribers;
}
@property BOOL change;
@end

// *** Fill the following variables using your own Project info  ***
// ***          https://dashboard.tokbox.com/projects            ***
// Replace with your OpenTok API key
static NSString* const kApiKey = @"100";
// Replace with your generated session ID
static NSString* const kSessionId = @"2_MX4xMDB-MTI3LjAuMC4xflRodSBBdWcgMjEgMTU6MTg6NTAgUERUIDIwMTR-MC4wODg3NjE2OX5-";
// Replace with your generated token
static NSString* const kToken = @"T1==cGFydG5lcl9pZD0xMDAmc2RrX3ZlcnNpb249dGJwaHAtdjAuOTEuMjAxMS0wNy0wNSZzaWc9M2E4MDQwNmJiMTZkNGVhYzgzMWI4MjYwMzE4ZTM4ZGY2NDYzOGE3YjpzZXNzaW9uX2lkPTJfTVg0eE1EQi1NVEkzTGpBdU1DNHhmbFJvZFNCQmRXY2dNakVnTVRVNk1UZzZOVEFnVUVSVUlESXdNVFItTUM0d09EZzNOakUyT1g1LSZjcmVhdGVfdGltZT0xNDA4NjU5Nzg4JnJvbGU9bW9kZXJhdG9yJm5vbmNlPTE0MDg2NTk3ODguODYxMzUyOTMzMTk3JmV4cGlyZV90aW1lPTE0MTEyNTE3ODg=";




@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    subscribers = [NSMutableArray new];
	// Do any additional setup after loading the view, typically from a nib.
    // Step 1: As the view comes into the foreground, initialize a new instance
    // of OTSession and begin the connection process.
    _session = [[OTSession alloc] initWithApiKey:kApiKey
                                       sessionId:kSessionId
                                        delegate:self];
    [self doConnect];

}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if (UIUserInterfaceIdiomPhone == [[UIDevice currentDevice]
                                      userInterfaceIdiom])
    {
        return NO;
    } else {
        return YES;
    }
}

- (void)doConnect
{
    OTError *error = nil;
    
    [_session connectWithToken:kToken error:&error];
    if (error)
    {
        [self showAlert:[error localizedDescription]];
    }
}
- (void)doPublish
{
    _publisher =
    [[OTPublisher alloc] initWithDelegate:self
                                     name:[[UIDevice currentDevice] name]];
    
    // _publisher.publishAudio = NO;
    OTError *error = nil;
    [_session publish:_publisher error:&error];
    if (error)
    {
        [self showAlert:[error localizedDescription]];
    }
    

}


- (void)cleanupPublisher {
    _publisher = nil;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return 4;
    
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}


-(void) addSubscriber : (OTSubscriber *) subscriber toCell : (Cell *) cell
{
    if(subscriber)
    {
        [cell.putSomethingInThisView addSubview:subscriber.view];
        [subscriber.view setFrame:CGRectMake(0, 0,
                                             cell.putSomethingInThisView.bounds.size.width,
                                             cell.putSomethingInThisView.bounds.size.height)];
        
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    

    switch (indexPath.row) {
        case 0: {
            if(_publisher)
            {
                [cell.putSomethingInThisView addSubview:_publisher.view];
                [_publisher.view setFrame:CGRectMake(0, 0,
                                                     cell.putSomethingInThisView.bounds.size.width,
                                                     cell.putSomethingInThisView.bounds.size.height)];

            } else {
                cell.putSomethingInThisView.backgroundColor = [UIColor redColor];
            }
            
        }
            break;

        case 1:
            if(subscribers.count >= 1)
            {
                [self addSubscriber:[subscribers objectAtIndex:0] toCell:cell];
            }
            break;
        case 2:
            if(subscribers.count >= 2)
            {
                [self addSubscriber:[subscribers objectAtIndex:1] toCell:cell];
            }
            break;

        case 3:
            if(subscribers.count >= 3)
            {
                [self addSubscriber:[subscribers objectAtIndex:2] toCell:cell];
            }
            break;

        default:
            break;
    }
    
   
    
    return cell;
}
#pragma mark UICollectionViewDelegate

#pragma mark – UICollectionViewDelegateFlowLayout


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    if(!self.change)
    {

        return  CGSizeMake(self.collectionView.bounds.size.width/2-20, self.collectionView.bounds.size.height/2-20);
    } else {
        return  CGSizeMake(200,200);
    }


}


- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
    
}
- (IBAction)changeSize:(id)sender {
    self.change = ! self.change;
    [self.collectionView reloadData];
}
- (void)showAlert:(NSString *)string
{
    // show alertview on main UI
	dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OTError"
                                                        message:string
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil] ;
        [alert show];
    });
}
# pragma mark - OTSession delegate callbacks

- (void)sessionDidConnect:(OTSession*)session
{
    NSLog(@"sessionDidConnect (%@)", session.sessionId);
    [self doPublish];
}

- (void)sessionDidDisconnect:(OTSession*)session
{
    NSString* alertMessage =
    [NSString stringWithFormat:@"Session disconnected: (%@)",
     session.sessionId];
    NSLog(@"sessionDidDisconnect (%@)", alertMessage);
}


- (void)session:(OTSession*)mySession
  streamCreated:(OTStream *)stream
{
    NSLog(@"session streamCreated (%@)", stream.streamId);
    OTSubscriber * _subscriber = [[OTSubscriber alloc] initWithStream:stream delegate:self];
    
    OTError *error = nil;
    [_session subscribe:_subscriber error:&error];
    if (error)
    {
        [self showAlert:[error localizedDescription]];
        return;
    }
    [subscribers addObject:_subscriber];
}

- (void)session:(OTSession*)session
streamDestroyed:(OTStream *)stream
{
    NSLog(@"session streamDestroyed (%@)", stream.streamId);
    OTSubscriber * subscriberToBeRemoved;
    for (OTSubscriber * subscriber in subscribers) {
        if ([subscriber.stream.streamId isEqualToString:stream.streamId])
        {
            subscriberToBeRemoved = subscriber;
            break;
        }
    }
    [subscribers removeObject:subscriberToBeRemoved];
    [self.collectionView reloadData];
}


- (void) session:(OTSession*)session
didFailWithError:(OTError*)error
{
    NSLog(@"didFailWithError: (%@)", error);
}

# pragma mark - OTSubscriber delegate callbacks

- (void)subscriberDidConnectToStream:(OTSubscriberKit*)subscriber
{
    NSLog(@"subscriberDidConnectToStream (%@)",
          subscriber.stream.connection.connectionId);


    [self.collectionView reloadData];
    
}

- (void)subscriber:(OTSubscriberKit*)subscriber
  didFailWithError:(OTError*)error
{
    NSLog(@"subscriber %@ didFailWithError %@",
          subscriber.stream.streamId,
          error);
}

# pragma mark - OTPublisher delegate callbacks

- (void)publisher:(OTPublisherKit *)publisher
    streamCreated:(OTStream *)stream
{
    [self.collectionView reloadData];
}

- (void)publisher:(OTPublisherKit*)publisher
  streamDestroyed:(OTStream *)stream
{
    
    [self cleanupPublisher];
}

- (void)publisher:(OTPublisherKit*)publisher
 didFailWithError:(OTError*) error
{
    NSLog(@"publisher didFailWithError %@", error);
    [self cleanupPublisher];
}


@end
