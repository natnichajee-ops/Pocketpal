import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  static final CurrencyService _instance = CurrencyService._internal();
  factory CurrencyService() => _instance;
  CurrencyService._internal();

  static const String _baseUrl = 'https://api.frankfurter.app';

  // ดึงรายชื่อสกุลเงินทั้งหมด
  Future<Map<String, String>> getAllCurrencies() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/currencies'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data.map((key, value) => MapEntry(key, value.toString()));
      } else {
        throw Exception('Failed to load currencies');
      }
    } catch (e) {
      // ถ้า API ไม่ได้ ใช้รายการสำรองค่ะ
      return _fallbackCurrencies;
    }
  }

  // ดึงอัตราแลกเปลี่ยนจากสกุลเงินหนึ่งไปอีกสกุล
  Future<double> getExchangeRate(String from, String to) async {
    try {
      if (from == to) return 1.0;

      final response = await http.get(
        Uri.parse('$_baseUrl/latest?from=$from&to=$to'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final rates = data['rates'] as Map<String, dynamic>;
        return (rates[to] as num).toDouble();
      } else {
        throw Exception('Failed to load exchange rate');
      }
    } catch (e) {
      return 1.0;
    }
  }

  // ดึงอัตราแลกเปลี่ยนทั้งหมดจากสกุลเงินหนึ่ง
  Future<Map<String, double>> getAllRates(String baseCurrency) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/latest?from=$baseCurrency'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final rates = data['rates'] as Map<String, dynamic>;
        return rates.map((key, value) => MapEntry(key, (value as num).toDouble()));
      } else {
        throw Exception('Failed to load rates');
      }
    } catch (e) {
      return {};
    }
  }

  // รายการสกุลเงินสำรองถ้า API ไม่ได้
  static const Map<String, String> _fallbackCurrencies = {
    'THB': 'Thai Baht',
    'USD': 'US Dollar',
    'EUR': 'Euro',
    'GBP': 'British Pound',
    'JPY': 'Japanese Yen',
    'KRW': 'South Korean Won',
    'CNY': 'Chinese Yuan',
    'SGD': 'Singapore Dollar',
    'AUD': 'Australian Dollar',
    'CAD': 'Canadian Dollar',
    'CHF': 'Swiss Franc',
    'HKD': 'Hong Kong Dollar',
    'MYR': 'Malaysian Ringgit',
    'IDR': 'Indonesian Rupiah',
    'PHP': 'Philippine Peso',
    'VND': 'Vietnamese Dong',
    'INR': 'Indian Rupee',
    'BRL': 'Brazilian Real',
    'MXN': 'Mexican Peso',
    'NZD': 'New Zealand Dollar',
  };
}