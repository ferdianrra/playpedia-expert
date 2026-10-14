# PlaypediaDomain

Swift Package mandiri untuk entity gim, pilihan sorting, kontrak repository, dan use case katalog/favorit. Package ini memakai Foundation dan Combine; tidak bergantung pada SwiftUI, Alamofire, Swinject, Core Data, atau konfigurasi API RAWG.

Buka `Package.swift` dalam folder ini untuk memeriksa package secara terpisah. Build mandiri:

```sh
swift build --package-path Modules/PlaypediaDomain
```

Aplikasi saat ini menggunakannya melalui dependency lokal di manifest root. Implementasi repository berada di PlaypediaData; kontrak tetap berada di PlaypediaDomain. Tes domain berada di `Tests/GameUseCaseTests.swift` pada project aplikasi dan dijalankan melalui scheme Playpedia atau `swift test` dari root repository.

## Publikasi nanti

Folder ini adalah root repository yang akan dipublikasikan. Salin seluruh folder ini ke repository `playpedia-domain`, commit source dan manifest, lalu buat tag versi seperti `1.0.0`. Setelah repository tersedia, dependency lokal pada manifest aplikasi dapat diganti dengan URL dan versi tag yang benar. Repository dan tag belum dibuat atau di-push.
