import 'package:flutter/material.dart';
import 'login_page.dart';

class AppColors {
  static const Color background = Color(0xFFEFF7F6);
  static const Color appBar = Color(0xFFB2D8D8);
  static const Color darkText = Color(0xFF302A4C);
  static const Color yellowActive = Color(0xFFFDD87A);
  static const Color white = Colors.white;
}

class AppStyles {
  static const TextStyle pocketPal = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.darkText,
    fontFamily: 'Jua',
  );
  static const TextStyle financialFriend = TextStyle(
    fontSize: 16,
    color: AppColors.darkText,
    fontFamily: 'Jua',
  );
  static const TextStyle dropdownText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.darkText,
    fontFamily: 'Jua',
  );
}

class CurrencyModel {
  final String flag;
  final String name;
  final String code;
  CurrencyModel({required this.flag, required this.name, required this.code});
}

final List<CurrencyModel> currencies = [
  CurrencyModel(flag: '🇹🇭', name: 'BAHT', code: 'THB'),
  CurrencyModel(flag: '🇰🇷', name: 'WON', code: 'KRW'),
  CurrencyModel(flag: '🇺🇸', name: 'DOLLAR', code: 'USD'),
];

class SelectCurrencyPage extends StatefulWidget {
  const SelectCurrencyPage({super.key});

  @override
  State<SelectCurrencyPage> createState() => _SelectCurrencyPageState();
}

class _SelectCurrencyPageState extends State<SelectCurrencyPage> {
  CurrencyModel? _selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', height: 200),
              const SizedBox(height: 10),
              const Text('POCKETPAL', style: AppStyles.pocketPal),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFD9EDED),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CurrencyDropdown(
                      selectedCurrency: _selectedCurrency,
                      onChanged: (newValue) {
                        setState(() => _selectedCurrency = newValue);
                      },
                    ),
                    if (_selectedCurrency != null) ...[
                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_selectedCurrency != null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );

                              print(
                                'Selected Currency: ${_selectedCurrency!.code}',
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.yellowActive,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 5,
                          ),
                          child: const Text(
                            'SAVE',
                            style: AppStyles.dropdownText,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CurrencyDropdown extends StatelessWidget {
  final CurrencyModel? selectedCurrency;
  final ValueChanged<CurrencyModel?> onChanged;

  const CurrencyDropdown({
    super.key,
    this.selectedCurrency,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<CurrencyModel>(
          value: selectedCurrency,
          isExpanded: true,
          hint: const Center(
            child: Text(
              'Select your currency',
              style: TextStyle(
                color: AppColors.darkText,
                fontFamily: 'Jua',
                fontSize: 20,
              ),
            ),
          ),
          icon: const Icon(
            Icons.arrow_drop_down_rounded,
            color: AppColors.darkText,
            size: 30,
          ),
          onChanged: onChanged,
          selectedItemBuilder: (context) {
            return currencies.map((item) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(item.flag, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 15),
                  Text(item.name, style: AppStyles.dropdownText),
                ],
              );
            }).toList();
          },
          items: currencies.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Row(
                children: [
                  Text(item.flag, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  Text(item.name, style: const TextStyle(fontFamily: 'Jua')),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
