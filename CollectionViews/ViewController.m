//
//  ViewController.m
//  CollectionViews
//
//  Created by Jaideep Shah on 8/21/14.
//  Copyright (c) 2014 Jaideep Shah. All rights reserved.
//

#import "ViewController.h"
#import "Cell.h"

@interface ViewController ()
@property BOOL change;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    //TODO - Assign subscriber to cell.putSomethingInThisView
    switch (indexPath.row) {
        case 0:
            cell.putSomethingInThisView.backgroundColor = [UIColor redColor];
            break;
        case 1:
            cell.putSomethingInThisView.backgroundColor = [UIColor brownColor];
            break;
        case 2:
            cell.putSomethingInThisView.backgroundColor = [UIColor greenColor];
            break;
        case 3:
            cell.putSomethingInThisView.backgroundColor = [UIColor blueColor];
            break;
        default:
            break;
    }
    
   
    
    return cell;
}
#pragma mark UICollectionViewDelegate

#pragma mark – UICollectionViewDelegateFlowLayout


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    if(self.change)
    {

        return  CGSizeMake(self.collectionView.bounds.size.width/2-20, self.collectionView.bounds.size.height/2-20);
    } else {
        return  CGSizeMake(self.collectionView.bounds.size.width/2 - 60, self.collectionView.bounds.size.height/2);
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
@end
