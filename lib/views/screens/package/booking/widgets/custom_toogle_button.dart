import 'package:flutter/material.dart';

class CustomToggle extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final Function(int) onChanged;

  const CustomToggle({required this.options, required this.selectedIndex, required this.onChanged, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: List.generate(options.length, (index) {
          final isSelected = index == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: Container(
                decoration: BoxDecoration(color: isSelected ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(10)),
                alignment: Alignment.center,
                child: Text(options[index], style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.indigo : Colors.black54)),
              ),
            ),
          );
        }),
      ),
    );
  }
}
