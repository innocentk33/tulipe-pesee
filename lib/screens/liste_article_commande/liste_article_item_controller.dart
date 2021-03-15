import 'package:fish_scan/models/api_response.dart';
import 'package:fish_scan/models/article.dart';
import 'package:fish_scan/models/commande.dart';
import 'package:fish_scan/repository/article_repository.dart';
import 'package:fish_scan/repository/commande_repository.dart';
import 'package:fish_scan/constants/navigation_menu.dart';
import 'package:get/get.dart';

class ListeArticleItemController extends GetxController {
  var _isLoading = false.obs;
  RxInt _nombreCartons = 0.obs;
  RxDouble _poids = 0.0.obs;
  Article _article;

  ArticleRepository repository = ArticleRepositoryImpl();

  setArticle(Article article) {
    _article = article;
  }

  loadDatas(String sourceType) async {
    getNombreCartons(sourceType);
  }

  Future getNombreCartons(String sourceType) async {
    _isLoading.value = true;
    var response =
        await repository.getValeurEffective(article: _article, champs: 0, sourceType: sourceType);
    if (!response.hasError) {
      _nombreCartons.value = int.parse(response.body);
      getPoids(sourceType);
      return;
    }
  }

  Future getPoids(String sourceType) async {
    var response =
        await repository.getValeurEffective(article: _article, champs: 1, sourceType: sourceType);
    if (!response.hasError) {
      _isLoading.value = false;
      _poids.value = double.parse(response.body);
    }
  }

  bool get isLoading => _isLoading.value;

  double get poids => _poids.value;

  int get nombreCartons => _nombreCartons.value;
}
