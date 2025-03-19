class MdString {
  static double similarityPercentage(String name1, String name2) {
    // Função para remover acentos e converter para minúsculas
    String removeAccents(String str) {
      const diacritics =
          'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
      const nonDiacritics =
          'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';
      return str
          .split('')
          .map((char) {
            final index = diacritics.indexOf(char);
            return index != -1 ? nonDiacritics[index] : char;
          })
          .join()
          .toLowerCase();
    }

    // Função para calcular a distância de Levenshtein
    int levenshteinDistance(String a, String b) {
      final m = a.length;
      final n = b.length;
      if (m == 0) return n;
      if (n == 0) return m;

      final dp = List.generate(m + 1, (_) => List.filled(n + 1, 0));

      for (var i = 0; i <= m; i++) {
        dp[i][0] = i;
      }
      for (var j = 0; j <= n; j++) {
        dp[0][j] = j;
      }

      for (var i = 1; i <= m; i++) {
        for (var j = 1; j <= n; j++) {
          final cost = a[i - 1] == b[j - 1] ? 0 : 1;
          dp[i][j] = [
            dp[i - 1][j] + 1, // Deletion
            dp[i][j - 1] + 1, // Insertion
            dp[i - 1][j - 1] + cost // Substitution
          ].reduce((value, element) => value < element ? value : element);
        }
      }

      return dp[m][n];
    }

    // Processamento das strings
    final words1 = removeAccents(name1).split(RegExp(r'\s+'));
    final words2 = removeAccents(name2).split(RegExp(r'\s+'));
    final maxLength =
        words1.length > words2.length ? words1.length : words2.length;

    double totalSimilarity = 0;
    double totalWeight = 0;

    for (var i = 0; i < maxLength; i++) {
      final word1 = i < words1.length ? words1[i] : "";
      final word2 = i < words2.length ? words2[i] : "";
      final lengthWeight =
          word1.length > word2.length ? word1.length : word2.length;

      if (lengthWeight == 0) continue;

      final distance = levenshteinDistance(word1, word2);
      final similarity = 1 - distance / lengthWeight;

      totalSimilarity += similarity * lengthWeight;
      totalWeight += lengthWeight;
    }

    if (totalWeight == 0) return 0.0;

    return double.parse(
        ((totalSimilarity / totalWeight) * 100).toStringAsFixed(2));
  }
}
