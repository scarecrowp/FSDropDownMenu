//
//  FSDropDownMenu.m
//  FSDropDownMenu
//
//  Created by xiang-chen on 14/12/17.
//  Copyright (c) 2014年 chx. All rights reserved.
//

#import "FSDropDownMenu.h"
#import "MyCustomTableViewCell.h"
@interface FSDropDownMenu()



@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) UIView *backGroundView;

@end

#define ScreenWidth      CGRectGetWidth([UIScreen mainScreen].applicationFrame)

@implementation FSDropDownMenu

#pragma mark - init method
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self = [self initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, 0)];
    if (self) {
        _origin = origin;
        _show = NO;
        _height = height;
        
        //tableView init
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth*0.6, self.frame.origin.y + self.frame.size.height, ScreenWidth*0.4, 0) style:UITableViewStylePlain];
        _leftTableView.rowHeight = 46;
        _leftTableView.dataSource = self;
        _leftTableView.delegate = self;
        
        
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.frame.origin.y + self.frame.size.height, ScreenWidth*0.6, 0) style:UITableViewStylePlain];
      //  _rightTableView.rowHeight = 46;
        _rightTableView.dataSource = self;
        _rightTableView.delegate = self;
       //   _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
       // _rightTableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.f];
        
        //self tapped
        self.backgroundColor = [UIColor whiteColor];
        
        
        //add bottom shadow
      //  UIView *bottomShadow = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, screenSize.width, 0.5)];
        //bottomShadow.backgroundColor = [UIColor lightGrayColor];
        //[self addSubview:bottomShadow];
    }
    return self;
}



#pragma mark - gesture handle

- (void)menuTapped{
    if (!_show) {
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.rightTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    [self animateBackGroundView:self.backGroundView show:!_show complete:^{
        [self animateTableViewShow:!_show complete:^{
            [self tableView:self.rightTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            _show = !_show;
        }];
    }];

}


#pragma mark - animation method


- (void)animateBackGroundView:(UIView *)view show:(BOOL)show complete:(void(^)())complete {
    if (show) {
        [self.superview addSubview:view];
        [view.superview addSubview:self];
        
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
    complete();
}

- (void)animateTableViewShow:(BOOL)show complete:(void(^)())complete {
    if (show) {

        _leftTableView.frame = CGRectMake(ScreenWidth*0.6, self.frame.origin.y, ScreenWidth*0.4, 0);
        [self.superview addSubview:_leftTableView];
        _rightTableView.frame = CGRectMake(0, self.frame.origin.y, ScreenWidth*0.6, 0);
        [self.superview addSubview:_rightTableView];
        
        _leftTableView.alpha = 1.f;
        _rightTableView.alpha = 1.f;
        [UIView animateWithDuration:0.2 animations:^{
            _leftTableView.frame = CGRectMake(ScreenWidth*0.6, self.frame.origin.y, ScreenWidth*0.4, _height);
            _rightTableView.frame = CGRectMake(0, self.frame.origin.y, ScreenWidth*0.6, _height);
         
        } completion:^(BOOL finished) {
            
        }];
    } else {

        [UIView animateWithDuration:0.2 animations:^{
            _leftTableView.alpha = 0.f;
            _rightTableView.alpha = 0.f;
           
        } completion:^(BOOL finished) {
            [_leftTableView removeFromSuperview];
            [_rightTableView removeFromSuperview];
        }];
    }
    complete();
}


#pragma mark - table datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSAssert(self.dataSource != nil, @"menu's dataSource shouldn't be nil");
    if ([self.dataSource respondsToSelector:@selector(menu:tableView:numberOfRowsInSection:)]) {
        return [self.dataSource menu:self tableView:tableView
                numberOfRowsInSection:section];
    } else {
        NSAssert(0 == 1, @"required method of dataSource protocol should be implemented");
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"DropDownMenuCell";
    MyCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MyCustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSAssert(self.dataSource != nil, @"menu's datasource shouldn't be nil");
    if ([self.dataSource respondsToSelector:@selector(menu:tableView:titleForRowAtIndexPath:)]) {
        cell.textLabel.text = [self.dataSource menu:self tableView:tableView titleForRowAtIndexPath:indexPath];
    } else {
        NSAssert(0 == 1, @"dataSource method needs to be implemented");
    }
    if(tableView == _leftTableView){
        cell.backgroundColor = [AciMath getColor:@"f3f3f3"];
    }else{
        
        UIView *sView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.4, 45)];
        UIImageView *img=[[UIImageView alloc ]initWithFrame:CGRectMake(SCREEN_WIDTH*0.4, 5, 12, 18)];
        img.contentMode=UIViewContentModeRight;
        [img setImage:[UIImage imageNamed:@"menu_selected"]];
        [sView addSubview:img];
      
        cell.selectedBackgroundView = img;
        
        
        
       // [cell setSelected:YES animated:NO];
        
       // cell.selectionStyle = UITableViewCellEditingStyleNone;
      //  cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
 //   cell.separatorInset = UIEdgeInsetsZero;
    

    
    return cell;
}
-(double)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate || [self.delegate respondsToSelector:@selector(menu:tableView:didSelectRowAtIndexPath:)]) {
        if (tableView == self.leftTableView) {
            
        }
        else
        {
           // NSIndexPath *indexPathOfCellAbove = [NSIndexPath indexPathForRow:(indexPath.row - 1) inSection:indexPath.section];
            
//            if (indexPath.row > 0)
//                [_rightTableView reloadRowsAtIndexPaths:@[indexPathOfCellAbove, indexPath] withRowAnimation:UITableViewRowAnimationNone];
//            else
//                [_rightTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            //Deselect Row
//            [_rightTableView deselectRowAtIndexPath:indexPath animated:YES];
//            
//            // fix for separators bug in iOS 7
//            _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//            _rightTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }
        [self.delegate menu:self tableView:tableView didSelectRowAtIndexPath:indexPath];
    } else {
        //TODO: delegate is nil
    }
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
