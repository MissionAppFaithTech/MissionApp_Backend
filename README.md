# Características do Banco de Dados Mission App

Segue algumas particularidades e características do modelo banco de dados:

1. A coleção pastorUsers não precisará ser considerada.
2. A coleção churchUsers não precisará ser considerada.
3. Users é uma coleção de documentos e subcoleções. O documento se refere aos atributos do próprio usuário.
4. O documento (schema ou modelo) de um usário contém diversos atributos, dentre eles destacamos "missionaryAgency" que precisará de normalização no campo de entrada.
5. As subcoleções de users são: followers, following e project.
6. followers são os seguidores de um missionário (role: missionary)
7. following são as pessoas que um usuário está seguindo.
8. project é o projeto pessoal de um missionário.
9. churches é um modelo necessário e está presente no cadastro. Também precisamos normalizar o campo "faithCommunity".
