//
//  TransFormViewController.m
//  RTSS
//
//  Created by 蔡杰Alan on 15-2-3.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "TransFormViewController.h"

#define kAlertQureChange 1000
#define kAlertTransform  2000


@interface TransformLogicModel : NSObject

@property(nonatomic,copy)NSString *resourcsID;  //获取单位和名字，submit  提交

@property(nonatomic,assign)CGFloat transferValue;

@property(nonatomic,copy)NSString *resourceName;

@property(nonatomic,assign)NSInteger unitType;

@property(nonatomic,retain)TTRule *rule;  //自己为主动方  --->被动方

@property(nonatomic,retain)id<ITransferable>item;

@end
@implementation TransformLogicModel
-(void)dealloc{
    [_rule release];
    [_item release];
    [super dealloc];
}
@end

typedef NS_ENUM(NSInteger, TransformState) {
    TransformStateNone,
    TransformStateOne,
    TransformStateTwo
};

typedef NS_ENUM(NSInteger, TransformStateDirection) {
    
    TransformStateDirectionLeft=-1,
    TransformStateDirectionNone=0,
    TransformStateDirectionRight=1
};
@interface TransFormViewController ()<AlertControllerDelegate>

@property(nonatomic,assign)TransformState transformState;

@property(nonatomic,retain)NSMutableArray *logicArray;  //只包含存在的两个元素  类型TransformLogicModel

@property(nonatomic,assign)BOOL reverse;


@end
@implementation TransFormViewController

#pragma mark --Life
-(void)dealloc{
    
    [super dealloc];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Transform_Title",nil);
    
}
-(void)loadView{
    
    [super loadView];
    [self loadTransactionViewWtihFrame:CGRectMake(kTransactionViewLREdge, kTransactionViewTopEdge, PHONE_UISCREEN_WIDTH-2*kTransactionViewLREdge, PHONE_UISCREEN_HEIGHT-kTransactionViewTopEdge-kTransactionViewBottomEdge-64) bindTransationCell:[TransationBaseTableViewCell class] bindTransactionView:[TransactionPanelBaseView class]];
    
    [self updateSubmitButtonState:NO];
}

-(void)loadData{
    
    _transformState = TransformStateTwo;
    
    Session *session = [Session sharedSession];
    
    NSArray *products = session.mTransferables;
    
    if (![CommonUtils objectIsValid:products]) {
        return;
    }
    if (![products count] >1) {
        //管子不够两个
        return;
    }
    
    for (id<ITransferable> item in products) {
        
        
        int codeType = [item getTypeCode];
        
        if (codeType != 1 && codeType != 2) {
            [self.dataSourceList addObject:item];
        }
    }
    
    //获取初始化两个规则
    RuleManager *ruleManger = [RuleManager sharedRuleManager];
    
    id<ITransferable> pr0 = [self.dataSourceList objectAtIndex:0];
    id<ITransferable> pr1 = [self.dataSourceList objectAtIndex:1];
    
    TransformLogicModel *tf0 = [[TransformLogicModel alloc]init];
    tf0.resourcsID = [pr0 getItemId];
    tf0.resourceName = [pr0 getItemName];
    tf0.unitType = [pr0 getUnit];
    tf0.transferValue = 0;
    tf0.item = pr0;
    
    TransformLogicModel *tf1  = [[TransformLogicModel alloc]init];
    tf1.resourcsID = [pr1 getItemId];
    tf1.transferValue = 0;
    tf1.resourceName = [pr1 getItemName];
    tf1.unitType = [pr1 getUnit];
    tf1.item = pr1;
    
    tf0.rule = [ruleManger transformRule:[pr0 getItemId] to:[pr1 getItemId]];
    tf1.rule = [ruleManger transformRule:[pr1 getItemId] to:[pr0 getItemId]];
    
    [self.logicArray addObject:tf0];
    [self.logicArray addObject:tf1];
    
    [tf0 release];
    [tf1 release];
    // NSLog(@"--%@",self.dataSourceList);
    [self.transactionView.tableView reloadData];
}
-(NSMutableArray *)logicArray{
    if (!_logicArray) {
        _logicArray = [[NSMutableArray alloc]init];
    }
    return _logicArray;
}
#pragma mark -transactionView Delegate

-(TransationBaseTableViewCell *)transactionView_TableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 以下写法避免两个问题：   1、滚动时 数据恢复问题   2.**  管子选中状态的错乱现象，数据错乱
    id<ITransferable>product=nil;
    if ([self.dataSourceList count] >0 && indexPath.row < [self.dataSourceList count]) {
         product = [self.dataSourceList objectAtIndex:indexPath.row];
    }
    
    NSString *CellIdentify;
    
    if (product) {
         CellIdentify =[NSString stringWithFormat:@"%@-%@",[product getSubscriberId],[product getItemId]];
    }else{
        CellIdentify = [NSString stringWithFormat:@"CellIDentify_Row%d_Section%d",indexPath.row,indexPath.section];
    }

    NSLog(@"%@",CellIdentify);
    TransationBaseTableViewCell *cell =(TransationBaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentify];

    if (cell == nil) {
        NSLog(@"nil");
        cell = [[[TransationBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentify]autorelease];
        //数据模型绑定
        if (product) {
            [cell transationTableViewCellBind_TransferFormModel:product];
              [self.storeCell setObject:cell forKey:CellIdentify];
        }
        //初始化时 头两个数据默认
        [self setCellProperty:cell cellForRowAtIndexPath:indexPath];
        cell.comboSlider.showComboSliderThumb = NO;
        if (indexPath.row == 1||indexPath.row == 0) {
            [self updateCell:cell BgColor:YES];
        }
        
    }else{
        
    }
    
    return cell;
}



