# Домашнее задание к занятию «2.4. Инструменты Git»

---
## Задание 1
### Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea.
>+ `git show aefea` используем show c сокращенным хешем aefea, получаем полную информацию о коммите
>+ хеш: ***aefead2207ef7e2aa5dc81a34aedf0cad4c32545***
>+ комментарий:  ***Update CHANGELOG.md***
## Задание 2
### Какому тегу соответствует коммит 85024d3? 
>+ `git show 85024d3` используем show c сокращенным хешем 85024d3, получаем полную информацию о коммите
>+ после хеша коммита в скобках смотрим тег ***(tag: v0.12.23)***
## Задание 3
### Сколько родителей у коммита b8d720? Напишите их хеши. 
>+ `git show --pretty=format:'%P' b8d720` используем show c параметром --pretty по хешу b8d720, 
>+ получаем 2 хеша это и есть 2 родителя b8d720 
>+ 1 родитель: ***56cd7859e05c36c06b56d013b55a252d0bb7e158***
>+ 2 родитель: ***9ea88f22fc6269854151c571162c5bcf958bee2b***
## Задание 4
### Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24. 
>+ `git log --oneline v0.12.23..v0.12.24` используем log и .. между тегами, получаем список коммитов
>+ ***b14b74c493 [Website] vmc provider links***
>+ ***3f235065b9 Update CHANGELOG.md***
>+ ***6ae64e247b registry: Fix panic when server is unreachable***
>+ ***5c619ca1ba website: Remove links to the getting started guide's old location***
>+ ***06275647e2 Update CHANGELOG.md***
>+ ***d5f9411f51 command: Fix bug when using terraform login on Windows***
>+ ***4b6d06cc5d Update CHANGELOG.md***
>+ ***dd01a35078 Update CHANGELOG.md***
>+ ***225466bc3e Cleanup after v0.12.23 release***
## Задание 5
### Найдите коммит в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...) (вместо троеточего перечислены аргументы). 
>+ первое что пришло в голову использовать grep с параметром -p `git grep -p 'func providerSource('`, получил имя файла где эта фунция описывается ***provider_source.go***
>+ после использовал `git log -L:'func providerSource':provider_source.go`, нашел 3 коммита где эта функция подверглась изменениям))
>+ первый коммит 8c928e83589d90a031f811fae52a81be7153e82f но назвать это функцией наверно нельзя) либо я еще мало чего знаю)
>+ трейти коммит 5af1e6234ab6da412fb8637393c5a17a1b293663 вот здесь уже похоже на фунцию
>+ после в конспекте попалось на глаза `git log -S'func providerSource(' --oneline`, этот вариант оказался проще)'
>+ результат тот же ***8c928e8358 main: Consult local directories as potential mirrors of providers***
## Задание 6
###  Найдите все коммиты в которых была изменена функция globalPluginDirs.
>+ используя первый метот поиска из предыдущего задание, он тут кстати)
>+ первым делом получаем имя файла с функцией globalPluginDirs `git grep -p 'globalPluginDirs'`, ***plugins.go***
>+ вторым действием получем коммиты где функция изменялась `git log -s -L:globalPluginDirs:plugins.go --oneline`
>+ ***78b1220558 Remove config.go and update things using its aliases***
>+ ***52dbf94834 keep .terraform.d/plugins for discovery***
>+ ***41ab0aef7a Add missing OS_ARCH dir to global plugin paths*** 
>+ ***66ebff90cd move some more plugin search path logic to command*** 
>+ ***8364383c35 Push plugin discovery down into command package***
## Задание 7
###  Кто автор функции synchronizedWriters?
>+ ищем в истории слово synchronizedWriters `git log -S'synchronizedWriters' --oneline`, находим 3 коммита
>+ берем самый первый коммит 5ac311e2a9 смотрим его `git show 5ac311e2a9` получаем автора
>+ ***Author: Martin Atkins <mart@degeneration.co.uk>***
>+ *не понял почему `git grep -p 'synchronizedWriters' ничего не нашел*