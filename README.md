To use it run `bin/run` or direct thin command like this. bin/run may be used with proxy server, it runs 3 thin instances using ports 5000, 5001, 5002.

`thin -p 8080 -R app.ru -r `pwd`/lib/upload_progress.rb -b Thin::Backends::UploadProgressBackend start`

You can pass other thin options as well to command above. 

To use with http server like Apache run more thin instances and use example configuration: https://github.com/slawosz/upload_progress/blob/master/APACHE.md

You need also install required gems with `bundle install` command.

Software contains 3 rack apps:

* `UploadProgress::Upload` for saving upload with attachment
* `UploadProgress::Description` for saving description
* `UploadProgress::CheckProgress` for getting file progress info

It use 2 rack middlewares:

* `UploadProgress::UidGetter` for setting upload id from param to header
* `UploadProgress::SmallUploadProgress` for setting upload progress for small uploads (ie. for request smaller than max chunk size), this is used due thin handler limitation described below.

And last but not leas Thin handler: `UploadProgress::Handlers::Thin`

This handler is mixed in class `Thin::UploadProgressConnection` that inherits from `Thin::Connection`. It simply caches data chunk and calculate progress based on total uploaded chunk size. It is worth to know, that it is starting to work on second `receive_data` method call. On first `receive_data` call http request is not parsed yet, so it is imposible to get needed information like `Content-Length` or upload id. This is why we need `UploadProgress::SmallUploadProgress` middleware.

Hander is used by `Thin::Backends::UploadProgressBackend` which inherits from `Thin::Backends::TcpServer`. It simply use `Thin::UploadProgressConnection` as hander for `EventMachine::start_server` method.
