class Cobs {
  void encode() {

  }

  List<int> decode(List<int> data) {
    List<int> results = [];

    if (data.isEmpty) {
      print("Nothing to decode.");
      return results;
    }

    int length = data.length;
    int idx = 0;
    int end = 0;
    List<int> copyMv = [];
    while (true){//for(int i in data) {
      length = data[idx];
      if (length == 0) {
        print("Error during decoding.");
        break;
      }
      idx += 1;
      end = idx + length - 1;
      if (end < data.length) {
        copyMv = data.sublist(idx, end);
      } else {
        copyMv = data.sublist(idx);
      }
      for (int i in copyMv) {
        if (i == 0) {
          print("Zero found during decode!");
          break;
        }
      }
      results += copyMv;
      idx = end;
      if (idx > data.length) {
        results.add(length);
        break;
      } else if (idx < data.length) {
        if (length < 0xFF) {
          results.add(0);
        }
      } else {
        break;
      }
    }
    return results;
  }
}