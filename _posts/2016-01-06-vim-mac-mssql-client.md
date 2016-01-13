---
layout: post
title: "Using Vim as a SQL Server Client on a Mac"
date: 2015-11-17 20:08:44
tags:
  - SQL
  - SQL Server
  - Mac
  - Vim
published: true
---

Bad times - having to connect to my company's SQL Server database in order to
migrate data. The last time I looked at that database it was through
a connection to a Windows box running the Microsoft development client. Laggy,
slow, and an unfamiliar environment.

So what are my options on a Mac? Well, there are a couple of SQL Server clients
out there,but the one I tried out turned out to be buggy - there's nothing
less fun than losing a query you've been crafting for an hour. And why should
I spend time moving the query betweeen an editor (Vi) and an awkward GUI
interface?

Screw that - let's do it in Vim! This method has been tested on my Mac, but
should also work for another \*nix based system. No guarantees though.

### The Tools

To do this we need:

- a way for the Mac to talk to the SQL Server database
- a way for that connection to talk to Vim

And we will be using the following tools to do that:

- [FreeTDS]
- [unixODBC]
- the Vim plugin [dbext.vim]
- and the Perl libraries [DBI] and [DBD::ODBC] \(installed using [CPAN])

We'll start with a simple example - connecting dbext to a local instance of
PostgreSQL.

### dbext with PostgreSQL

Install dbext into Vim using whichever package manager or other you like. Dbext
is a 'proper' Vim extension, in that it comes with extensive documentation in
the form of Vim helpfiles. Access the full help with `:h dbext` and check out
the tutorial at `:h dbext-tutorial`.

If even the tutorial is fast enough, here's a quick start for
PostgreSQL locally. Let's assume you've already installed PostgreSQL,
and that you've not added any usernames or passwords. Somewhere in your Vim
initialization files (like `~/.vimrc`) add the following line:

`let g:dbext_default_profile_local_PSQL = 'type=PGSQL'`

Here we've set up a local profile for PostgreSQL, called it `local_PSQL`, and
told dbext that the type of connection this profile will use is, well,
Postgres. Now either restart Vim or evaluate that command in your current session.

To use this profile with some SQL in Vim, first put some SQL into a buffer. Try
this: `SELECT * FROM bob`. Then, in the buffer, send the command
`:DBPromptForBufferParameters`. You'll get a menu with the `local_PSQL` option
on it. Select that option (probably option 1).

Now have a crack at running a query - put your cursor on the line with the SQL
statement on it and execute the query with the command `<Leader>sel` (`s`ql
`e`xecute `l`ine).

