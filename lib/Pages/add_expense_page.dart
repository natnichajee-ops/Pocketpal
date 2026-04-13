import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/transaction.dart';
import 'add_income_page.dart';
import 'select_amount_page.dart';
import 'select_date_page.dart';
import '../models/database_helper.dart';
import 'select_currency_page.dart';

class AddExpensePage extends StatefulWidget {
  final String preSelectedCategory;
  const AddExpensePage({super.key, this.preSelectedCategory = 'FOOD'});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  late DateTime selectedDate;
  late String selectedCategory;
  double amount = 0.0;
  String currency = 'THB';

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    selectedCategory = widget.preSelectedCategory;
  }

  String _formatDate(DateTime d) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${d.day} ${months[d.month]} ${d.year}';
  }
   String _getCurrencyFlag(String currency) {
    const flags = {
      'THB': '🇹🇭',
      'USD': '🇺🇸',
      'EUR': '🇪🇺',
      'GBP': '🇬🇧',
      'JPY': '🇯🇵',
      'CNY': '🇨🇳',
      'SGD': '🇸🇬',
      'KRW': '🇰🇷',
      'HKD': '🇭🇰',
      'AUD': '🇦🇺',
    };
    return flags[currency] ?? '🏳️';
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGray,
      appBar: AppBar(
        backgroundColor: AppColors.teal,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Transaction',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddIncomePage(
                          preSelectedCategory: selectedCategory,
                        ),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.teal,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'ADD INCOME +',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.pink,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'ADD EXPENSE -',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildField(
              icon: Icons.calendar_today_outlined,
              iconColor: AppColors.teal,
              label: 'Select Date',
              value: _formatDate(selectedDate),
              onTap: () async {
                final picked = await Navigator.push<DateTime>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SelectDatePage(initialDate: selectedDate),
                  ),
                );
                if (picked != null) setState(() => selectedDate = picked);
              },
            ),
            const SizedBox(height: 16),
            _buildField(
              icon: Icons.grid_view_rounded,
              iconColor: AppColors.yellow,
              label: 'Select Category',
              value: selectedCategory,
              hasDropdown: true,
              onTap: () async {
                final result = await _showCategoryPicker(context);
                if (result != null) setState(() => selectedCategory = result);
              },
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.remove_circle_outline,
                    color: AppColors.expenseRed,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        final result = await Navigator.push<double>(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                SelectAmountPage(initialAmount: amount),
                          ),
                        );
                        if (result != null) setState(() => amount = result);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'select Amount',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.mediumGray,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '- ${amount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.darkGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push<String>(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              SelectCurrencyPage(selectedCurrency: currency),
                        ),
                      );
                      if (result != null) setState(() => currency = result);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightGray,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Text(_getCurrencyFlag(currency), style: const TextStyle(fontSize: 12)),
                          const SizedBox(width: 4),
                          Text(
                            currency,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.darkGray,
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down, size: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () async {
                final t = Transaction(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  type: 'expense',
                  category: selectedCategory,
                  amount: amount,
                  date: selectedDate,
                  currency: currency,
                );
                await DatabaseHelper().insertTransaction(t);
                if (mounted) Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.yellow,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(
                  child: Text(
                    'SAVE',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGray,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    bool hasDropdown = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.mediumGray,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.darkGray,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              hasDropdown ? Icons.arrow_drop_down : Icons.calendar_today,
              color: AppColors.mediumGray,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _showCategoryPicker(BuildContext context) {
    final cats = [
      'FOOD',
      'TRANSPORT',
      'SHOPPING',
      'COFFEE',
      'CLOTHES',
      'GAMES',
      'HEALTH',
      'BILLS',
      'HOUSING',
    ];
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Select Category'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: cats
                .map(
                  (c) => ListTile(
                    title: Text(c),
                    trailing: c == selectedCategory
                        ? const Icon(Icons.check, color: AppColors.teal)
                        : null,
                    onTap: () => Navigator.pop(context, c),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
