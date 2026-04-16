import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/currency_service.dart';

class SelectCurrencyPage extends StatefulWidget {
  final String selectedCurrency;

  const SelectCurrencyPage({super.key, this.selectedCurrency = 'THB'});

  @override
  State<SelectCurrencyPage> createState() => _SelectCurrencyPageState();
}

class _SelectCurrencyPageState extends State<SelectCurrencyPage> {
  final CurrencyService _currencyService = CurrencyService();
  Map<String, String> _currencies = {};
  Map<String, double> _rates = {};
  bool _isLoading = true;
  String _searchQuery = '';
  late String _selectedCurrency;

  // Flag emoji map
  static const Map<String, String> _flags = {
    'THB': '🇹🇭',
    'USD': '🇺🇸',
    'EUR': '🇪🇺',
    'GBP': '🇬🇧',
    'JPY': '🇯🇵',
    'KRW': '🇰🇷',
    'CNY': '🇨🇳',
    'SGD': '🇸🇬',
    'AUD': '🇦🇺',
    'CAD': '🇨🇦',
    'CHF': '🇨🇭',
    'HKD': '🇭🇰',
    'MYR': '🇲🇾',
    'IDR': '🇮🇩',
    'PHP': '🇵🇭',
    'VND': '🇻🇳',
    'INR': '🇮🇳',
    'BRL': '🇧🇷',
    'MXN': '🇲🇽',
    'NZD': '🇳🇿',
    'SEK': '🇸🇪',
    'NOK': '🇳🇴',
    'DKK': '🇩🇰',
    'PLN': '🇵🇱',
    'CZK': '🇨🇿',
    'HUF': '🇭🇺',
    'RON': '🇷🇴',
    'TRY': '🇹🇷',
    'ZAR': '🇿🇦',
    'SAR': '🇸🇦',
    'AED': '🇦🇪',
    'ILS': '🇮🇱',
  };

  @override
  void initState() {
    super.initState();
    _selectedCurrency = widget.selectedCurrency;
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final currencies = await _currencyService.getAllCurrencies();
      final rates = await _currencyService.getAllRates('THB');
      setState(() {
        _currencies = currencies;
        _rates = rates;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  List<MapEntry<String, String>> get _filteredCurrencies {
    final entries = _currencies.entries.toList();
    if (_searchQuery.isEmpty) return entries;
    return entries
        .where(
          (e) =>
              e.key.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              e.value.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
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
          onPressed: () => Navigator.pop(context, _selectedCurrency),
        ),
        title: const Text(
          'SELECT CURRENCY',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: const InputDecoration(
                hintText: 'ค้นหาสกุลเงิน...',
                border: InputBorder.none,
                icon: Icon(Icons.search, color: AppColors.mediumGray),
              ),
            ),
          ),

          // Currency list
          Expanded(
            child: _isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: AppColors.teal),
                        SizedBox(height: 16),
                        Text(
                          'กำลังโหลดสกุลเงิน...',
                          style: TextStyle(color: AppColors.mediumGray),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadData,
                    child: ListView.builder(
                      itemCount: _filteredCurrencies.length,
                      itemBuilder: (context, index) {
                        final entry = _filteredCurrencies[index];
                        final code = entry.key;
                        final name = entry.value;
                        final flag = _flags[code] ?? '🏳️';
                        final isSelected = _selectedCurrency == code;
                        final rate = _rates[code];

                        return GestureDetector(
                          onTap: () {
                            setState(() => _selectedCurrency = code);
                            Navigator.pop(context, code);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.teal.withValues(alpha: 0.1)
                                  : AppColors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: isSelected
                                  ? Border.all(
                                      color: AppColors.teal,
                                      width: 1.5,
                                    )
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  flag,
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        code,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.darkGray,
                                        ),
                                      ),
                                      Text(
                                        name,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: AppColors.mediumGray,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (rate != null)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '1 THB = ${rate.toStringAsFixed(4)} $code',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: AppColors.mediumGray,
                                        ),
                                      ),
                                      Text(
                                        '1 $code = ${(1 / rate).toStringAsFixed(4)} THB',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: AppColors.mediumGray,
                                        ),
                                      ),
                                    ],
                                  ),
                                if (isSelected)
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Icon(
                                      Icons.check_circle,
                                      color: AppColors.teal,
                                      size: 20,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
