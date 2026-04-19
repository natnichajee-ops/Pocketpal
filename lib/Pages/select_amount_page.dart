import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

// อัตราแลกเปลี่ยนเทียบกับ THB
const Map<String, double> _ratesFromTHB = {
  'THB': 1.0,
  'USD': 0.0278,
  'EUR': 0.0257,
  'JPY': 4.23,
  'CNY': 0.201,
  'GBP': 0.0220,
  'KRW': 38.10,
  'SGD': 0.0374,
  'MYR': 0.130,
  'HKD': 0.217,
  'AUD': 0.0431,
};

const Map<String, String> _currencyFlags = {
  'THB': '🇹🇭',
  'USD': '🇺🇸',
  'EUR': '🇪🇺',
  'JPY': '🇯🇵',
  'CNY': '🇨🇳',
  'GBP': '🇬🇧',
  'KRW': '🇰🇷',
  'SGD': '🇸🇬',
  'MYR': '🇲🇾',
  'HKD': '🇭🇰',
  'AUD': '🇦🇺',
};

class SelectAmountPage extends StatefulWidget {
  final double initialAmount;

  const SelectAmountPage({super.key, required this.initialAmount});

  @override
  State<SelectAmountPage> createState() => _SelectAmountPageState();
}

class _SelectAmountPageState extends State<SelectAmountPage> {
  String _display = '';
  String _selectedCurrency = 'THB';

  @override
  void initState() {
    super.initState();
    _display = widget.initialAmount > 0
        ? widget.initialAmount.toStringAsFixed(0)
        : '';
  }

  void _onKey(String key) {
    setState(() {
      if (key == '⌫') {
        if (_display.isNotEmpty) {
          _display = _display.substring(0, _display.length - 1);
        }
      } else if (key == '.') {
        if (!_display.contains('.')) _display += '.';
      } else {
        if (_display.length < 12) _display += key;
      }
    });
  }

  /// แปลงจากสกุลเงินที่เลือก → THB
  double get _amountInTHB {
    final input = double.tryParse(_display) ?? 0;
    if (_selectedCurrency == 'THB') return input;
    final rate = _ratesFromTHB[_selectedCurrency] ?? 1.0;
    return input / rate;
  }

  @override
  Widget build(BuildContext context) {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['.', '0', '⌫'],
    ];

    final hasInput = (double.tryParse(_display) ?? 0) > 0;

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
          'SELECT AMOUNT',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // ── Currency Chip Selector ───────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _ratesFromTHB.keys.map((currency) {
                  final isSelected = _selectedCurrency == currency;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCurrency = currency),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.teal : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.teal, width: 1.5),
                      ),
                      child: Text(
                        '${_currencyFlags[currency]} $currency',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : AppColors.teal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // ── Display ──────────────────────────────────────────────────
          Container(
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.lightGray,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _display.isEmpty ? '0' : _display,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGray,
                  ),
                ),
                if (_selectedCurrency != 'THB' && hasInput)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '= ${_amountInTHB.toStringAsFixed(2)} THB',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.darkGray.withOpacity(0.6),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── Keypad ───────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: keys.map((row) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: row.map((k) {
                      final isDelete = k == '⌫';
                      return GestureDetector(
                        onTap: () => _onKey(k),
                        child: Container(
                          width: 84,
                          height: 62,
                          decoration: BoxDecoration(
                            color: isDelete
                                ? AppColors.darkGray
                                : AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.07),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: isDelete
                                ? const Icon(
                                    Icons.backspace_outlined,
                                    color: Colors.white,
                                    size: 22,
                                  )
                                : Text(
                                    k,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.darkGray,
                                    ),
                                  ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
            ),
          ),

          // ── Save Button ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(20),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context, _amountInTHB);
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
          ),
        ],
      ),
    );
  }
}
