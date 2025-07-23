import 'dart:math';
import 'package:intl/intl.dart';
import 'package:dropdown_recreation/custom_dropdown.dart';
import 'package:flutter/material.dart';

import 'dropdown_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final selectedKey = ValueNotifier<String?>(null);
  final equipmentAccounts = [
    Account(
      id: '1',
      name: 'Wheel Loader',
      accountNumber: '*3456',
      isNew: true,
      availableCommitment: Random().nextDouble() * 10000000,
    ),
    Account(
      id: '2',
      name: 'Excavator',
      accountNumber: '*4321',
      isNew: false,
      availableCommitment: Random().nextDouble() * 10000000,
    ),
    Account(
      id: '3',
      name: 'Bulldozer',
      accountNumber: '*2233',
      isNew: false,
      availableCommitment: Random().nextDouble() * 10000000,
    ),
    Account(
      id: '6',
      name: 'Dump Truck',
      accountNumber: '*7788',
      isNew: false,
      availableCommitment: Random().nextDouble() * 10000000,
    ),
    Account(
      id: '7',
      name: 'Crane',
      accountNumber: '*1122',
      isNew: false,
      availableCommitment: Random().nextDouble() * 10000000,
    ),
    Account(
      id: '8',
      name: 'Forklift',
      accountNumber: '*3344',
      isNew: false,
      availableCommitment: Random().nextDouble() * 10000000,
    ),
  ];
  final operatingAccounts = [
    Account(
      id: '4',
      name: 'LOC',
      accountNumber: '*5566',
      isNew: true,
      availableCommitment: Random().nextDouble() * 10000000,
    ),
    Account(
      id: '5',
      name: 'Operating',
      accountNumber: '*8899',
      isNew: false,
      availableCommitment: Random().nextDouble() * 10000000,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton(
              items: equipmentAccounts.map((i) => DropdownMenuItem(value: i, child: Text(i.displayName))).toList(),
              onChanged: (Account? value) {},
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 400,
              child: CustomDropdown(
                options: {
                  'all': DropdownItem<Account>.static('All'),
                  'equipment': DropdownItem<Account>.groupTitle('Equipment'),
                  for (var item in equipmentAccounts) item.id: DropdownItem.dynamic(item),
                  'operating': DropdownItem<Account>.groupTitle('Operating'),
                  for (var item in operatingAccounts) item.id: DropdownItem.dynamic(item),
                },
                selectedKey: selectedKey,
                itemSelected: _onDropdownItemSelected,
                itemBuilder: _buildItemWidget,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onDropdownItemSelected(String key, DropdownItem<Account> selectedItem) {
    selectedKey.value = key;
    if (selectedItem.isStatic) {
      print('Selected static item: ${selectedItem.staticValue}');
    } else {
      print('Selected item: ${selectedItem.value.displayName}');
    }
  }

  Widget _buildItemWidget(DropdownItem<Account> selectedItem, bool isForRootButton) {
    final theme = Theme.of(context);
    final textColor = isForRootButton ? theme.colorScheme.primary : null;
    final labelLargeTextStyle = theme.primaryTextTheme.labelLarge?.copyWith(color: textColor);
    final labelLargeBoldTextStyle = labelLargeTextStyle?.copyWith(color: textColor, fontWeight: FontWeight.bold);
    final selectableItemSize = 40.0;

    if (selectedItem.isGroupTitle) {
      return SizedBox(
        width: double.infinity,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('${selectedItem.groupTitle!}:', style: labelLargeBoldTextStyle),
        ),
      );
    }

    if (selectedItem.isStatic) {
      return SizedBox(
        width: double.infinity,
        height: selectableItemSize,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(selectedItem.staticValue!, style: labelLargeBoldTextStyle),
        ),
      );
    }

    return SizedBox(
      height: selectableItemSize,
      child: Padding(
        padding: EdgeInsets.only(left: isForRootButton ? 0.0 : 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(selectedItem.value.name, style: labelLargeBoldTextStyle),
                const SizedBox(width: 4.0),
                Text(selectedItem.value.accountNumber, style: labelLargeTextStyle),
                if (selectedItem.value.isNew)
                  Container(
                    margin: const EdgeInsets.only(left: 8.0),
                    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                    decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(4.0)),
                    child: Text('New', style: theme.primaryTextTheme.labelMedium),
                  ),
              ],
            ),
            Text(
              'Available Commitment: ${selectedItem.value.formattedAvailableCommitment}',
              style: theme.primaryTextTheme.bodySmall?.copyWith(color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}

class Account {
  final String id;
  final String name;
  final String accountNumber;
  final bool isNew;
  final double availableCommitment;

  String get displayName => '$name $accountNumber';

  String get formattedAvailableCommitment => NumberFormat.simpleCurrency().format(availableCommitment);

  Account({
    required this.id,
    required this.name,
    required this.accountNumber,
    required this.isNew,
    required this.availableCommitment,
  });
}
