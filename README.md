A simple mail script to send a text to a list of recipients.

Usage
=====

- Text of the mail is in mail.txt, first line is the subject, second line should be empty, starting from third line is the body
- mail addresses of recipiens are in recipients.txt, one address per line
- config.yml contains your smtp account data, see config.example.yml for an example
- dependencies are handled by bundler, so you should do `gem install bundler` and `bundle install` to get required gems

When everything is set up, run

> ruby mailer.rb


Features
========

- sends mails in batches of 20 addresses per mail
- uses bcc to not disclose email addresses to others
- validates addresses and skips invalid ones
- saves remaining addresses in a textfile in case of fatal errors while sending


License
=======

*MIT-License*

Copyright (c) 2011 Sven Koschnicke

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
