import 'package:flutter/material.dart';

import 'input.c_text_form_field.dart';
import 'utils/converts.dart';
import 'utils/utils.dart';

// import 'input.cTextFormField.dart';

class CAmountInput extends StatelessWidget {
  const CAmountInput({
    Key? key,
    this.controller,
    this.enabled,
    this.onValidate,
    this.onChanged,
    this.maxAmount = 300000,
    this.availableAmount = 1000000000,
    this.hintText,
  }) : super(key: key);
  final TextEditingController? controller;
  final bool? enabled;
  final ValueChanged<bool>? onValidate;
  final ValueChanged<int>? onChanged;
  final int maxAmount;
  final int availableAmount;
  final String? hintText;

  String? amountValidator(String? val) {
    final String str = val ?? '';
    final int amount = ((double.tryParse(str) ?? 0) * 100).toInt();
    if (amount <= 0) {
      doChange(amount: amount, valid: false);
      return 'Invalid amount';
    } else if (amount > availableAmount) {
      doChange(amount: amount, valid: false);
      return 'Insufficient balance';
    } else if (amount > maxAmount) {
      doChange(amount: amount, valid: false);
      return 'Exceed max limit of ${toPrice(maxAmount)}';
    }
    doChange(amount: amount, valid: true);
    return null;
  }

  void doChange({required int amount, required bool valid}) {
    Future.delayed(Duration.zero, () {
      onValidate?.call(valid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CTextFormField(
      style: const TextStyle(fontSize: 20),
      validator: (value) => amountValidator(value),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enabled: enabled,
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [CFormatters.amountFormatter],
      // decoration: InputDecoration(
      prefixText: '\$',
      filled: false,
      border: const UnderlineInputBorder(),
      hintText: hintText ?? 'Enter Amount',
      helperText: ' ',
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.green,
          width: 2,
        ),
      ),
      // ),
    );
  }
}
