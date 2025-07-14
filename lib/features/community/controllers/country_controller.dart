import 'package:get/get.dart';
import '../../authentication/models/country.dart';

class CountryController extends GetxController {
  Rx<Country?> selectedCountry = Rx<Country?>(null);

  List<Country> countries = [];

  void selectCountry(Country country) {
    selectedCountry.value = country;
  }

  void loadCountries(List<Country> loadedCountries) {
    countries = loadedCountries;

    if (selectedCountry.value == null && countries.isNotEmpty) {
      selectedCountry.value = countries.first;
    }
  }
}
