# Домашнее задание к занятию «2.1. Системы контроля версий.»

## Задание 1
>+ `**/.terraform/*` Исключает папку .terraform где бы она ненаходилась (a/b/c/.terraform/)
>+ `*.tfstate` Исключает файлы с расширением .tfstate (имя_файла.tfstate)
>+ `*.tfstate.*` Исключает файлы включающие в название .tfstate. (имя_файла.tfstate.расширение)
>+ `crash.log` Исключает файл crash.log
>+ `crash.*.log` Исключает файлы название которых начинаеться на сcrash. и расширением .log (crash.имя_файла.log)
>+ `*.tfvars` Исключает файлы с расширением .tfvars (имя_файла.tfvars)
>+ `*.tfvars.json` Исключает файлы с хвостом файла .tfvars.json
>+ `override.tf` Исключает файл override.tf
>+ `override.tf.json` Исключает файл override.tf.json
>+ `*_override.tf` Исключает файлы с хвостом файла _override.tf
>+ `*_override.tf.json` Исключает файлы с хвостом файла _override.tf.json
>+ `!example_override.tf` Этот файл в исключения НЕ попадет хотя соответствует предыдущему шаблону
>+ `*tfplan*` Исключает файлы включающие в название tfplan
>+ `.terraformrc` Исключает файл .terraformrc
>+ `terraform.rc` Исключает файл terraform.rc
## Ссылки на репозитории
>+ [GitHub](https://github.com/AlexeyKRD/devops-netology)
>+ [GitLab](https://gitlab.com/AlexeyKRD/devops-netology/-/tree/main)
>+ [BitBucket](https://bitbucket.org/alexeykrd/devops-netology/src/main/)