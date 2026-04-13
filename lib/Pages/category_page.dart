import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/app_bottom_nav_bar.dart';
import 'add_income_page.dart';
import 'summaries_page.dart';
import 'profile_page.dart';
 
class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});
 
  @override
  State<CategoryPage> createState() => _CategoryPageState();
}
 
class _CategoryPageState extends State<CategoryPage> {
  int _currentIndex = 0;
 
  final List<Map<String, String>> categories = [
    {'icon': '☕', 'label': 'COFFEE'},
    {'icon': '🍕', 'label': 'FOOD'},
    {'icon': '🚕', 'label': 'TRANSPORT'},
    {'icon': '🛍️', 'label': 'SHOPPING'},
    {'icon': '👗', 'label': 'CLOTHES'},
    {'icon': '🎮', 'label': 'GAMES'},
    {'icon': '🏥', 'label': 'HEALTH'},
    {'icon': '💡', 'label': 'BILLS'},
    {'icon': '🏠', 'label': 'HOUSING'},
  ];
 
  String? _selectedCategory;
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGray,
      appBar: AppBar(
        backgroundColor: AppColors.teal,
        elevation: 0,
        title: const Text(
          'PocketPal',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Select your category',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGray,
                      ),
                    ),
                    const SizedBox(height: 24),
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1,
                      children: categories.map((cat) {
                        final isSelected = _selectedCategory == cat['label'];
                        return GestureDetector(
                          onTap: () {
                            setState(() => _selectedCategory = cat['label']);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.teal
                                  : AppColors.lightBlue,
                              borderRadius: BorderRadius.circular(16),
                              border: isSelected
                                  ? Border.all(
                                      color: AppColors.darkGray, width: 2)
                                  : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  cat['icon']!,
                                  style: const TextStyle(fontSize: 28),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  cat['label']!,
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: isSelected
                                        ? AppColors.white
                                        : AppColors.darkGray,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),
                    GestureDetector(
                      onTap: _selectedCategory != null
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddIncomePage(
                                    preSelectedCategory: _selectedCategory!,
                                  ),
                                ),
                              );
                            }
                          : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 56, vertical: 14),
                        decoration: BoxDecoration(
                          color: _selectedCategory != null
                              ? AppColors.yellow
                              : AppColors.lightGray,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          'SAVE',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _selectedCategory != null
                                ? AppColors.darkGray
                                : AppColors.mediumGray,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SummariesPage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
          }
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
 