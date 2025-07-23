import 'dart:async';

import 'package:dropdown_recreation/custom_dropdown_route.dart';
import 'package:flutter/material.dart';

class DropdownItem<T> {
  final T? _value;
  final String? staticValue;
  final String? groupTitle;

  bool get isStatic => staticValue != null;

  bool get isGroupTitle => groupTitle != null;

  T get value {
    final value = _value;
    if (value == null) {
      throw StateError('This is a static instance and does not have a value');
    }
    return value;
  }

  const DropdownItem._({T? value, this.staticValue, this.groupTitle})
      : _value = value;

  const DropdownItem.static([String? staticValue]) : this._(staticValue: staticValue);

  const DropdownItem.dynamic(T value) : this._(value: value);

  const DropdownItem.groupTitle(String groupTitle) : this._(groupTitle: groupTitle);
}