-(void)transactionView:(TransactionView *)transationView transationTableViewCell:(TransationBaseTableViewCell *)cell onSliderTouchUpInside:(ComboSlider *)comboSlider{
    
    //这里进行数据的变更
    [super transactionView:transationView transationTableViewCell:cell onSliderTouchUpInside:comboSlider];
    
    //当前移动cell 位置
    NSIndexPath *indexPath = [transationView.tableView indexPathForCell:cell];
    NSIndexPath *unSelectPath = indexPath.row == 0 ? [NSIndexPath indexPathForItem:1 inSection:0]:[NSIndexPath indexPathForItem:0 inSection:0];
    [self correct_transactionView:transationView selectTransactionCell:cell unSelectIndexPath:unSelectPath];
    
}
//纠正值
-(void)correct_transactionView:(TransactionView *)transationView selectTransactionCell:(TransationBaseTableViewCell*)selectCell   unSelectIndexPath:(NSIndexPath*)unselectIndexPath{
    if ([self.logicArray count] != 2) {//选中的管子  必须是两个  否则无法移动
        [selectCell.comboSlider setCurrentValue:selectCell.comboSlider.resetValue animated:NO];
        return;
    }
    
    //未选中
    TransationBaseTableViewCell *unSelectCell =(TransationBaseTableViewCell*)[transationView.tableView cellForRowAtIndexPath:unselectIndexPath];
    
    //获取转换规则
    CGFloat direction = selectCell.comboSlider.midSlider.sliderControl.value - selectCell.comboSlider.resetValue;
    
      _reverse = direction > 0 ? YES : NO;
    
    switch (unselectIndexPath.row) {//如果选中第二根管子  需要再次取反---
        case 0:{
            _reverse = !_reverse;
            break;
        }
        default:
            break;
    }

    TransformStateDirection directionState = direction > 0 ? TransformStateDirectionRight:TransformStateDirectionLeft;
    
    TransformLogicModel *transformModel = nil;
    switch (directionState) {
        case TransformStateDirectionLeft:{////selectCell --> unselectCell
            transformModel = [self.logicArray objectAtIndex:abs(unselectIndexPath.row-1)];
        }
            break;
        case TransformStateDirectionRight:{//unSelectCell --> selectCell
            transformModel = [self.logicArray objectAtIndex:abs(unselectIndexPath.row)];
            break;
        }
            
        default:
            return;
            break;
    }
    if (transformModel == nil) return;
    TTRule *rule = transformModel.rule;
    if (rule == nil) {
        selectCell.comboSlider.showCurrentValue = YES;
        unSelectCell.comboSlider.showCurrentValue = YES;
        return;
    }
    
    CGFloat minOrgAmount =  rule.mMinOrgAmount ;
    CGFloat maxOrgAmount = rule.mMaxOrgAmount ;
    //符合规则
    //cell的显示
    CGFloat directonAbs = fabsf(direction); //转换为正整数值
    CGFloat  selectStep = 0.0;
    CGFloat unSelectStep = 0.0;
    
    CGFloat delta = 0.0; //
    switch (directionState) {
        case TransformStateDirectionLeft:{
            //----selectCell --> unselectCell
            selectStep = (NSInteger)(directonAbs /(selectCell.comboSlider.negtiveStep)) *selectCell.comboSlider.negtiveStep;
            unSelectStep =(NSInteger)(directonAbs /(selectCell.comboSlider.negtiveStep)) *unSelectCell.comboSlider.activeStep;
           // CGFloat transferToTotal =  unSelectCell.comboSlider.resetValue + unSelectStep; //转换得值
            //判断转换值得值是否超过最大值
            //if(transferToTotal > unSelectCell.comboSlider.maximumValue)  transferToTotal = unSelectCell.comboSlider.maximumValue;
            
            delta = selectStep;
        }
            break;
        case TransformStateDirectionRight:{
            //unSelectCell --> selectCell 划动得是 selectCell
            selectStep = (NSInteger)(directonAbs /(selectCell.comboSlider.activeStep)) *selectCell.comboSlider.activeStep;
            unSelectStep = (NSInteger)(directonAbs /(selectCell.comboSlider.activeStep)) *unSelectCell.comboSlider.negtiveStep;
            
            CGFloat transferFromRemain =  unSelectCell.comboSlider.resetValue - unSelectStep;
            //判断已经滑到  最小值了
            if(transferFromRemain < unSelectCell.comboSlider.minimumValue){
                
                unSelectStep = unSelectCell.comboSlider.resetValue;
            }
            
            delta = unSelectStep;
            break;
        }
            
        default:
            return;
            break;
    }
    
    if (delta>= minOrgAmount && delta <= maxOrgAmount) {
        //符合要求
        
        CGFloat cselect = 0.0;
        CGFloat cunselct = 0.0;
        
        CGFloat selectValue = fabsf(selectCell.comboSlider.currentValue - selectCell.comboSlider.resetValue);
        CGFloat unSelectValue = fabsf(unSelectCell.comboSlider.currentValue - unSelectCell.comboSlider.resetValue);
        
        switch (directionState) {
            case TransformStateDirectionLeft:{//selectCell --> unselectCell
                cselect = selectValue / selectCell.comboSlider.negtiveStep;
                cunselct = unSelectValue / unSelectCell.comboSlider.activeStep;
                break;
            }
            case TransformStateDirectionRight:{
                cselect = selectValue / selectCell.comboSlider.activeStep;
                cunselct = unSelectValue / unSelectCell.comboSlider.negtiveStep;
                break;
            }
            default:
                break;
        }
        if (cselect == cunselct) {
            [self updatePanelData];
             [self queryCharge];
            return;   //符合规则
        }
        
        if (cselect > cunselct) {
            //未滑动的cell已经滑动头
            NSInteger minc = MIN(cselect, cunselct);
            CGFloat deltaSelct ;//=  minc *selectStep;
            CGFloat deltaUnselct ;//= minc *unSelectStep;

            switch (directionState) {
                case TransformStateDirectionLeft:{
                    //----selectCell --> unselectCell
                    
                    deltaSelct = minc * selectCell.comboSlider.negtiveStep;
                    deltaUnselct = minc * unSelectCell.comboSlider.activeStep;
                    
                    [selectCell.comboSlider setCurrentValue:selectCell.comboSlider.resetValue-deltaSelct animated:NO];
                    selectCell.comboSlider.currentValueLabel.text = [NSString stringWithFormat:@"%.0f",selectCell.comboSlider.currentValue-selectCell.comboSlider.resetValue];
                    
                    CGFloat transferToTotal =  unSelectCell.comboSlider.resetValue + deltaUnselct; //转换得值
                    
                    [unSelectCell.comboSlider setCurrentValue:transferToTotal animated:NO];
                    unSelectCell.comboSlider.currentValueLabel.text = [NSString stringWithFormat:@"%.0f",transferToTotal-unSelectCell.comboSlider.resetValue];
                    break;
                }
                case TransformStateDirectionRight:{
                    //unSelectCell --> selectCell 划动得是 selectCell
                    
                    deltaSelct = minc * selectCell.comboSlider.activeStep;
                    deltaUnselct = minc * unSelectCell.comboSlider.negtiveStep;
                    
                    [selectCell.comboSlider setCurrentValue:selectCell.comboSlider.resetValue+deltaSelct animated:NO];
                    selectCell.comboSlider.currentValueLabel.text = [NSString stringWithFormat:@"%.0f",selectCell.comboSlider.currentValue-selectCell.comboSlider.resetValue];
                    
                    CGFloat transferFromRemain =  unSelectCell.comboSlider.resetValue - deltaUnselct; //转换得值
                    NSLog(@"transferFor =%f--resetValue =%f",transferFromRemain,unSelectCell.comboSlider.resetValue);
                
                    [unSelectCell.comboSlider setCurrentValue:transferFromRemain animated:NO];
                    
                    unSelectCell.comboSlider.currentValueLabel.text = [NSString stringWithFormat:@"%.0f",transferFromRemain-unSelectCell.comboSlider.resetValue];
                    break;
                }
                default:
                    return;
                    break;
            }
    
            TransformLogicModel *model0 = [self.logicArray objectAtIndex:abs(unselectIndexPath.row-1)];
            model0.transferValue = fabsf( selectCell.comboSlider.currentValue - selectCell.comboSlider.resetValue);
            TransformLogicModel *model1 = [self.logicArray objectAtIndex:unselectIndexPath.row];
            model1.transferValue = fabsf( unSelectCell.comboSlider.currentValue - unSelectCell.comboSlider.resetValue);
            
            [self updatePanelData];
            //FIXME:
            [self queryCharge];
            return;
        }
    }
    
    //不符合规则  归位
    [selectCell.comboSlider setCurrentValue:selectCell.comboSlider.resetValue animated:NO];
    selectCell.comboSlider.currentValueLabel.text = @"0";
    [unSelectCell.comboSlider setCurrentValue:unSelectCell.comboSlider.resetValue animated:NO];
    unSelectCell.comboSlider.currentValueLabel.text = @"0";
    
    TransformLogicModel *model0 = [self.logicArray objectAtIndex:0];
    model0.transferValue = 0.0f;
    TransformLogicModel *model1 = [self.logicArray objectAtIndex:1];
    model1.transferValue = 0.0f;
    
    selectCell.comboSlider.showCurrentValue = YES;
    unSelectCell.comboSlider.showCurrentValue = YES;

    [self updatePanelData];
    
}

