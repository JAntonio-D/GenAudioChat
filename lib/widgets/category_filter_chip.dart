import 'package:flutter/material.dart';

// Enum para los tipos de ejercicio
enum CategoryFilter { walking, running, cycling, hiking }

class CategoryFilterChip extends StatelessWidget {
  final Set<CategoryFilter> filters;
  final ValueChanged<Set<CategoryFilter>> onFilterChanged;

  const CategoryFilterChip({
    super.key,
    required this.filters,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5.0,
      children: CategoryFilter.values.map((CategoryFilter exercise) {
        return FilterChip(
          label: Text(exercise.name),
          selected: filters.contains(exercise),
          onSelected: (bool selected) {
            if (selected) {
              filters.add(exercise);
            } else {
              filters.remove(exercise);
            }
            onFilterChanged(filters); // Pasamos los filtros seleccionados hacia arriba
          },
        );
      }).toList(),
    );
  }
}
