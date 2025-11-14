import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/data/models/movie/genre_model.dart';
import 'package:ditonton/domain/entities/movie/genre.dart';

void main() {
  group('GenreModel', () {
    const tId = 28;
    const tName = 'Action';

    final tGenreModel = GenreModel(
      id: tId,
      name: tName,
    );

    final tGenreEntity = Genre(
      id: tId,
      name: tName,
    );

    test('should create GenreModel instance correctly', () {
      expect(tGenreModel.id, tId);
      expect(tGenreModel.name, tName);
    });

    test('should convert JSON to GenreModel', () {
      final Map<String, dynamic> jsonMap = {
        "id": tId,
        "name": tName,
      };

      final result = GenreModel.fromJson(jsonMap);

      expect(result, tGenreModel);
    });

    test('should convert GenreModel to JSON', () {
      final result = tGenreModel.toJson();

      final expectedJsonMap = {
        "id": tId,
        "name": tName,
      };

      expect(result, expectedJsonMap);
    });

    test('should convert GenreModel to Genre entity', () {
      final result = tGenreModel.toEntity();

      expect(result, tGenreEntity);
    });

    test('should be equal when properties are same', () {
      final genreModel1 = GenreModel(id: tId, name: tName);
      final genreModel2 = GenreModel(id: tId, name: tName);

      expect(genreModel1, genreModel2);
    });

    test('props should contain id and name', () {
      expect(tGenreModel.props, [tId, tName]);
    });
  });
}