-(void)transactionView:(TransactionView *)transationView transationTableViewCell:(TransationBaseTableViewCell *)cell onSliderValueChanged:(ComboSlider *)comboSlider {
    
    //[super transactionView:transationView transationTableViewCell:cell onSliderValueChanged:comboSlider];
    
    //当前移动cell 位置
    NSIndexPath *indexPath = [transationView.tableView indexPathForCell:cell];
    
    NSIndexPath *unSelectPath = indexPath.row == 0 ? [NSIndexPath indexPathForItem:1 inSection:0]:[NSIndexPath indexPathForItem:0 inSection:0];
    
    //业务logic
    [self transactionView:transationView selectTransactionCell:cell unSelectIndexPath:unSelectPath];
    
}
-(void)transactionView:(TransactionView *)transationView selectTransactionCell:(TransationBaseTableViewCell*)selectCell   unSelectIndexPath:(NSIndexPath*)unselectIndexPath {
    
   

    if ([self.logicArray count] != 2) {//选中的管子  必须是两个  否则无法移动
        [selectCell.comboSlider setCurrentValue:selectCell.comboSlider.resetValue animated:NO];
        return;
    }
    
    //未选中
    TransationBaseTableViewCell *unSelectCell =(TransationBaseTableViewCell*)[transationView.tableView cellForRowAtIndexPath:unselectIndexPath];
    
    //滑动时 将显示值隐藏掉
    selectCell.comboSlider.showCurrentValue = NO;
    unSelectCell.comboSlider.showCurrentValue = NO;
    //获取转换规则
    CGFloat direction = selectCell.comboSlider.midSlider.sliderControl.value - selectCell.comboSlider.resetValue;
    
    _reverse = direction > 0 ? YES : NO;
    
    switch (unselectIndexPath.row) {//如果选中第二根管子  需要再次取反---
        case 0:{
            _reverse = !_reverse;
            
            break;
        }
        default:
            break;
    }
    
    TransformStateDirection directionState = direction > 0 ? TransformStateDirectionRight:TransformStateDirectionLeft;
    TransformLogicModel *transformModel = nil;
    TransformLogicModel *toModel = nil;
    switch (directionState) {
        case TransformStateDirectionLeft:{////selectCell --> unselectCell
            transformModel = [self.logicArray objectAtIndex:abs(unselectIndexPath.row-1)];
            toModel =[  self.logicArray objectAtIndex:abs(unselectIndexPath.row)];
            break;
        }
            
        case TransformStateDirectionRight:{//unSelectCell --> selectCell
             transformModel = [self.logicArray objectAtIndex:abs(unselectIndexPath.row)];
             toModel = [self.logicArray objectAtIndex:abs(unselectIndexPath.row-1)];
              break;
        }
        default:
            return;
            break;
    }
    if (transformModel == nil) return;
    TTRule *rule = transformModel.rule;
    if (rule == nil) {
        [selectCell.comboSlider setCurrentValue:selectCell.comboSlider.resetValue animated:NO];
         selectCell.comboSlider.currentValueLabel.text = @"0";
        return;
    }
    
    //获取step值  改变step
    CGFloat orgAmout = rule.mOrgAmount;
    CGFloat targetAmout = rule.mTargetAmount;

    if (orgAmout < 0.0 ) {
        orgAmout = 1.0f;
    }
    
    if (targetAmout < 0.0 ) {
        targetAmout = 1.0f;
    }
    switch (directionState) {
        case TransformStateDirectionLeft:{//selectCell --> UnselectCell
           
            selectCell.comboSlider.negtiveStep = orgAmout;
            unSelectCell.comboSlider.activeStep = targetAmout;
            break;
        }
           
        case TransformStateDirectionRight:{//UnSelectCell --> selectCell
        
            unSelectCell.comboSlider.negtiveStep = orgAmout;
            selectCell.comboSlider.activeStep = targetAmout;
            
            break;
        }
        default:
            return;
            break;
    }
    
    //cell的显示
    CGFloat directonAbs = fabsf(direction); //转换为正整数值
    CGFloat  selectStep = 0.0;
    CGFloat unSelectStep = 0.0;
    
    switch (directionState) {
        case TransformStateDirectionLeft:{
            //----selectCell --> unselectCell
            selectStep = (NSInteger)(directonAbs /(selectCell.comboSlider.negtiveStep)) *selectCell.comboSlider.negtiveStep;
            unSelectStep =(NSInteger)(directonAbs /(selectCell.comboSlider.negtiveStep)) *unSelectCell.comboSlider.activeStep;
            [selectCell.comboSlider setCurrentValue:selectCell.comboSlider.resetValue-selectStep animated:NO];
            
             selectCell.comboSlider.currentValueLabel.text = [NSString stringWithFormat:@"%.0f",[CommonUtils getUnitConverteValue:selectCell.comboSlider.currentValue-selectCell.comboSlider.resetValue AndUnit:[transformModel.item getUnit]]];
            
            CGFloat transferToTotal =  unSelectCell.comboSlider.resetValue + unSelectStep; //转换得值
            
            //判断转换值得值是否超过最大值
            if(transferToTotal > unSelectCell.comboSlider.maximumValue)  transferToTotal = unSelectCell.comboSlider.maximumValue;
            [unSelectCell.comboSlider setCurrentValue:transferToTotal animated:NO];
            
            unSelectCell.comboSlider.currentValueLabel.text = [NSString stringWithFormat:@"%.0f",[CommonUtils getUnitConverteValue:transferToTotal-unSelectCell.comboSlider.resetValue AndUnit:[toModel.item getUnit]]];
        }
            break;
        case TransformStateDirectionRight:{
            //unSelectCell --> selectCell 划动得是 selectCell
             selectStep = (NSInteger)(directonAbs /(selectCell.comboSlider.activeStep)) *selectCell.comboSlider.activeStep;
             unSelectStep = (NSInteger)(directonAbs /(selectCell.comboSlider.activeStep)) *unSelectCell.comboSlider.negtiveStep;
            
            [selectCell.comboSlider setCurrentValue:selectCell.comboSlider.resetValue+selectStep animated:NO];
            
             selectCell.comboSlider.currentValueLabel.text = [NSString stringWithFormat:@"%.0f",[CommonUtils getUnitConverteValue:selectCell.comboSlider.currentValue-selectCell.comboSlider.resetValue AndUnit:[toModel.item getUnit]]];
            
            CGFloat transferFromRemain =  unSelectCell.comboSlider.resetValue - unSelectStep; //转换得值
            NSLog(@"transferFor =%f--resetValue =%f",transferFromRemain,unSelectCell.comboSlider.resetValue);
            //判断转换值得值是否超过最小值
            if(transferFromRemain < unSelectCell.comboSlider.minimumValue){
                
                transferFromRemain = unSelectCell.comboSlider.minimumValue;
            }
            [unSelectCell.comboSlider setCurrentValue:transferFromRemain animated:NO];
             unSelectCell.comboSlider.currentValueLabel.text = [NSString stringWithFormat:@"%.0f",[CommonUtils getUnitConverteValue:transferFromRemain-unSelectCell.comboSlider.resetValue AndUnit:[transformModel.item getUnit]]];
            break;
        }
            
        default:
            return;
            break;
    }
    

    TransformLogicModel *model0 = [self.logicArray objectAtIndex:abs(unselectIndexPath.row-1)];
    model0.transferValue = fabsf( selectCell.comboSlider.currentValue - selectCell.comboSlider.resetValue);
    TransformLogicModel *model1 = [self.logicArray objectAtIndex:unselectIndexPath.row];
    model1.transferValue = fabsf( unSelectCell.comboSlider.currentValue - unSelectCell.comboSlider.resetValue);
    [self updatePanelData];
    [self installPanellData];
    
}

