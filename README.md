# playpedia-expert

## CircleCI

Konfigurasi `.circleci/config.yml` menjalankan target `PlaypediaTests` lewat scheme `Playpedia` pada macOS dengan Xcode 27.0. Pipeline memasang SwiftLint dan xcbeautify, mengambil dependency Swift Package Manager, lalu menjalankan XCTest pada simulator iPhone yang tersedia. Laporan JUnit tampil di halaman Tests; log dan bundle `.xcresult` tersimpan sebagai artifacts.

Hubungkan repository ini ke CircleCI, gunakan konfigurasi dari repository (`.circleci/config.yml`), lalu commit dan push konfigurasi tersebut bersama project Xcode, shared scheme, dan folder Tests. Setelah repository tersambung, setiap push yang memicu pipeline akan menjalankan workflow `build-and-test`.

Tes memakai stub dan database in-memory sehingga tidak memerlukan API key RAWG. Pipeline mengosongkan `RAWG_API_KEY` saat build. Runner macOS perlu tersedia pada akun CircleCI.

Referensi: [Testing iOS on CircleCI](https://circleci.com/docs/guides/test/testing-ios/).

## Modularization

Aplikasi memakai sembilan Swift Package lokal. Setiap package memiliki manifest sendiri dan menghasilkan framework dinamis yang di-link serta di-embed ke aplikasi:

| Modul | Tanggung jawab |
| --- | --- |
| PlaypediaHomeFeature | List, pencarian, sorting, pagination |
| PlaypediaDetailFeature | Detail gim dan screenshot |
| PlaypediaFavoritesFeature | Halaman daftar favorit |
| PlaypediaAboutFeature | Biodata dan resource foto profil |
| PlaypediaFavoritesState | State favorit bersama untuk Home/Detail/Favorites |
| PlaypediaUI | Komponen SwiftUI, tema warna, dan pesan error presentation |
| PlaypediaData | Alamofire, DTO/mapping, dan repository Core Data |
| PlaypediaDomain | Entity, kontrak repository, dan use case |
| PlaypediaComposition | Registrasi dan resolusi dependency lewat Swinject |

Semua modul memiliki API publik yang diperlukan konsumen. Manifest setiap package menentukan arah dependency; Domain tidak bergantung pada implementasi Data atau UI. Fitur memakai Domain, UI bersama, dan state favorit; fitur Home/Favorites memakai Detail untuk navigasi. App merangkai tab serta menginjeksikan hasil composition root.

Warna diambil dari bundle PlaypediaUI dan foto profil dari bundle PlaypediaAboutFeature. Asset tersebut tidak diduplikasi di target aplikasi. AppIcon tetap milik target aplikasi.

Tetap buka `Playpedia.xcodeproj`, pilih scheme **Playpedia**, lalu **Command+R** untuk menjalankan atau **Command+U** untuk XCTest. `Package.swift` di root menyediakan modul dan tes, bukan aplikasi iOS.

CircleCI tetap menjalankan target PlaypediaTests melalui scheme yang sama. Setelah commit/push seluruh folder Modules dan perubahan project/manifest, pipeline akan mengambil dependency lokal dari checkout repository.

PlaypediaDomain memiliki `Package.swift` sendiri di `Modules/PlaypediaDomain`, sehingga siap dipublikasikan sebagai package mandiri. Publikasi repository ditunda sesuai permintaan; link modul untuk Catatan submission baru tersedia setelah publikasi dilakukan. Begitu pula status terakhir CI perlu diperiksa pada server setelah perubahan didorong.

Referensi: [Swift Package targets dan products](https://docs.swift.org/latest/documentation/packagemanagerdocs/introducingpackages/), [resource Swift Package](https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package).

## Membuka source modul di Xcode

Buka source lewat grup `Modules` pada navigator project. Grup ini hanya menampilkan file; dependency package didaftarkan satu kali lewat project. Jika Xcode menampilkan `already opened from another project or workspace`, tutup seluruh jendela package/project dan Quit Xcode, kemudian buka kembali hanya `Playpedia.xcodeproj`. Jangan membuka manifest root dan semua package sebagai workspace terpisah bersamaan dengan aplikasi.
