---
layout: post
title: "Using Vim as a SQL Server Client on a Mac"
date: 2015-11-17 20:08:44
tags:
    - SQL
    - SQL Server
    - Mac
    - Vim
published: false
---

Bad times - having to connect to my company's SQL Server database in order to
migrate data. The last time I looked at that database it was through
a connection to a Windows box running the Microsoft development client. Laggy,
slow, and an unfamiliar environment.

So what are my options on a Mac? Well, there are a couple of SQL Server clients
out there, costing a little bit of clink, but the one I tried out turned out to
be buggy - there's nothing less fun than losing a query you've been crafting for
an hour because of some peculiar crash. And why should I spend time moving the
query betweeen an appropriate text editor (Vi) and an awkward GUI interface.

Screw that - let's do it in Vim. This method has been tested on my Mac, but
should also work for another *nix based system. No guarantees though.

### The Tools

To do this we need:
- a way for the Mac to talk to the SQL Server database
- a way for that connection to talk to Vim

And we will be using the following tools to do that:
- FreeTDS
- unixODBC
- dbext
- and the Perl libraries

```
brew install unixodbc
```

```
brew install freetds --with-unixodbc --with-msdblib
```

Perl installation
```
$ sudo perl -MCPAN -e shell

cpan[1]> install DBI
cpan[2]> install DBD::ODBC
```
