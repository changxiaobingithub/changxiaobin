//
//  HPSubstringViewController.m
//  TestDemos
//
//  Created by 常肖彬 on 2019/7/26.
//  Copyright © 2019 XiaoBinChang. All rights reserved.
//

#import "HPSubstringViewController.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

@interface HPSubstringViewController ()<CNContactPickerDelegate>

@end

@implementation HPSubstringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

//    [self testObjcetAtIndex];
//    [self testSubstringURL];

}

- (void)testObjcetAtIndex {
    int i = 3;
    NSArray *dataSource = @[@"111", @"222", @"333"];
    if(i < 0 || i >= dataSource.count) {
        return;
    }
    NSString *str = [dataSource objectAtIndex:i];
    NSLog(@"str -- %@",str);
}

//测试截取URL地址
- (void)testSubstringURL {
    NSString *testStr = @"protocol://customProtocol|title=this is title|message=this is message|shareUrl=this is url";

    NSString *parten = @"\\|title=(.*?)\\|message=(.*?)\\|shareUrl=(.*)$";
    NSError *error = nil;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:NSRegularExpressionCaseInsensitive error:&error]; //options 根据自己需求选择

    NSArray *matches = [reg matchesInString:testStr options:NSMatchingReportCompletion range:NSMakeRange(0, testStr.length)];

    for (NSTextCheckingResult *match in matches) {

        NSRange matchRange = [match rangeAtIndex:2];
        NSString *matchString = [testStr substringWithRange:matchRange];
        NSLog(@"index:%@, %@", @(2), matchString);

//        for (int i = 0; i < match.numberOfRanges; i++) {
//            NSRange matchRange = [match rangeAtIndex:i];
//            NSString *matchString = [testStr substringWithRange:matchRange];
//            NSLog(@"index:%@, %@", @(i), matchString);
//        }
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 1. 创建选择联系人控制器
    if (@available(iOS 9.0, *)) {
        CNContactPickerViewController *pickerVC = [[CNContactPickerViewController alloc] init];
        // 2. 设置代理
        pickerVC.delegate = self;
         //3. 弹出控制器
        [self presentViewController:pickerVC animated:YES completion:nil];
    }
}

#pragma mark - 代理方法
// 控制器点击取消的时候调用
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker  API_AVAILABLE(ios(9.0)){
    NSLog(@"点击了取消");
}

// 点击了联系人的时候调用, 如果实现了这个方法, 就无法进入联系人详情界面
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact  API_AVAILABLE(ios(9.0)){

    // contact属性就是联系人的信息
    NSLog(@"%@---%@", contact.namePrefix, contact.familyName);

    // 获取联系人的电话号码
    NSArray<CNLabeledValue<CNPhoneNumber*>*> *phoneNumbers = contact.phoneNumbers;

    // 注意, 由于这个数组规定了泛型, 所以要使用遍历器来取出每一个特定类型的对象, 才能取到里面的属性
    [phoneNumbers enumerateObjectsUsingBlock:^(CNLabeledValue<CNPhoneNumber*> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        NSLog(@"%@--%@", obj.label, obj.value.stringValue);
    }];
}

// 点击了联系人的确切属性的时候调用, 注意, 这两个方法只能实现一个
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty  API_AVAILABLE(ios(9.0)){
    NSLog(@"%@---%@", contactProperty.key, contactProperty.value);
}
@end
