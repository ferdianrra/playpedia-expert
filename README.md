# playpedia-expert

## CircleCI

Konfigurasi `.circleci/config.yml` menjalankan target `PlaypediaTests` lewat scheme `Playpedia` pada macOS dengan Xcode 27.0. Pipeline memasang SwiftLint dan xcbeautify, mengambil dependency Swift Package Manager, lalu menjalankan XCTest pada simulator iPhone yang tersedia. Laporan JUnit tampil di halaman Tests; log dan bundle `.xcresult` tersimpan sebagai artifacts.

Hubungkan repository ini ke CircleCI, gunakan konfigurasi dari repository (`.circleci/config.yml`), lalu commit dan push konfigurasi tersebut bersama project Xcode, shared scheme, dan folder Tests. Setelah repository tersambung, setiap push yang memicu pipeline akan menjalankan workflow `build-and-test`.

Tes memakai stub dan database in-memory sehingga tidak memerlukan API key RAWG. Pipeline mengosongkan `RAWG_API_KEY` saat build. Runner macOS perlu tersedia pada akun CircleCI.

Referensi: [Testing iOS on CircleCI](https://circleci.com/docs/guides/test/testing-ios/).
