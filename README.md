# LakkaTOR
LakkaTOR is a command line tool to setup Lakka default architecture (i.e /storage/thumbnails, /storage/roms/downloads & /storage/playlists) and automatically import game into playlists.

## Usage
```
./LakkaTOR <cmd>
-h, --help : use to get help.
--setup : use to setup the system.
--scan : use to automatically add games to playlists.

[IMPORTANT] this script take cares of only zip file. For more informations, follow this urls :
 - http://www/.lakka.tv/
 - http://www.lakka.tv/doc/home
```

### Installing

You have to clone the repo. in your computer with :

```
git clone https://github.com/LzOggar/LakkaTOR
```

After, you need to copy the repo. from your computer directly into Lakka with :

```
scp -P 22 <repo_path> root@<Lakka_ip>:/storage/roms/
```

## Running the tests

Use the following command to check the script working correctly :

```
chmod +x LakkaTOR.bash
./LakkaTOR.bash --help
```

## Built With

* [Bash] : Bash is a Unix shell and command language written by Brian Fox for the GNU Project as a free software replacement for the Bourne shell. See "https://en.wikipedia.org/wiki/Bash_(Unix_shell).
* [Lakka] : Lakka is a lightweight Linux distribution that transforms a small computer into a full blown retrogaming console..See "http://www.lakka.tv".

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Authors

**LzOggar** - CyberSecurity student

## Contributing
You can pull request the project or suggest to me some increasement.
