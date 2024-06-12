abstract class CrudFutureService<T> {
  Future<String> createF(T item);
  Future<T?> getByIdF(String id);
  Future<List<Map<String, dynamic>>> getAllF();
  Future<void> updateF(T updatedItem);
  Future<void> deleteF(String id);
  T getNew();
}