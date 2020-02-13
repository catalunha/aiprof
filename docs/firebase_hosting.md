
# Build aplicação in Flutter Web
visite: https://flutter.dev/docs/get-started/web

* Execute
~~~
flutter channel beta
flutter upgrade
flutter config --enable-web
~~~
* Conferir se os devices estao prontos
~~~
flutter devices
2 connected device:

Chrome     • chrome     • web-javascript • Google Chrome 78.0.3904.108
Web Server • web-server • web-javascript • Flutter Tools
~~~
   
* Mandar executar o flutter no device específico
~~~
flutter run -d chrome
~~~
* Trabalhar normalmente dando r pra reload no Terminal do VSCode e no chrome CTRL+ 'Recarregar página' . O aplicativo tb funciona no emulador dando F5 ou reload no VSCode na barra de botoes do debug.
* Compile o codigo com este comando. A aplicação será gerada em build/web pronta para deploy
~~~
flutter build web
~~~


# Deploy in Firebase Hosting

1. Acesse esse link: https://firebase.google.com/docs/hosting/quickstart?hl=pt-BR verifique se o firebase esta iniciado nesta pasta
5. Antes confira o firebase.json q deve ficar desta forma:
~~~
Para o PI-Prof
{
  "firestore": {
    "rules": "firestore.rules",
    "indexes": "firestore.indexes.json"
  },
  "hosting": {
    "site": "aiprof",
    "public": "build/web",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ]
  }
}

Para o PI-Aluno
{
  "hosting": {
    "site": "aialuno",
    "public": "build/web",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ]
  }
}
~~~
* Digite o comando de deploy que enviará os arquivos
~~~
firebase deploy --only hosting:aiprof
~~~
ou
~~~
firebase deploy --only hosting:aialuno
~~~

Todos os assets são movidos automaticamente para o endereço /web/assets
