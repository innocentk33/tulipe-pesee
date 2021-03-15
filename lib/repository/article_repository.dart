import 'package:fish_scan/api/article_client.dart';
import 'package:fish_scan/models/api_response.dart';
import 'package:fish_scan/models/article.dart';

abstract class ArticleRepository {
  Future<ApiResponse<Article>> getArticlesAchat(String commandeNo);

  Future<ApiResponse<Article>> getArticlesVente(String commandeNo);

  Future<ApiResponse<Article>> getArticlesPeseeManuelle(String commandeNo);

  Future<ApiResponse<Article>> getArticlesVenteByLot(
      {String articleNo, String lot, String locationCode});

  Future<ApiResponse<Article>> getValeurEffective(
      {Article article, int champs, String sourceType});

  Future<ApiResponse<Article>> getArticleAchatRapide();

  Future<ApiResponse<Article>> getNombreColisPeseur(
      {Article article, int champs, String sourceType, String login});

  Future<ApiResponse<Article>> getFreeLotNo(
      {int number, String quantity, Article article, String userLogin});
}

class ArticleRepositoryImpl extends ArticleRepository {
  final ArticleClient client = ArticleClient();

  @override
  Future<ApiResponse<Article>> getArticlesAchat(String commandeNo) =>
      client.getArticlesAchat(commandeNo);

  @override
  Future<ApiResponse<Article>> getArticlesVente(String commandeNo) =>
      client.getArticlesVente(commandeNo);

  @override
  Future<ApiResponse<Article>> getArticlesVenteByLot(
          {String articleNo, String lot, String locationCode}) =>
      client.getArticleVenteByLot(
          articleNo: articleNo, lot: lot, locationCode: locationCode);

  @override
  Future<ApiResponse<Article>> getValeurEffective(
          {Article article, int champs, String sourceType}) =>
      client.getValeurEffective(
          article: article, champs: champs, sourceType: sourceType);

  @override
  Future<ApiResponse<Article>> getArticleAchatRapide() =>
      client.getArticleAchatRapide();

  @override
  Future<ApiResponse<Article>> getNombreColisPeseur(
          {Article article, int champs, String sourceType, String login}) =>
      client.getNombreColisPeseur(
          article: article,
          champs: champs,
          sourceType: sourceType,
          login: login);

  @override
  Future<ApiResponse<Article>> getFreeLotNo(
          {int number, String quantity, Article article, String userLogin}) =>
      client.getFreeLotNo(
        number: number,
        quantity: quantity,
        article: article,
        userLogin: userLogin,
      );

  @override
  Future<ApiResponse<Article>> getArticlesPeseeManuelle(String commandeNo) => client.getArticlePeseeManuelle(commandeNo);
}
