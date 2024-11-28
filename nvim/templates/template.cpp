#include <bits/stdc++.h>

using namespace std;

template <typename T> ostream &operator<<(ostream &stream, vector<T> var) {
  for (int i = 0; i < var.size(); i++) {
    stream << var[i] << ' ';
  }
  stream << endl;
  return stream;
}

int main() {
  int t;
  cin >> t;
  while (t--) {
    int n;
    cin >> n;
    vector<int> a(n);
    for (int &i : a)
      cin >> i;
  }
  return 0;
}
