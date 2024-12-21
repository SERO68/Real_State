class FormValidator {
  static String? validateCompoundName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a compound name';
    }
    if (value.length < 3) {
      return 'Compound name must be at least 3 characters';
    }
    return null;
  }

  static bool isFormValid({
    required String compoundName,
    required String? imageUrl,
  }) {
    if (compoundName.isEmpty || imageUrl == null) {
      return false;
    }
    return validateCompoundName(compoundName) == null;
  }
}