#pragma mark --Resource logic
-(void)transactionView:(TransactionView *)transationView transationTableViewCell:(TransationBaseTableViewCell *)cell resourceEvent:(ComboSlider *)comboSlider{
    //点击cell选中
    //判断位置
    
    [self checkCurrentStateWithTableView:transationView.tableView tableViewCell:cell comboSlider:comboSlider];
    
}

-(void)checkCurrentStateWithTableView:(UITableView*)tableView tableViewCell:(TransationBaseTableViewCell*)cell comboSlider:(ComboSlider*)comnoSlider{
    
    
    //判断点击的cell位置
    NSIndexPath *selectIndexPath = [tableView indexPathForCell:cell];
    [self updateCell:cell BgColor:YES];
    [comnoSlider setCurrentValue:comnoSlider.resetValue animated:NO];//归位
    comnoSlider.currentValueLabel.text = @"0";
    id<ITransferable> product = [self.dataSourceList objectAtIndex:selectIndexPath.row];
    switch (_transformState) {
        case TransformStateNone:{
            //添加对象业务规则--添加对象 一个
            if([self.logicArray count] > 0)  [self.logicArray removeAllObjects];
            TransformLogicModel *transdormModel = [[TransformLogicModel alloc]init];
            transdormModel.resourcsID = [product getItemId];
            transdormModel.transferValue = 0;
            transdormModel.resourceName = [product getItemName];
            transdormModel.unitType = [product getUnit];
            transdormModel.rule = nil;
            transdormModel.item =product;
            [self.logicArray addObject:transdormModel];
            [transdormModel release];
            //================
            if (selectIndexPath.row == 0) {
                //选中的管子在第一个位置 不需要移动
                
            }else{
                //数据源变更到第一个位置
                
                [self.dataSourceList removeObject:product];
                [self.dataSourceList insertObject:product atIndex:0];
                //移动 数据变更操作
                [tableView moveRowAtIndexPath:selectIndexPath toIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            }
            
            _transformState = TransformStateOne;
            break;
        }
        case TransformStateOne:{
            
            //绑定业务 添加 第二个对象
            TransformLogicModel *transdormModel = [[TransformLogicModel alloc]init];
            transdormModel.resourcsID = [product getItemId];
            transdormModel.transferValue = 0;
            transdormModel.rule = nil;
            transdormModel.resourceName = [product getItemName];
            transdormModel.unitType = [product getUnit];
            transdormModel.item =product;
            [self.logicArray addObject:transdormModel];
            [transdormModel release];
            //======
            
            //判断是否移动cell  同时移动数据原位置
            if (selectIndexPath.row == 1) {
                
            }else{//数据源在数组
                [self.dataSourceList removeObject:product];
                [self.dataSourceList insertObject:product atIndex:1];
                [tableView moveRowAtIndexPath:selectIndexPath toIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            }
            //规则互相绑定
            if ([self.logicArray count] == 2) {
                TransformLogicModel *model0 = [self.logicArray firstObject];
                TransformLogicModel  *model1 = [self.logicArray lastObject];
                RuleManager *ruleManager = [RuleManager sharedRuleManager];
                model0.rule = [ruleManager transformRule:model0.resourcsID to:model1.resourcsID];
                model1.rule = [ruleManager transformRule:model1.resourcsID to:model0.resourcsID];
                
            }
            //============
            _transformState = TransformStateTwo;
            [self updateSubmitButtonState:YES];
            break;
        }
        case TransformStateTwo:{//变化规则: 当前滑动的cell 变化为初始化状态   点击的cell上移
            _transformState = TransformStateNone;
            
            TransformLogicModel *model0 = [self.logicArray objectAtIndex:0];
            TransformLogicModel *model1 = [self.logicArray objectAtIndex:1];
            id<ITransferable>item0 = model0.item;
            id<ITransferable>item1 = model1.item;
            
            TransationBaseTableViewCell *cell0 = [self.storeCell objectForKey:[NSString stringWithFormat:@"%@-%@",[item0 getSubscriberId],[item0 getItemId]]];
            cell0.comboSlider.showCurrentValue = YES;
           
            [cell0.comboSlider setCurrentValue:cell0.comboSlider.resetValue animated:NO];
            cell0.comboSlider.currentValueLabel.text = @"0";
            [self updateCell:cell0 BgColor:NO];
            
             TransationBaseTableViewCell *cell1 = [self.storeCell objectForKey:[NSString stringWithFormat:@"%@-%@",[item1 getSubscriberId],[item1 getItemId]]];
             cell1.comboSlider.showCurrentValue = YES;
            [cell1.comboSlider setCurrentValue:cell1.comboSlider.resetValue animated:NO];
            cell1.comboSlider.currentValueLabel.text = @"0";
            [self updateCell:cell1 BgColor:NO];
            
            //业务规则
            [self.logicArray removeAllObjects];
            
            //添加对象业务规则--添加对象 一个
           // if([self.logicArray count] > 0)  [self.logicArray removeAllObjects];
            //绑定model
            TransformLogicModel *transdormModel = [[TransformLogicModel alloc]init];
            transdormModel.resourcsID = [product getItemId];
            transdormModel.transferValue = 0;
            transdormModel.resourceName = [product getItemName];
            transdormModel.unitType = [product getUnit];
            transdormModel.item =product;
            transdormModel.rule = nil;
            [self.logicArray addObject:transdormModel];
            [transdormModel release];
            //================
            if (selectIndexPath.row == 0) {
                //不需要移动cell
            }else{
                
                [self.dataSourceList removeObject:product];
                [self.dataSourceList insertObject:product atIndex:0];
                //移动 数据变更操作
                [tableView moveRowAtIndexPath:selectIndexPath toIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            }
            [self updateSubmitButtonState:NO];
            _transformState = TransformStateOne;
            break;
        }
        default:
            break;
    }
    [self updatePanelData];
}


-(void)transactionView:(TransactionView *)transationView transationTableViewCell:(TransationBaseTableViewCell *)cell rightItemEvent:(ComboSlider *)comboSlider{
    
   //取消当前cell状态 回复原值
    [cell.comboSlider setCurrentValue:cell.comboSlider.resetValue animated:NO];
    cell.comboSlider.currentValueLabel.text = @"0";
     NSIndexPath *indexPath = [transationView.tableView indexPathForCell:cell];
    
    // 去掉对应绑定的数据
    if (indexPath.row < self.logicArray.count) {
         [self.logicArray removeObjectAtIndex:indexPath.row];
    }

    if (comboSlider.comboSliderSelected) {
        
        [self updateCell:cell BgColor:NO];
        
        switch (_transformState) {
            case TransformStateTwo:{
                
                [self updateSubmitButtonState:NO];
                //改变另一个cell的状态
                TransationBaseTableViewCell *otherCell = (TransationBaseTableViewCell*)[transationView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:abs(indexPath.row-1) inSection:0]];
                [otherCell.comboSlider setCurrentValue:otherCell.comboSlider.resetValue animated:NO];
                otherCell.comboSlider.currentValueLabel.text = @"0";
                otherCell.comboSlider.showCurrentValue = YES;
               // [self updateCell:otherCell BgColor:NO];
                if ([self.logicArray count] ==1) {
                    TransformLogicModel *model = [self.logicArray firstObject];
                    model.transferValue = 0.0f;
                }
                if (indexPath.row == 0) {//数据源插入到数据 1 位置
                    //下移
                    ProductResource *productResource = [self.dataSourceList objectAtIndex:indexPath.row];
                    [self.dataSourceList removeObject:productResource];
                    [self.dataSourceList insertObject:productResource atIndex:1];
                    [transationView.tableView moveRowAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                    
                }
                _transformState = TransformStateOne;
                break;
            }
            case TransformStateOne:{
                //点击消失属性
             
                _transformState = TransformStateNone;
                break;
            }
                
            default:
                break;
        }
        [self updatePanelData];
      return;
    }
    
}

#pragma mark --跟新cell状态
-(void)updateCell:(TransationBaseTableViewCell*)cell BgColor:(BOOL)state{
    //YES为选中
    if (state) {

        cell.comboSlider.comboSliderSelected = YES;
        cell.comboSlider.showComboSliderThumb = YES;
    }else{
        
       
        cell.comboSlider.comboSliderSelected = NO;
        cell.comboSlider.showComboSliderThumb = NO;
    }
}

#pragma mark --Update Panel Data
//跟新button状态
-(void)updatePanelData{
    
    //Transform----to-----
    if ([self.logicArray count] != 2) {
       // showString = @"There is not transform business";
        [self updateSubmitButtonState:NO];
        return;
    }else{
        TransformLogicModel *model0 = [self.logicArray objectAtIndex:0];
        TransformLogicModel *model1 = [self.logicArray objectAtIndex:1];
        
        if (!model0.transferValue && !model1.transferValue) {
            [self updateSubmitButtonState:NO];
        }else{
            [self updateSubmitButtonState:YES];
        }
    }
    
}

#pragma mark--OverRide
-(void)reset{
    
    TransationBaseTableViewCell *cell0;
    TransationBaseTableViewCell *cell1;
    
    switch (_transformState) {
        case TransformStateNone:{// 初始化当前的两根管子
            
            //将tableView头两个进行业务绑定
            cell0 =(TransationBaseTableViewCell*)[self.transactionView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell0.comboSlider.currentValueLabel.text = @"0";
            [self updateCell:cell0 BgColor:YES];
            cell1 =(TransationBaseTableViewCell*)[self.transactionView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            [self updateCell:cell1 BgColor:YES];
            
            
            if ([self.logicArray count] > 0) {
                [self.logicArray removeAllObjects];
            }
            //获取初始化两个规则
            RuleManager *ruleManger = [RuleManager sharedRuleManager];
            
            ProductResource *pr0 = [self.dataSourceList objectAtIndex:0];
            ProductResource *pr1 = [self.dataSourceList objectAtIndex:1];
            
            TransformLogicModel *tf0 = [[TransformLogicModel alloc]init];
            tf0.resourcsID = pr0.mResourceId;
            tf0.resourceName = pr0.mName;
            tf0.unitType = pr0.mUnit;
            tf0.transferValue = 0;
            
            TransformLogicModel *tf1  = [[TransformLogicModel alloc]init];
            tf1.resourcsID = pr1.mResourceId;
            tf1.transferValue = 0;
            tf1.resourceName = pr1.mName;
            tf1.unitType = pr1.mUnit;
            
            tf0.rule = [ruleManger transformRule:pr0.mResourceId to:pr1.mResourceId];
            tf1.rule = [ruleManger transformRule:pr1.mResourceId to:pr0.mResourceId];
            
            [self.logicArray addObject:tf0];
            [self.logicArray addObject:tf1];
            
            [tf0 release];
            [tf1 release];

            break;
            
        }
        case TransformStateOne:{//改变第二根管子
            
            cell0 =(TransationBaseTableViewCell*)[self.transactionView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            
            cell1 =(TransationBaseTableViewCell*)[self.transactionView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            [self updateCell:cell1 BgColor:YES];
            
            //业务绑定
            RuleManager *ruleManger = [RuleManager sharedRuleManager];
        
            TransformLogicModel *tf0 = [self.logicArray objectAtIndex:0];
            tf0.transferValue = 0;
            
            ProductResource *pr1 = [self.dataSourceList objectAtIndex:1];
            TransformLogicModel *tf1  = [[TransformLogicModel alloc]init];
            tf1.resourcsID = pr1.mResourceId;
            tf1.transferValue = 0;
            tf1.resourceName = pr1.mName;
            tf1.unitType = pr1.mUnit;
            
            tf0.rule = [ruleManger transformRule:tf0.resourcsID to:tf1.resourcsID];
            tf1.rule = [ruleManger transformRule:tf1.resourcsID to:tf0.resourcsID];

            [self.logicArray addObject:tf1];
            
            [tf1 release];

            _transformState = TransformStateTwo;
            
            break;
        }
        case TransformStateTwo:{
            cell0 =(TransationBaseTableViewCell*)[self.transactionView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell1 =(TransationBaseTableViewCell*)[self.transactionView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            break;
        }
            
        default:
            break;
    }
    
    [cell0.comboSlider setCurrentValue:cell0.comboSlider.resetValue animated:NO];
     cell0.comboSlider.currentValueLabel.text = @"0";
    [cell1.comboSlider setCurrentValue:cell1.comboSlider.resetValue animated:NO];
    cell1.comboSlider.currentValueLabel.text = @"0";

    
    for (TransformLogicModel *model in self.logicArray) {
        model.transferValue = 0.0f;
    }
    [self  updatePanelData];
    [self installPanellData];
}
-(void)submit{
    
    AlertController *alert = [[AlertController alloc]initWithTitle:nil message:[NSString stringWithFormat:NSLocalizedString(@"Transform_User_Submit_Sure", nil)] delegate:self tag:kAlertQureChange cancelButtonTitle:NSLocalizedString(@"UIAlertView_Cancel_String", nil) otherButtonTitles:NSLocalizedString(@"UIAlertView_Confirm_String", nil),nil];
    [alert showInViewController:self];
    [alert release];
}
-(void)sureSubmit{
    
    
    if ([self.logicArray count] == 2) {
        
       // [APPLICATION_KEY_WINDOW makeToastActivity];
        TransformLogicModel *model0 = [self.logicArray objectAtIndex:0];
        TransformLogicModel *model1 = [self.logicArray objectAtIndex:1];
        
        TransformLogicModel *fromModel;
        TransformLogicModel *toModel;
        if (_reverse) {
            fromModel = model1;
            toModel = model0;
        }else{
            fromModel = model0;
            toModel = model1;
        }

        [fromModel.item transformTo:[toModel.item getItemId] withOrignalAmount:[CommonUtils formatResourcesValueWithValue:fromModel.transferValue unit:fromModel.unitType] withTargetAmount:[CommonUtils formatResourcesValueWithValue:toModel.transferValue unit:toModel.unitType] andDelegate:self];
        [APPLICATION_KEY_WINDOW makeToastActivity];
    }

}

-(void)installPanellData{
    self.transactionView.panelView.feeLabel.text = NSLocalizedString(@"Transform_Fee", nil);
    self.transactionView.panelView.feeValueLabel.text = [NSString stringWithFormat:@"%0.1f",0.0];
}

#pragma mark --queryCharge
-(void)queryCharge{
    
    
    //from 调用
    if ([self.logicArray count] == 2) {
        // [APPLICATION_KEY_WINDOW makeToastActivity];
        TransformLogicModel *model0 = [self.logicArray objectAtIndex:0];
        TransformLogicModel *model1 = [self.logicArray objectAtIndex:1];
        
        id<ITransferable>from = nil;
        if (_reverse) {
            from =  model1.item;
        }else{
            from = model0.item;
        }
        if (from) {
            [from queryChargeWithTransactionType:3 andDelegate:self];
            [APPLICATION_KEY_WINDOW makeToastActivity];
        }
    }

}
-(void)queryChargeFinished:(NSInteger)status andInfo:(double)info{
    [APPLICATION_KEY_WINDOW hideToastActivity];
    
    if (status != MappActorFinishStatusOK) {
        //失败后 reset
        [self reset];
        return;
    }
    TransformLogicModel *model0 = [self.logicArray objectAtIndex:0];
    TransformLogicModel *model1 = [self.logicArray objectAtIndex:1];
    
    id<ITransferable>from = nil;
    id<ITransferable>to = nil;

     TransformLogicModel *fromModel=nil;
    
    if (_reverse) {
        from =  model1.item;
        to = model0.item;
        fromModel = model1;
    }else{
        from = model0.item;
        to = model1.item;
        fromModel = model0;
    }
    if (from && fromModel) {
        
        CGFloat fee = fromModel.transferValue * (info/100);
        
        //self.transactionView.panelView.feeValueLabel.text = [NSString stringWithFormat:@"%.1f(%@)",[CommonUtils getUnitConverteValue:fee AndUnit:[from getUnit]],[CommonUtils getUnitName:[from getUnit]]];
        
         self.transactionView.panelView.feeValueLabel.text = [CommonUtils formatResourcesWithValue:fee unit:[from getUnit] decimals:2 unitEnable:YES];
        TransationBaseTableViewCell *cell0 =(TransationBaseTableViewCell*)[self.transactionView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        TransationBaseTableViewCell *cell1 =(TransationBaseTableViewCell*)[self.transactionView.tableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        //重新计算值
        CGFloat newValue = fromModel.transferValue - fee;
        TransationBaseTableViewCell *fromCell;
        TransationBaseTableViewCell *toCell;
        
        if (_reverse) {
           //from 1  to  0
            fromCell = cell1;
            toCell = cell0;
        }else{
          //from 0 to 1
            fromCell = cell0;
            toCell = cell1;
        }
        //---变更值
        //----selectCell --> unselectCell
    // CGFloat  selectStep = (NSInteger)(newValue /(from.comboSlider.negtiveStep)) *from.comboSlider.negtiveStep;
       CGFloat  unSelectStep =(NSInteger)(newValue /(fromCell.comboSlider.negtiveStep)) *toCell.comboSlider.activeStep;
        
        fromCell.comboSlider.currentValueLabel.text = [NSString stringWithFormat:@"%@%@",(newValue>0?@"-":@""),[CommonUtils formatResourcesWithValue:newValue unit:[from getUnit] decimals:2 unitEnable:NO]];
    
        CGFloat transferToTotal =  toCell.comboSlider.resetValue + unSelectStep; //转换得值
        
        //判断转换值得值是否超过最大值
        if(transferToTotal > toCell.comboSlider.maximumValue)  transferToTotal = toCell.comboSlider.maximumValue;
        
        toCell.comboSlider.currentValueLabel.text = [CommonUtils formatResourcesWithValue:transferToTotal-toCell.comboSlider.resetValue unit:[to getUnit] decimals:2 unitEnable:NO];
        
        //显示值
        cell0.comboSlider.showCurrentValue = YES;
        cell1.comboSlider.showCurrentValue = YES;
    }
    
}

-(void)alertController:(AlertController *)alertController didDismissWithButtonIndex:(NSInteger)buttonIndex{
  
    if (alertController.tag == kAlertQureChange) {
        
        if (buttonIndex==0) {
            //用户取消不做任何处理
            
        }else if(buttonIndex == 1){
            //用户确认支付
            
            [self sureSubmit];
            
        }
        
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)transferBalanceFinished:(NSInteger)status result:(NSDictionary *)result{
    
    [APPLICATION_KEY_WINDOW hideToastActivity];
    if (status != MappActorFinishStatusOK) {
        [self reset];
        return;
    }
    AlertController *alert = [[AlertController alloc]initWithTitle:nil message:NSLocalizedString(@"Transform_Success", nil) delegate:self tag:0 cancelButtonTitle:NSLocalizedString(@"UIAlertView_Confirm_String", nil) otherButtonTitles: nil];
    [alert showInViewController:self];
    [alert release];
}

@end
