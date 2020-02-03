
aialuno$
keytool -genkey -v -keystore aiia.keystore -alias pibrintec -keyalg RSA -keysize 2048 -validity 10000

senha: aiia4c@ta

~~~
catalunha@nbuft:~/projetos-flutter/aialuno$ keytool -genkey -v -keystore aiia.keystore -alias pibrintec -keyalg RSA -keysize 2048 -validity 10000
Informe a senha da área de armazenamento de chaves:  
Informe novamente a nova senha: 
Qual é o seu nome e o seu sobrenome?
  [Unknown]:  marcio catalunha
Qual é o nome da sua unidade organizacional?
  [Unknown]:  particular
Qual é o nome da sua empresa?
  [Unknown]:  professor 
Qual é o nome da sua Cidade ou Localidade?
  [Unknown]:  palmas
Qual é o nome do seu Estado ou Município?
  [Unknown]:  to
Quais são as duas letras do código do país desta unidade?
  [Unknown]:  br
CN=marcio catalunha, OU=particular, O=professor, L=palmas, ST=to, C=br Está correto?
  [não]:  sim

Gerando o par de chaves RSA de 2.048 bit e o certificado autoassinado (SHA256withRSA) com uma validade de 10.000 dias
        para: CN=marcio catalunha, OU=particular, O=professor, L=palmas, ST=to, C=br
[Armazenando aiia.keystore]
catalunha@nbuft:~/projetos-flutter/aialuno$ 
~~~