This won't work, but should give you a hint about what's going wrong: PostgreSQL
needs a `[.pgpass]` file for the password to the database - even if there isn't
a password(!). So just create an empty file called `.pgpass` in your `$HOME`
directory. Now it should work (or at least return a reasonable error message if
your default database doesn't have a `bob` table).

Now... go crazy! Dbext is great - read some of the docs in full and have a play
with some SQL queries. Ah, the joy of Vim! Come back when you want to hook it
up to a remote SQL Server.

### SQL Server on Mac

Had fun? Right, this bit is a bit of a drag. Macs (and other \*nix systems) have
no native support for TDS, the protocol by which we talk to SQL Server
databases. So we'll have to install a library called `freetds`.

But before we do that we'll need to install an ODBC driver as the `freetds`
library does not provide sufficiently sophisticated binaries for `dbext` to use
to query a database directly.[^1]

First up we'll install `unixodbc` - I'm using [Homebrew], but if you'd
like to build your own binaries be my guest.

```
brew install unixodbc
```

And now that's done, let's get hold of `freetds`

```
brew install freetds --with-unixodbc --with-msdblib
```

We're asking for `freetds` to be installed with `unixodbc` support, and telling
it that we want it to use the version of TDS that Microsoft developed for SQL
Server.[^2]

If you'd like to test the installation, `freetds` comes with a couple of command
line tools you can use to connect to a SQL Server DB. Run `tsql` with the
appropriate server, port, username and password passed in as options and check
to see if you can connect. Have a bit more of a play around if you can - you've
earned it.

### Perl: `DBI` and `DBD::ODBC`

The final step is to get `dbext` talking to the ODBC installation. And it wants
to do this through a pair of Perl libraries. We'll install these using CPAN, the
Perl equivalent of RubyGems or NPM.[^3] First start the interactive interface as
the super user:

```
sudo perl -MCPAN -e shell
```

And then install the libraries we need:

```
install DBI
install DBD::ODBC
```

Both of these will output a scarily verbose amount of logs - it's ok, it's
normal[^4] - and by the end of it we've got everything installed that we'll
need. Almost there. Almost...

### Configuration files

Getting `freetds` and `unixodbc` working together happily is super simple -
but it took me a while to work out exactly what was needed. Configuration for
`freetds` can live either in its own configuration file, or with the ODBC
configuration. The simplest thing to do is to push the configuration over to the
ODBC side entirely.

What we're looking to do it to tell ODBC that there is a sort of database called
'freeTDS' and to point it to where the files that describe the protocol live -
this is the database 'driver', just like a printer driver.  Then we need to give
ODBC the details of the specific database we want to connect to - think of this
as the specific printer you connect to using a printer driver, the network
address etc.

The first step is to register `freetds` as a driver with `unixodbc` - this is
done in a file called `odbcinst.ini` which Homebrew has (hopefully) symlinked
into `/usr/local/etc/odbcinst.ini`[^5]. And in that file we put the following:

```
[FreeTDS]
Description = TD Driver (MSSQL)
Driver = /usr/local/lib/libtdsodbc.so
Setup = /usr/local/lib/libtdsodbc.so
FileUsage = 1
```

The top line is the name we're giving the driver, the second a human-friendly
description of what it does. Thee next two lines give ODBC the driver and set up
information - `libsdsodbc.so` was installed with the `freeTDS` installation and
put in `/usr/local/lib` as a symlink by Homebrew (again, hopefully).

That's the driver bit done. Now let's point ODBC to your SQL Server database by
adding its details to the `~/.odbc.ini` file, which you'll have to create.[^6]
Put the following in there:

```
[MyMSSQLDB]
Driver = FreeTDS
Server = <ip or domain name goes here>
Database = <database name goes here>
Port = <port number>
```

This connection information is called a DSN, and we'll be using it in `dbext`.
Replace `MyMSSQLDB` with something more descriptive - it's the name of the
connection to your database that ODBC (and, by extension, `dbext`) will use.

Success! One more small step to go

### ODBC in `dbext`

Now we've got an ODBC connection to play with, it's time to put its details into
`dbext`. This can bedone by putting the following into your `.vimrc` - right
next to where you declared your PostgreSQL connection information.

`let g:dbext_default_profile_MyMSSQLDB = 'type=ODBC:user=<username>:passwd=<password>:dsnname=MyMSSQLDB'`[^7]

Pretty long, right? But comprehendible. We're giving similar information to that
which we used for the PostgreSQL connection, only we're declaring that the type
is `ODBC`, and we're declaring the DSN name that we're using as well.

And that's it. Restart your Vim Session, `<Leader>sbp` (it's the same as
`:DBPromptForBufferParameters`) and pick MyMSSQLDB (feel free to give it
a better name later). You can now evaluate lines of SQL against the database,
and see the return value in a separate split below.

### tl;dr

- `brew install unixodbc`
- `brew install freetds --with-unixodbc --with-msdblib`
- `sudo perl -MCPAN -e shell`
- `install DBI` and `install DBD::ODBC` in the CPAN shell
- Add the following to `/usr/local/etc/odbcinst.ini`:

```
[FreeTDS]
Description = TD Driver (MSSQL)
Driver = /usr/local/lib/libtdsodbc.so
Setup = /usr/local/lib/libtdsodbc.so
FileUsage = 1
```

- Add the following to `~/.odbc.ini`:

```
[MyMSSQLDB]
Driver = FreeTDS
Server = <ip or domain name goes here>
Database = <database name goes here>
Port = <port number>
```

- install `dbext` into Vim
- Add `let g:dbext_default_profile_MyMSSQLDB = 'type=ODBC:user=<username>:passwd=<password>:dsnname=MyMSSQLDB'` to `~/.vimrc`
- Read the `dbext` manual (`:h dbext`)

[^1]: My details are _fuzzy_ at best, but as far as I can see the `osql` and `tsql` bins that come with `freetds` are not set up for interactive querying, and can't be used in the same way that, say, `osql` on a Windows machine would work.
[^2]: Even when making their own standard, M$ can't help but diverge from it.
[^3]: Or Maven or whatever.
[^4]: CPAN is running all the tests on each of the modules. Bit excessive I know.
[^5]: This inforamation can also be added using the `odbcinst` tool, But this way seems easier to me. Read more about these files in the unixODBC documentation  [here][odbcFiles]
[^6]: ODBC will also look in `/usr/local/etc/odbc.ini` for DSNs, but these will be available to all users. So we're putting them in the local user file it checks, `~/.odbc.ini`.
[^7]: The connection information used here can include the database, but we've pushed that part down to the DSN defined above. It must always include the `username` and `passwd` from what I've seen through experimentation.

[.pgpass]: http://www.postgresql.org/docs/-3/static/libpq-pgpass.html
[FreeTDS]: http://www.freetds.org/
[unixODBC]: http://www.unixodbc.com/
[dbext.vim]: http://www.vim.org/scripts/script.php?script_id=356
[DBI]: http://dbi.perl.org/
[DBD::ODBC]: http://search.cpan.org/~mjevans/DBD-ODBC-1.52/ODBC.pm
[CPAN]: http://search.cpan.org/~mjevans/DBD-ODBC-1.52/ODBC.pm
[Homebrew]: http://brew.sh/
[odbcFiles]: http://www.unixodbc.org/odbcinst.html


