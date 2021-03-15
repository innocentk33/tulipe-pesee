import 'package:fish_scan/models/api_response.dart';
import 'package:fish_scan/models/article.dart';
import 'package:fish_scan/models/commande.dart';
import 'package:fish_scan/repository/article_repository.dart';
import 'package:fish_scan/repository/commande_repository.dart';
import 'package:fish_scan/constants/navigation_menu.dart';
import 'package:get/get.dart';

class ListeArticleCommandeController extends GetxController {
  var _isLoading = false.obs;
  ApiResponse<Article> _response;

  ArticleRepository repository = ArticleRepositoryImpl();

  Future getArticles({String commandeNo, NavigationMenu menu}) async {
    _isLoading.value = true;
    if (commandeNo != null) {
      _response = await (menu == NavigationMenu.DEPOTAGE
          ? repository.getArticlesAchat(commandeNo)
          : repository.getArticlesVente(commandeNo));
    } else {
      _response = await repository.getArticleAchatRapide();
    }
    _isLoading.value = false;
  }

  bool get isLoading => _isLoading.value;

  ApiResponse<Article> get response => _response;

  getArticlesPeseeManuelle({String commandeNo}) async {
    _isLoading.value = true;
    _response = await repository.getArticlesPeseeManuelle(commandeNo);
    _isLoading.value = false;
  }
}
