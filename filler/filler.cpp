#include <bits/stdc++.h>
using namespace std;

using ll = long long;

// Ref: https://stackoverflow.com/a/12468109
std::string random_string(size_t length) {
    auto randchar = []() -> char {
        const char charset[] =
        "0123456789"
        // "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        "abcdefghijklmnopqrstuvwxyz";
        const size_t max_index = (sizeof(charset) - 1);
        return charset[rand() % max_index];
    };
    std::string str(length,0);
    std::generate_n(str.begin(), length, randchar);
    return str;
}

int main() {
    int unit;
    ll base_size;
    int count;
    const ll buf_size = 1024 * 1024;
    char buf[buf_size] = {0, };

    assert (sizeof(char) == 1);

    srand(time(0));

    cout << "Size unit (B=0, KB=1, MB=2, GB=3) : ";
    cin >> unit;

    cout << "File size : ";
    cin >> base_size;

    cout << "File count : ";
    cin >> count;

    assert (0 <= unit && unit <= 3 && "invalid size unit");
    assert (buf_size > 0 && "size must be a positive integer");
    assert (count > 0 && "count must be a positive integer");

    while (unit--) base_size *= 1024;

    unordered_set<string> filenames;

    for (int i = 1; i <= count; ++i) {
        while (true) {
            string filename = random_string(64);
            if (filenames.find(filename) != end(filenames))
                continue;
            filenames.insert(filename);
        }
        ll size = base_size;

        FILE *f = fopen(filename.c_str(), "wb"); {
            while (size > 0) {
                if (size < buf_size)
                    fwrite(buf, 1, size, f);
                else
                    fwrite(buf, 1, buf_size, f);
                size -= buf_size;
            }
        }
        fclose(f);

        printf("File #%d Done -- %s\n", i, filename.c_str());
    }

    return 0;
}
